//
//  CRSyncManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
#import "AFNetworking.h"

#define LAST_SYNC @"CRLastSync"

@interface CRSyncManager ()

- (void)_updateLastSync:(NSNumber *)lastSync;
- (void)_parseAndStoreSyncData:(NSDictionary *)data;
- (void)_handleSyncResponse:(id)responseObject operation:(AFHTTPRequestOperation *)operation;
- (NSArray *)_retrieveBeaconIdsFromEventDictionary:(NSDictionary *)dictionary;

@end

@implementation CRSyncManager {
    AFHTTPRequestOperationManager *_requestOperationManager;
    AFHTTPRequestOperation *_currentOperation;
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
        _requestOperationManager = [AFHTTPRequestOperationManager manager];
        _currentOperation = nil;
        _appKey = appKey;
        _aggregator = aggregator;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

- (void)startSyncing {
    if (!_currentOperation) {
        [self _syncData];
    }
}

- (void)stopSyncing {
    if (_currentOperation) {
        [_currentOperation cancel];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Private

- (void)_syncData {
    NSNumber *lastSync = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SYNC];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (_appKey) {
        parameters[@"app_key"] = _appKey;
    }
    
    if (lastSync) {
        parameters[@"ts"] = lastSync;
    }
    
    NSURL *aPath = [_baseURL URLByAppendingPathComponent:@"sync"];
    _currentOperation = [_requestOperationManager GET:[aPath absoluteString]
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  _currentOperation = nil;
                                                  [self _handleSyncResponse:responseObject operation:operation];
                                                  
                                                  // Call the delegate
                                                  if ([(id<CRSyncManagerDelegate>)_delegate respondsToSelector:@selector(syncManagerDidFinishSyncing:)]) {
                                                      [_delegate syncManagerDidFinishSyncing:self];
                                                  }
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  _currentOperation = nil;
                                                  CRLog(@"A synchronisation error has occured: %@", error.localizedDescription);
                                                  if (operation.response.statusCode == 404) {
                                                      CRLog(@"Did you mistype the url to your bms root?");
                                                  }
                                                  if (operation.response.statusCode == 400 || operation.response.statusCode == 500) {
                                                      CRLog(@"Did you mistype your app key? Does it exist?");
                                                      NSString *responseString = [operation responseString];
                                                      NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
                                                      error = nil;
                                                      NSDictionary *json = [NSJSONSerialization
                                                                            JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                            error:&error];
                                                      if (!error && json && json[@"message"]) {
                                                          CRLog(@"The server says: %@", json[@"message"]);
                                                      }
                                                      
                                                      // Call the delegate
                                                      if ([(id<CRSyncManagerDelegate>)_delegate respondsToSelector:@selector(syncManager:didFailWithError:)]) {
                                                          [_delegate syncManager:self didFailWithError:error];
                                                      }
                                                  }
                                              }];
}

- (void)_handleSyncResponse:(id)responseObject operation:(AFHTTPRequestOperation *)operation {
    NSString *responseString = [operation responseString];
    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
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


- (NSArray *)_retrieveBeaconIdsFromEventDictionary:(NSDictionary *)dictionary {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *beacons = dictionary[@"beacons"];
    for (NSDictionary *beaconDict in beacons) {
        [result addObject:beaconDict[@"id"]];
    }
    return [NSArray arrayWithArray:result];
}

@end
