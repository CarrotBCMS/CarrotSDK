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
