//
//  CRBeaconManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeaconManager.h"

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
    [_regions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_locationManager startMonitoringForRegion:obj];
    }];
    [_locationManager startUpdatingLocation];
}

- (void)stopMonitoringBeacons {
    [_regions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    return YES;
}

- (BOOL)cancelSyncingProcess {
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

@end
