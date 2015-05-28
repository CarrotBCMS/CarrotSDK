//
//  CRRegionCache.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 Temporarily stores beacons. See `NSCache` for memory related details.
 
 @see NSCache
 */
@interface CRBeaconCache : NSCache

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
- (void)addCRBeaconsFromRangedBeacons:(NSArray *)beacons forUUID:(NSUUID *)uuid;

/**
 Retrieve all beacons for given id
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param uuid The UUID
 */
- (NSArray *)CRBeaconsForUUID:(NSUUID *)uuid;

/**
 Retrieve all beacons
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param region The region
 */
- (NSArray *)enteredCRBeaconsForRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

/**
 Retrieve all beacons
 
 @see CRBeacon
 
 @param beacons Beacon array
 @param region The region
 */
- (NSArray *)exitedCRBeaconsRangedBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end
