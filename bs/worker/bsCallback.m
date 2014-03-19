//
//  bsCallback.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsCallback.h"

#import "bsError.h"

@implementation bsCallback

+ (bsCallback *)GWithBlock:(bsCallbackBlock)callbackBlock {
    
    return [[bsCallback alloc] initWithBlock:callbackBlock];
}

+ (bsCallback *)GWithTarget:(id)target selector:(SEL)selector {
    
    return [[bsCallback alloc] initWithTarget:target selector:selector];
}

- (id)initWithBlock:(bsCallbackBlock)callbackBlock {
    
    if( self = [super init] ) {
        block_ = callbackBlock;
    }
    return self;
}

- (id)initWithTarget:(id)target selector:(SEL)selector {
    
    if (self = [super init]) {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void)dealloc {
    
    _target = nil;
    _selector = nil;
    block_ = nil;
}

- (void)callbackWithKey:(NSString *)key data:(id)data error:(bsError *)error {
    
    if (_target && [_target respondsToSelector:_selector]) {
        if ([_target isKindOfClass:[UIView class]] && ![NSThread isMainThread]) {
            dispatch_sync( dispatch_get_main_queue(), ^{
                objc_msgSend(_target, _selector, key, data, error);
            });
        } else {
            objc_msgSend( _target, _selector, key, data, error );
        }
    } else {
        if (block_) block_(key, data, error);
    }
}

@end
