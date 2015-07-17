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
#import "CRBeacon_Internal.h"
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
    CRNotificationEvent *_notEvent;
}

- (void)setUp {
    [super setUp];
    if ([_fileManager fileExistsAtPath:_eventStorage.basePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_eventStorage.basePath error:NULL];
    }
    
    _fileManager = [NSFileManager defaultManager];
    _basePath = [NSTemporaryDirectory() stringByAppendingString:@"data"];
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath];
    _beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"]
                                       major:@111
                                       minor:@222];
    _beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440002"]
                                          major:@113
                                          minor:@225];
    _event = [[CREvent alloc] initWithEventId:1
                                    threshold:1000
                           scheduledStartDate:nil
                             scheduledEndDate:nil
                                lastTriggered:nil
                                    eventType:CREventTypeEnter];
    _eventTwo = [[CREvent alloc] initWithEventId:12
                                       threshold:1000
                              scheduledStartDate:nil
                                scheduledEndDate:nil
                                   lastTriggered:nil
                                       eventType:CREventTypeEnter];
    _notEvent = [[CRNotificationEvent alloc] initWithEventId:122
                                                   threshold:1000
                                          scheduledStartDate:nil
                                            scheduledEndDate:nil
                                               lastTriggered:nil
                                                   eventType:CREventTypeEnter];
    [_beacon.events addObjectsFromArray:@[@(_event.eventId), @(_eventTwo.eventId), @(_notEvent.eventId)]];
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
    [_eventStorage addEvent:_event];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
    [_eventStorage addEvent:_event];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
}

- (void)testAddEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
}

- (void)testRemoveEventForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo, _notEvent]];
    [_eventStorage removeEventWithId:_event.eventId];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 1);
    XCTAssert([[_eventStorage findAllEventsForBeacon:_beacon][0] isEqual:_eventTwo]);
}

- (void)testRemoveEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    [_eventStorage removeEventsWithIds:@[@(_event.eventId), @(_eventTwo.eventId)]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testRemoveAllEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    [_eventStorage removeAllEvents];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testFindAllEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo, _notEvent]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    CREvent *eventThree = [[CREvent alloc] initWithEventId:1213
                                                 threshold:1000
                                        scheduledStartDate:nil
                                          scheduledEndDate:nil
                                             lastTriggered:nil
                                                 eventType:CREventTypeEnter];
    CREvent *eventFour = [[CREvent alloc] initWithEventId:1111
                                                threshold:1000
                                       scheduledStartDate:nil
                                         scheduledEndDate:nil
                                            lastTriggered:nil
                                                eventType:CREventTypeEnter];
    [_eventStorage addEvents:@[eventThree, eventFour]];
    
    CREvent *eventFive = [[CREvent alloc] initWithEventId:1111
                                                threshold:1000
                                       scheduledStartDate:nil
                                         scheduledEndDate:nil
                                            lastTriggered:nil
                                                eventType:CREventTypeBoth];
    
    [_eventStorage addEvents:@[eventThree, eventFour, eventFive]];
    NSArray *array = [_eventStorage findAllEventsForBeacon:_beacon];
    XCTAssert(array.count == 2);
    XCTAssert([array containsObject:_event] && [array containsObject:_eventTwo]);
}

- (void)testFindNotificationEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllNotificationEventsForBeacon:_beacon].count == 0);
    
    CRNotificationEvent *notEvent = [[CRNotificationEvent alloc] initWithEventId:123355
                                                                       threshold:1000
                                                              scheduledStartDate:nil
                                                                scheduledEndDate:nil
                                                                   lastTriggered:nil
                                                                       eventType:CREventTypeEnter];
    CRNotificationEvent *notEventTwo = [[CRNotificationEvent alloc] initWithEventId:1332
                                                                          threshold:1000
                                                                 scheduledStartDate:nil
                                                                   scheduledEndDate:nil
                                                                      lastTriggered:nil
                                                                          eventType:CREventTypeEnter];
    CRNotificationEvent *notEventThree = [[CRNotificationEvent alloc] initWithEventId:2312
                                                                            threshold:1000
                                                                   scheduledStartDate:nil
                                                                     scheduledEndDate:nil
                                                                        lastTriggered:nil
                                                                            eventType:CREventTypeBoth];
    [_beacon.events addObjectsFromArray:@[@(notEvent.eventId), @(notEventTwo.eventId), @(notEventThree.eventId)]];
    [_eventStorage addEvents:@[notEvent, notEventTwo, notEventThree]];
    XCTAssert([_eventStorage findAllNotificationEventsForBeacon:_beacon].count == 3);
}

- (void)testEventsWithSameUUIDDifferentMinor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@113 minor:@226];
    [newBeacon.events addObjectsFromArray:@[@(_event.eventId), @(_eventTwo.eventId)]];
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:newBeacon].count == 2);
}

- (void)testEventsWithSameUUIDDifferentMajor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@116 minor:@222];
    [newBeacon.events addObjectsFromArray:@[@(_event.eventId), @(_eventTwo.eventId)]];
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:newBeacon].count == 2);
}

@end
