//
//  UIApplication+WindowOverlay.m
//  i-order-pos
//
//  Created by Jidolstar on 12. 9. 12..
//  Copyright (c) 2012년 TwoPeople. All rights reserved.
//

#import "UIApplication+WindowOverlay.h"

@implementation UIApplication(WindowOverlay)
-(UIView *)baseWindowView
{
    UIWindow* window = self.keyWindow;
    if (!window) {
        window = [self.windows objectAtIndex:0];
    }
    if (window.subviews.count > 0){
        return [window.subviews objectAtIndex:0];
    }
    return nil;
}
-(void)addWindowOverlay:(UIView *)view
{
    [self.baseWindowView addSubview:view];
}
@end
