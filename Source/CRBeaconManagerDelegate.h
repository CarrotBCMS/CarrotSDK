//
//  CRBeaconManagerDelegate.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 24.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CRBeaconManagerEnums.h"

@class CRBeaconManager;
@class CRBeacon;
@class CRNotificationEvent;

@protocol CRBeaconManagerDelegate <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Beacon ranging callbacks
///---------------------------------------------------------------------------------------

/**
 Invoked whenever a known beacon enters proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param beacon Single beacon
 */
- (void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon;

/**
 Invoked whenever a known beacon exists proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param beacon Single beacon
 */
- (void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon;

/**
 Invoked whenever a notification has been fired.
 
 @see CRBeaconManager
 @see CRNotificationEvent
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param notification Notification event
 @param beacon Single beacon
 */
- (void)manager:(CRBeaconManager *)beaconManager didFireNotification:(CRNotificationEvent *)notification
         beacon:(CRBeacon *)beacon;

/**
 Invoked whenever one or more events are triggered and ready to be presented.
 
 @see CRBeaconManager
 @see CREvent
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param events An array containing all events that should be presented
 @param beacon Single beacon
 */
- (void)manager:(CRBeaconManager *)beaconManager shouldPresentEvents:(NSArray *)events
         beacon:(CRBeacon *)beacon;

///---------------------------------------------------------------------------------------
/// @name Syncing
///---------------------------------------------------------------------------------------

/**
 Invoked whenever a syncing error occurs.
 
 @see CRBeaconManager
 
 @param beaconManager Beacon manager
 @param error The error
 */
- (void)manager:(CRBeaconManager *)beaconManager syncingDidFailWithError:(NSError *)error;


/**
 Invoked whenever syncing finishes.
 
 @see CRBeaconManager
 @param beaconManager Beacon manager
 */
- (void)managerDidFinishSyncing:(CRBeaconManager *)beaconManager;

///---------------------------------------------------------------------------------------
/// @name Bluetooth
///---------------------------------------------------------------------------------------

/**
 Invoked whenever a known beacon exists proximity range.
 
 @see CRBeaconManager
 
 @param beaconManager Beacon manager
 @param state The bluetooth state
 */
- (void)manager:(CRBeaconManager *)beaconManager didUpdateBluetoothState:(CRBluetoothState)state;

///---------------------------------------------------------------------------------------
/// @name Other (derived from ´CLBeaconManagerDelegate´)
///---------------------------------------------------------------------------------------

/**
 Invoked whenever authorization status changes.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 
 @param beaconManager Beacon manager
 @param status Authorization status
 */
- (void)manager:(CRBeaconManager *)beaconManager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

/**
 Invoked whenever the user enters a region.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param region The specific region
 @param beacons All beacons
 */
- (void)manager:(CRBeaconManager *)beaconManager
 didEnterRegion:(CLBeaconRegion *)region;

/**
 Invoked whenever the user exits a region.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param region The specific region
 @param beacons Array with beacons
 */
- (void)manager:(CRBeaconManager *)beaconManager
  didExitRegion:(CLBeaconRegion *)region;

/**
 Invoked whenever a region state was determined.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param state The current state
 @param region The specific region
 */
- (void)manager:(CRBeaconManager *)beaconManager didDetermineState:(CLRegionState)state
      forRegion:(CLBeaconRegion *)region;

/**
 Invoked whenever beacons were ranged.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param beacons Array with beacons
 @param region The specific region
 */
- (void)manager:(CRBeaconManager *)beaconManager didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region;

///---------------------------------------------------------------------------------------
/// @name Errors
///---------------------------------------------------------------------------------------

/**
 Invoked whenever an error occurs.
 
 @see CRBeaconManager
 
 @param beaconManager Beacon manager
 @param error Error
 */
- (void)manager:(CRBeaconManager *)beaconManager didFailWithError:(NSError *)error;

/**
 Invoked whenever an error occurs while monitoring a specific region.
 
 @see CRBeaconManager
 
 @param beaconManager Beacon manager
 @param region The region
 @param error Error
 */
- (void)manager:(CRBeaconManager *)beaconManager monitoringDidFailForRegion:(CLBeaconRegion *)region
      withError:(NSError *)error;

/**
 Invoked whenever there is a ranging error for the specific region.
 
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param beaconManager Current region
 @param error Error
 */
- (void)manager:(CRBeaconManager *)beaconManager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
      withError:(NSError *)error;

@end
