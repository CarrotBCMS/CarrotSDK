/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
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

#import "CRDefines.h"
#import "CREventStorage.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CRNotificationEvent.h"
#import "CRBeaconEventAggregator.h"

@interface CREventStorage ()

- (void)_save:(CREvent *)event;
- (CREvent *)_load:(NSUInteger)eventId;
- (void)_remove:(NSUInteger)eventId;
- (NSArray<__kindof CREvent *> *)_findAllEventsForBeacon:(CRBeacon *)beacon onlyNotifications:(BOOL)notifications;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventStorage {
    NSString *_basePath;
    NSFileManager *_fileManager;
    NSCache *_objects; // Using a cache here should prevent low-memory circumstances
    NSOperationQueue *_queue;
    CRBeaconEventAggregator *_aggregator;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithBaseStoragePath:(NSString *)path aggregator:(CRBeaconEventAggregator *)aggregator {
    self = [super init];
    
    if (self) {
        _basePath = path;
        _fileManager = [NSFileManager defaultManager];
        _objects = [[NSCache alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        _aggregator = aggregator;
        
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

- (void)removeEventsWithIds:(NSArray<NSNumber *> *)events {
    for (NSNumber *eventId in events) {
        [self removeEventWithId:eventId.integerValue];
    }
}

- (void)removeAllEvents {
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
    [_objects removeAllObjects];
}

- (void)refresh:(CREvent *)event {
    [self _save:event];
}

- (CREvent *)findEventForId:(NSUInteger)eventId {
    CREvent *event = [_objects objectForKey:@(eventId)];
    if (!event) {
        event = [self _load:eventId];
    }
    
    return event;
}

- (NSArray<__kindof CREvent *> *)findAllEventsForBeacon:(CRBeacon *)beacon {
    return [self _findAllEventsForBeacon:beacon onlyNotifications:NO];
}

- (NSArray<CRNotificationEvent *> *)findAllNotificationEventsForBeacon:(CRBeacon *)beacon {
    return [self _findAllEventsForBeacon:beacon onlyNotifications:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSArray<__kindof CREvent *> *)_findAllEventsForBeacon:(CRBeacon *)beacon onlyNotifications:(BOOL)notifications {
    NSMutableArray *result = [NSMutableArray array];
    NSArray<NSNumber *> *events = [NSArray arrayWithArray:[_aggregator eventsForBeacon:beacon.beaconId]];
    
    for (NSNumber *eventId in events) {
        CREvent *event = [self findEventForId:eventId.integerValue];
        if (event && [event isKindOfClass:[CREvent class]]) {
            if (notifications && [event isKindOfClass:[CRNotificationEvent class]]) {
                [result addObject:event];
            } else if(!notifications && ![event isKindOfClass:[CRNotificationEvent class]]) {
                [result addObject:event];
            }
        }
    }
    return [NSArray arrayWithArray:result];
}

- (void)_save:(CREvent *)event {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:event];
    [_queue addOperationWithBlock:^{
        NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(event.eventId)]];
        NSError *error;
        if (![data writeToFile:path options:NSDataWritingAtomic error:&error]) {
            CRLog(@"There was an error saving an event: %@", error);
            
        }
    }];
}

- (void)_remove:(NSUInteger)eventId {
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(eventId)]];
    [_queue addOperationWithBlock:^{
        NSError *error;
        if ([_fileManager fileExistsAtPath:path isDirectory:NULL]) {
            if(![_fileManager removeItemAtPath:path error:&error] && error) {
                CRLog(@"There was an error removing an entity: %@", error);
            }
        }
    }];
}

- (CREvent *)_load:(NSUInteger)eventId {
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(eventId)]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
