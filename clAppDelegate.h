//
//  clAppDelegate.h
//  iorder
//
//  Created by Jidolstar on 13. 2. 18..
//  Copyright (c) 2013년 TwoPeople. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bs.h"
#import "psViewController.h"
#import "psModel.h"
#import "TestFlight.h"

@interface clAppDelegate : bs {
    psViewController *viewController_;
}
@end
@implementation clAppDelegate
-(void)ready {
    NSLog(@"App Display Name=%@", self.APP_DISPLAY_NAME);
    NSLog(@"Version=%@", self.VERSION);
    NSLog(@"Version=%@", self.BUILD);
    NSLog(@"ID=%@", self.ID);
    NSLog(@"width=%f", self.width);
    NSLog(@"height=%f", self.height);
    NSLog(@"%@", self.launchOptions);
    NSLog(@"backgroundTaskSupported=%d", self.backgroundTaskSupported);
    [self.app setStatusBarStyle:UIStatusBarStyleLightContent];
    viewController_ = [psViewController viewController];
    
    //https://testflightapp.com
    [TestFlight takeOff:@"e12f9fce-f04d-4dcd-aa7f-be0ac0c5f80f"];
}

@end
