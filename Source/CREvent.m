//
//  CRContent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREvent.h"

@implementation CREvent {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising & NSCoding

- (instancetype)initWithEventId:(NSNumber *)eventId
                      threshold:(NSTimeInterval)threshold
                  lastTriggered:(NSDate *)lastTriggered
                      eventType:(CREventType)eventType;
{
    self = [super init];
    if (self) {
        _threshold = threshold;
        _eventId = eventId;
        _lastTriggered = lastTriggered;
        _eventType = eventType;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self initWithEventId:[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_eventId"]
                       threshold:((NSNumber *)[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_threshold"]).doubleValue
                   lastTriggered:[coder decodeObjectOfClass:[NSDate class] forKey:@"CREvent_lastTriggered"]
                       eventType:((NSNumber *)[coder decodeObjectOfClass:[NSNumber class] forKey:@"CREvent_eventType"]).integerValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_eventId forKey:@"CREvent_eventId"];
    [aCoder encodeObject:[NSNumber numberWithDouble:_threshold] forKey:@"CREvent_threshold"];
    [aCoder encodeObject:_lastTriggered forKey:@"CREvent_lastTriggered"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_eventType] forKey:@"CREvent_eventType"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    CREvent *aObject = (CREvent *)object;
    if (!aObject || ![self.eventId isEqualToNumber:aObject.eventId])
    {
        return NO;
    }
    
    return YES;
}

@end
