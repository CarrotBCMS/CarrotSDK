//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 26.05.15.
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
    NSURL *urlToBMS = [NSURL URLWithString:@"http://test.com"];
    _beaconManager = [[CRBeaconManager alloc] initWithDelegate:self url:urlToBMS appKey:@"123456"];
    
    [_beaconManager grantNotficationPermission];
    [_beaconManager startSyncing];
    [_beaconManager startMonitoringBeacons];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRBeaconManagerDelegate

- (void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"Entered radius (Example): %@", beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"Exited radius (Example): %@", beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager didFireNotification:(CRNotificationEvent *)notification beacon:(CRBeacon *)beacon {
    NSLog(@"Fired notification: %@ - Beacon: %@", notification, beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager shouldPresentEvents:(NSArray *)events beacon:(CRBeacon *)beacon {
    NSLog(@"Should present events: %@ - Beacon: %@", events, beacon);
}

@end
