/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
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

#import "CRBeaconEventAggregator.h"
#import "CRSingleFileStorage_Internal.h"

@implementation CRBeaconEventAggregator

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithStoragePath:(NSString *)path {
    self = [super initWithStoragePath:path];
    
    if (self) {
        if (_objects.count != 2) {
            [_objects addObject:[NSMutableDictionary dictionary]]; // First is event->beacon
            [_objects addObject:[NSMutableDictionary dictionary]]; // Second is beacon->event
            [self _save];
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Crud

- (void)setBeacons:(NSArray<NSNumber *> *)beaconIds forEvent:(NSUInteger)eventId {
    NSMutableDictionary *eventBeacons = _objects[0];
    NSMutableDictionary *beaconEvents = _objects[1];
    
    // Set events-beacon
    if (eventBeacons) {
        [eventBeacons setObject:[NSSet setWithArray:beaconIds] forKey:@(eventId)];
    }
    
    // Set beacon-events
    if (beaconEvents) {
        for (NSNumber *aBeaconId in beaconIds) {
            NSMutableSet<NSNumber *> *events = [beaconEvents objectForKey:aBeaconId];
            if (!events) {
                events = [NSMutableSet set];
                [beaconEvents setObject:events forKey:aBeaconId];
            }
            
            [events addObject:@(eventId)];
        }
    }
    
    [self _save];
}

- (NSArray<NSNumber *> *)beaconsForEvent:(NSUInteger)eventId {
    NSSet *objects = [(NSDictionary *)_objects[0] objectForKey:@(eventId)];
    return [objects allObjects];
}

- (NSArray<NSNumber *> *)eventsForBeacon:(NSUInteger)beaconId {
    NSSet *objects = [(NSDictionary *)_objects[1] objectForKey:@(beaconId)];
    return [objects allObjects];
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Overrides

- (void)addObject:(id)object {
    // ..
}

- (void)removeObject:(id)object {
    // ..
}

- (void)addObjectsFromArray:(NSArray *)array {
    // ..
}

- (void)removeObjectsInArray:(NSArray *)array {
    // ..
}

@end
