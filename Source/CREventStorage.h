/*
 * Carrot -  beacon content management (sdk)
 * Copyright (C) 2016 Heiko Dreyer
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

NS_ASSUME_NONNULL_BEGIN

@class CREvent;
@class CRNotificationEvent;
@class CRBeacon;
@class CRBeaconEventAggregator;

/**
 In contrast to the `CRSingleFileStorage`, this storage persists an array containing all events for a specific beacon region
 in a single file. There is a single file per region. File name is the uuid string.
 
 @see CRSingleFileStorage
 @see CRBeaconStorage
 */
@interface CREventStorage : NSObject

///---------------------------------------------------------------------------------------
/// @name Storage properties
///---------------------------------------------------------------------------------------

/**
 Base path
 */
@property (readonly, strong) NSString *basePath;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Inits a Storage with given base path.
 
 @param path The base path
 @param aggregator Instance to retrieve beacon-event relationships
 */
- (instancetype)initWithBaseStoragePath:(NSString *)path aggregator:(CRBeaconEventAggregator *)aggregator;

///---------------------------------------------------------------------------------------
/// @name CRUD methods
///---------------------------------------------------------------------------------------

/**
 Add an event.
 
 @param event The event
 @param beacon The corresponding beacon
 */
- (void)addEvent:(CREvent *)event;

/**
 Adds an array of events.
 
 @param events The array
 */
- (void)addEvents:(NSArray<__kindof CREvent *> *)events;

/**
 Remove an event.
 
 @param eventId The id
 */
- (void)removeEventWithId:(NSUInteger)eventId;

/**
 Remove an array of events.
 
 @param events Array with eventIds
 */
- (void)removeEventsWithIds:(NSArray<NSNumber *> *)events;

/**
 Removes all events.
 */
- (void)removeAllEvents;

/**
 Refreshes event.
 */
- (void)refresh:(CREvent *)event;

/**
 Finds a specific event.
 @param eventId The id
 */
- (CREvent *)findEventForId:(NSUInteger)eventId;

/**
 Finds all events for a corresponding beacon. 
 Notification events are not included.
 
 @param beacon The beacon
 */
- (NSArray<__kindof CREvent *> *)findAllEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification events for a corresponding beacon.
 
 @param beacon The beacon
 */
- (NSArray<CRNotificationEvent *> *)findAllNotificationEventsForBeacon:(CRBeacon *)beacon;

@end

NS_ASSUME_NONNULL_END
