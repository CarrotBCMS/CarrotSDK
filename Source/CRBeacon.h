/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRBeacon : NSObject

/**
 Name of the beacon. Might be null.
 */
@property (readonly, strong, nullable) NSString *name;

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
@property (strong, nullable) CLBeacon *beacon;

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
                        name:(NSString *__nullable)name;


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

NS_ASSUME_NONNULL_END
