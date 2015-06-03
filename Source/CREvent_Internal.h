//
//  CREvent_Internal.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 06/03/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <CarrotSDK/CarrotSDK.h>

@interface CREvent (Internal)

- (void)__setScheduledEndDate:(NSDate *)endDate;
- (void)__setScheduledStartDate:(NSDate *)startDate;
- (void)__setLastTriggered:(NSDate *)lastTriggered;

@end
