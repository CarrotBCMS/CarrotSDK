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