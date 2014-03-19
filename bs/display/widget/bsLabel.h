#import "bsDisplay.h"

#define kbsLabelText                100101
#define kbsLabelTextColor           100102
#define kbsLabelAutoResize          100103
#define kbsLabelTextShadowColor     100104
#define kbsLabelTextShadowOffset    100105
#define kbsLabelFontName            100106
#define kbsLabelFontSize            100107
#define kbsLabelPadding             100108
#define kbsLabelLineBreak           100109
#define kbsLabelLines               100110
#define kbsLabelMaxSize             100111
#define kbsLabelMinSize             100112
#define kbsLabelHighlightColor      100113
#define kbsLabelHighlightEnable     100114
#define kbsLabelAlign               100115

@interface bsLabel : bsDisplay {
    
    UILabel *label_;
    BOOL autoResize_;   //텍스트 크기에 맞게 자동 리사이즈 여부
    UIEdgeInsets padding_;
    CGSize maxSize_;
    CGSize minSize_;
    NSString *fontName_;
    BOOL maxSizeSetting_;
    BOOL minSizeSetting_;
}

@property (nonatomic, readonly) UILabel *label;

@end
