//
//  CREventStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CREvent;
@class CRBeacon;

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
 */
- (instancetype)initWithBaseStoragePath:(NSString *)path;

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
- (void)addEvents:(NSArray *)events;

/**
 Remove an event.
 
 @param eventId The id
 */
- (void)removeEventWithId:(NSUInteger)eventId;

/**
 Remove an array of events.
 
 @param events Array with eventIds
 */
- (void)removeEventsWithIds:(NSArray *)events;

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
- (NSArray *)findAllEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification events for a corresponding beacon.
 
 @param beacon The beacon
 */
- (NSArray *)findAllNotificationEventsForBeacon:(CRBeacon *)beacon;

@end

NS_ASSUME_NONNULL_END
