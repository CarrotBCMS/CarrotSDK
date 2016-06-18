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

#import "CRSyncManager.h"
#import "CREventStorage.h"
#import "CRBeaconStorage.h"
#import "CRBeaconEventAggregator.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CRTextEvent.h"
#import "CRNotificationEvent.h"
#import "CREvent_Internal.h"
#import "CRDefines.h"

#define LAST_SYNC @"CRLastSync"

@interface CRSyncManager () <NSURLSessionDelegate>

- (void)_updateLastSync:(NSNumber *)lastSync;
- (void)_parseAndStoreSyncData:(NSDictionary *)data;
- (void)_handleSyncData:(NSData *)data;
- (NSArray<NSNumber *> *)_retrieveBeaconIdsFromEventDictionary:(NSDictionary *)dictionary;

@end

@implementation CRSyncManager {
    NSURLSessionTask *_currentTask;
    NSURLSession *_session;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithDelegate:(id<CRSyncManagerDelegate>)delegate
                    eventStorage:(CREventStorage*)eventStorage
                   beaconStorage:(CRBeaconStorage *)beaconStorage
                      aggregator:(CRBeaconEventAggregator *)aggregator
                         baseURL:(NSURL *)url
                          appKey:(NSString *)appKey
{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _eventStorage = eventStorage;
        _beaconStorage = beaconStorage;
        _baseURL = url;
        _currentTask = nil;
        _appKey = appKey;
        _aggregator = aggregator;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

- (void)startSyncing {
    if (!_currentTask) {
        [self _syncData];
    }
}

- (void)stopSyncing {
    if (_currentTask) {
        [_currentTask cancel];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (void)_syncData {
    NSNumber *lastSync = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SYNC];
    NSMutableArray *queryItems = [NSMutableArray array];
    
    if (_appKey) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_key" value:_appKey]];
    }
    
    if (lastSync) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"ts" value:[lastSync stringValue]]];
    }
    
    NSURL *aURL = [_baseURL URLByAppendingPathComponent:@"sync"];
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:aURL resolvingAgainstBaseURL:NO];
    [components setQueryItems:queryItems];
    
    _currentTask = [[self _session] dataTaskWithURL: [components URL]
                                  completionHandler:^(NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _currentTask = nil;
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        if (error) {
            CRLog(@"A synchronisation error occured: %@", error.localizedDescription);
            if (urlResponse.statusCode == 404) {
                CRLog(@"Did you mistype the url to your bms root?");
            }
            
            if (urlResponse.statusCode == 400 ||
                urlResponse.statusCode == 401 ||
                urlResponse.statusCode == 404 ||
                urlResponse.statusCode == 500) {
                CRLog(@"Did you mistype your app key? Does it exist?");
                error = nil;
                NSDictionary *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
                if (!error && json && json[@"message"]) {
                    CRLog(@"The server says: %@", json[@"message"]);
                }
            }
            
            // Call the delegate
            if ([(id<CRSyncManagerDelegate>)_delegate respondsToSelector:@selector(syncManager:didFailWithError:)]) {
                [_delegate syncManager:self didFailWithError:error];
            }
            return;
        }
        
        [self _handleSyncData:data];
        
        // Call the delegate
        if ([(id<CRSyncManagerDelegate>)_delegate respondsToSelector:@selector(syncManagerDidFinishSyncing:)]) {
            [_delegate syncManagerDidFinishSyncing:self];
        }

    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_currentTask resume];
}

- (void)_handleSyncData:(NSData *)data {
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    if (jsonData) {
        [self _parseAndStoreSyncData:jsonData];
    } else if (error) {
        CRLog(@"There was an error parsing the sync response: %@", error.localizedDescription);
        if ([(id<CRSyncManagerDelegate>)_delegate respondsToSelector:@selector(syncManager:didFailWithError:)]) {
            [_delegate syncManager:self didFailWithError:error];
        }
    }
}

- (void)_parseAndStoreSyncData:(NSDictionary *)data {
    NSNumber *timestamp = data[@"timestamp"];
    
    // Parse beacons
    NSArray *createdBeaconDictionaries = data[@"beacons"][@"createdOrUpdated"];
    NSArray *deletedBeaconIds = data[@"beacons"][@"deleted"];
    
    for (NSDictionary *beaconDictionary in createdBeaconDictionaries) {
        CRLog(@"Adding/Updating beacon with id: %@", beaconDictionary[@"id"]);
        CRBeacon *yBeacon = [CRBeacon beaconFromJSON:beaconDictionary];
        [_beaconStorage addObject:yBeacon];
    }
    
    for (NSNumber *deletedBeaconId in deletedBeaconIds) {
        CRLog(@"Delete beacon with id: %@", deletedBeaconId);
        CRBeacon *beacon = [_beaconStorage findCRBeaconWithId:deletedBeaconId.integerValue];
        [_beaconStorage removeObject:beacon];
    }
    
    // Parse Events
    NSArray *createdEventsDictionaries = data[@"events"][@"createdOrUpdated"];
    NSArray *deletedEventIds = data[@"events"][@"deleted"];
    
    for (NSDictionary *eventDictionary in createdEventsDictionaries) {
        CRLog(@"Adding/Updating event with id: %@", eventDictionary[@"id"]);
        CREvent *event = [CREvent eventFromJSON:eventDictionary];
        [_aggregator setBeacons:[self _retrieveBeaconIdsFromEventDictionary:eventDictionary] forEvent:event.eventId];
        [_eventStorage addEvent:event];
    }
    
    for (NSNumber *deletedEventId in deletedEventIds) {
        CRLog(@"Delete event with id: %@", deletedEventId);
        [_eventStorage removeEventWithId:deletedEventId.integerValue];
    }
    
    if (timestamp) {
        [self _updateLastSync:timestamp]; // Last thing to do - save the timestamp
    }
}

- (void)_updateLastSync:(NSNumber *)lastSync {
    if (!lastSync) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:lastSync forKey:LAST_SYNC];
    [userDefaults synchronize];
}

- (NSArray<NSNumber *> *)_retrieveBeaconIdsFromEventDictionary:(NSDictionary *)dictionary {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *beacons = dictionary[@"beacons"];
    for (NSDictionary *beaconDict in beacons) {
        [result addObject:beaconDict[@"id"]];
    }
    return [NSArray arrayWithArray:result];
}

- (NSURLSession *)_session {
    if (_session) {
        return _session; // Early exit
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:self
                                        delegateQueue:[[NSOperationQueue alloc] init]];
    
    return _session;
}

@end
