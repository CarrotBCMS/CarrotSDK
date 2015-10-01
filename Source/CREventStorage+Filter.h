//
//  CREventStorage+Filter.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
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
- (NSArray<__kindof CREvent *> *)findAllEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<CRNotificationEvent *> *)findAllNotificationEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<__kindof CREvent *> *)findAllExitEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<CRNotificationEvent *> *)findAllNotificationExitEventsForBeacon:(CRBeacon *)beacon;

@end
