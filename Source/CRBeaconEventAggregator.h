//
//  CRBeaconEventAggregator.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/18/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRSingleFileStorage.h"

NS_ASSUME_NONNULL_BEGIN

@class CREvent;
@class CRBeacon;

@interface CRBeaconEventAggregator : CRSingleFileStorage

- (void)setBeacons:(NSArray<NSNumber *> *)beaconIds forEvent:(NSUInteger)eventId;
- (NSArray<NSNumber *> *)eventsForBeacon:(NSUInteger)beaconId;
- (NSArray<NSNumber *> *)beaconsForEvent:(NSUInteger)eventId;

@end

NS_ASSUME_NONNULL_END