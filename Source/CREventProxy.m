//
//  CREventProxy.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 07/20/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventProxy.h"
#import "CREvent.h"
#import "CRDefines.h"

@implementation CREventProxy {
    NSString *_basePath;
}

+ (instancetype)proxyWithBasePath:(NSString *)path eventId:(NSUInteger)eventId {
    return [[self alloc] initWithBasePath:path eventId:eventId];
}

- (instancetype)initWithBasePath:(NSString *)path eventId:(NSUInteger)eventId {
    _basePath = path;
    _eventId = eventId;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [_object methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (!_object) {
        [self _load]; // Load real object
    }
    
    [invocation invokeWithTarget:_object];
}

+ (BOOL)respondsToSelector:(SEL)aSelector {
    return [CREvent respondsToSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)selector {
    if (!_object) {
        [self _load]; // Load real object
    }
    
    return [_object respondsToSelector:selector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (!_object) {
        [self _load]; // Load real object
    }
    
    return [_object isKindOfClass:aClass];
}

- (void)_load {
    // Load real data here
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(_eventId)]];
    _object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
