//
//  BeaconsViewController.h
//  Example
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CarrotSDK/CarrotSDK.h>

@class DetailViewController;

@interface BeaconsViewController : UITableViewController <CRBeaconManagerDelegate>

@property (strong, nonatomic) CRBeaconManager *beaconManager;


@end

