//
//  NSDate+ISO.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/17/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO)

+ (NSDate *)dateFromISO8601String:(NSString *)iso8601String;

@end
