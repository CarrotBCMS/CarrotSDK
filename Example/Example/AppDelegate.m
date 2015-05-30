//
//  AppDelegate.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "AppDelegate.h"
#import "BeaconViewController.h"
#import <CarrotSDK/CarrotSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    CRBeaconManager *_beaconManager;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window.tintColor = BASE_COLOR;
    
    return YES;
}

@end
