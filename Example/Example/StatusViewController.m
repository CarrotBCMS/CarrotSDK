//
//  StatusViewController.m
//  Example
//
//  Created by Heiko Dreyer on 05/30/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "StatusViewController.h"
#import "AppDelegate.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (void)viewDidAppear:(BOOL)animated {
    [self update];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:[UIApplication sharedApplication]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
        [self update];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Status

- (void)update {
    [self bluetoothStatus];
    [self rangingStatus];
    [self monitoringStatus];
    [self locationServices];
    [self authorization];
    [self notifications];
}

- (void)bluetoothStatus {
    NSString *status = _beaconManager.bluetoothState == CRBluetoothStatePoweredOn ? @"On" : @"Off";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIColor *color = _beaconManager.bluetoothState == CRBluetoothStatePoweredOn ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

- (void)rangingStatus {
    NSString *status = _beaconManager.isRangingAvailable ? @"Available" : @"Unavailable";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIColor *color = _beaconManager.isRangingAvailable ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

- (void)monitoringStatus {
    NSString *status = _beaconManager.isMonitoringAvailable ? @"Available" : @"Unavailable";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UIColor *color = _beaconManager.isMonitoringAvailable ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

- (void)locationServices {
    NSString *status = _beaconManager.locationServicesEnabled ? @"Enabled" : @"Disabled";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UIColor *color = _beaconManager.locationServicesEnabled ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

- (void)notifications {
    NSString *status = _beaconManager.notificationsEnabled ? @"Permitted" : @"Not permitted";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UIColor *color = _beaconManager.notificationsEnabled ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

- (void)authorization {
    NSString *status = _beaconManager.isAuthorized ? @"Granted" : @"Not granted";
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UIColor *color = _beaconManager.isAuthorized ? GREEN_COLOR : RED_COLOR;
    cell.detailTextLabel.textColor = color;
    cell.detailTextLabel.text = status;
}

@end
