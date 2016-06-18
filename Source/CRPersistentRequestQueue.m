/*
 * Carrot -  beacon content management (sdk)
 * Copyright (C) 2016 Heiko Dreyer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "CRPersistentRequestQueue.h"
#import "CRSingleFileStorage_Internal.h"
#import "CRDefines.h"

@interface CRPersistentRequestQueue () <NSURLSessionDelegate>
@end

//////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRPersistentRequestQueue {
    NSURLSession *_session;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Networking

- (void)sendQueuedRequests {
    if (_objects.count == 0) {
        return;
    }
    
    // Copy all (currently stored) requests into a new array
    NSArray *queueCopy = [NSArray arrayWithArray:_objects];
    [queueCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CRLog(@"Sending log operation...");
        NSURLSessionDataTask *task  = [[self _backgroundSession] dataTaskWithRequest:obj
                                                                   completionHandler:^(NSData * _Nullable data,
                                                                                       NSURLResponse * _Nullable response,
                                                                                       NSError * _Nullable error)
        {
            if (error) {
                CRLog(@"Logging error: %@", error);
                return;
            }
            
            CRLog(@"Logging successful.");
            [_objects removeObject:obj]; // Remove request from queue when finished
            [self _save];
        }];
        [task resume];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)cancelQueuedRequests {
    [[self _backgroundSession] getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionTask *task in tasks) {
            [_objects removeObject:task.originalRequest];
            [task cancel];
        }
        [self _save];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSURLSession *)_backgroundSession {
    if (_session) {
        return _session; // Early exit
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:self
                                        delegateQueue:[[NSOperationQueue alloc] init]];
    
    return _session;
}
@end
