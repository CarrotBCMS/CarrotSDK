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
#import "CREvent.h"

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
    CRBeacon *beacon = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] major:@2 minor:@560 name:@"Beacon 1"];
    CRBeacon *beaconTwo = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0001"] major:@2 minor:@559 name:@"Beacon 2"];
    CRBeacon *beaconThree = [[CRBeacon alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"73676723-7400-0000-ffff-0000ffff0003"] major:@2 minor:@558 name:@"Beacon 3"];
    // Setup beacons
    [_beaconStorage addObjectsFromArray:@[beacon, beaconTwo, beaconThree]];
}

- (void)stopSyncing {
    
}

@end
