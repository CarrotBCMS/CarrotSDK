//
//  CRNotificationEvent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/25/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRNotificationEvent.h"
#import "CREvent_Internal.h"

@implementation CRNotificationEvent {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    _title = [coder decodeObjectOfClass:[NSNumber class] forKey:@"CRNotificationEvent_title"];
    _message = [coder decodeObjectOfClass:[NSNumber class] forKey:@"CRNotificationEvent_message"];
    _payload = [coder decodeObjectOfClass:[NSNumber class] forKey:@"CRNotificationEvent_payload"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_title forKey:@"CRNotificationEvent_title"];
    [aCoder encodeObject:_message forKey:@"CRNotificationEvent_message"];
    [aCoder encodeObject:_payload forKey:@"CRNotificationEvent_payload"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal

- (void)__setTitle:(NSString *)title {
    _title = title;
}

- (void)__setMessage:(NSString *)message {
    _message = message;
}

- (void)__setPayload:(NSString *)payload {
    _payload = payload;
}

- (NSString *)_objectType {
    return @"notification";
}

@end
