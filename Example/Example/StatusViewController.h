//
//  StatusViewController.h
//  Example
//
//  Created by Heiko Dreyer on 05/30/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CarrotSDK/CarrotSDK.h>

@interface StatusViewController : UITableViewController

@property (strong, nonatomic) CRBeaconManager *beaconManager;

@end
