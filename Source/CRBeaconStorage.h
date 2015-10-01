//
//  CRBeaconStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRSingleFileStorage.h"

NS_ASSUME_NONNULL_BEGIN

@class CRBeacon;
@class CLBeaconRegion;

/**
 This Subclass adds several ceacon specific crud methods to the superclass.
 */
@interface CRBeaconStorage : CRSingleFileStorage

///---------------------------------------------------------------------------------------
/// @name CRUD methods
///---------------------------------------------------------------------------------------

/**
Finds a specific beacon.

@param beaconId The id
*/
- (CRBeacon *)findCRBeaconWithId:(NSUInteger)beaconId;

/**
 Finds a specific beacon.
 
 @param path The uuid
 @param major Major
 @param minor Minor
 */
- (CRBeacon *)findCRBeaconWithUUID: (NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;

/**
 Finds all uuid regions.
 */
- (NSArray<CLBeaconRegion *> *)UUIDRegions;

NS_ASSUME_NONNULL_END

@end
