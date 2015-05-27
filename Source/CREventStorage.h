//
//  CREventStorage.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/27/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CREvent, CRBeacon;
@interface CREventStorage : NSObject

- (void)addEvent:(CREvent *)event forBeacon:(CRBeacon *)beacon;
- (void)addEvents:(NSArray *)events forBeacon:(CRBeacon *)beacon;

- (NSDictionary *)findAllEventsForBeacon:(CRBeacon *)beacon;
- (NSArray *)findNotificationEventsForBeacon:(CRBeacon *)beacon;

@end
