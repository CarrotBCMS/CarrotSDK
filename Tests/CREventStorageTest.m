//
//  CREventStorageTest.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
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
    _basePath = [NSTemporaryDirectory() stringByAppendingString:@"data"];
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath];
    _beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]
                                       major:@111
                                       minor:@222];
    _beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440002"]
                                          major:@113
                                          minor:@225];
    _event = [[CREvent alloc] initWithEventId:@1 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    _eventTwo = [[CREvent alloc] initWithEventId:@12 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    
}

- (void)tearDown {
    [super tearDown];
    
    if ([_fileManager fileExistsAtPath:_eventStorage.basePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_eventStorage.basePath error:NULL];
    }
}

- (void)testInitWithStoragePath {
    BOOL dir = NO;
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
    CREvent *eventThree = [[CREvent alloc] initWithEventId:@1213 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    CREvent *eventFour = [[CREvent alloc] initWithEventId:@1111 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    [_eventStorage addEvents:@[eventThree, eventFour] forBeacon:_beaconTwo];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beaconTwo].count == 2);
    NSArray *array = [_eventStorage findAllEventsForBeacon:_beacon];
    XCTAssert(array.count == 2);
    XCTAssert([array containsObject:_event] && [array containsObject:_eventTwo]);
}

- (void)testFindNotificationEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findNotificationEventsForBeacon:_beacon].count == 0);
    
    CRNotificationEvent *notEvent = [[CRNotificationEvent alloc] initWithEventId:@12 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    CRNotificationEvent *notEventTwo = [[CRNotificationEvent alloc] initWithEventId:@1 threshold:1000 lastTriggered:nil eventType:CREventTypeEnter];
    [_eventStorage addEvents:@[notEvent, notEventTwo] forBeacon:_beacon];
    XCTAssert([_eventStorage findNotificationEventsForBeacon:_beacon].count == 2);
}

- (void)testEventsWithSameUUIDDifferentMinor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@113 minor:@226];
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:newBeacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testEventsWithSameUUIDDifferentMajor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@116 minor:@222];
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:newBeacon];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testBeaconEventsFileName {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@116 minor:@222];
    [_eventStorage addEvents:@[_event, _eventTwo] forBeacon:newBeacon];
    
    NSString *path = [_eventStorage.basePath stringByAppendingFormat:@"/%@_%@_%@", newBeacon.uuid.UUIDString, newBeacon.major, newBeacon.minor];
    BOOL dir = YES;
    XCTAssert([_fileManager fileExistsAtPath:path isDirectory:&dir]);
    XCTAssert(!dir);
}


@end
