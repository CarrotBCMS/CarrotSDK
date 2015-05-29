//
//  CRContent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRBeaconManagerEnums.h"

@interface CREvent : NSObject <NSSecureCoding>

/**
 Unique event id.
 */
@property (readonly, strong) NSNumber *eventId;

/**
 The threshold in seconds.
 */
@property (readonly, assign) NSTimeInterval threshold;

/**
 Last time this event was triggered.
 */
@property (strong) NSDate *lastTriggered;

/**
 Event type
 */
@property (readonly, assign) CREventType eventType;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Initialize this event.
 
 @param eventId UUID string
 @param threshold Threshold in milliseconds
 @param lastTriggered Last time triggered
 @param eventType Event type
 */
- (instancetype)initWithEventId:(NSNumber *)eventId
                      threshold:(NSTimeInterval)threshold
                  lastTriggered:(NSDate *)lastTriggered
                      eventType:(CREventType)eventType;
@end
