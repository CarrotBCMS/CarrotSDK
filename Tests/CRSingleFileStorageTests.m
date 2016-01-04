/*
 * Carrot - beacon management (sdk)
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
#import "CRSingleFileStorage.h"
#import "CRBeacon.h"

@interface CRSingleFileStorageTests : XCTestCase
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRSingleFileStorageTests {
    CRSingleFileStorage *_store;
    CRBeacon *_beacon;
    NSFileManager *_fileManager;
    NSString *_storagePath;
}

- (void)setUp {
    [super setUp];
    
    _storagePath = [NSTemporaryDirectory() stringByAppendingString:@"data"];
    _store = [[CRSingleFileStorage alloc] initWithStoragePath: _storagePath];
    _beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"123e4567-e89b-12d3-a456-426655440000"] major:@222 minor:@111 name:@"Test"];
    _fileManager = [NSFileManager defaultManager];
}

- (void)tearDown {
    if ([_fileManager fileExistsAtPath:_store.storagePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_store.storagePath error:NULL];
    }
    
    [super tearDown];
}

- (void)testAddingObject {
    [_store addObject:_beacon];
    XCTAssertEqual([[_store objects] lastObject], _beacon);
}

- (void)testRemovingObject {
    [_store addObject:_beacon];
    XCTAssertEqual([[_store objects] lastObject], _beacon);
    [_store removeObject:_beacon];
    XCTAssert([[_store objects] count] == 0);
}

@end
