//
//  CRContent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRBeaconManagerEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface CREvent : NSObject

/**
 Name of the event. Might be null.
 */
@property (strong, nullable) NSString *name;

/**
 Unique event id.
 */
@property (readonly, assign) NSUInteger eventId;

/**
 The threshold in seconds.
 */
@property (readonly, assign) NSTimeInterval threshold;

/**
 Last time this event was triggered.
 */
@property (readonly, strong, nullable) NSDate *lastTriggered;

/**
 Scheduled start date for this event - Might be null.
 */
@property (readonly, strong, nullable) NSDate *scheduledStartDate;

/**
 Scheduled end date for this event - Might be null.
 */
@property (readonly, strong, nullable) NSDate *scheduledEndDate;

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
- (instancetype)initWithEventId:(NSUInteger)eventId
                      threshold:(NSTimeInterval)threshold
             scheduledStartDate:(NSDate *__nullable)startDate
               scheduledEndDate:(NSDate *__nullable)endDate
                  lastTriggered:(NSDate *__nullable)lastTriggered
                      eventType:(CREventType)eventType;
@end

NS_ASSUME_NONNULL_END
