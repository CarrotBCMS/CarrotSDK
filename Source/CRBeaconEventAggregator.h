//
//  CRBeaconEventAggregator.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 18.07.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRSingleFileStorage.h"

@interface CRBeaconEventAggregator : CRSingleFileStorage

- (void)setBeacons:(NSArray *)beaconIds forEvent:(NSUInteger)eventId;
- (NSArray *)eventsForBeacon:(NSUInteger)beaconId;
- (NSArray *)beaconsForEvent:(NSUInteger)eventId;

@end
