//
//  BeaconsViewController.m
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "BeaconViewController.h"
#import "AppDelegate.h"

@interface BeaconViewController ()
@property NSMutableArray *objects;
@end

@implementation BeaconViewController {
    UILabel *backgroundLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

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

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Misc

- (void)setupVisuals {
    // Do some visual setup
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundLabel = [[UILabel alloc] init];
    [backgroundLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    backgroundLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17];
    backgroundLabel.textColor = BASE_COLOR;
    backgroundLabel.text = @"No beacons in range";
    backgroundLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.backgroundView = backgroundLabel;
}

- (void)setupCarrotSDK {
    // Setup CarrotSDK
    NSURL *urlToBMS = [NSURL URLWithString:@"http://test.com"];
    _beaconManager = [[CRBeaconManager alloc] initWithDelegate:self url:urlToBMS appKey:@"123456"];
    
    [_beaconManager grantNotficationPermission];
    [_beaconManager startSyncing];
    [_beaconManager startMonitoringBeacons];
}

@end
