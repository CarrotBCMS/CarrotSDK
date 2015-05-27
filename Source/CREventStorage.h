//
//  CREventStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CREvent, CRBeacon;
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
- (void)addEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon;

/**
 Adds an array of events.
 
 @param events The array
 @param beacon The corresponding beacon
 */
- (void)addEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon;

/**
 Remove an event.
 
 @param event The event
 @param beacon The corresponding beacon
 */
- (void)removeEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon;

/**
 Remove an array of events.
 
 @param events The array
 @param beacon The assigned beacon
 */
- (void)removeEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon;

/**
 Removes all events for the corresponding beacon
 
 @param beacon The corresponding beacon
 */
- (void)removeAllEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findAllEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findNotificationEventsForBeacon:(CRBeacon *)beacon;


@end
