//
//  CRPersistentStoreTests.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CRPersistentStorage.h"
#import "CRBeacon.h"

@interface CRPersistentStoreTests : XCTestCase

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CRPersistentStoreTests {
    CRPersistentStorage *_store;
    CRBeacon *_beacon;
    NSFileManager *_fileManager;
    NSString *_storagePath;
}

- (void)setUp {
    [super setUp];
    
    _storagePath = [NSTemporaryDirectory() stringByAppendingString:@"data"];
    _store = [[CRPersistentStorage alloc] initWithStoragePath: _storagePath];
    _beacon = [[CRBeacon alloc] initWithUUID:@"testuuid" major:@222 minor:@111 name:@"Test" events:nil];
    _fileManager = [NSFileManager defaultManager];
}

- (void)tearDown {
    if ([_fileManager fileExistsAtPath:_store.storagePath isDirectory:NULL]) {
        [_fileManager removeItemAtPath:_store.storagePath error:NULL];
    }
    
    [super tearDown];
}


///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)testAddingObject {
    [_store addObject:_beacon];
    XCTAssertEqual([[_store objects] lastObject], _beacon);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)testRemovingObject {
    [_store addObject:_beacon];
    XCTAssertEqual([[_store objects] lastObject], _beacon);
    [_store removeObject:_beacon];
    XCTAssert([[_store objects] count] == 0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)testStoringObject {
    XCTAssert(![_fileManager fileExistsAtPath:_storagePath isDirectory:NULL]);
    [_store addObject:_beacon];
    XCTAssert([_fileManager fileExistsAtPath:_storagePath isDirectory:NULL]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)testRestoringObjects {
    [_store addObject:_beacon];
    
    CRPersistentStorage *newStore = [[CRPersistentStorage alloc] initWithStoragePath:_storagePath];
    XCTAssert([[newStore objects] count] == 1);
    
    CRBeacon *aBeacon = [[newStore objects] lastObject];
    XCTAssertNotNil(aBeacon);
    XCTAssert([_beacon isEqual:aBeacon]);
}


@end