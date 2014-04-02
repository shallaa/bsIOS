//
//  bsActionSheet.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsActionSheet.h"

#import "bsLog.h"

@implementation bsActionSheet

+ (void)showRect:(CGRect)rect
          inView:(UIView*)view
           title:(NSString*)title
     cancelTitle:(NSString *)cancelTitle
destructiveTitle:(NSString *)destructiveTitle
     otherTitles:(NSArray *)otherTitles
         onClick:(bsActionSheetClickBlock) clicked
        onCancel:(bsActionSheetCancelBlock) cancelled
       onDismiss:(bsActionSheetDismissBlock) dismissed {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:(id<UIActionSheetDelegate>)self
                                              cancelButtonTitle:cancelTitle
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for( NSString* title in otherTitles ) [sheet addButtonWithTitle:title];
    [sheet showFromRect:rect inView:view animated:YES];
}

+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
}

+ (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
}

@end
