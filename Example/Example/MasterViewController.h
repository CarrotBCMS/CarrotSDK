//
//  MasterViewController.h
//  Example
//
//  Created by Heiko Dreyer on 26.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CarrotSDK/CarrotSDK.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

