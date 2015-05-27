//
//  CRGeneralStorageTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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

- (void)testStoringObject {
    XCTAssert(![_fileManager fileExistsAtPath:_storagePath isDirectory:NULL]);
    [_store addObject:_beacon];
    XCTAssert([_fileManager fileExistsAtPath:_storagePath isDirectory:NULL]);
}

- (void)testRestoringObjects {
    [_store addObject:_beacon];
    
    CRSingleFileStorage *newStore = [[CRSingleFileStorage alloc] initWithStoragePath:_storagePath];
    XCTAssert([[newStore objects] count] == 1);
    
    CRBeacon *aBeacon = [[newStore objects] lastObject];
    XCTAssertNotNil(aBeacon);
    XCTAssert([_beacon isEqual:aBeacon]);
}

@end
