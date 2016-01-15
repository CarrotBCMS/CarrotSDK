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
