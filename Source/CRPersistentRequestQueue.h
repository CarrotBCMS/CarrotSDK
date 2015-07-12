//
//  CRPersistentRequestQueue.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/11/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRSingleFileStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRPersistentRequestQueue : CRSingleFileStorage

- (void)sendQueuedRequests;
- (void)cancelQueuedRequests;
- (void)waitUntilAllRequestsAreFinished;

NS_ASSUME_NONNULL_END

@end
