//
//  CREventStorage+Filter.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 28.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventStorage.h"

@interface CREventStorage (Filter)

///---------------------------------------------------------------------------------------
/// @name CRUD methods
///---------------------------------------------------------------------------------------

/**
 Finds all enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findAllEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findAllNotificationEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findAllExitEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray *)findAllNotificationExitEventsForBeacon:(CRBeacon *)beacon;

@end
