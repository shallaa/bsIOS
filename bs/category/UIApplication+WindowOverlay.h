//
//  UIApplication+WindowOverlay.h
//  i-order-pos
//
//  Created by Jidolstar on 12. 9. 12..
//  Copyright (c) 2012년 TwoPeople. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication(WindowOverlay)

@property (nonatomic, readonly) UIView *baseWindowView;

-(void)addWindowOverlay:(UIView *)view;

@end
