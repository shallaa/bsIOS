
#import <UIKit/UIKit.h>

//Blocks
typedef void (^bsActionSheetClickBlock)(int buttonIndex);
typedef void (^bsActionSheetCancelBlock)();
typedef void (^bsActionSheetDismissBlock)();


//안써서 만들다가 중단..
@interface bsActionSheet : NSObject <UIActionSheetDelegate> {
}
@end
@implementation bsActionSheet

+(void)showRect:(CGRect)rect
         inView:(UIView*)view
          title:(NSString*)title
         cancelTitle:(NSString *)cancelTitle
    destructiveTitle:(NSString *)destructiveTitle
         otherTitles:(NSArray *)otherTitles
        onClick:(bsActionSheetClickBlock) clicked
       onCancel:(bsActionSheetCancelBlock) cancelled
      onDismiss:(bsActionSheetDismissBlock) dismissed {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:(id<UIActionSheetDelegate>)self
                                              cancelButtonTitle:cancelTitle
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    for( NSString* title in otherTitles ) [sheet addButtonWithTitle:title];
    [sheet showFromRect:rect inView:view animated:YES];
}
+(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
+(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
}
@end
