//
//  BSDemoAppDelegate.m
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2014/03/22.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "BSDemoAppDelegate.h"

#import "BSDemoViewController.h"
#import "BSDemoModel.h"

@interface BSDemoAppDelegate ()

@property (nonatomic, strong) BSDemoViewController *viewController;

@end

@implementation BSDemoAppDelegate

- (void)ready {
    
    NSLog(@"App Display Name=%@", self.APP_DISPLAY_NAME);
    NSLog(@"Version=%@", self.VERSION);
    NSLog(@"Version=%@", self.BUILD);
    NSLog(@"ID=%@", self.ID);
    NSLog(@"width=%f", self.width);
    NSLog(@"height=%f", self.height);
    NSLog(@"launchOptions=%@", self.launchOptions);
    NSLog(@"backgroundTaskSupported=%d", self.backgroundTaskSupported);
    [self.app setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.viewController = [BSDemoViewController sharedViewController];
}

@end
