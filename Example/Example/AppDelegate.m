//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "AppDelegate.h"
#import <CarrotSDK/CarrotSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window.tintColor = BASE_COLOR;
    
    UITabBarController *tabBarController = (UITabBarController *)_window.rootViewController;
    BeaconViewController *beaconViewController = (BeaconViewController *)((UINavigationController *)tabBarController.viewControllers[0]).topViewController;
    StatusViewController *statusViewController = (StatusViewController *)((UINavigationController *)tabBarController.viewControllers[1]).topViewController;

    
    NSURL *urlToBMS = [NSURL URLWithString:@"http://192.168.0.105:8080"];
    CRBeaconManager *beaconManager = [[CRBeaconManager alloc] initWithDelegate:beaconViewController url:urlToBMS appKey:@"aa1ac789-4ad4-4ee0-9626-337e1f3b4594"];
    beaconViewController.beaconManager = beaconManager;
    statusViewController.beaconManager = beaconManager;
    
    return YES;
}

@end
