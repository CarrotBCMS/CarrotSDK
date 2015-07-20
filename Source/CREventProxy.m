//
//  CREventProxy.m
//  CarrotSDK
//
//  Created by Heiko Dreyer on 20.07.15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

#import "CREventProxy.h"
#import "CREvent.h"
#import "CRDefines.h"

@implementation CREventProxy {
    NSString *_basePath;
    BOOL _access;
}

+ (instancetype)proxyWithBasePath:(NSString *)path eventId:(NSUInteger)eventId {
    return [[self alloc] initWithBasePath:path eventId:eventId];
}

- (instancetype)initWithBasePath:(NSString *)path eventId:(NSUInteger)eventId {
    _basePath = path;
    _eventId = eventId;
    _access = NO;
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
    NSString *path = [_basePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%@", @(_eventId)]];
    _object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (BOOL)beginContentAccess {
    _access = YES;
    return ![self isContentDiscarded];
}

- (void)endContentAccess {
    _access = NO;
}

- (void)discardContentIfPossible {
    if (!_access) {
        _object = nil;
    }
}

- (BOOL)isContentDiscarded {
    return (_object == nil);
}

@end
