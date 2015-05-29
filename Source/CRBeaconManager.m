//
//  CRBeaconManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "CRBeaconManager.h"
#import "CRBeaconManagerDelegate.h"
#import "CRDefinitions.h"
#import "CRBeaconCache.h"
#import "CRBeacon.h"
#import "CRBeaconStorage.h"
#import "CREventStorage.h"
#import "CREventCoordinator.h"
#import "CRSyncManager.h"

@interface CRBeaconManager () <CLLocationManagerDelegate, CBCentralManagerDelegate, CRSyncManagerDelegate>

- (void)_setup;
- (NSString *)_stringForState:(CLRegionState)state;
- (void)_sendLocalNotificationsAndNotifyDelegateWithEvents:(NSArray *)notificationObjects
                                                    beacon:(CRBeacon *)beacon;
- (void)_notifyDelegateToPresentEvents:(NSArray *)objects beacon:(CRBeacon *)beacon;
- (NSArray *)_regions;

- (void)_handleEnterBeacons:(NSArray *)beacons;
- (void)_handleExitBeacons:(NSArray *)beacons;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconManager {
    CLLocationManager *_locationManager;
    CBCentralManager *_bluetoothManager;
    NSArray *_regions;
    BOOL _isActive;
    
    CRBeaconCache *_beaconCache;
    CRBeaconStorage *_beaconStorage;
    CREventStorage *_eventStorage;
    CREventCoordinator *_eventCoordinator;
    CRSyncManager *_syncManager;
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
        _isSyncing = NO;
        [self _setup];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Monitoring

- (void)startMonitoringBeacons {
    if (![self isRangingAvailable] || ![self isMonitoringAvailable]) {
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

- (BOOL)isAuthorized {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
}

- (BOOL)isRangingAvailable {
    return [CLLocationManager isRangingAvailable];
}

- (BOOL)isMonitoringAvailable {
    return [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
}

- (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)isBackgroundFetchingAvailable {
    return [UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable;
}

- (CRBluetoothState)bluetoothState {
    return (CRBluetoothState)_bluetoothManager.state;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing & CRSyncManagerDelegate

- (void)startSyncing {
    CRLog("Start syncing process.");
    _isSyncing = YES;
}

- (void)stopSyncing {
    CRLog("Stop syncing process.");
    _isSyncing = NO;
}

- (void)syncManager:(CRSyncManager *)syncManager didFailWithError:(NSError *)error {
    CRLog("Syncing process failed with error: %@", error);
    
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:syncingDidFailWithError:)]) {
        [_delegate manager:self syncingDidFailWithError:error];
    }
}

- (void)syncManagerDidFinishSyncing:(CRSyncManager *)syncManager {
    CRLog("Syncing process finished.");
    _isSyncing = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (void)_setup {
    _regions = [NSArray array];
    _beaconCache = [[CRBeaconCache alloc] init];
    _beaconStorage = [[CRBeaconStorage alloc] initWithStoragePath:CRBeaconDataFilePath];
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:CRBeaconDataBasePath];
    _eventCoordinator = [[CREventCoordinator alloc] initWithEventStorage:_eventStorage];
    
    _syncManager = [[CRSyncManager alloc] initWithDelegate:self eventStorage:_eventStorage
                                             beaconStorage:_beaconStorage];
    
    _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                             queue:dispatch_get_main_queue()
                                                           options:@{CBCentralManagerOptionShowPowerAlertKey: @NO}];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    
    // Important for iOS 8 cases.
    if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
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
        beacon = [_beaconStorage findCRBeaconWithUUID:beacon.uuid major:beacon.major minor:beacon.minor];
        
        if (beacon) {
            if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didEnterBeaconRadius:)]) {
                [_delegate manager:self didEnterBeaconRadius:beacon];
            }
            
            // Check and perform notification handling if necessary.
            NSArray *notificationObjects = [_eventCoordinator validEnterNotificationEventsForBeacon:beacon];
            [self _sendLocalNotificationsAndNotifyDelegateWithEvents:notificationObjects beacon:beacon];
            
            // Check and perform event handling if necessary.
            NSArray *objects = [_eventCoordinator validEnterEventsForBeacon:beacon];
            [self _notifyDelegateToPresentEvents:objects beacon:beacon];
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
        beacon = [_beaconStorage findCRBeaconWithUUID:beacon.uuid major:beacon.major minor:beacon.minor];
        
        if (beacon) {
            if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didExitBeaconRadius:)]) {
                [_delegate manager:self didExitBeaconRadius:beacon];
            }
            
            // Check and perform notification handling if necessary.
            NSArray *notificationObjects = [_eventCoordinator validExitNotificationEventsForBeacon:beacon];
            [self _sendLocalNotificationsAndNotifyDelegateWithEvents:notificationObjects beacon:beacon];
            
            // Check and perform event handling if necessary.
            NSArray *objects = [_eventCoordinator validExitEventsForBeacon:beacon];
            [self _notifyDelegateToPresentEvents:objects beacon:beacon];
        }
    }];
}

- (void)_sendLocalNotificationsAndNotifyDelegateWithEvents:(NSArray *)notificationObjects
                                                    beacon:(CRBeacon *)beacon
{
    for (CRNotificationEvent *event in notificationObjects) {
        [_eventCoordinator sendLocalNotificationWithEvent:event];
        if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didFireNotification:beacon:)]) {
            [_delegate manager:self didFireNotification:event beacon:beacon];
        }
    }
}

- (void)_notifyDelegateToPresentEvents:(NSArray *)objects beacon:(CRBeacon *)beacon {
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:shouldPresentEvents:beacon:)]) {
        if (objects && objects.count > 0) {
            [_delegate manager:self shouldPresentEvents:objects beacon:beacon];
        }
    }
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
    
    [_beaconCache addCRBeaconsFromRangedBeacons:beacons forUUID:region.proximityUUID];
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

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    CRLog("Did update bluetooth state: %ld", (long)central.state);
    
    if ([(id<CRBeaconManagerDelegate>)_delegate respondsToSelector:@selector(manager:didUpdateBluetoothState:)]) {
        [_delegate manager:self didUpdateBluetoothState:(CRBluetoothState)central.state];
    }
}

@end
