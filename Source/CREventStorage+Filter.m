//
//  CREventStorage+Filter.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventStorage+Filter.h"
#import "CREvent.h"
#import "CRBeaconManagerEnums.h"

@implementation CREventStorage (Filter)

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRUD

- (NSArray<__kindof CREvent *> *)findAllEnterEventsForBeacon:(CRBeacon *)beacon {
    NSArray<__kindof CREvent *> *allEvents = [self findAllEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeEnter];
}

- (NSArray<__kindof CREvent *> *)findAllNotificationEnterEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllNotificationEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeEnter];
}

- (NSArray<__kindof CREvent *> *)findAllExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray<__kindof CREvent *> *allEvents = [self findAllEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeExit];
}

- (NSArray<__kindof CREvent *> *)findAllNotificationExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [self findAllNotificationEventsForBeacon:beacon];
    return [self _filterEvents:allEvents type:CREventTypeExit];
}

- (NSArray<__kindof CREvent *> *)_filterEvents:(NSArray *)events type:(CREventType)type {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        CREvent *event = (CREvent *)evaluatedObject;
        return event.eventType == type || event.eventType == CREventTypeBoth;
    }];
    return [events filteredArrayUsingPredicate:predicate];
}

@end
