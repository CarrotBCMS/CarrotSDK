//
//  CRBeaconStore.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRPersistentStore.h"

/**
 `CRBeaconStore` is a sublcass of `CRPersistentStore`
 This is a concret implementation to store (serialize) Beacon data.
 Have a look at `CRDefinitions.h` for more information on storage paths.
 
 @see CRPersistentStore
 */
@interface CRBeaconStore : CRPersistentStore

@end
