//
//  CRBeaconEventAggregator.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/18/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
