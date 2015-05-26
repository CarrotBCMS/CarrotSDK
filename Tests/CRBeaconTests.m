//
//  CRBeaconTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/26/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRBeacon.h"

@interface CRBeaconTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIsEqual {
    CRBeacon *beaconOne = [[CRBeacon alloc] initWithUUID:@"testuuid" major:@112 minor:@111 name:@"testbeacon" events:nil];
    CRBeacon *beaconTwo = [[CRBeacon alloc] initWithUUID:@"testuuid" major:@112 minor:@111 name:@"testbeacon" events:nil];
    CRBeacon *beaconThree = [[CRBeacon alloc] initWithUUID:@"_testuuid_" major:@112222 minor:@1111213 name:@"testbeacon" events:nil];
    XCTAssertEqualObjects(beaconOne, beaconTwo);
    XCTAssertNotEqualObjects(beaconOne, beaconThree);
    XCTAssertNotEqualObjects(beaconTwo, beaconThree);
}

@end
