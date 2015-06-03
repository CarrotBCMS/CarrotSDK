//
//  CRContent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREvent.h"
#import "CREvent_Internal.h"

@implementation CREvent {
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
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_eventId) forKey:@"CREvent_eventId"];
    [aCoder encodeObject:@(_threshold) forKey:@"CREvent_threshold"];
    [aCoder encodeObject:_lastTriggered forKey:@"CREvent_lastTriggered"];
    [aCoder encodeObject:_scheduledStartDate forKey:@"CREvent_scheduledStartDate"];
    [aCoder encodeObject:_scheduledEndDate forKey:@"CREvent_scheduledEndDate"];
    [aCoder encodeObject:@(_eventType) forKey:@"CREvent_eventType"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal Accessors 

- (void)__setScheduledEndDate:(NSDate *)endDate {
    _scheduledEndDate = endDate;
}

- (void)__setScheduledStartDate:(NSDate *)startDate {
    _scheduledStartDate = startDate;
}

- (void)__setLastTriggered:(NSDate *)lastTriggered {
    _lastTriggered = lastTriggered;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    CREvent *aObject = (CREvent *)object;
    if (!aObject || self.eventId != aObject.eventId)
    {
        return NO;
    }
    
    return YES;
}

@end
