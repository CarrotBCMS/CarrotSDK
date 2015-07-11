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
#import "AFNetworking.h"

@interface CRAnalyticsProvider ()

- (void)_dispatchOperationWithJSONString: (NSString *)string;
- (NSString *)_JSONStringForLogWithEvent:(CREvent *)event beacon:(CRBeacon *)beacon;

@end

@implementation CRAnalyticsProvider {
    NSOperationQueue *_queue;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if(self) {
        _baseURL = url;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Analytics

- (void)logEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    NSString *string = [self _JSONStringForLogWithEvent:event beacon:beacon];
    [self _dispatchOperationWithJSONString:string];
}

- (void)logEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    for (CREvent *event in events) {
        [self logEvent:event forBeacon:beacon];
    }
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
                          
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    CRLog(@"Adding log operation...");
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        CRLog(@"Logging response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CRLog(@"Logging error: %@", error);
    }];
    
    [[self _queue] addOperation:operation];
}

- (NSOperationQueue *)_queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}

@end
