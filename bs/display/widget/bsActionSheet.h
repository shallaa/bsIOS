
#import <UIKit/UIKit.h>

typedef void (^bsActionSheetClickBlock)(int buttonIndex);
typedef void (^bsActionSheetCancelBlock)();
typedef void (^bsActionSheetDismissBlock)();

@interface bsActionSheet : NSObject <UIActionSheetDelegate>

+ (void)showRect:(CGRect)rect
          inView:(UIView*)view
           title:(NSString*)title
     cancelTitle:(NSString *)cancelTitle
destructiveTitle:(NSString *)destructiveTitle
     otherTitles:(NSArray *)otherTitles
         onClick:(bsActionSheetClickBlock) clicked
        onCancel:(bsActionSheetCancelBlock) cancelled
       onDismiss:(bsActionSheetDismissBlock) dismissed;
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
+ (void)actionSheetCancel:(UIActionSheet *)actionSheet;

@end
