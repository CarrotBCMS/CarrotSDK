//
//  CREventTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 28.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CREvent.h"

@interface CREventTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIsEqual {
    CREvent *event = [[CREvent alloc] init];
    event.eventId = @1;
    CREvent *eventTwo = [[CREvent alloc] init];
    eventTwo.eventId = @1;
    CREvent *eventThree = [[CREvent alloc] init];
    eventThree.eventId = @15;
    
    XCTAssertEqualObjects(event, eventTwo);
    XCTAssertNotEqualObjects(event, eventThree);
    XCTAssertNotEqualObjects(eventTwo, eventThree);
}


@end
