//
//  bsSwitch.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/19.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsSwitch.h"

#import "bsStr.h"

static NSDictionary *__bsSwitch_keyValues = nil;

@implementation bsSwitch

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (switch_ == nil) {
        switch_ = [[UISwitch alloc] init];
        [self addSubview:switch_];
        self.frame = switch_.frame;
    }
    if (__bsSwitch_keyValues == nil) {
        __bsSwitch_keyValues =
        @{ @"on": @kbsSwitchOn, @"animation": @kbsSwitchAnimation, @"tint-off-color": @kbsSwitchTintOffColor,
           @"tint-on-color": @kbsSwitchTintOnColor, @"tint-thumb-color": @kbsSwitchTintThumbColor,
           @"img-on": @kbsSwitchImgOn, @"img-off": @kbsSwitchImgOff
           };
    }
    animation_ = YES;
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    objc_removeAssociatedObjects( self );
}

- (id)__g:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger num = [[__bsSwitch_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsSwitchOn: value = @(switch_.on); break;
        case kbsSwitchAnimation: value = @(animation_); break;
        case kbsSwitchTintOffColor: value = switch_.tintColor; break;
        case kbsSwitchTintOnColor: value = switch_.onTintColor; break;
        case kbsSwitchTintThumbColor: value = switch_.thumbTintColor; break;
        case kbsSwitchImgOn: value = switch_.onImage; break;
        case kbsSwitchImgOff: value = switch_.offImage; break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSMutableArray *remain = [NSMutableArray array];
    BOOL onChange = NO;
    BOOL on;
    for (NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsSwitch_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsSwitchOn: on = [bsStr BOOLEAN:v]; onChange = YES; break;
            case kbsSwitchAnimation: animation_ = [bsStr BOOLEAN:v]; break;
            case kbsSwitchTintOffColor: switch_.tintColor = [bsStr color:v]; break;
            case kbsSwitchTintOnColor: switch_.onTintColor = [bsStr color:v]; break;
            case kbsSwitchTintThumbColor: switch_.thumbTintColor = [bsStr color:v]; break;
            case kbsSwitchImgOn: switch_.onImage = [UIImage imageNamed:v]; break;
            case kbsSwitchImgOff: switch_.offImage = [UIImage imageNamed:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if (onChange) {
        [switch_ setOn:on animated:animation_];
    }
    return remain;
}

#pragma mark - block

- (void)blockOn:(bsSwitchOnBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (!addedOn_) {
        addedOn_ = YES;
        [switch_ addTarget:self action:@selector(__valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    objc_setAssociatedObject(self, &blockKey_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)__valueChanged:(id)sender {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsSwitchOnBlock block = objc_getAssociatedObject(self, &blockKey_);
    if (block) block(self, switch_.on);
}

#pragma mark - override
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString*)styleNames parameters:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString*)styleNames parameters:(NSString*)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (bsDisplay *)subviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)removeSubviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
