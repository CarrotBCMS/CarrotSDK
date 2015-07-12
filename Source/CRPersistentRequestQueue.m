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
    NSMutableArray *_queue;
    NSOperationQueue *_internalOperationQueue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Requests

- (void)sendQueuedRequests {
    if (_queue.count == 0) {
        return;
    }
    // Copy all (currently stored) requests into a new array
    NSArray *queueCopy = [NSArray arrayWithArray:_queue];
    [queueCopy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:obj];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        CRLog(@"Sending log operation...");
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            CRLog(@"Logging response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            [_queue removeObject:obj]; // Remove request from queue when finished
            [self _save];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CRLog(@"Logging error: %@", error);
        }];
        [_internalOperationQueue addOperation:operation];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)cancelQueuedRequests {
    [_internalOperationQueue cancelAllOperations];
    [_queue removeAllObjects];
    [self _save];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)waitUntilAllRequestsAreFinished {
    [_internalOperationQueue waitUntilAllOperationsAreFinished];
}

@end
