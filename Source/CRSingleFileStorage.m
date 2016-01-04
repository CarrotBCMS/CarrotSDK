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
