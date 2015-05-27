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
/// @name CRUD methods
///---------------------------------------------------------------------------------------


/**
 Add an event.
 
 @param event The event
 @param beacon The assigned beacon
 */
- (void)addEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon;

/**
 Adds an array of events.
 
 @param events The array
 @param beacon The assigned beacon
 */
- (void)addEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon;

/**
 Finds all events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSDictionary *)findAllEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findNotificationEventsForBeacon:(CRBeacon *)beacon;

@end
