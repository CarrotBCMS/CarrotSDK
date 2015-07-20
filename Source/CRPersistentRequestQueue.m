//
//  CRPersistentRequestQueue.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/11/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
