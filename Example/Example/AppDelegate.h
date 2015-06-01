//
//  AppDelegate.h
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconViewController.h"
#import "StatusViewController.h"

#define BASE_COLOR [UIColor colorWithRed:0.913 green:0.478 blue:0.141 alpha:1.0]
#define RED_COLOR [UIColor redColor]
#define GREEN_COLOR [UIColor colorWithRed:0.403 green:0.658 blue:0.266 alpha:1.0]

@class CRBeaconManager;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

