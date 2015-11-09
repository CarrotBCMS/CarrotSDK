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

#import "BeaconViewController.h"
#import "AppDelegate.h"

@interface BeaconViewController ()
@property NSMutableArray *objects;
@end

@implementation BeaconViewController {
    UILabel *backgroundLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising & Actions

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _objects = [NSMutableArray array];
    [self setupVisuals];
    [self setupCarrotSDK];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refresh:(id)sender {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                   UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    [_beaconManager startSyncing];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.objects.count;
    backgroundLabel.hidden = count != 0;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CRBeacon *beacon = self.objects[indexPath.row];
    cell.textLabel.text = beacon.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@ - Minor: %@ - UUID: %@", beacon.major, beacon.minor, beacon.uuid.UUIDString];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRBeaconManagerDelegate

- (void)manager:(CRBeaconManager *)beaconManager didEnterBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Entered radius (Example): %@", beacon);
    
    if (![_objects containsObject:beacon]) {
        [_objects addObject:beacon];
        [self.tableView reloadData];
    }
}

- (void)manager:(CRBeaconManager *)beaconManager didExitBeaconRadius:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Exited radius (Example): %@", beacon);
    
    if ([_objects containsObject:beacon]) {
        [_objects removeObject:beacon];
        [self.tableView reloadData];
    }
}

- (void)manager:(CRBeaconManager *)beaconManager didFireNotification:(CRNotificationEvent *)notification beacon:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Fired notification: %@ - Beacon: %@", notification, beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager shouldPresentEvents:(NSArray *)events beacon:(CRBeacon *)beacon {
    NSLog(@"CarrotExample: Should present events: %@ - Beacon: %@", events, beacon);
}

- (void)manager:(CRBeaconManager *)beaconManager syncingDidFailWithError:(NSError *)error {
    [self addRefreshButton];
}

- (void)managerDidFinishSyncing:(CRBeaconManager *)beaconManager {
    [self addRefreshButton];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Misc

- (void)setupVisuals {
    // Do some visual setup
    [self addRefreshButton];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundLabel = [[UILabel alloc] init];
    [backgroundLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    backgroundLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17];
    backgroundLabel.textColor = BASE_COLOR;
    backgroundLabel.text = @"No beacons in range";
    backgroundLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.backgroundView = backgroundLabel;
}

- (void)addRefreshButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
}

- (void)setupCarrotSDK {
    // Setup CarrotSDK
    [_beaconManager grantNotficationPermission];
    [_beaconManager startMonitoringBeacons];
}

@end
