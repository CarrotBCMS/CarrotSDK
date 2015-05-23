//
//  CRBeaconManager.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CRBeacon.h"

@class CRBeaconManager;
@protocol CRBeaconManagerDelegate <NSObject>
@optional

-(void)manager:(CRBeaconManager *)beaconManager
didEnterRegion:(CLBeaconRegion *)region
        beacon:(CRBeacon *)beacon;

- (void)manager:(CRBeaconManager *)beaconManager
  didExitRegion:(CLBeaconRegion *)region
         beacon:(CRBeacon *)beacon;

- (void)manager:(CRBeaconManager *)beaconManager didDetermineState:(CLRegionState)state
      forRegion:(CLBeaconRegion *)region;

- (void)manager:(CRBeaconManager *)beaconManager didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@interface CRBeaconManager : NSObject

-(instancetype)initWithDelegate: (id<CRBeaconManagerDelegate>)delegate;

-(void)handleAuthorization;

-(void)startRangingBeacons;

-(void)stopRangingBeacons;

-(BOOL)startSyncingProcessWithError: (NSError **)error;

-(BOOL)cancelSyncingProcess;


@end
