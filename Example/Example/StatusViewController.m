/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
