//
//  CRTextEvent.h
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CREvent.h"

@interface CRTextEvent : CREvent

/**
 Text value
 */
@property (readonly, strong, nullable) NSString *text;

@end