//
//  CRBeaconStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRPersistentStorage.h"

@interface CRBeaconStorage : CRPersistentStorage

- (NSArray *)UUIDRegions;

@end
