//
//  CRNotificationEvent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/25/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CREvent.h"

@interface CRNotificationEvent : CREvent

/**
 Title of the notification
 */
@property (strong) NSString *title;

/**
 Notification message
 */
@property (strong) NSString *message;

@end
