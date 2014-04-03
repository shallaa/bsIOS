//
//  BSDemoViewController.m
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2014/03/22.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "BSDemoViewController.h"

#import <objc/runtime.h>
#import "BSDemoModel.h"
#import "bs.h"
#import "NSNumber+ProjectBS.h"

typedef void (^BSDemoViewControllerPresentView)(NSString *oldView, NSString *newView);

@interface BSDemoViewController ()

@property (nonatomic, strong) BSDemoModel *model;

@end

@implementation BSDemoViewController

+ (id)sharedViewController {
    
    static BSDemoViewController *sharedViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedViewController = [[self alloc] init];
    });
    return sharedViewController;
}

- (id)init {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    self = [super init];
    if (self) {
        self.model = [BSDemoModel sharedModel];
        [self p_start];
    }
    return self;
}

#pragma mark - Private methods

- (void)p_start {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [bs displayAS:@"defaultSwitch" params:@"tint-on-color,179|195|27"];
    
    [[bs root] addSubviewWithName:@"image" parameters:@"k,imgBack,src,Default-568h@2x.png,auto-resize,true"]; //깜박임 방지
    [bs layerParentA:[bs root] parentName:@"root"];
    [[bs root] addSubviewWithName:@"button" parameters:@"k,sampleButton,bg,130|130|130,x,20,y,0,w,88,h,44"];
    [[bs root] addSubviewWithName:@"switch" parameters:@"k,sampleSwitch,x,20,y,88,w,88,h,44"];
    
    BSDemoViewControllerPresentView presentViewBlock = ^(NSString *prevViewName, NSString *viewName) {
        
        bsLog(nil, bsLogLevelInfo, @"PresentViewBlock");
        
        if ([viewName isEqualToString:prevViewName] ||
            (viewName == nil && prevViewName == nil)) {
            return;
        }
        
        static NSString *viewNamePrefix = @"BSDemo";
        void (^presentNewView)(void) = ^{
            if (viewName) {
                NSString *viewClassName = [viewNamePrefix stringByAppendingString:[viewName capitalizedString]];
                Class clazz = NSClassFromString(viewClassName);
                if (!clazz) {
                    bsException(NSInvalidArgumentException, @"Class name '%@' is not defined", viewClassName);
                }
                Method m = class_getInstanceMethod(clazz, @selector(show));
                if (m) {
                    method_invoke(clazz, m);
                }
            }
        };
        
        if (prevViewName) {
            NSString *prevViewClassName = [viewNamePrefix stringByAppendingString:[prevViewName capitalizedString]];
            Class prevViewClazz = NSClassFromString(prevViewClassName);
            if (prevViewClazz) {
                Method m = class_getInstanceMethod(prevViewClazz, @selector(hide:));
                if (m) {
                    method_invoke(prevViewClazz, m, ^{presentNewView();});
                }
            }
        } else {
            presentNewView();
        }
    };
    
    __block BOOL imgBackDirty = YES;
    [bsBinding bind:_model keyPathes:[bsStr col:@"layerA"] block:^(NSString *uniqueID, bsBindingChange *change) {
        if (imgBackDirty) {
            imgBackDirty = NO;
            [[bs root] removeSubviewWithName:@"imgBack"];
        }
        presentViewBlock(change.valueOld, change.valueNew);
    }];
    
    presentViewBlock(nil, _model.layerA);
}

@end
