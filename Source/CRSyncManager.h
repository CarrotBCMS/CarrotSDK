/*
 * Carrot - beacon management (sdk)
 * Copyright (C) 2015 Heiko Dreyer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CRSyncManager;
@protocol CRSyncManagerDelegate <NSObject>

- (void)syncManager:(CRSyncManager *)syncManager didFailWithError:(NSError *)error;
- (void)syncManagerDidFinishSyncing:(CRSyncManager *)syncManager;

@end

@class CREventStorage;
@class CRBeaconStorage;
@class CRBeaconEventAggregator;

@interface CRSyncManager : NSObject

/**
 The delegate
 */
@property (assign, nullable) id<CRSyncManagerDelegate> delegate;

/**
 The event storage
 */
@property (readonly, strong) CREventStorage *eventStorage;

/**
 The beacon storage
 */
@property (readonly, strong) CRBeaconStorage *beaconStorage;

/**
 The beacon-event Aggregator
 */
@property (readonly, strong) CRBeaconEventAggregator *aggregator;

/**
 The base url to bms
 */
@property (readonly, strong) NSURL *baseURL;

/**
 The app key
 */
@property (readonly, strong) NSString *appKey;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Init instance with storages.
 */
- (instancetype)initWithDelegate:(id<CRSyncManagerDelegate>)delegate
                    eventStorage:(CREventStorage*)eventStorage
                   beaconStorage:(CRBeaconStorage *)beaconStorage
                      aggregator:(CRBeaconEventAggregator *)aggregator
                         baseURL:(NSURL *)url
                          appKey:(NSString *)appKey;

///---------------------------------------------------------------------------------------
/// @name Sync
///---------------------------------------------------------------------------------------

/**
 Starts the syncing process
 */
- (void)startSyncing;

/**
 Stops the syncing process
 */
- (void)stopSyncing;

@end

NS_ASSUME_NONNULL_END
