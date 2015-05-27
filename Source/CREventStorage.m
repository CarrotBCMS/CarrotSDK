//
//  CREventStorage.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRDefinitions.h"
#import "CREventStorage.h"
#import "CRBeacon.h"
#import "CRNotificationEvent.h"

@interface CREventStorage ()

- (void)_save:(CRBeacon *)beacon;
- (NSMutableArray *)_allEventsForBeacon:(CRBeacon *)beacon;
- (NSMutableArray *)_addOrReplaceEvent:(CREvent *)event allEvents:(NSMutableArray *)allEvents;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation CREventStorage {
    NSString *_basePath;
    NSMutableDictionary *_objects;
    NSFileManager *_fileManager;;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (id)initWithBaseStoragePath:(NSString *)path {
    self = [super init];
    
    if (self) {
        _basePath = path;
        _fileManager = [NSFileManager defaultManager];
        
        if (![_fileManager fileExistsAtPath:_basePath]) {
            NSError *error;
            [_fileManager createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                CRLog(@"Error creating event storage path: %@", error);
            }
        }
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CRUD

- (void)addEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [self _addOrReplaceEvent:event allEvents:allEvents];
    [self _save:beacon];
}

- (void)addEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [self _allEventsForBeacon:beacon];
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self _addOrReplaceEvent:obj allEvents:allEvents];
    }];
    
    [self _save:beacon];
}

- (NSArray *)findAllEventsForBeacon:(CRBeacon *)beacon {
    return [NSArray arrayWithArray:[self _allEventsForBeacon:beacon]];
    
}

- (NSArray *)findNotificationEventsForBeacon:(CRBeacon *)beacon {
    NSMutableArray *allEvents = [[self _allEventsForBeacon:beacon] mutableCopy];
    [allEvents filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[CRNotificationEvent class]];
    }]];
     
     return [NSArray arrayWithArray:allEvents];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (NSMutableArray *)_addOrReplaceEvent:(CREvent *)event allEvents:(NSMutableArray *)allEvents {
    NSUInteger index = [allEvents indexOfObject:event];
    if (index == NSNotFound) {
        [allEvents addObject:event];
    } else {
        [allEvents replaceObjectAtIndex:index withObject:event];
    }
    
    return allEvents;
}

- (NSMutableArray *) _allEventsForBeacon:(CRBeacon *)beacon {
    NSMutableArray *array = [_objects objectForKey:beacon.uuid.UUIDString];
    
    if (array) {
        return array;
    }
    
    NSString *path = [_basePath stringByAppendingPathComponent:beacon.uuid.UUIDString];
    
    @try {
        if ([_fileManager fileExistsAtPath:path]) {
            array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
    }
    @catch (NSException *exception) {
        if (!array) {
            array = [NSMutableArray array];
        }
    }
    
    [_objects setObject:array forKey:beacon.uuid.UUIDString];
    
    return array;
}

- (void)_save:(CRBeacon *)beacon {
    NSString *path = [_basePath stringByAppendingPathComponent:beacon.uuid.UUIDString];
    NSMutableArray *array = [_objects objectForKey:beacon.uuid.UUIDString];
    [NSKeyedArchiver archiveRootObject:array toFile:path];
}

@end
