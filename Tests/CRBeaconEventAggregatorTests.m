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
