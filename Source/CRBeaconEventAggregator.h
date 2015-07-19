//
//  CRBeaconEventAggregator.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/18/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRSingleFileStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRBeaconEventAggregator : CRSingleFileStorage

- (void)setBeacons:(NSArray *)beaconIds forEvent:(NSUInteger)eventId;
- (NSArray *)eventsForBeacon:(NSUInteger)beaconId;
- (NSArray *)beaconsForEvent:(NSUInteger)eventId;

@end

NS_ASSUME_NONNULL_END