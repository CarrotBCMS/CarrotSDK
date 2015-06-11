//
//  CREventStorage+Filter.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 28.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventStorage+Filter.h"
#import "CREvent.h"
#import "CRBeaconManagerEnums.h"

@implementation CREventStorage (Filter)

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRUD

- (NSArray *)findAllEnterEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeEnter];
}

- (NSArray *)findAllNotificationEnterEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllNotificationEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeEnter];
}

- (NSArray *)findAllExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeExit];
}

- (NSArray *)findAllNotificationExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllNotificationEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeExit];
}

- (NSArray *)_filterEvents:(NSArray *)events type:(CREventType)type {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CREvent *event = (CREvent *)evaluatedObject;
        return event.eventType == type || event.eventType == CREventTypeBoth;
    }];
    return [events filteredArrayUsingPredicate:predicate];
}

@end
