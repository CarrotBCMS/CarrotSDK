/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
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
#import "AFNetworking.h"

@implementation CRPersistentRequestQueue {
    NSOperationQueue *_internalOperationQueue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Requests

- (void)sendQueuedRequests {
    if (_objects.count == 0) {
        return;
    }
    // Copy all (currently stored) requests into a new array
    NSArray *queueCopy = [NSArray arrayWithArray:_objects];
    [queueCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:obj];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        CRLog(@"Sending log operation...");
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            CRLog(@"Logging successful.");
            [_objects removeObject:obj]; // Remove request from queue when finished
            [self _save];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CRLog(@"Logging error: %@", error);
        }];
        [[self _internalOperationQueue] addOperation:operation];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)cancelQueuedRequests {
    [[self _internalOperationQueue] cancelAllOperations];
    [_objects removeAllObjects];
    [self _save];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)waitUntilAllRequestsAreFinished {
    [[self _internalOperationQueue] waitUntilAllOperationsAreFinished];
}

- (NSOperationQueue *)_internalOperationQueue {
    if (!_internalOperationQueue) {
        _internalOperationQueue = [[NSOperationQueue alloc] init];
        _internalOperationQueue.maxConcurrentOperationCount = 1;
    }
    return _internalOperationQueue;
}

@end
