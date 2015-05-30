//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "AppDelegate.h"
#import <CarrotSDK/CarrotSDK.h>

@interface AppDelegate () <CRBeaconManagerDelegate>

@end

@implementation AppDelegate {
    CRBeaconManager *_beaconManager;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setup visuals
    _window.tintColor = [UIColor orangeColor];
    
    // Setup CarrotSDK
    NSURL *urlToBMS = [NSURL URLWithString:@"http://test.com"];
    _beaconManager = [[CRBeaconManager alloc] initWithDelegate:self url:urlToBMS appKey:@"123456"];
    
    [_beaconManager grantNotficationPermission];
    [_beaconManager startSyncing];
    [_beaconManager startMonitoringBeacons];
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRBeaconManagerDelegate

- (void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Entered radius (Example): %@", beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Exited radius (Example): %@", beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager didFireNotification:(CRNotificationEvent *)notification beacon:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Fired notification: %@ - Beacon: %@", notification, beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager shouldPresentEvents:(NSArray *)events beacon:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Should present events: %@ - Beacon: %@", events, beacon);
}

@end
