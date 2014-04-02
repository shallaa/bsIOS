//
//  bsKeyboard.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsKeyboard.h"

#import "bsLog.h"
#import "bsMacro.h"

@implementation bsKeyboard

+ (id)alloc {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsKeyboard' cannot be instantiated!");
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsKeyboard' cannot be instantiated!");
    return nil;
}

//키보드 감추기
+ (void)hideKeyboard {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    UIWindow *tempWindow;
    NSInteger count = [[[UIApplication sharedApplication] windows] count];
    for (NSInteger c = 0; c < count; c++) {
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
        for (int i = 0; i < [tempWindow.subviews count]; i++) {
            [self __hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
        }
    }
    /*
     if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
     //ipad에서 keyboard dismiss(이 방법은 reject될 수 있다.) - UIModalPresentationFormSheet
     @try {
     Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
     id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
     [activeInstance performSelector:@selector(dismissKeyboard)];
     }
     @catch (NSException *exception) {
     NSLog(@"%@",exception);
     }
     } else {
     UIWindow *tempWindow;
     for (int c = 0, count = [[[UIApplication sharedApplication] windows] count]; c < count; c++) {
     tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
     for (int i = 0; i < [tempWindow.subviews count]; i++) {
     [self __hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
     }
     }
     }
     */
}

//키보드를 사라지게 하기 위해 사용하는 재귀함수
+ (void)__hideKeyboardRecursion:(UIView *)view {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
	if ([view conformsToProtocol:@protocol(UITextInputTraits)]) {
		[view resignFirstResponder];
	}
	if ([view.subviews count] > 0) {
		for (int i = 0; i < [view.subviews count]; i++) {
			[self __hideKeyboardRecursion:[view.subviews objectAtIndex:i]];
		}
	}
}

@end
