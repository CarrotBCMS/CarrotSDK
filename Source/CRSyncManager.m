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
#import "CREvent_Internal.h"

@implementation CRSyncManager

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithDelegate:(id<CRSyncManagerDelegate>)delegate
                    eventStorage:(CREventStorage*)eventStorage
                   beaconStorage:(CRBeaconStorage *)beaconStorage
                         baseURL:(NSURL *)url
{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _eventStorage = eventStorage;
        _beaconStorage = beaconStorage;
        _baseURL = url;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

- (void)startSyncing {
    // This is all boilerplate as long as there is no proper sync method in action
    // Setup beacons
    CRBeacon *beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"]
                                                major:@2
                                                minor:@560 name:@"Beacon 1"];
    CRBeacon *beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0001"]
                                                   major:@2
                                                   minor:@559
                                                    name:@"Beacon 2"];
    CRBeacon *beaconThree = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"]
                                                     major:@2
                                                     minor:@558
                                                      name:@"Beacon 3"];
    [_beaconStorage addObjectsFromArray:@[beacon, beaconTwo, beaconThree]];
    
    // Setup events
    NSArray *arrayOne = [_eventStorage findAllEventsForBeacon:beacon];
    NSArray *arrayTwo = [_eventStorage findAllNotificationEventsForBeacon:beacon];
    
    CRTextEvent *event = [[CRTextEvent alloc] initWithEventId:1
                                                    threshold:30
                                           scheduledStartDate:nil
                                             scheduledEndDate:nil
                                                lastTriggered:nil
                                                    eventType:CREventTypeEnter];
    [event __setText:@"This is a dummy text"];
    
    CRTextEvent *eventTwo = [[CRTextEvent alloc] initWithEventId:2
                                                       threshold:30
                                              scheduledStartDate:nil
                                                scheduledEndDate:nil
                                                   lastTriggered:nil
                                                       eventType:CREventTypeExit];
    [eventTwo __setText:@"This is a dummy text"];
    
    CRNotificationEvent *eventThree = [[CRNotificationEvent alloc] initWithEventId:3
                                                                         threshold:60
                                                                scheduledStartDate:nil
                                                                  scheduledEndDate:nil
                                                                     lastTriggered:nil
                                                                         eventType:CREventTypeEnter];
    [eventThree __setTitle:@"Willkommmen in Beacon 1"];
    [eventThree __setMessage:@"Du bist hier genau richtig. Alles ist super!"];
    [eventThree __setPayload:@"Custom data enter"];
    
    CRNotificationEvent *eventFour = [[CRNotificationEvent alloc] initWithEventId:4
                                                                        threshold:60
                                                               scheduledStartDate:nil
                                                                 scheduledEndDate:nil
                                                                    lastTriggered:nil
                                                                        eventType:CREventTypeExit];
    [eventFour __setTitle:@"Tschüss aus Beacon 1"];
    [eventFour __setMessage:@"Schade dass du gehst!"];
    [eventFour __setPayload:@"Custom data exit"];
    
    NSArray *events = @[event, eventTwo];
    NSArray *eventNotification = @[eventThree, eventFour];
    
    for (CREvent *aEvent in events) {
        if (![arrayOne containsObject:aEvent]) {
            [_eventStorage addEvent:aEvent];
        }
    }
    
    for (CRNotificationEvent *aEvent in eventNotification) {
        if (![arrayTwo containsObject:aEvent]) {
            [_eventStorage addEvent:aEvent];
        }
    }
}

- (void)stopSyncing {
    
}

@end
