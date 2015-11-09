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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CRBeaconManagerEnums.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CRBeaconManagerDelegate;

@interface CRBeaconManager : NSObject

/**
 Delegate property
 */
@property (nonatomic, assign, nullable) id <CRBeaconManagerDelegate> delegate;

/**
 URL to CarrotBMS
 */
@property (readonly, nonnull) NSURL *url;

/**
 Application key
 */
@property (readonly, nonnull) NSString *appKey;

/**
 Whether monitoring is active or not
 */
@property (readonly) BOOL monitoringIsActive;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Initialize a CRBeaconManager instance. Must provide a valid app key and url to a running bms endpoint.
 
 @see CRBeaconManagerDelegate
 
 @param delegate Manager delegate
 @param url URL to CarrotBMS
 @param key Application key
 */
- (instancetype)initWithDelegate:(id<CRBeaconManagerDelegate> __nullable)delegate
                            url:(NSURL *)url
                         appKey:(NSString *)key;

///---------------------------------------------------------------------------------------
/// @name Monitoring
///---------------------------------------------------------------------------------------

/**
 Start monitoring beacons. Checking for proximity of available beacons.
 */
- (void)startMonitoringBeacons;

/**
 Stop monitoring beacons. No further delegate methods are being called.
 */
- (void)stopMonitoringBeacons;

///---------------------------------------------------------------------------------------
/// @name Capabilities & Permissions
///---------------------------------------------------------------------------------------

/**
 Determines whether the user has granted authorization to use the location at any time.
 */
- (BOOL)isAuthorized;

/**
 Determines whether the device has (iBeacon) ranging support.
 */
- (BOOL)isRangingAvailable;

/**
 Determines whether the device has (iBeacon) monitoring support.
 */
- (BOOL)isMonitoringAvailable;

/**
 Determines whether the user has location services enabled.
 */
- (BOOL)locationServicesEnabled;

/**
 Determines whether permissions are granted.
 */
- (BOOL)notificationsEnabled;

/**
 Determines bluetooth state 
 */
- (CRBluetoothState)bluetoothState;

/**
 Asking for permission to send local notifications.
 */
- (void)grantNotficationPermission;

///---------------------------------------------------------------------------------------
/// @name Syncing
///---------------------------------------------------------------------------------------

/**
 Whether manager is currently syncing with the BMS.
 */
@property (readonly) BOOL isSyncing;

/**
 Connect to CarrotBMS and start syncing beacons and events.
 */
- (void)startSyncing;

/**
 Cancecel active sync process beacon data.
 */
- (void)stopSyncing;

@end

NS_ASSUME_NONNULL_END
