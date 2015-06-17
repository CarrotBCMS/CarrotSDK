//
//  CRBeacon_Internal.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/17/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CarrotSDK/CarrotSDK.h>

@interface CRBeacon (Internal)

- (void)setBeaconId:(NSUInteger)beaconId;
- (NSUInteger)beaconId;

@end