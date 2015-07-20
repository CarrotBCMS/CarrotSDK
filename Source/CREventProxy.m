//
//  CREventProxy.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 20.07.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventProxy.h"
#import "CREvent.h"

@implementation CREventProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [_object methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_object];
}

+ (BOOL)respondsToSelector:(SEL)aSelector {
    return [CREvent respondsToSelector:aSelector];
}

@end
