//
//  CRDefines.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
// Logging
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CRLog(x, ...)

/*
#ifdef DEBUG
#define CRLog(x, ...) NSLog(@"CarrotSDK: %s %d: " x, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CRLog(x, ...)
#endif*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// Paths
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CRBeaconDataBasePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/.data/carrot/"]
#define CRBeaconDataFilePath [CRBeaconDataBasePath stringByAppendingString:@"data"]
#define CRAnalyticsLogsDataFilePath [CRBeaconDataBasePath stringByAppendingString:@"logs"]