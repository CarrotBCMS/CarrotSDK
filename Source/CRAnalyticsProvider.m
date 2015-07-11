//
//  CRAnalyticsProvider.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/01/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRAnalyticsProvider.h"
#import "CRDefines.h"
#import "CREvent.h"
#import "CREvent_Internal.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CRPersistentRequestQueue.h"
#import "AFNetworking.h"

@interface CRAnalyticsProvider ()

- (void)_dispatchOperationWithJSONString: (NSString *)string;
- (NSString *)_JSONStringForLogWithEvent:(CREvent *)event beacon:(CRBeacon *)beacon;

@end

@implementation CRAnalyticsProvider {
    CRPersistentRequestQueue *_requestStore;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if(self) {
        _baseURL = url;
        _requestStore = [[CRPersistentRequestQueue alloc] initWithStoragePath:CRAnalyticsLogsDataFilePath];
        [self _sendRequests]; // Dequeue old requests 
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Analytics

- (void)logEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    [self _dispatchOperationWithJSONString:[self _JSONStringForLogWithEvent:event beacon:beacon]];
    [self _sendRequests];
}

- (void)logEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    for (CREvent *event in events) {
        [self _dispatchOperationWithJSONString:[self _JSONStringForLogWithEvent:event beacon:beacon]];
    }
    [self _sendRequests];
}

- (NSString *)_JSONStringForLogWithEvent:(CREvent *)event beacon:(CRBeacon *)beacon {
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];
    [eventDictionary setObject:@(event.eventId) forKey:@"id"];
    [eventDictionary setObject:event._objectType forKey:@"objectType"];
    
    NSMutableDictionary *beaconDictionary = [NSMutableDictionary dictionary];
    [beaconDictionary setObject:@(beacon.beaconId) forKey:@"id"];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:eventDictionary forKey:@"occuredEvent"];
    [dictionary setObject:beaconDictionary forKey:@"beacon"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (void)_dispatchOperationWithJSONString: (NSString *)string {
    if (!string) {
        return;
    }
    
    NSURL *url = [_baseURL URLByAppendingPathComponent:@"/client/analytics/logs"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_requestStore addRequest:request];
}

- (void)_sendRequests {
    [_requestStore sendQueuedRequestsWithBlock:^(NSOperationQueue * __nonnull queue, NSURLRequest * __nonnull request) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        CRLog(@"Sending log operation...");
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            CRLog(@"Logging response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CRLog(@"Logging error: %@", error);
        }];
        [queue addOperation:operation];
    }];
}

@end
