//
//  CRBeacon_Internal.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/17/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CarrotSDK/CarrotSDK.h>

@interface CRBeacon (Internal) <NSSecureCoding>

- (void)__setBeaconId:(NSUInteger)beaconId;
- (NSUInteger)beaconId;
+ (instancetype)beaconFromJSON:(NSDictionary *)dictionary;

@end