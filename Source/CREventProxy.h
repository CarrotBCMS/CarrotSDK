//
//  CREventProxy.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 20.07.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CREvent;

@interface CREventProxy : NSProxy

@property (strong, nullable) CREvent *object;

@end
