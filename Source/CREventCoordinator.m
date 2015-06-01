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

- (NSArray *)_updateAndReturnPermittedEvents:(NSArray*)events beacon:(CRBeacon *)beacon;

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
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllExitEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllNotificationEnterEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray *allEvents = [_storage findAllNotificationExitEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (void)sendLocalNotificationWithEvent:(CRNotificationEvent *)event {
    CRLog("Sending local notification.");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = event.title;
    notification.alertBody = event.message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSMutableDictionary *userInfo = [@{@"id": @(event.eventId)} mutableCopy];
    if (event.payload) {
        [userInfo setObject:event.payload forKey:@"payload"];
    }
    
    notification.userInfo = [NSDictionary dictionaryWithDictionary:userInfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSArray *)_updateAndReturnPermittedEvents:(NSArray*)events beacon:(CRBeacon *)beacon {
    NSMutableArray *results = [NSMutableArray array];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CREvent *event = (CREvent *)obj;
        NSDate *lastTriggered = event.lastTriggered;
        if (!lastTriggered || [lastTriggered timeIntervalSinceNow] + event.threshold <= 0) {
            // Assign a new date for "lastTriggered" - We assume that those events will get triggered eventually.
            event.lastTriggered = [NSDate date];
            [_storage refresh:beacon];
            
            // Add object to results
            [results addObject:event];
        }
    }];

    return [NSArray arrayWithArray:results];
}

@end
