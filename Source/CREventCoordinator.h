//
//  CREventCoordinator.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CRBeacon;
@class CREventStorage;
@class CRNotificationEvent;

/**
 Coordinates validation and retrieval of stored events.
 */
@interface CREventCoordinator : NSObject

///---------------------------------------------------------------------------------------
/// @name Storage properties
///---------------------------------------------------------------------------------------

/**
 Storage
 */
@property (readonly, strong) CREventStorage *storage;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Init instance with storage.
 */
- (instancetype)initWithEventStorage:(CREventStorage*)storage;

///---------------------------------------------------------------------------------------
/// @name Coordination
///---------------------------------------------------------------------------------------

- (NSArray *)validEnterEventsForBeacon:(CRBeacon *)beacon;
- (NSArray *)validExitEventsForBeacon:(CRBeacon *)beacon;

- (NSArray *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon;
- (NSArray *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon;

- (void)sendLocalNotificationWithEvent:(CRNotificationEvent *)event;

NS_ASSUME_NONNULL_END

@end
