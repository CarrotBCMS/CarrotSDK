//
//  CRBeaconProxy.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CRBeaconProxy : NSObject

@property (strong) NSUUID *proximityUUID;
@property (strong) NSNumber *major;
@property (strong) NSNumber *minor;
@property (strong) CLBeacon *beacon;

@end
