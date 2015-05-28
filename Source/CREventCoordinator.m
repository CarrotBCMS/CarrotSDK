//
//  CREventCoordinator.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/28/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventCoordinator.h"

@implementation CREventCoordinator {
    CREventStorage *_storage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithEventStorage:(CREventStorage*)storage {
    self = [super init];
    if (self) {
        _storage = storage;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Coordination

- (NSArray *)validEnterEventsForBeacon:(CRBeacon *)beacon {
    return nil;
}

- (NSArray *)validExitEventsForBeacon:(CRBeacon *)beacon {
    return nil;
}

- (NSArray *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon {
    return nil;
}

- (NSArray *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon {
    return nil;
}

@end
