//
//  CRRegionCache.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@class CRBeacon;

/**
 Temporarily stores beacons. This is not persistent, objects are not getting evicted during low memory circumstances.
 */
@interface CRBeaconCache : NSObject

///---------------------------------------------------------------------------------------
/// @name Caching
///---------------------------------------------------------------------------------------

/**
 Create a `CRBeacon` array from a `CLBeacon` array and add it to the cache.
 
 @see CRBeacon
 @see CLBeacon
 
 @param beacons Beacon array
 @param uuid The UUID
 */
- (void)addCRBeaconsFromRangedBeacons:(NSArray<CLBeacon *> *)beacons forUUID:(NSUUID *)uuid;

/**
 Retrieve all beacons for given id
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param uuid The UUID
 */
- (NSArray<CRBeacon *> *)CRBeaconsForUUID:(NSUUID *)uuid;

/**
 Retrieve all beacons
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param region The region
 */
- (NSArray<CRBeacon *> *)enteredCRBeaconsForRangedBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region;

/**
 Retrieve all beacons
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param region The region
 */
- (NSArray<CRBeacon *> *)exitedCRBeaconsRangedBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region;

@end

NS_ASSUME_NONNULL_END
