//
//  bsIOSDemoAppDelegate.h
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2013/11/25.
//  Copyright (c) 2013 ProjectBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bs.h"

@interface bsIOSDemoAppDelegate : bs

@end
@implementation bsIOSDemoAppDelegate
- (void)ready {
    NSLog(@"App Display Name=%@", self.APP_DISPLAY_NAME);
    NSLog(@"Version=%@", self.VERSION);
    NSLog(@"Version=%@", self.BUILD);
    NSLog(@"ID=%@", self.ID);
    NSLog(@"width=%f", self.width);
    NSLog(@"height=%f", self.height);
    NSLog(@"%@", self.launchOptions);
    NSLog(@"backgroundTaskSupported=%d", self.backgroundTaskSupported);
    [self.app setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
