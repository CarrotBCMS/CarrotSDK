//
//  CRContent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CREvent : NSObject <NSSecureCoding>

/**
 Unique event id.
 */
@property (strong) NSNumber *eventId;

/**
 The threshold in seconds.
 */
@property (strong) NSNumber *threshold;

/**
 Last time this event was triggered.
 */
@property (strong) NSDate *lastTriggered;

@end
