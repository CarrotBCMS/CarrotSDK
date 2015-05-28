//
//  CREventCoordinatorTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 28.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CREventCoordinator.h"
#import "CREvent.h"
#import "CRNotificationEvent.h"
#import "CRBeacon.h"
#import "CREventStorage.h"

@interface CREventCoordinatorTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventCoordinatorTests {
    CREventCoordinator *_coordinator;
    CRBeacon *_beacon;
    CREvent *_event;
    CREvent *_eventTwo;
    CRNotificationEvent *_notEvent;
    CRNotificationEvent *_notEventTwo;
    CREventStorage *_storage;
}

- (void)setUp {
    [super setUp];
    
    _beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]
                                       major:@1
                                       minor:@2];
    
    _event = [[CREvent alloc] init];
    _event = [[CREvent alloc] initWithEventId:@1
                                    threshold:1000
                                lastTriggered:[NSDate dateWithTimeIntervalSinceNow:-2000]
                                    eventType:CREventTypeEnter];
    
    _eventTwo = [[CREvent alloc] initWithEventId:@2
                                       threshold:1000
                                   lastTriggered:[NSDate dateWithTimeIntervalSinceNow:-1000]
                                       eventType:CREventTypeEnter];
    
    _notEvent = [[CRNotificationEvent alloc] initWithEventId:@12
                                                   threshold:1000
                                               lastTriggered:[NSDate dateWithTimeIntervalSinceNow:-4000]
                                                   eventType:CREventTypeEnter];
    _notEvent.message = @"testmessage";
    _notEvent.title = @"testtitle";
    _notEvent.payload = @"testpayload";
    
    _notEventTwo = [[CRNotificationEvent alloc] initWithEventId:@12
                                                   threshold:1000
                                               lastTriggered:[NSDate dateWithTimeIntervalSinceNow:-5000]
                                                   eventType:CREventTypeEnter];
    _notEventTwo.message = @"testmessage";
    _notEventTwo.title = @"testtitle";
    _notEventTwo.payload = @"testpayload";
    
    _storage = OCMClassMock([CREventStorage class]);
    _coordinator = [[CREventCoordinator alloc] initWithEventStorage:_storage];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testValidEnterEvents {
    NSArray *result = [_coordinator validEnterEventsForBeacon:_beacon];
    XCTAssert(result.count == 2);
}

- (void)testValidExitEvents {
    NSArray *result = [_coordinator validEnterEventsForBeacon:_beacon];
    XCTAssert(result.count == 2);
}

- (void)testValidEnterNotificationEvents {
    NSArray *result = [_coordinator validEnterNotificationEventsForBeacon:_beacon];
    XCTAssert(result.count == 2);
}

- (void)testValidExitNotificationEvents {
    NSArray *result = [_coordinator validExitNotificationEventsForBeacon:_beacon];
    XCTAssert(result.count == 0);
}

@end
