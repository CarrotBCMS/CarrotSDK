/*
 * Carrot - beacon management (sdk)
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

NS_ASSUME_NONNULL_BEGIN

/**
 `CRSingleFileStorage` is a class to store (serialize) abstract objects in a single file.
 This class may be overriden for more concrete implementations. 
 Keep in mind that there is no lazy loading of any kind. The object graph is stored in-memory permanently.
 Have a look at `CRDefinitions.h` for more information on storage paths.
 */
@interface CRSingleFileStorage : NSObject {
@protected
    NSMutableArray *_objects;
}

///---------------------------------------------------------------------------------------
/// @name Storage properties
///---------------------------------------------------------------------------------------

/**
 Storage path
 */
@property (readonly, strong) NSString *storagePath;

///---------------------------------------------------------------------------------------
/// @name Lifecycle
///---------------------------------------------------------------------------------------

/**
 Inits a Storage with given path.
 
 @param path The storage path
 */
- (instancetype)initWithStoragePath:(NSString *)path;

///---------------------------------------------------------------------------------------
/// @name Adding, deleting & retrieving objects
///---------------------------------------------------------------------------------------

/**
 Adds an object to store. The store usually auto-saves.
 
 @param object The object
 */
- (void)addObject:(id)object;

/**
 Remove an object from store. The store usually auto-saves.
 
 @param object The object
 */
- (void)removeObject:(id)object;

/**
 Return all stored objects.
 */
- (NSArray *)objects;

/**
 Adds an array to store.
 
 @param array An array
 */
- (void)addObjectsFromArray:(NSArray *)array;

/**
 Removes an array from store.
 
 @param array An array
 */
- (void)removeObjectsInArray:(NSArray *)array;

NS_ASSUME_NONNULL_END

@end
