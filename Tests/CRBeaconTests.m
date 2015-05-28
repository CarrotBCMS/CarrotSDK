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

- (void)testEquality {
    CRBeacon *beaconOne = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@112 minor:@111 name:@"testbeacon"];
    CRBeacon *beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]  major:@112 minor:@111 name:@"testbeacon"];
    CRBeacon *beaconThree = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655190000"]  major:@112222 minor:@1111213 name:@"testbeacon"];
    XCTAssertEqualObjects(beaconOne, beaconTwo);
    XCTAssertNotEqualObjects(beaconOne, beaconThree);
    XCTAssertNotEqualObjects(beaconTwo, beaconThree);
}

@end
