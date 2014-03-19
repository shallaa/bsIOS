#import "bsDisplay.h"

@class bsSwitch;

typedef void (^bsSwitchOnBlock)(bsSwitch *sw, BOOL on);

#define kbsSwitchOn 100901
#define kbsSwitchAnimation 100902
#define kbsSwitchTintOffColor 100903
#define kbsSwitchTintOnColor 100904
#define kbsSwitchTintThumbColor 100905
#define kbsSwitchImgOn 100910 //77x27 이미지이어야 함
#define kbsSwitchImgOff 100911 //77x27 이미지이어야 함 

@interface bsSwitch : bsDisplay {
    
    UISwitch *switch_;
    BOOL animation_;
    NSString *blockKey_;
    BOOL addedOn_;
}

- (void)blockOn:(bsSwitchOnBlock)block;

@end
