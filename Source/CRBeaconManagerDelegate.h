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

-(void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon;

-(void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon;

///---------------------------------------------------------------------------------------
/// @name Other (derived from CLBeaconManagerDelegate)
///---------------------------------------------------------------------------------------

- (void)manager:(CRBeaconManager *)beaconManager
 didEnterRegion:(CLBeaconRegion *)region
        beacons:(NSArray *)beacons;

- (void)manager:(CRBeaconManager *)beaconManager
  didExitRegion:(CLBeacon *)region
        beacons:(NSArray *)beacons;

- (void)manager:(CRBeaconManager *)beaconManager didDetermineState:(CLRegionState)state
      forRegion:(CLBeaconRegion *)region;

- (void)manager:(CRBeaconManager *)beaconManager didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region;

///---------------------------------------------------------------------------------------
/// @name Errors
///---------------------------------------------------------------------------------------

- (void)manager:(CRBeaconManager *)manager didFailWithError:(NSError *)error;

- (void)manager:(CRBeaconManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
      withError:(NSError *)error;

@end
