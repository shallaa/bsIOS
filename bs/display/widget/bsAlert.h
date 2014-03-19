#import "bsDisplay.h"

typedef void (^bsAlertBlock)(int buttonIndex, BOOL canceled);

@interface bsAlert : NSObject <UIAlertViewDelegate>

+ (void)__alert:(NSString *)params block:(bsAlertBlock)block reserved:(BOOL)reserved;
+ (void)alert:(NSString *)params block:(bsAlertBlock)block;
+ (void)alert:(NSString *)params replace:(id)replace block:(bsAlertBlock)block;
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
