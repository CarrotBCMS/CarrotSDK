//
//  CRBeacon.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CRBeacon : NSObject <NSSecureCoding>

/**
 Name of the beacon. Might be null.
 */
@property (readonly, strong) NSString *name;

/**
 UUID, e.g. 123e4567-e89b-12d3-a456-426655440000.
 */
@property (readonly, strong) NSUUID *uuid;

/**
 Major identifier, e.g. 523423
 */
@property (readonly, strong) NSNumber *major;

/**
 Minor identifier, e.g. 233123.
 */
@property (readonly, strong) NSNumber *minor;

/**
 Related beacon (CoreLocation).
 */
@property (strong) CLBeacon *beacon;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Initialize this proxy.
 
 @param uuid UUID string
 @param major Major identifier
 @param minor Minor identifier
 @param name Name
 @param events Dictionary with associated events
 */
- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
                        name:(NSString *)name;


/**
 Initialize this proxy by providing a CLBeacon object.
 
 @param uuid UUID string
 @param major Major identifier
 @param minor Minor identifier
 */
- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor;

@end
