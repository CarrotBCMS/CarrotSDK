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

#import "CRAnalyticsProvider.h"
#import "CRDefines.h"
#import "CREvent.h"
#import "CREvent_Internal.h"
#import "CRBeacon.h"
#import "CRBeacon_Internal.h"
#import "CRPersistentRequestQueue.h"

@interface CRAnalyticsProvider ()

- (void)_dispatchOperationWithJSONString: (NSString *)string;
- (NSString *)_JSONStringForLogWithEvent:(CREvent *)event beacon:(CRBeacon *)beacon;

@end

@implementation CRAnalyticsProvider {
    CRPersistentRequestQueue *_requestStore;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithBaseURL:(NSURL *)url appKey:(NSString *)appKey {
    self = [super init];
    if(self) {
        _baseURL = url;
        _appKey = appKey;
        _requestStore = [[CRPersistentRequestQueue alloc] initWithStoragePath:CRAnalyticsLogsDataFilePath];
        [_requestStore sendQueuedRequests]; // Dequeue old requests
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Analytics

- (void)logEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon {
    [self _dispatchOperationWithJSONString:[self _JSONStringForLogWithEvent:event beacon:beacon]];
    [_requestStore sendQueuedRequests];
}

- (void)logEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon {
    for (CREvent *event in events) {
        [self _dispatchOperationWithJSONString:[self _JSONStringForLogWithEvent:event beacon:beacon]];
    }
    [_requestStore sendQueuedRequests];
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
    if (!string || !_appKey) {
        return;
    }
    
    NSURL *url = [_baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/client/analytics/logs/%@", _appKey]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_requestStore addObject:request];
}

@end
