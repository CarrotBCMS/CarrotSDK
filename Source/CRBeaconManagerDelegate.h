//
//  CRBeaconManagerDelegate.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 24.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CRBeaconManager, CRBeacon;

@protocol CRBeaconManagerDelegate <NSObject>
@optional

///---------------------------------------------------------------------------------------
/// @name Callbacks
///---------------------------------------------------------------------------------------

/**
 Invoked whenever a known beacon enters proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 */
-(void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon;


/**
 Invoked whenever a known beacon exists proximity range.
 
 @see CRBeaconManager
 @see CRBeacon
 */
-(void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon;

///---------------------------------------------------------------------------------------
/// @name Other (derived from ´CLBeaconManagerDelegate´)
///---------------------------------------------------------------------------------------

/**
 Invoked whenever the user enters a region.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 */
- (void)manager:(CRBeaconManager *)beaconManager
 didEnterRegion:(CLBeaconRegion *)region
        beacons:(NSArray *)beacons;

/**
 Invoked whenever the user exits a region.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 */
- (void)manager:(CRBeaconManager *)beaconManager
  didExitRegion:(CLBeacon *)region
        beacons:(NSArray *)beacons;

/**
 Invoked whenever a region state was determined.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 */
- (void)manager:(CRBeaconManager *)beaconManager didDetermineState:(CLRegionState)state
      forRegion:(CLBeaconRegion *)region;


/**
 Invoked whenever beacons were ranged.
 
 @see CLBeaconManagerDelegate
 @see CRBeaconManager
 @see CLBeaconRegion
 */
- (void)manager:(CRBeaconManager *)beaconManager didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region;

///---------------------------------------------------------------------------------------
/// @name Errors
///---------------------------------------------------------------------------------------

/**
 Invoked whenever an error occurs.
 
 @see CRBeaconManager
 */
- (void)manager:(CRBeaconManager *)manager didFailWithError:(NSError *)error;

/**
 Invoked whenever there is a ranging error for the specific region
 
 @see CRBeaconManager
 @see CLBeaconRegion
 */
- (void)manager:(CRBeaconManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
      withError:(NSError *)error;

@end
