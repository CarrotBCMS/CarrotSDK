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

#import "CRBeaconCache.h"
#import "CRBeacon.h"

@interface CRBeaconCache()

-(NSArray<CRBeacon *> *)_CRBeaconArrayFromBeaconArray:(NSArray *)beacons;

@end

@implementation CRBeaconCache {
    NSMutableDictionary<NSString *, NSArray *> *_objects;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - De/-Initialising

- (instancetype)init {
    self = [super init];
    if (self) {
        _objects = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Storing, Caching and general fiddling

- (void)addCRBeaconsFromRangedBeacons:(NSArray<CLBeacon *> *)beacons forUUID:(NSUUID *)uuid {
    [_objects setObject:[NSArray arrayWithArray:[self _CRBeaconArrayFromBeaconArray:beacons]] forKey:uuid.UUIDString];
}

- (NSArray<CRBeacon *> *)CRBeaconsForUUID:(NSUUID *)uuid {
    NSArray *object = [_objects objectForKey:uuid.UUIDString];
    if (!object) {
        object = [NSArray array];
    }
    
    return [NSArray arrayWithArray:object];
}

- (NSArray<CRBeacon *> *)enteredCRBeaconsForRangedBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    NSArray *beaconsInRange = [self _CRBeaconArrayFromBeaconArray:beacons];
    NSArray *prevBeaconsInRange = [NSArray arrayWithArray:[self CRBeaconsForUUID:region.proximityUUID]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", prevBeaconsInRange];
    return [beaconsInRange filteredArrayUsingPredicate:predicate];
}

- (NSArray<CRBeacon *> *)exitedCRBeaconsRangedBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    NSArray *beaconsInRange = [self _CRBeaconArrayFromBeaconArray:beacons];
    NSArray *prevBeaconsInRange = [NSArray arrayWithArray:[self CRBeaconsForUUID:region.proximityUUID]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", beaconsInRange];
    return [prevBeaconsInRange filteredArrayUsingPredicate:predicate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

-(NSArray<CRBeacon *> *)_CRBeaconArrayFromBeaconArray:(NSArray<CLBeacon *> *)beacons {
    NSMutableArray *crBeaconArray = [NSMutableArray array];
    for (CLBeacon *beacon in beacons) {
        CRBeacon *crBeacon = [[CRBeacon alloc] initWithUUID:beacon.proximityUUID
                                                      major:beacon.major
                                                      minor:beacon.minor];
        crBeacon.beacon = beacon;
        [crBeaconArray addObject:crBeacon];
    }
    
    return crBeaconArray;
}

@end
