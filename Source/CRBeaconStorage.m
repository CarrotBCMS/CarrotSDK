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

#import "CRBeaconStorage.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"

@implementation CRBeaconStorage

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Beacon specific CRUD methods

- (CRBeacon *)findCRBeaconWithUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor {
    CRBeacon *beacon = [[CRBeacon alloc] initWithUUID:uuid major:major minor:minor];
    CRBeacon *result = nil;
    
    NSArray *objects = [self objects];
    for (CRBeacon *aBeacon in objects) {
        if ([aBeacon isEqual:beacon]) {
            result = aBeacon;
            break;
        }
    }
    
    return result;
}

- (CRBeacon *)findCRBeaconWithId:(NSUInteger)beaconId {
    CRBeacon *result = nil;
    
    NSArray *objects = [self objects];
    for (CRBeacon *aBeacon in objects) {
        if (aBeacon.beaconId == beaconId) {
            result = aBeacon;
            break;
        }
    }
    
    return result;
}

- (NSArray<CLBeaconRegion *> *)UUIDRegions {
    NSMutableSet<CLBeaconRegion *> *uuids = [NSMutableSet set];
    NSArray *objects = [self objects];
    CLBeaconRegion *region;
    for (CRBeacon *aBeacon in objects) {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:aBeacon.uuid identifier:aBeacon.uuid.UUIDString];
        [uuids addObject:region];
    }
    
    return [uuids allObjects];
}

@end
