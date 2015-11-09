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

//! Project version number for CarrotSDK.
FOUNDATION_EXPORT double CarrotSDKVersionNumber;

//! Project version string for CarrotSDK.
FOUNDATION_EXPORT const unsigned char CarrotSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CarrotSDK/PublicHeader.h>
#import <CarrotSDK/CRBeaconManager.h>
#import <CarrotSDK/CRBeaconManagerDelegate.h>
#import <CarrotSDK/CRBeacon.h>
#import <CarrotSDK/CREvent.h>
#import <CarrotSDK/CRTextEvent.h>
#import <CarrotSDK/CRNotificationEvent.h>
#import <CarrotSDK/CRBeaconManagerEnums.h>