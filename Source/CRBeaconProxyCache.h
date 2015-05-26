//
//  CRRegionCache.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CRBeaconProxyCache : NSCache

- (void)addBeaconsAsProxies:(NSArray *)beacons forUUIDString:(NSString *)uuidString;
- (NSArray *)beaconProxiesForUUIDString:(NSString *)uuidString;

- (NSArray *)enteredBeaconProxiesForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (NSArray *)exitedBeaconProxiesForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end
