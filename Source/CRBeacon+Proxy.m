//
//  CRBeacon+Proxy.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeacon+Proxy.h"
#import "CRBeaconProxy.h"

@implementation CRBeacon (Proxy)

- (instancetype)initFromProxy:(CRBeaconProxy *)proxy {
    if (!proxy) {
        return [self init];
    }
    
    self = [self initWithUUID:proxy.proximityUUID.UUIDString major:proxy.major minor:proxy.minor name:@"" events:nil];
    return self;
}

@end
