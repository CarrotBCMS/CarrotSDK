//
//  CRBeaconProxy.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeaconProxy.h"

@implementation CRBeaconProxy

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Misc

- (BOOL)isEqual:(id)object {
    CRBeaconProxy *aObject = (CRBeaconProxy *)object;
    if (!object ||
        ![aObject.proximityUUID.UUIDString isEqualToString:self.proximityUUID.UUIDString] ||
        ![aObject.major isEqualToNumber:self.major] ||
        ![aObject.minor isEqualToNumber:self.minor]
        )
    {
        return NO;
    }
    
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CRBeaconProxy - UUID: %@ - Major: %@ - Minor: %@", self.proximityUUID.UUIDString, self.major, self.minor];
}

@end
