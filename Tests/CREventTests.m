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

- (void)testIsEquality {
    CREvent *event = [[CREvent alloc] initWithEventId:1 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    CREvent *eventTwo = [[CREvent alloc] initWithEventId:1 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    CREvent *eventThree = [[CREvent alloc] initWithEventId:3 threshold:1000 lastTriggered:nil eventType:CREventTypeExit];
    
    XCTAssertEqualObjects(event, eventTwo);
    XCTAssertNotEqualObjects(event, eventThree);
    XCTAssertNotEqualObjects(eventTwo, eventThree);
}


@end
