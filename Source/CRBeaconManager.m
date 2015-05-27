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
#import "CRBeaconCache.h"
#import "CRBeacon.h"
#import "CRBeaconStorage.h"

@interface CRBeaconManager () <CLLocationManagerDelegate>

- (void)_setup;
- (NSString *)_stringForState:(CLRegionState)state;
- (void)_sendLocalNotificationWithMessage:(NSString*)message;
- (NSArray *)_regions;

- (void)_handleEnterBeacons:(NSArray *)beacons;
- (void)_handleExitBeacons:(NSArray *)beacons;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconManager {
    CLLocationManager *_locationManager;
    NSArray *_regions;
    BOOL _isActive;
    
    CRBeaconCache *_beaconCache;
    CRBeaconStorage *_beaconStorage;
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
    if (![CRBeaconManager isRangingAvailable] || ![CRBeaconManager isMonitoringAvailable]) {
        CRLog("No hardware support for ranging and monitoring.");
        return;
    }
    
    CRLog("Start monitoring beacons.");
    [[self _regions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CRLog("Start monitoring region: %@", obj);
        CLBeaconRegion *region = (CLBeaconRegion *)obj;
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        region.notifyEntryStateOnDisplay = YES;
        [_locationManager startRangingBeaconsInRegion:region];
        [_locationManager startMonitoringForRegion:region];
    }];
    [_locationManager startUpdatingLocation];
    _monitoringIsActive = YES;
}

- (void)stopMonitoringBeacons {
    CRLog("Stop monitoring beacons.");
    [[self _regions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_locationManager stopMonitoringForRegion:obj];
    }];
    [_locationManager stopUpdatingLocation];
    _monitoringIsActive = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Status

+ (BOOL)isAuthorized {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

+ (BOOL)isRangingAvailable {
    return [CLLocationManager isRangingAvailable];
}

+ (BOOL)isMonitoringAvailable {
    return [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
}

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)isBackgroundFetchingAvailable {
    return [UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

- (BOOL)startSyncingProcessWithError:(NSError * __autoreleasing *)error {
    CRLog("Start syncing process.");
    _syncingIsActive = YES;
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
    _beaconCache = [[CRBeaconCache alloc] init];
    _beaconStorage = [[CRBeaconStorage alloc] initWithStoragePath:CRBeaconDataFilePath];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    // Important for iOS 8 cases.
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}

- (void)_sendLocalNotificationWithMessage:(NSString*)message {
    CRLog("Sending local notification.");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSString *)_stringForState:(CLRegionState)state {
    NSString *stateString;
    
    switch (state) {
        case CLRegionStateInside:
            stateString = @"CLRegionStateInside";
            break;
            
        case CLRegionStateOutside:
            stateString = @"CLRegionStateOutside";
            break;
            
        default:
            stateString = @"CLRegionStateUnknown";
            break;
    }
    
    return stateString;
}

- (NSArray *)_regions {
    // return _regions;
    return @[[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] identifier:@"Sensorberg Test Beacons" ],
             [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0001"] identifier:@"Sensorberg Test Beacons 2" ]];
}

- (void)_handleEnterBeacons:(NSArray *)beacons {
    [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CRBeacon *beacon = nil;
        if ([obj isKindOfClass:[CRBeacon class]]) {
            beacon = obj;
        }
        
        // Find concrete CRBeacon instance in storage
        // Only call delegate if a CRBeacon was found
        beacon = [_beaconStorage findCRBeaconWithUUID:beacon.uuidString major:beacon.major minor:beacon.minor];
        
        if (beacon && [(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didEnterBeaconRadius:)]) {
            [_delegate manager:self didEnterBeaconRadius:beacon];
        }
    }];
}

- (void)_handleExitBeacons:(NSArray *)beacons {
    [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CRBeacon *beacon = nil;
        if ([obj isKindOfClass:[CRBeacon class]]) {
            beacon = obj;
        }
        // Find concrete CRBeacon instance in storage
        // Only call delegate if a CRBeacon was foundon instance from storage
        beacon = [_beaconStorage findCRBeaconWithUUID:beacon.uuidString major:beacon.major minor:beacon.minor];
        
        if (beacon && [(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didExitBeaconRadius:)]) {
            [_delegate manager:self didExitBeaconRadius:beacon];
        }
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didRangeBeacons:inRegion:)]) {
        [_delegate manager:self didRangeBeacons:beacons inRegion:region];
    }

    NSArray *enteredBeacons = [_beaconCache enteredCRBeaconsForRangedBeacons:beacons inRegion:region];
    NSArray *exitedBeacons = [_beaconCache exitedCRBeaconsRangedBeacons:beacons inRegion:region];
    
    if (enteredBeacons.count > 0) {
        CRLog(@"Entered beacons: %@", enteredBeacons);
        [self _handleEnterBeacons:enteredBeacons];
    }
    
    if (exitedBeacons.count > 0) {
        CRLog(@"Exited beacons: %@", exitedBeacons);
        [self _handleExitBeacons:exitedBeacons];
    }
    
    [_beaconCache addCRBeacons:beacons forUUIDString:region.proximityUUID.UUIDString];
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    CRLog("Did determine state: %@ - Region: %@", [self _stringForState:state], region);
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
    CRLog("Did fail for Region: %@ - Error: %@", region, error);
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:monitoringDidFailForRegion:withError:)]) {
        [_delegate manager:self monitoringDidFailForRegion:(CLBeaconRegion *)region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    CRLog("Did change authorization status: %d", status);
    
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didChangeAuthorizationStatus:)]) {
        [_delegate manager:self didChangeAuthorizationStatus:status];
    }
}

@end
