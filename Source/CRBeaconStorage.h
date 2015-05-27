//
//  CRBeaconStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRSingleFileStorage.h"

@class CRBeacon;
@interface CRBeaconStorage : CRSingleFileStorage

- (CRBeacon *)findCRBeaconWithUUID: (NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;
- (NSArray *)UUIDRegions;

@end
