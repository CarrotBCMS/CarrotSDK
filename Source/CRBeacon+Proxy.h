//
//  CRBeacon+Proxy.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CarrotSDK/CarrotSDK.h>

@class CRBeaconProxy;
@interface CRBeacon (Proxy)

- (instancetype)initFromProxy:(CRBeaconProxy *)proxy;

@end
