//
//  CRBeacon.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeacon.h"

@implementation CRBeacon {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithUUID:(NSString *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
                        name:(NSString *)name
                      events:(NSDictionary *)events
{
    self = [super init];
    
    if (self) {
        _name = name;
        _uuid = uuid;
        _major = major;
        _minor = minor;
        _beacon = nil;
        _events = [NSDictionary dictionaryWithDictionary:events];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self initWithUUID:[coder decodeObjectOfClass:[NSString class] forKey:@"uuid"]
                        major:[coder decodeObjectOfClass:[NSString class] forKey:@"major"]
                        minor:[coder decodeObjectOfClass:[NSString class] forKey:@"minor"]
                         name:[coder decodeObjectOfClass:[NSString class] forKey:@"name"]
                       events:[coder decodeObjectOfClass:[NSString class] forKey:@"events"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_uuid forKey:@"uuid"];
    [aCoder encodeObject:_major forKey:@"major"];
    [aCoder encodeObject:_minor forKey:@"minor"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_events forKey:@"events"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
