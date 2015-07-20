//
//  CRAnalyticsProvider.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/01/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CREvent;
@class CRBeacon;

@interface CRAnalyticsProvider : NSObject

///---------------------------------------------------------------------------------------
/// @name Analytics
///---------------------------------------------------------------------------------------

/**
 Inits with a base url to bms
*/
- (instancetype)initWithBaseURL:(NSURL *)url appKey:(NSString *)appKey;

///---------------------------------------------------------------------------------------
/// @name Analytics
///---------------------------------------------------------------------------------------

/**
 The base url to bms
*/
@property (readonly, strong) NSURL *baseURL;

/**
 The app key
 */
@property (readonly, strong) NSString *appKey;

- (void)logEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon;

- (void)logEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon;

@end

NS_ASSUME_NONNULL_END