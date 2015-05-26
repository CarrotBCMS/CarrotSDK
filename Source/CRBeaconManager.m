//
//  CRBeaconManager.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRBeaconManager.h"

@implementation CRBeaconManager {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

-(instancetype)initWithDelegate:(id<CRBeaconManagerDelegate>)delegate
                            url:(NSURL *)url
                         appKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _url = url;
        _appKey = key;
        _delegate = delegate;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Monitoring

-(void)handleAuthorization {
}

-(void)startRangingBeacons{
}

-(void)stopRangingBeacons {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Syncing

-(BOOL)startSyncingProcessWithError:(NSError * __autoreleasing *)error {
    return YES;
}

-(BOOL)cancelSyncingProcess {
    return YES;
}

@end
