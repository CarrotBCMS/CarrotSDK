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

#import "CREventCoordinator.h"
#import "CREventStorage.h"
#import "CREventStorage+Filter.h"
#import "CREvent.h"
#import "CREvent_Internal.h"
#import "CRNotificationEvent.h"
#import "CRDefines.h"

@interface CREventCoordinator ()

- (NSArray<__kindof CREvent*> *)_updateAndReturnPermittedEvents:(NSArray<__kindof CREvent *> *)events beacon:(CRBeacon *)beacon;
- (BOOL)_eventInSchedule:(CREvent *)event;

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
    NSArray<__kindof CREvent *> *allEvents = [_storage findAllEnterEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validExitEventsForBeacon:(CRBeacon *)beacon {
    NSArray<__kindof CREvent *> *allEvents = [_storage findAllExitEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray<CRNotificationEvent *> *allEvents = [_storage findAllNotificationEnterEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (NSArray *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSArray<CRNotificationEvent *> *allEvents = [_storage findAllNotificationExitEventsForBeacon:beacon];
    return [self _updateAndReturnPermittedEvents:allEvents beacon:beacon];
}

- (void)sendLocalNotificationWithEvent:(CRNotificationEvent *)event {
    CRLog("Sending local notification.");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = event.title;
    notification.alertBody = event.message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSMutableDictionary<NSString *, NSString *> *userInfo = [@{@"id": @(event.eventId)} mutableCopy];
    if (event.payload && ![event.payload isEqual:[NSNull null]]) {
        [userInfo setObject:event.payload forKey:@"payload"];
    }
    
    notification.userInfo = [NSDictionary dictionaryWithDictionary:userInfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSArray<__kindof CREvent *> *)_updateAndReturnPermittedEvents:(NSArray*)events beacon:(CRBeacon *)beacon {
    NSMutableArray<__kindof CREvent *> *results = [NSMutableArray array];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CREvent *event = (CREvent *)obj;
        NSDate *lastTriggered = event.lastTriggered;
        if (event.isActive && (!lastTriggered || [lastTriggered timeIntervalSinceNow] + event.threshold <= 0)) {
            if ((!event.scheduledStartDate && !event.scheduledEndDate) || [self _eventInSchedule:event]) {
                // Assign a new date for "lastTriggered" - We assume that those events will get triggered eventually.
                [event __setLastTriggered:[NSDate date]];
                [_storage refresh:event];
                
                // Add object to results
                [results addObject:event];
            }
        }
    }];

    return [NSArray arrayWithArray:results];
}

- (BOOL)_eventInSchedule:(CREvent *)event {
    NSDate *currentDate = [NSDate date];
    NSDate *startDate = event.scheduledStartDate;
    NSDate *endDate = event.scheduledEndDate;
    if (!startDate || !endDate) {
        return NO;
    }
    
    const NSTimeInterval i = [currentDate timeIntervalSinceReferenceDate];
    return ([startDate timeIntervalSinceReferenceDate] <= i && [endDate timeIntervalSinceReferenceDate] >= i);
}

@end
