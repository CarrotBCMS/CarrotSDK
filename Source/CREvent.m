//
//  CRContent.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 05/23/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREvent.h"

@implementation CREvent {
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Initialising

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
