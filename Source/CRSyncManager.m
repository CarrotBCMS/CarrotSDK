//
//  CRSyncManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRSyncManager.h"
#import "CREventStorage.h"
#import "CRBeaconStorage.h"
#import "CRBeacon.h"
#import "CRTextEvent.h"
#import "CRNotificationEvent.h"

@implementation CRSyncManager

- (instancetype)initWithDelegate:(id<CRSyncManagerDelegate>)delegate
                    eventStorage:(CREventStorage*)eventStorage
                   beaconStorage:(CRBeaconStorage *)beaconStorage
{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _eventStorage = eventStorage;
        _beaconStorage = beaconStorage;
    }
    
    return self;
}

- (void)startSyncing {
    // Setup beacons
    CRBeacon *beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] major:@2 minor:@560 name:@"Beacon 1"];
    CRBeacon *beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0001"] major:@2 minor:@559 name:@"Beacon 2"];
    CRBeacon *beaconThree = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] major:@2 minor:@558 name:@"Beacon 3"];
    [_beaconStorage addObjectsFromArray:@[beacon, beaconTwo, beaconThree]];
    
    // Setup events
    NSArray *arrayOne = [_eventStorage findAllEventsForBeacon:beacon];
    CRTextEvent *event = [[CRTextEvent alloc] initWithEventId:@1 threshold:30 lastTriggered:nil eventType:CREventTypeEnter];
    CRTextEvent *eventTwo = [[CRTextEvent alloc] initWithEventId:@2 threshold:30 lastTriggered:nil eventType:CREventTypeExit];
    CRNotificationEvent *eventThree = [[CRNotificationEvent alloc] initWithEventId:@2 threshold:120 lastTriggered:nil eventType:CREventTypeEnter];
    eventThree.title = @"Willkommmen in Beacon 1";
    eventThree.message = @"Du bist hier genau richtig. Alles ist super!";
    eventThree.payload = @"Custom data";
    
    NSArray *events = @[event, eventTwo, eventThree];
    
    for (CREvent *aEvent in events) {
        if (![arrayOne containsObject:aEvent]) {
            [_eventStorage addEvent:aEvent forBeacon:beacon];
        }
    }
    
}

- (void)stopSyncing {
    
}

@end
