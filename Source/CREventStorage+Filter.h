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

#import "CREventStorage.h"

@interface CREventStorage (Filter)

///---------------------------------------------------------------------------------------
/// @name CRUD methods
///---------------------------------------------------------------------------------------

/**
 Finds all enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<__kindof CREvent *> *)findAllEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<CRNotificationEvent *> *)findAllNotificationEnterEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<__kindof CREvent *> *)findAllExitEventsForBeacon:(CRBeacon *)beacon;

/**
 Finds all notification enter events for a corresponding beacon
 
 @param beacon The beacon
 */
- (NSArray<CRNotificationEvent *> *)findAllNotificationExitEventsForBeacon:(CRBeacon *)beacon;

@end
