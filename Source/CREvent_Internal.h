//
//  CREvent_Internal.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/03/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CarrotSDK/CarrotSDK.h>

@interface CREvent (Internal) <NSSecureCoding>

- (void)__setScheduledEndDate:(NSDate *)endDate;
- (void)__setScheduledStartDate:(NSDate *)startDate;
- (void)__setLastTriggered:(NSDate *)lastTriggered;
- (void)__setEventId:(NSUInteger)eventId;

- (void)setIsActive:(BOOL)active;
- (BOOL)isActive;

- (NSString *)_objectType;

+ (instancetype)eventFromJSON:(NSDictionary *)dictionary;

@end

@interface CRNotificationEvent (Internal)

- (void)__setTitle:(NSString *)title;
- (void)__setMessage:(NSString *)message;
- (void)__setPayload:(NSString *)payload;

@end

@interface CRTextEvent (Internal)

- (void)__setText:(NSString *)text;

@end