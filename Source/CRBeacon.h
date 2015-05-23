//
//  CRBeacon.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CRBeacon : NSObject <NSSecureCoding>

/**
 Name of the beacon.
 */
@property (strong) NSString *name;

/**
 UUID string, e.g. 123e4567-e89b-12d3-a456-426655440000.
 */
@property (readonly) NSString *uuid;

/**
 Major identifier, e.g. 523423
 */
@property (readonly) NSString *major;

/**
 Minor identifier, e.g. 233123.
 */
@property (readonly) NSString *minor;

/**
 Related beacon (CoreLocation).
 */
@property (strong) CLBeacon *beacon;

/**
 Events dictionary.
    E.g. use key "CRBeaconTextEventsKey" to retrieve an array of all text events associated with this beacon.
 */
@property (strong) NSDictionary *events;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Initialize this proxy by providing a CLBeacon object.
 */
- (instancetype)initWithCLBeacon: (CLBeacon *)beacon
                            name: (NSString *)name
                          events: (NSDictionary *)events;

@end
