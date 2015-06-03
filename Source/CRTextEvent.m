//
//  CRTextEvent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CRTextEvent.h"

@implementation CRTextEvent {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    _text = [coder decodeObjectOfClass:[NSNumber class] forKey:@"CRTextEvent_text"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_text forKey:@"CRTextEvent_text"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Internal

- (void)__setText:(NSString *)text {
    _text = text;
}

@end
