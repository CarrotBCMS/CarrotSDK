//
//  CRSingleFileStorage.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/24/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRSingleFileStorage.h"
#import "CRSingleFileStorage_Internal.h"
#import "CRDefines.h"

@implementation CRSingleFileStorage {
    NSOperationQueue *_queue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithStoragePath:(NSString *)path {
    self = [super init];
    
    if (self) {
        _storagePath = path;
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        @try {
            if ([fileManager fileExistsAtPath:_storagePath]) {
                _objects = [NSKeyedUnarchiver unarchiveObjectWithFile:_storagePath];
            }
        } @finally {
            if (!_objects) {
                _objects = [NSMutableArray array];
            }
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Public interface

- (void)addObject:(id)object {
    if (object) {
        [_objects addObject:object];
        [self _save];
    }
}

- (void)removeObject:(id)object {
    if (object) {
        [_objects removeObject:object];
        [self _save];
    }
}

- (void)addObjectsFromArray:(NSArray *)array {
    if (array) {
        [_objects addObjectsFromArray:array];
        [self _save];
    }
}

- (void)removeObjectsInArray:(NSArray *)array {
    if (array) {
        [_objects removeObjectsInArray:array];
        [self _save];
    }
}

- (NSArray *)objects {
    return [NSArray arrayWithArray:_objects];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal

- (void)_save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_objects];
    [_queue addOperationWithBlock:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *dirpath = [_storagePath stringByDeletingLastPathComponent];
        if (![fileManager fileExistsAtPath:dirpath]) {
            [fileManager createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        NSError *error;
        if (![data writeToFile:_storagePath options:NSDataWritingAtomic error:&error]) {
            CRLog(@"There was an error saving some objects: %@", error);
        }
    }];
}

@end
