//
//  CRSyncManager.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

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
