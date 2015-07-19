//
//  CRBeaconEventAggregatorTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 19.07.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRBeaconEventAggregator.h"

@interface CRBeaconEventAggregatorTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRBeaconEventAggregatorTests {
    CRBeaconEventAggregator *_aggregator;
}

- (void)setUp {
    [super setUp];
    _aggregator = [[CRBeaconEventAggregator alloc] initWithStoragePath:[NSTemporaryDirectory() stringByAppendingString:@"data/aggregation"]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSetBeaconsForEvents {
    [_aggregator setBeacons:@[@1, @2, @3] forEvent:1];
    
    XCTAssert([[_aggregator beaconsForEvent:1] count] == 3);
    XCTAssert([[_aggregator beaconsForEvent:1] containsObject:@1]);
    XCTAssert([[_aggregator beaconsForEvent:1] containsObject:@2]);
    XCTAssert([[_aggregator beaconsForEvent:1] containsObject:@3]);
}

- (void)testEventsForBeacon {
    [_aggregator setBeacons:@[@1, @2, @3, @4] forEvent:1];
    [_aggregator setBeacons:@[@1, @2, @5] forEvent:2];
    
    XCTAssert([_aggregator eventsForBeacon:2].count == 2);
    XCTAssert([_aggregator eventsForBeacon:5].count == 1);
    XCTAssert([[_aggregator eventsForBeacon:5][0] isEqualToNumber: @2]);
}

- (void)testBeaconsForEvent {
    [_aggregator setBeacons:@[@1, @2, @3, @4] forEvent:1];
    [_aggregator setBeacons:@[@1, @2, @5] forEvent:2];
    
    XCTAssert([_aggregator beaconsForEvent:2].count == 3);
    XCTAssert([_aggregator beaconsForEvent:1].count == 4);
}

@end
