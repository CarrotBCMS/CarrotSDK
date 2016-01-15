/*
 * Carrot -  beacon content management (sdk)
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
