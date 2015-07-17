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
#import "CRBeacon_Internal.h"
#import "CRNotificationEvent.h"

@interface CREventStorage ()

- (void)_save:(CREvent *)event;
- (CREvent *)_load:(NSUInteger)eventId;
- (void)_remove:(NSUInteger)eventId;
- (NSArray *)_findAllEventsForBeacon:(CRBeacon *)beacon onlyNotifications:(BOOL)notifications;

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

- (void)addEvent:(CREvent *)event {
    [self _save:event];
    [_objects setObject:event forKey:@(event.eventId)];
}

- (void)addEvents:(NSArray *)events {
    for (CREvent *event in events) {
        [self addEvent:event];
    }
}

- (void)removeEventWithId:(NSUInteger)eventId {
    [_objects removeObjectForKey:@(eventId)];
    [self _remove:eventId];
}

- (void)removeEventsWithIds:(NSArray *)events {
    for (NSNumber *eventId in events) {
        [self removeEventWithId:eventId.integerValue];
    }
}

- (void)removeAllEvents {
    [_objects removeAllObjects];
    NSError *error;
    NSArray *files = [_fileManager contentsOfDirectoryAtPath:_basePath error:&error];
    
    if (error) {
        CRLog(@"There was an error accessing the storage directoy: %@", error);
    }
    
    for (NSString *file in files) {
        if(![_fileManager removeItemAtPath:[_basePath stringByAppendingPathComponent:file] error:&error] && error) {
            CRLog(@"There was an error removing an entity: %@", error);
        }
    }
}

- (void)refresh:(CREvent *)event {
    [self _save:event];
}

- (CREvent *)findEventForId:(NSUInteger)eventId {
    CREvent *event = [_objects objectForKey:@(eventId)];
    if (!event) {
        event = [self _load:eventId];
    }
    return event; // Maybe nil
}

- (NSArray *)findAllEventsForBeacon:(CRBeacon *)beacon {
    return [self _findAllEventsForBeacon:beacon onlyNotifications:NO];
}

- (NSArray *)findAllNotificationEventsForBeacon:(CRBeacon *)beacon {
    return [self _findAllEventsForBeacon:beacon onlyNotifications:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSArray *)_findAllEventsForBeacon:(CRBeacon *)beacon onlyNotifications:(BOOL)notifications {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *events = [NSArray arrayWithArray:beacon.events];
    
    for (NSNumber *eventId in events) {
        CREvent *event = [self findEventForId:eventId.integerValue];
        if (event) {
            BOOL addObject = (!notifications && [event isKindOfClass:[CREvent class]]
                              && ![event isKindOfClass:[CRNotificationEvent class]])
            ||(notifications && [event isKindOfClass:[CRNotificationEvent class]]);
            
            if (addObject) {
                [result addObject:event];
            }
        }
    }
    return [NSArray arrayWithArray:result];
}

- (void)_save:(CREvent *)event {
    [_queue addOperationWithBlock:^{
        NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(event.eventId)]];
        [NSKeyedArchiver archiveRootObject:event toFile:path];
    }];
}

- (CREvent *)_load:(NSUInteger)eventId {
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(eventId)]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)_remove:(NSUInteger)eventId {
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(eventId)]];
    [_queue addOperationWithBlock:^{
        NSError *error;
        if(![_fileManager removeItemAtPath:path error:&error] && error) {
            CRLog(@"There was an error removing an entity: %@", error);
        }
    }];

}


@end
