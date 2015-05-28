//
//  CRBeaconCacheTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
    
    NSArray *result = [_cache CRbeaconsForUUID:_uuidSecondInstance];
    XCTAssert(result.count == 2);
}

- (void)testCRBeaconsForUUID {
    [_cache addCRBeaconsFromRangedBeacons:@[_beacon, _beaconTwo] forUUID:_uuid];
    
    NSArray *result = [_cache CRbeaconsForUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440002"]];
    XCTAssert(result.count == 0);
    result = [_cache CRbeaconsForUUID:_uuidSecondInstance];
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
    result = [_cache CRbeaconsForUUID:_uuid];
    XCTAssert(result.count == 2);
    result = [_cache exitedCRBeaconsRangedBeacons:@[_beacon] inRegion:region];
    XCTAssert(result.count == 1);
}

@end
