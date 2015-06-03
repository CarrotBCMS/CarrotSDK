//
//  CRNotificationEvent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/25/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREvent.h"

@interface CRNotificationEvent : CREvent

/**
 Title of the notification
 */
@property (readonly, strong) NSString *title;

/**
 Notification message
 */
@property (readonly, strong) NSString *message;

/**
 A payload
 */
@property (readonly, strong) NSString *payload;

@end
