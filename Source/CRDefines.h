/*
 * Carrot -  beacon content management (sdk)
 * Copyright (C) 2016 Heiko Dreyer
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

///////////////////////////////////////////////////////////////////////////////////////////////////
// Logging
///////////////////////////////////////////////////////////////////////////////////////////////////

//#define CRLog(x, ...)

#ifdef DEBUG
#define CRLog(x, ...) NSLog(@"CarrotSDK: %s %d: " x, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CRLog(x, ...)
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////
// Paths
///////////////////////////////////////////////////////////////////////////////////////////////////

#define CRBeaconBaseDataPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/.data/carrot/"]
#define CRBeaconDataBeaconFilePath [CRBeaconBaseDataPath stringByAppendingString:@"data_b"]
#define CRBeaconDataAggregrationFilePath [CRBeaconBaseDataPath stringByAppendingString:@"data_a"]
#define CRAnalyticsLogsDataFilePath [CRBeaconBaseDataPath stringByAppendingString:@"logs"]