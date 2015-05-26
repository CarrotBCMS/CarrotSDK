//
//  CRBeaconManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeaconManager.h"
#import "CRBeaconManagerDelegate.h"
#import "CRDefinitions.h"

@interface CRBeaconManager () <CLLocationManagerDelegate>
- (void)_setup;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconManager {
    CLLocationManager *_locationManager;
    NSArray *_regions;
    BOOL _isActive;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithDelegate:(id<CRBeaconManagerDelegate>)delegate
                             url:(NSURL *)url
                          appKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _url = url;
        _appKey = key;
        _delegate = delegate;
        _monitoringIsActive = NO;
        _syncingIsActive = NO;
        [self _setup];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Monitoring

- (void)startMonitoringBeacons {
    CRLog("Start monitoring beacons.");
    [[self _regions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_locationManager startMonitoringForRegion:obj];
    }];
    [_locationManager startUpdatingLocation];
}

- (void)stopMonitoringBeacons {
    CRLog("Stop monitoring beacons.");
    [[self _regions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_locationManager stopMonitoringForRegion:obj];
    }];
    [_locationManager stopUpdatingLocation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Status

+ (BOOL)isAuthorized {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

+ (BOOL)isRangingAvailable {
    return [CLLocationManager isRangingAvailable];
}

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

- (BOOL)startSyncingProcessWithError:(NSError * __autoreleasing *)error {
    CRLog("Start syncing process.");
    return YES;
}

- (BOOL)cancelSyncingProcess {
    CRLog("Stop syncing process.");
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private
- (void)_setup {
    _regions = [NSArray array];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    // Important for iOS 8 cases.
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}

-(void)_sendLocalNotificationWithMessage:(NSString*)message {
    CRLog("Sending local notification.");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSArray *)_regions {
    // return _regions;
    return @[[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] identifier:@"Sensorberg Test Beacons" ]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CRLog("Did range beacons: %@ - Region: %@", beacons, region);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didRangeBeacons:inRegion:)]) {
        [_delegate manager:self didRangeBeacons:beacons inRegion:region];
    }

    
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    CRLog("Did determine state: %ld - Region: %@", state, region);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didDetermineState:forRegion:)]) {
        [_delegate manager:self didDetermineState:state forRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    CRLog("Ranging beacons failed for region: %@ - Error: %@", region, error);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:rangingBeaconsDidFailForRegion:withError:)]) {
        [_delegate manager:self rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    CRLog("Did enter region: %@", region);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didEnterRegion:)]) {
        [_delegate manager:self didEnterRegion:(CLBeaconRegion *)region];
    }
    
    // Start ranging here
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    CRLog("Did exit region: %@", region);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didExitRegion:)]) {
        [_delegate manager:self didExitRegion:(CLBeaconRegion *)region];
    }
    
    // Stop ranging here
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    CRLog("Did fail: %@", error);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didFailWithError:)]) {
        [_delegate manager:self didFailWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:monitoringDidFailForRegion:withError:)]) {
        [_delegate manager:self monitoringDidFailForRegion:(CLBeaconRegion *)region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didChangeAuthorizationStatus:)]) {
        [_delegate manager:self didChangeAuthorizationStatus:status];
    }
}

@end
