//
//  CRRegionCache.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
