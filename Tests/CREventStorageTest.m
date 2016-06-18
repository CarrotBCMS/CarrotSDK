/*
 * Carrot -  beacon content management (sdk)
 * Copyright (C) 2016 Heiko Dreyer
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
#import <OCMock/OCMock.h>
#import "CREventStorage.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CREvent.h"
#import "CRNotificationEvent.h"
#import "CRBeaconEventAggregator.h"

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
    CRBeaconEventAggregator *_aggregator;
}

- (void)setUp {
    [super setUp];
    
    _fileManager = [NSFileManager defaultManager];
    _basePath = [NSTemporaryDirectory() stringByAppendingString:@"data"];
    
    _aggregator = OCMClassMock([CRBeaconEventAggregator class]);
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath aggregator:_aggregator];
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
    
    NSArray *eventIds = @[@(_event.eventId), @(_eventTwo.eventId), @(_notEvent.eventId)];
    OCMStub([_aggregator eventsForBeacon:_beacon.beaconId]).andReturn(eventIds);
}

- (void)tearDown {
    if ([_fileManager fileExistsAtPath:_basePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_basePath error:NULL];
    }
    
    [super tearDown];
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


- (void)testRemoveEventsForBeacon {
    _aggregator = OCMClassMock([CRBeaconEventAggregator class]);
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath aggregator:_aggregator];
    NSArray *eventIds = @[@(_event.eventId), @(_eventTwo.eventId), @(_notEvent.eventId)];
    OCMStub([_aggregator eventsForBeacon:_beacon.beaconId]).andReturn(eventIds);
    
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    sleep(1); // ... sleep ?
    [_eventStorage removeEventsWithIds:@[@(_event.eventId), @(_eventTwo.eventId)]];
    sleep(1); // ... sleep ?
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testRemoveAllEventsForBeacon {
    [_eventStorage addEvents:@[_event, _eventTwo]];
    sleep(1); // ... sleep ?
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 2);
    [_eventStorage removeAllEvents];
    sleep(1); // ... sleep ?
    XCTAssert([_eventStorage findAllEventsForBeacon:_beacon].count == 0);
}

- (void)testFindAllEventsForBeacon {
    _aggregator = OCMClassMock([CRBeaconEventAggregator class]);
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath aggregator:_aggregator];
    
    NSArray *eventIds = @[@(_event.eventId), @(_eventTwo.eventId), @(_notEvent.eventId)];
    OCMStub([_aggregator eventsForBeacon:_beacon.beaconId]).andReturn(eventIds);
    
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
    _aggregator = OCMClassMock([CRBeaconEventAggregator class]);
    _eventStorage = [[CREventStorage alloc] initWithBaseStoragePath:_basePath aggregator:_aggregator];
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllNotificationEventsForBeacon:_beacon].count == 0);
    
    CRNotificationEvent *notEvent = [[CRNotificationEvent alloc] initWithEventId:221212
                                                                       threshold:1000
                                                              scheduledStartDate:nil
                                                                scheduledEndDate:nil
                                                                   lastTriggered:nil
                                                                       eventType:CREventTypeEnter];
    CRNotificationEvent *notEventTwo = [[CRNotificationEvent alloc] initWithEventId:13321321
                                                                          threshold:1000
                                                                 scheduledStartDate:nil
                                                                   scheduledEndDate:nil
                                                                      lastTriggered:nil
                                                                          eventType:CREventTypeEnter];
    CRNotificationEvent *notEventThree = [[CRNotificationEvent alloc] initWithEventId:232212
                                                                            threshold:1000
                                                                   scheduledStartDate:nil
                                                                     scheduledEndDate:nil
                                                                        lastTriggered:nil
                                                                            eventType:CREventTypeBoth];
    
    NSArray *eventIds = @[@(notEvent.eventId), @(notEventTwo.eventId), @(notEventThree.eventId)];
    NSArray *events = @[notEvent, notEventTwo, notEventThree];
    OCMStub([_aggregator eventsForBeacon:_beacon.beaconId]).andReturn(eventIds);
    [_eventStorage addEvents:events];
    XCTAssert([_eventStorage findAllNotificationEventsForBeacon:_beacon].count == 3);
}

- (void)testEventsWithSameUUIDDifferentMinor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@113 minor:@226];
    
    NSArray *eventIds = @[@(_event.eventId), @(_eventTwo.eventId)];
    OCMStub([_aggregator eventsForBeacon:newBeacon.beaconId]).andReturn(eventIds);
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:newBeacon].count == 2);
}

- (void)testEventsWithSameUUIDDifferentMajor {
    CRBeacon *newBeacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@116 minor:@222];
    
    NSArray *eventIds = @[@(_event.eventId), @(_eventTwo.eventId)];
    OCMStub([_aggregator eventsForBeacon:newBeacon.beaconId]).andReturn(eventIds);
    [_eventStorage addEvents:@[_event, _eventTwo]];
    XCTAssert([_eventStorage findAllEventsForBeacon:newBeacon].count == 2);
}

@end
