//
//  CRPersistentRequestQueue.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 7/11/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRPersistentRequestQueue : NSObject

- (id)initWithStoragePath:(NSString *)path;
- (void)sendQueuedRequests;
- (void)cancelQueuedRequests;
- (void)waitUntilAllRequestsAreFinished;

- (void)addRequest:(NSURLRequest *)request;
- (void)removeRequest:(NSURLRequest *)request;
- (void)removeLastRequest;

NS_ASSUME_NONNULL_END

@end
