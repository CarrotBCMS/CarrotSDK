/*
 * Carrot -  beacon content management (sdk)
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
