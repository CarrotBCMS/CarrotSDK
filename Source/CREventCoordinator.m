//
//  CREventCoordinator.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventCoordinator.h"
#import "CREventStorage.h"
#import "CREventStorage+Filter.h"
#import "CREvent.h"
#import "CRNotificationEvent.h"
#import "CRDefinitions.h"

@interface CREventCoordinator ()

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventCoordinator {
    CREventStorage *_storage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithEventStorage:(CREventStorage*)storage {
    self = [super init];
    if (self) {
        _storage = storage;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Coordination

- (NSArray *)validEnterEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllEnterEventsForBeacon:beacon];
    return [self _filterPermittedEvents:allEvents];
}

- (NSArray *)validExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllExitEventsForBeacon:beacon];
    return [self _filterPermittedEvents:allEvents];
}

- (NSArray *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllNotificationEnterEventsForBeacon:beacon];
    return [self _filterPermittedEvents:allEvents];
}

- (NSArray *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllNotificationExitEventsForBeacon:beacon];
    return [self _filterPermittedEvents:allEvents];
}

- (void)sendLocalNotificationWithEvent:(CRNotificationEvent *)event {
    CRLog("Sending local notification.");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = event.title;
    notification.alertBody = event.message;
    notification.userInfo = @{@"payload": event.payload, @"id": event.eventId};
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSArray *)_filterPermittedEvents:(NSArray*)events {
    NSMutableArray *results = [NSMutableArray array];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CREvent *event = (CREvent *)obj;
        NSDate *lastTriggered = event.lastTriggered;
        if ([lastTriggered timeIntervalSinceNow] + event.threshold <= 0) {
            [results addObject:event];
        }
    }];

    return [NSArray arrayWithArray:results];
}

@end
