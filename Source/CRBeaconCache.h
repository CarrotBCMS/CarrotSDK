//
//  CRRegionCache.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CRBeaconCache : NSCache

- (void)addCRBeaconsFromRangedBeacons:(NSArray *)beacons forUUID:(NSUUID *)uuid;
- (NSArray *)CRbeaconsForUUID:(NSUUID *)uuid;

- (NSArray *)enteredCRBeaconsForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (NSArray *)exitedCRBeaconsRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end
