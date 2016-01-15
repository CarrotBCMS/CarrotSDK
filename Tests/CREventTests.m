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
#import "NSDate+ISO.h"
#import "CREvent.h"
#import "CREvent_Internal.h"

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
    CREvent *event = [[CREvent alloc] initWithEventId:1
                                            threshold:1000
                                   scheduledStartDate:nil
                                     scheduledEndDate:nil
                                        lastTriggered:nil
                                            eventType:CREventTypeEnter];
    
    CREvent *eventTwo = [[CREvent alloc] initWithEventId:1
                                               threshold:1000
                                      scheduledStartDate:nil
                                        scheduledEndDate:nil
                                           lastTriggered:nil
                                               eventType:CREventTypeEnter];
    
    CREvent *eventThree = [[CREvent alloc] initWithEventId:3
                                                 threshold:1000
                                        scheduledStartDate:nil
                                          scheduledEndDate:nil
                                             lastTriggered:nil
                                                 eventType:CREventTypeExit];
    
    XCTAssertEqualObjects(event, eventTwo);
    XCTAssertNotEqualObjects(event, eventThree);
    XCTAssertNotEqualObjects(eventTwo, eventThree);
}

-(void)testEventFromJson {
    NSString *jsonData = @"{\"objectType\":\"text\",\"id\":4,\"dateCreated\":\"2015-11-08T19:55:32.443Z\",\"dateUpdated\":\"2015-11-08T19:55:36.059Z\",\"name\":\"Text event\",\"active\":true,\"threshold\":1.5,\"scheduledStartDate\":\"2015-11-04T01:10:00.000Z\",\"scheduledEndDate\":\"2016-02-18T09:30:00.000Z\",\"eventType\":0,\"beacons\":[],\"text\":\"Test\"}";
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    CREvent *eventOne = [CREvent eventFromJSON:dictionary];
    
    XCTAssertNil(error);
    XCTAssertEqual(eventOne.eventId, 4);
    XCTAssertEqual(eventOne.class, [CRTextEvent class]);
    XCTAssertEqual(eventOne.threshold, 90);
    XCTAssertTrue([((CRTextEvent *)eventOne).text isEqualToString:@"Test"]);
    
    NSDate *scheduledStartDate = [NSDate dateFromISO8601String:@"2015-11-04T01:10:00.000Z"];
    NSDate *scheduledEndDate = [NSDate dateFromISO8601String:@"2016-02-18T09:30:00.000Z"];
    XCTAssertNil(eventOne.lastTriggered);
    XCTAssertEqualWithAccuracy([eventOne.scheduledEndDate timeIntervalSinceReferenceDate], [scheduledEndDate timeIntervalSinceReferenceDate], 0.001);
    XCTAssertEqualWithAccuracy([eventOne.scheduledStartDate timeIntervalSinceReferenceDate], [scheduledStartDate timeIntervalSinceReferenceDate], 0.001);
}

@end
