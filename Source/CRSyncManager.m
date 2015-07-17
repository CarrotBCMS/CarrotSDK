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
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CRTextEvent.h"
#import "CRNotificationEvent.h"
#import "CREvent_Internal.h"
#import "CRDefines.h"
#import "AFNetworking.h"

#define LAST_SYNC @"cr_last_sync"

@interface CRSyncManager ()

- (void)_updateLastSync:(NSNumber *)lastSync;
- (void)_parseAndStoreSyncData:(NSDictionary *)data;
- (void)_handleSyncResponse:(id)responseObject operation:(AFHTTPRequestOperation *)operation;

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
        CRLog(@"Sync was successful!");
    } else if (error) {
        CRLog(@"There was an error parsing the sync response: %@", error.localizedDescription);
    }
}

- (void)_parseAndStoreSyncData:(NSDictionary *)data {
    NSNumber *timestamp = data[@"timestamp"];
    
    // Parse beacons
    NSArray *createdBeaconDictionaries = data[@"beacons"][@"createdOrUpdated"];
    NSArray *deletedBeaconIds = data[@"beacons"][@"deleted"];
    
    for (NSDictionary *beaconDictionary in createdBeaconDictionaries) {
        CRBeacon *yBeacon = [CRBeacon beaconFromJSON:beaconDictionary];
        [_beaconStorage addObject:yBeacon];
    }
    
    for (NSNumber *deletedBeaconId in deletedBeaconIds) {
        CRBeacon *beacon = [_beaconStorage findCRBeaconWithId:deletedBeaconId.integerValue];
        [_beaconStorage removeObject:beacon];
    }
    
    // Parse Events
    NSArray *createdEventsDictionaries = data[@"events"][@"createdOrUpdated"];
    NSArray *deletedEventIds = data[@"events"][@"deleted"];
    
    for (NSDictionary *eventDictionary in createdEventsDictionaries) {
        CREvent *event = [CREvent eventFromJSON:eventDictionary];
        [_eventStorage addEvent:event];
    }
    
    for (NSNumber *deletedEventId in deletedEventIds) {
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
    
    NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SYNC];
    [userDefaults setObject:lastSync forKey:LAST_SYNC];
    [userDefaults synchronize];
}

@end
