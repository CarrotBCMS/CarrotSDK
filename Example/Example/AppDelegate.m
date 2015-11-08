//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "AppDelegate.h"
#import <CarrotSDK/CarrotSDK.h>

#define SERVER_ADDRESS @"http://carrotbms.herokuapp.com"
#define APP_KEY @"4a5a09d3-c805-4bf2-bc75-66fa46f2212d"

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
