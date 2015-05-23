//
//  CRBeaconManager.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CRBeaconManagerDelegate;

@interface CRBeaconManager : NSObject

@property (nonatomic, assign) id <CRBeaconManagerDelegate> delegate;
@property (readonly) NSURL *url;
@property (readonly) NSString *appKey;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

-(instancetype)initWithDelegate: (id<CRBeaconManagerDelegate>)delegate
                            url: (NSURL *)url
                         appKey: (NSString *)key;

///---------------------------------------------------------------------------------------
/// @name Monitoring
///---------------------------------------------------------------------------------------

-(void)handleAuthorization;

-(void)startRangingBeacons;

-(void)stopRangingBeacons;

///---------------------------------------------------------------------------------------
/// @name Syncing
///---------------------------------------------------------------------------------------

-(BOOL)startSyncingProcessWithError: (NSError * __autoreleasing *)error;

-(BOOL)cancelSyncingProcess;

@end
