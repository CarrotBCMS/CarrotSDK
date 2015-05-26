//
//  CRRegionCache.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeaconProxyCache.h"
#import "CRBeaconProxy.h"

@interface CRBeaconProxyCache()

-(NSArray *)_proxyArrayFromBeaconArray:(NSArray *)beacons;

@end

@implementation CRBeaconProxyCache

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Storing, Caching and general fiddling

- (void)addBeaconsAsProxies:(NSArray *)beacons forUUIDString:(NSString *)uuidString {
    [self setObject:[NSArray arrayWithArray:[self _proxyArrayFromBeaconArray:beacons]] forKey:uuidString];
}

- (NSArray *)beaconProxiesForUUIDString:(NSString *)uuidString {
    NSArray *object = [self objectForKey:uuidString];
    if (!object) {
        object = [NSArray array];
    }
    return [NSArray arrayWithArray:object];
}

- (NSArray *)enteredBeaconProxiesForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSArray *beaconsInRange = [self _proxyArrayFromBeaconArray:beacons];
    NSArray *prevBeaconsInRange = [NSArray arrayWithArray:[self beaconProxiesForUUIDString:region.proximityUUID.UUIDString]];

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", prevBeaconsInRange];
    return [beaconsInRange filteredArrayUsingPredicate:predicate];
}

- (NSArray *)exitedBeaconProxiesForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSArray *beaconsInRange = [self _proxyArrayFromBeaconArray:beacons];
    NSArray *prevBeaconsInRange = [NSArray arrayWithArray:[self beaconProxiesForUUIDString:region.proximityUUID.UUIDString]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", beaconsInRange];
    return [prevBeaconsInRange filteredArrayUsingPredicate:predicate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

-(NSArray *)_proxyArrayFromBeaconArray:(NSArray *)beacons {
    NSMutableArray *proxyArray = [NSMutableArray array];
    for (CLBeacon *beacon in beacons) {
        CRBeaconProxy *proxy = [[CRBeaconProxy alloc] init];
        proxy.major = [beacon.major copy];
        proxy.minor = [beacon.minor copy];
        proxy.proximityUUID = [beacon.proximityUUID copy];
        proxy.beacon = beacon;
        [proxyArray addObject:proxy];
    }
    
    return proxyArray;
}


@end
