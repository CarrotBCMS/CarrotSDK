//
//  CRContent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREvent.h"
#import "CREvent_Internal.h"

#import "CRTextEvent.h"
#import "CRNotificationEvent.h"

#import "NSDate+ISO.h"

@interface CREvent ()
@end

@implementation CREvent {
    BOOL _isActive;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising & NSCoding

- (instancetype)initWithEventId:(NSUInteger)eventId
                      threshold:(NSTimeInterval)threshold
             scheduledStartDate:(NSDate *)startDate
               scheduledEndDate:(NSDate *)endDate
                  lastTriggered:(NSDate *)lastTriggered
                      eventType:(CREventType)eventType;
{
    self = [super init];
    if (self) {
        _threshold = threshold;
        _eventId = eventId;
        _lastTriggered = lastTriggered;
        _eventType = eventType;
        _scheduledEndDate = endDate;
        _scheduledStartDate = startDate;
        _isActive = true;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self initWithEventId:[[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_eventId"] integerValue]
                       threshold:((NSNumber *)[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_threshold"]).doubleValue
            scheduledStartDate:[coder decodeObjectOfClass:[NSDate class] forKey:@"CREvent_scheduledStartDate"]
                scheduledEndDate:[coder decodeObjectOfClass:[NSDate class] forKey:@"CREvent_scheduledEndDate"]
                   lastTriggered:[coder decodeObjectOfClass:[NSDate class] forKey:@"CREvent_lastTriggered"]
                       eventType:((NSNumber *)[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_eventType"]).integerValue];
    [self setIsActive:((NSNumber *)[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_isActive"]).boolValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_eventId) forKey:@"CREvent_eventId"];
    [aCoder encodeObject:@(_threshold) forKey:@"CREvent_threshold"];
    [aCoder encodeObject:_lastTriggered forKey:@"CREvent_lastTriggered"];
    [aCoder encodeObject:_scheduledStartDate forKey:@"CREvent_scheduledStartDate"];
    [aCoder encodeObject:_scheduledEndDate forKey:@"CREvent_scheduledEndDate"];
    [aCoder encodeObject:@(_eventType) forKey:@"CREvent_eventType"];
    [aCoder encodeObject:@(_isActive) forKey:@"CREvent_isActive"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal

- (void)__setScheduledEndDate:(NSDate *)endDate {
    _scheduledEndDate = endDate;
}

- (void)__setScheduledStartDate:(NSDate *)startDate {
    _scheduledStartDate = startDate;
}

- (void)__setLastTriggered:(NSDate *)lastTriggered {
    _lastTriggered = lastTriggered;
}

- (void)setIsActive:(BOOL)active {
    _isActive = active;
}

- (BOOL)isActive {
    return _isActive;
}

- (void)__setEventId:(NSUInteger)eventId {
    _eventId = eventId;
}

// Should be overriden
- (NSString *)_objectType {
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    CREvent *aObject = (CREvent *)object;
    if (!aObject || self.eventId != aObject.eventId) {
        return NO;
    }
    
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal factory method

+ (instancetype)eventFromJSON:(NSDictionary *)dictionary {
    NSNumber *eventId = dictionary[@"id"];
    NSNumber *active = dictionary[@"active"];
    NSNumber *threshold = dictionary[@"threshold"]; // It's in minutes here
    NSString *scheduledStartDate = dictionary[@"scheduledStartDate"];
    NSString *scheduledEndDate = dictionary[@"scheduledEndDate"];
    NSNumber *eventType = dictionary[@"eventType"];
    NSString *objectType = dictionary[@"objectType"];
    
    NSString *text = dictionary[@"text"];
    NSString *title = dictionary[@"title"];
    NSString *message = dictionary[@"message"];
    NSString *payload = dictionary[@"payload"];
    
    NSArray *beacons = dictionary[@"beacons"];
    NSMutableArray *beaconIds = [NSMutableArray array];

    if (beacons) {
        for (NSDictionary *beaconDict in beacons) {
            if (beaconDict[@"id"]) {
                [beaconIds addObject:beaconDict[@"id"]];
            }
        }
    }
    
    CREventType aEventType = eventType.integerValue;
    
    if (!eventId || !active || !threshold || !eventType || !objectType) {
        return nil;
    }
    
    NSDate *aScheduledStartDate = nil;
    NSDate *aScheduledEndDate = nil;

    if (aScheduledStartDate) {
        aScheduledStartDate = [NSDate dateFromISO8601String:scheduledStartDate];
    }
    if (scheduledEndDate) {
        aScheduledEndDate = [NSDate dateFromISO8601String:scheduledEndDate];
    }
    
    CREvent *event = nil;
    
    // Create TextEvent here...
    if ([objectType isEqualToString:@"text"]) {
        CRTextEvent *textEvent = [[CRTextEvent alloc] initWithEventId:eventId.integerValue
                                           threshold:(threshold.doubleValue * 60)
                                  scheduledStartDate:aScheduledStartDate
                                    scheduledEndDate:aScheduledEndDate
                                       lastTriggered:nil
                                           eventType:aEventType];
        if (text) {
            [textEvent __setText:text];
        }
        event = textEvent;
        
    }
    
    // Create NotificationEvent here...
    if ([objectType isEqualToString:@"notification"]) {
        CRNotificationEvent *notificationEvent = [[CRNotificationEvent alloc] initWithEventId:eventId.integerValue
                                                            threshold:(threshold.doubleValue * 60)
                                                   scheduledStartDate:aScheduledStartDate
                                                     scheduledEndDate:aScheduledEndDate
                                                        lastTriggered:nil
                                                            eventType:aEventType];
        if (message) {
            [notificationEvent __setMessage:message];
        }
        if (title) {
            [notificationEvent __setTitle:title];
        }
        if (payload) {
            [notificationEvent __setPayload:payload];
        }
        event = notificationEvent;
    }
    
    if (event) {
        [event __setEventId:eventId.integerValue];
        event.isActive = active.boolValue;
    }

    return event;
}

@end
