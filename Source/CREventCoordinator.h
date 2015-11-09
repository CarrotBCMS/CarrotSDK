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

@class CRBeacon;
@class CREvent;
@class CREventStorage;
@class CRNotificationEvent;

/**
 Coordinates validation and retrieval of stored events.
 */
@interface CREventCoordinator : NSObject

///---------------------------------------------------------------------------------------
/// @name Storage properties
///---------------------------------------------------------------------------------------

/**
 Storage
 */
@property (readonly, strong, nonnull) CREventStorage *storage;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Init instance with storage.
 */
- (instancetype)initWithEventStorage:(CREventStorage *)storage;

///---------------------------------------------------------------------------------------
/// @name Coordination
///---------------------------------------------------------------------------------------

- (NSArray<__kindof CREvent *> *)validEnterEventsForBeacon:(CRBeacon *)beacon;
- (NSArray<__kindof CREvent *> *)validExitEventsForBeacon:(CRBeacon *)beacon;

- (NSArray<CRNotificationEvent *> *)validEnterNotificationEventsForBeacon:(CRBeacon *)beacon;
- (NSArray<CRNotificationEvent *> *)validExitNotificationEventsForBeacon:(CRBeacon *)beacon;

- (void)sendLocalNotificationWithEvent:(CRNotificationEvent *)event;

NS_ASSUME_NONNULL_END

@end
