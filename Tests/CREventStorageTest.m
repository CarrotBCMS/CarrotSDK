//
//  CREventStorageTest.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 27.05.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CREventStorage.h"
#import "CRBeacon.h"
#import "CREvent.h"
#import "CRNotificationEvent.h"

@interface CREventStorageTest : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventStorageTest {
    CREventStorage *_eventStorage;
    NSString *_basePath;
    NSFileManager *_fileManager;
    CRBeacon *_beacon;
    CRBeacon *_beaconTwo;
    CREvent *_event;
    CREvent *_eventTwo;
}

- (void)setUp {
    [super setUp];
    _fileManager = [NSFileManager defaultManager];
    _basePath = [NSTemporaryDirectory() stringByAppendingString:@"data/"];
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath];
    _beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@111 minor:@222];
    _beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440002"] major:@113 minor:@225];
    _event = [[CREvent alloc] init];
    _event.eventId = @111;
    _eventTwo = [[CREvent alloc] init];
    _eventTwo.eventId = @112;
    
}

- (void)tearDown {
    [super tearDown];
    
    if ([_fileManager fileExistsAtPath:_eventStorage.basePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_eventStorage.basePath error:NULL];
    }
}

- (void)testInitWithStoragePath {
    BOOL dir = false;
    XCTAssertTrue([_fileManager fileExistsAtPath:_eventStorage.basePath isDirectory:&dir]);
    XCTAssertTrue(dir);
}

- (void)testAddEventForBeacon {
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
    [_eventStorage addEvent:_event forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
    [_eventStorage addEvent:_event forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
}

- (void)testAddEventsForBeacon {
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
}

- (void)testRemoveEventForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    [_eventStorage removeEvent:_event forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
    XCTAssert([[_eventStorage findAllEventsForBeacon:_beacon][0] isEqual:_eventTwo]);
}

- (void)testRemoveEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    [_eventStorage removeEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testRemoveAllEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    [_eventStorage removeAllEventsForBeacon:_beacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testFindAllEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    CREvent *eventThree = [[CREvent alloc] init];
    eventThree.eventId = @932;
    CREvent *eventFour = [[CREvent alloc] init];
    eventFour.eventId = @931;
    [_eventStorage addEvents:@[eventThree, eventFour] forBeacon:_beaconTwo];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beaconTwo].count == 2);
    NSArray *array = [_eventStorage findAllEventsForBeacon:_beacon];
    XCTAssert(array.count == 2);
    XCTAssert([array containsObject:_event] && [array containsObject:_eventTwo]);
}

- (void)testFindNotificationEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findNotificationEventsForBeacon:_beacon].count == 0);
    
    CRNotificationEvent *notEvent = [[CRNotificationEvent alloc] init];
    notEvent.eventId = @1111;
    CRNotificationEvent *notEventTwo = [[CRNotificationEvent alloc] init];
    notEventTwo.eventId = @1112;
    [_eventStorage addEvents:@[notEvent, notEventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findNotificationEventsForBeacon:_beacon].count == 2);
}

@end
