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

#import "NSDate+ISO.h"

/**
 Forked from https://github.com/soffes/SAMCategories/blob/master/SAMCategories/NSDate%2BSAMAdditions.m
 */
@implementation NSDate (ISO)

+ (NSDate *)dateFromISO8601String:(NSString *)iso8601 {
    // Return nil if nil is given
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) {
        return nil;
    }
    
    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }
    
    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]]) {
        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }
        
        struct tm tm;
        char newStr[25] = "";
        BOOL hasTimezone = NO;
        
        // 2014-03-30T09:13:00Z
        if (len == 20 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
        }
        
        // 2014-03-30T09:13:00-07:00
        else if (len == 25 && str[22] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }
        
        // 2014-03-30T09:13:00.000Z
        else if (len == 24 && str[len - 1] == 'Z') {
            strncpy(newStr, str, 19);
        }
        
        // 2014-03-30T09:13:00.000-07:00
        else if (len == 29 && str[26] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }
        
        // Poorly formatted timezone
        else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }
        
        // Timezone
        size_t l = strlen(newStr);
        if (hasTimezone) {
            strncpy(newStr + l, str + len - 6, 3);
            strncpy(newStr + l + 3, str + len - 2, 2);
        } else {
            strncpy(newStr + l, "+0000", 5);
        }
        
        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;
        
        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }
        
        time_t t;
        t = mktime(&tm);
        
        return [NSDate dateWithTimeIntervalSince1970:t];
    }
    
    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}

@end
