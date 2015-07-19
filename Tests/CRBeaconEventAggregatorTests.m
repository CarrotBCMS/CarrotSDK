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

@end
