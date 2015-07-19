//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "AppDelegate.h"
#import <CarrotSDK/CarrotSDK.h>

#define SERVER_ADDRESS @"http://192.168.0.108:8080"
#define APP_KEY @"841bbbde-d8b1-4a75-bd79-74107c6bd1c4"

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

    
    NSURL *urlToBMS = [NSURL URLWithString:SERVER_ADDRESS];
    CRBeaconManager *beaconManager = [[CRBeaconManager alloc] initWithDelegate:beaconViewController url:urlToBMS appKey:APP_KEY];
    beaconViewController.beaconManager = beaconManager;
    statusViewController.beaconManager = beaconManager;
    
    return YES;
}

@end
