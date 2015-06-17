//
//  CRBeacon.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeacon.h"
#import "CRBeacon_Internal.h"

@implementation CRBeacon {
    NSUInteger _beaconId;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
                        name:(NSString *)name
{
    self = [super init];
    
    if (self) {
        _name = name;
        _uuid = uuid;
        _major = major;
        _minor = minor;
        _beacon = nil;
        _beaconId = 0;
    }
    
    return self;
}


- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor {
    return [self initWithUUID:uuid major:major minor:minor name:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self initWithUUID:[coder decodeObjectOfClass:[NSString class] forKey:@"uuid"]
                        major:[coder decodeObjectOfClass:[NSNumber class] forKey:@"major"]
                        minor:[coder decodeObjectOfClass:[NSNumber class] forKey:@"minor"]
                         name:[coder decodeObjectOfClass:[NSString class] forKey:@"name"]];
    self.beaconId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"beaconId"] integerValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_uuid forKey:@"uuid"];
    [aCoder encodeObject:_major forKey:@"major"];
    [aCoder encodeObject:_minor forKey:@"minor"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:@(_beaconId) forKey:@"beaconId"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    CRBeacon *aObject = (CRBeacon *)object;
    if (!object ||
        ![aObject.uuid isEqual:self.uuid] ||
        ![aObject.major isEqualToNumber:self.major] ||
        ![aObject.minor isEqualToNumber:self.minor] ||
        aObject.beaconId != self.beaconId
        )
    {
        return NO;
    }
    
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CRBeacon - UUID: %@ - Major: %@ - Minor: %@ - Name: %@", _uuid, _major, _minor, _name];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Accessors

- (void)setBeaconId:(NSUInteger)beaconId {
    _beaconId = beaconId;
}

- (NSUInteger)beaconId {
    return _beaconId;
}

@end
