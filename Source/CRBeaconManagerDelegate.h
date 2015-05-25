//
//  CRBeaconManagerDelegate.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 24.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CRBeaconManager, CRBeacon, CRNotificationEvent;

@protocol CRBeaconManagerDelegate <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Callbacks
///---------------------------------------------------------------------------------------

/**
 Invoked whenever a known beacon enters proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param beacon Single beacon
 */
-(void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon;

/**
 Invoked whenever a known beacon exists proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param beacon Single beacon
 */
-(void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon;

/**
 Invoked whenever a notification has been fired.
 
 @see CRBeaconManager
 @see CRNotificationEvent
 @see CRBeacon
 
 @param beaconManager Beacon manager
 @param notification Notification event
 @param beacon Single beacon
 */
-(void)manager:(CRBeaconManager *)beaconManager didFireNotification:(CRNotificationEvent *)notification
        beacon:(CRBeacon *)beacon;

///---------------------------------------------------------------------------------------
/// @name Other (derived from ´CLBeaconManagerDelegate´)
///---------------------------------------------------------------------------------------

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
 didEnterRegion:(CLBeaconRegion *)region
        beacons:(NSArray *)beacons;

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
  didExitRegion:(CLBeacon *)region
        beacons:(NSArray *)beacons;

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
- (void)manager:(CRBeaconManager *)manager didFailWithError:(NSError *)error;

/**
 Invoked whenever there is a ranging error for the specific region.
 
 @see CRBeaconManager
 @see CLBeaconRegion
 
 @param beaconManager Beacon manager
 @param beaconManager Current region
 @param error Error
 */
- (void)manager:(CRBeaconManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
      withError:(NSError *)error;

@end
