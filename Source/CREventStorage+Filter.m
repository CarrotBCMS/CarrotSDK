/*
 * Carrot - beacon management (sdk)
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
