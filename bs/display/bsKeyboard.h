#import <UIKit/UIKit.h>

@interface bsKeyboard : NSObject

+(void)hideKeyboard;
+(void)__hideKeyboardRecursion:(UIView *)view;

@end
