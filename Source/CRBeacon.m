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
    self = [self initWithUUID:[coder decodeObjectOfClass:[NSString class] forKey:@"CRBeacon_uuid"]
                        major:[coder decodeObjectOfClass:[NSNumber class] forKey:@"CRBeacon_major"]
                        minor:[coder decodeObjectOfClass:[NSNumber class] forKey:@"CRBeacon_minor"]
                         name:[coder decodeObjectOfClass:[NSString class] forKey:@"CRBeacon_name"]];
    self.beaconId = [[coder decodeObjectOfClass:[NSNumber class] forKey:@"CRBeacon_beaconId"] integerValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_uuid forKey:@"CRBeacon_uuid"];
    [aCoder encodeObject:_major forKey:@"CRBeacon_major"];
    [aCoder encodeObject:_minor forKey:@"CRBeacon_minor"];
    [aCoder encodeObject:_name forKey:@"CRBeacon_name"];
    [aCoder encodeObject:@(_beaconId) forKey:@"CRBeacon_beaconId"];
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
        ![aObject.minor isEqualToNumber:self.minor] 
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

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal factory method

+ (instancetype)beaconFromJSON:(NSDictionary *)dictionary {
    NSString *uuid = dictionary[@"uuid"];
    NSNumber *major = dictionary[@"major"];
    NSNumber *minor = dictionary[@"minor"];
    NSString *name = dictionary[@"name"];
    NSNumber *beaconId = dictionary[@"id"];
    
    if (!uuid || !major || !minor || !name || !beaconId) {
        return nil;
    }
    
    NSUUID *sUuuid = [[NSUUID alloc] initWithUUIDString:uuid];
    if (!sUuuid) {
        return nil;
    }
    
    CRBeacon *beacon = [[CRBeacon alloc] initWithUUID:sUuuid major:major minor:minor name:name];
    beacon.beaconId = beaconId.integerValue;

    return beacon;
}


@end
