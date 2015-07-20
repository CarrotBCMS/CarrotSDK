//
//  CREventProxy.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/20/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CREvent;

/**
 Proxy class for CREvent. May discard content on memory warnings.
 */
@interface CREventProxy : NSProxy

@property (strong, nullable) CREvent *object;
@property (assign, readonly) NSUInteger eventId;

- (instancetype)initWithBasePath:(NSString *)path eventId:(NSUInteger)eventId;
+ (instancetype)proxyWithBasePath:(NSString *)path eventId:(NSUInteger)eventId;

NS_ASSUME_NONNULL_END

@end
