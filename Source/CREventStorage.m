//
//  CREventStorage.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRDefines.h"
#import "CREventStorage.h"
#import "CRBeacon.h"
#import "CRNotificationEvent.h"

@interface CREventStorage ()

- (void)_save:(CRBeacon *)beacon;
- (NSMutableArray *)_allEventsForBeacon:(CRBeacon *)beacon;
- (NSMutableArray *)_addOrReplaceEvent:(CREvent *)event fromEvents:(NSMutableArray *)allEvents;
- (NSMutableArray *)_removeEvent:(CREvent *)event fromEvents:(NSMutableArray *)allEvents;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventStorage {
    NSString *_basePath;
    NSFileManager *_fileManager;
    NSCache *_objects; // Using a cache here should prevent low-memory circumstances
    NSOperationQueue *_queue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithBaseStoragePath:(NSString *)path {
    self = [super init];
    
    if (self) {
        _basePath = path;
        _fileManager = [NSFileManager defaultManager];
        _objects = [[NSCache alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        
        if (![_fileManager fileExistsAtPath:_basePath]) {
            NSError *error;
            [_fileManager createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                CRLog(@"There was a error creating the event storage path: %@", error);
            }
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRUD

- (void)addEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [self _addOrReplaceEvent:event fromEvents:allEvents];
    [self _save:beacon];
}

- (void)addEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _addOrReplaceEvent:obj fromEvents:allEvents];
    }];
    
    [self _save:beacon];
}

- (void)removeEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [self _removeEvent:event fromEvents: allEvents];
    [self _save:beacon];
}

- (void)removeEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _removeEvent:obj fromEvents:allEvents];
    }];
    
    [self _save:beacon];
}

- (void)removeAllEventsForBeacon:(CRBeacon *)beacon {
    NSString *path = [_basePath stringByAppendingPathComponent:[self filename:beacon]];
    [_objects removeObjectForKey:[self filename:beacon]];
    
    NSError *error;
    if ([_fileManager fileExistsAtPath:path isDirectory:NULL]) {
        [_fileManager removeItemAtPath:path error:&error];
    }
    
    if (error) {
        CRLog(@"There was a error removing all events for beacon: %@ - Error: %@", beacon, error);
    }
}


/**
 Triggers a refresh.
 */
- (void)refresh:(CRBeacon *)beacon {
    [self _save:beacon];
}

- (NSArray *)findAllEventsForBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [[self _allEventsForBeacon:beacon] mutableCopy];
    [allEvents filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isKindOfClass:[CRNotificationEvent class]] &&
                [evaluatedObject isKindOfClass:[CREvent class]];
    }]];
    
    return [NSArray arrayWithArray:allEvents];
}

- (NSArray *)findAllNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [[self _allEventsForBeacon:beacon] mutableCopy];
    [allEvents filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[CRNotificationEvent class]];
    }]];
     
    return [NSArray arrayWithArray:allEvents];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSMutableArray *)_addOrReplaceEvent:(CREvent *)event fromEvents:(NSMutableArray *)allEvents {
    NSUInteger index = [allEvents indexOfObject:event];
    if (index == NSNotFound) {
        [allEvents addObject:event];
    } else {
        [allEvents replaceObjectAtIndex:index withObject:event];
    }
    
    return allEvents;
}

- (NSMutableArray *)_removeEvent:(CREvent *)event fromEvents:(NSMutableArray *)allEvents {
    [allEvents removeObject:event];
    return allEvents;
}

- (NSMutableArray *) _allEventsForBeacon:(CRBeacon *)beacon {
    NSMutableArray *array = [_objects objectForKey:[self filename:beacon]];
    
    if (array) {
        return array;
    }
    
    NSString *path = [_basePath stringByAppendingPathComponent:[self filename:beacon]];
    
    @try {
        if ([_fileManager fileExistsAtPath:path]) {
            array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
    }
    @finally {
        if (!array) {
            array = [NSMutableArray array];
        }
    }
    
    [_objects setObject:array forKey:[self filename:beacon]];
    
    return array;
}

- (void)_save:(CRBeacon *)beacon {
    [_queue addOperationWithBlock:^{
        NSString *path = [_basePath stringByAppendingPathComponent:[self filename:beacon]];
        NSMutableArray *array = [_objects objectForKey:[self filename:beacon]];
        if (array) {
            [NSKeyedArchiver archiveRootObject:array toFile:path];
        }
    }];
}

- (NSString *)filename:(CRBeacon *)beacon {
    return [NSString stringWithFormat: @"%@_%@_%@", beacon.uuid.UUIDString, beacon.major, beacon.minor];
}

@end
