/*
 * Carrot -  beacon content management (sdk)
 * Copyright (C) 2016 Heiko Dreyer
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
#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import <OCMock/OCMock.h>
#import "CRBeaconCache.h"

@interface CRBeaconCacheTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconCacheTests {
    CLBeacon *_beacon;
    CLBeacon *_beaconTwo;
    CRBeaconCache *_cache;
    NSUUID *_uuid;
    NSUUID *_uuidSecondInstance;
}

- (void)setUp {
    [super setUp];
    
    _beacon = OCMClassMock([CLBeacon class]);
    _beaconTwo = OCMClassMock([CLBeacon class]);
    _uuid = [[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"];
    _uuidSecondInstance = [[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"];
    OCMStub([_beacon proximityUUID]).andReturn(_uuid);
    OCMStub([_beaconTwo proximityUUID]).andReturn(_uuid);
    OCMStub([_beacon major]).andReturn(@111);
    OCMStub([_beaconTwo major]).andReturn(@111);
    OCMStub([_beacon minor]).andReturn(@1);
    OCMStub([_beaconTwo minor]).andReturn(@2);
    
    _cache = [[CRBeaconCache alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAddCRBeacons {
    [_cache addCRBeaconsFromRangedBeacons:@[_beacon, _beaconTwo] forUUID:_uuid];
    
    NSArray *result = [_cache CRBeaconsForUUID:_uuidSecondInstance];
    XCTAssert(result.count == 2);
}

- (void)testCRBeaconsForUUID {
    [_cache addCRBeaconsFromRangedBeacons:@[_beacon, _beaconTwo] forUUID:_uuid];
    
    NSArray *result = [_cache CRBeaconsForUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440002"]];
    XCTAssert(result.count == 0);
    result = [_cache CRBeaconsForUUID:_uuidSecondInstance];
    XCTAssert(result.count == 2);
}

- (void)testEnteredCRBeacons {
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"test"];
    
    NSArray *result = [_cache enteredCRBeaconsForRangedBeacons:@[_beacon, _beaconTwo] inRegion:region];
    XCTAssert(result.count == 2);
}

- (void)testExitedCRBeacons {
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"test"];
    NSArray *result = [_cache enteredCRBeaconsForRangedBeacons:@[_beacon, _beaconTwo] inRegion:region];
    XCTAssert(result.count == 2);
    
    result = [_cache exitedCRBeaconsRangedBeacons:@[_beacon] inRegion:region];
    XCTAssert(result.count == 0);
    
    [_cache addCRBeaconsFromRangedBeacons:@[_beacon, _beaconTwo] forUUID:_uuidSecondInstance];
    result = [_cache CRBeaconsForUUID:_uuid];
    XCTAssert(result.count == 2);
    result = [_cache exitedCRBeaconsRangedBeacons:@[_beacon] inRegion:region];
    XCTAssert(result.count == 1);
}

@end
