//
//  CRBeaconManager.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CRBeaconManagerDelegate;

@interface CRBeaconManager : NSObject

/**
 Delegate property
 */
@property (nonatomic, assign) id <CRBeaconManagerDelegate> delegate;

/**
 URL to CarrotBMS
 */
@property (readonly) NSURL *url;

/**
 Application key
 */
@property (readonly) NSString *appKey;

/**
 Whether monitoring is active or not
 */
@property (readonly) BOOL monitoringIsActive;

/**
 Whether syncing is active or not
 */
@property (readonly) BOOL syncingIsActive;

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
- (instancetype)initWithDelegate:(id<CRBeaconManagerDelegate>)delegate
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
/// @name Syncing
///---------------------------------------------------------------------------------------

/**
 Determines whether the user has granted authorization to use the location at any time.
 */
+ (BOOL)isAuthorized;

/**
 Determines whether the device has (iBeacon) ranging support.
 */
+ (BOOL)isRangingAvailable;

/**
 Determines whether the user has location services enabled.
 */
+ (BOOL)locationServicesEnabled;

///---------------------------------------------------------------------------------------
/// @name Syncing
///---------------------------------------------------------------------------------------

/**
 Connect to CarrotBMS and start syncing beacons and events.
 
 @param error Error pointer
 */
- (BOOL)startSyncingProcessWithError:(NSError * __autoreleasing *)error;

/**
 Stop syncing beacon data.
 */
- (BOOL)cancelSyncingProcess;

@end
