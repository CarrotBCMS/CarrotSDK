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
}

- (void)setUp {
    [super setUp];
    
    _beacon = OCMPartialMock([[CLBeacon alloc] init]);
    _beaconTwo = OCMPartialMock([[CLBeacon alloc] init]);
    OCMStub([_beacon proximityUUID]).andReturn([[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]);
    OCMStub([_beaconTwo proximityUUID]).andReturn([[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]);
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
    [_cache addCRBeaconsFromBeacons:@[_beacon, _beaconTwo] forUUIDString:@"123e4567-e89b-12d3-a456-426655440000"];
}

- (void)testCRBeaconsForUUID {
    
}

- (void)testEnteredCRBeacons {
    
}

- (void)testExitedCRBeacons {
    
}

@end
