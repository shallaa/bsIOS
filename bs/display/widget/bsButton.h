#import "bsDisplay.h"
#import "bsStr.h"
#import "bsDisplayUtil.h"

@class bsButton;

typedef void (^bsButtonTouchedBlock)( bsButton *button );

#define kbsButtonEnabled                100301
#define kbsButtonSelected               100302
#define kbsButtonHighlighted            100303
#define kbsButtonLbShadowOffset         100304
#define kbsButtonLbAlign                100305
#define kbsButtonLbFontName             100306
#define kbsButtonLbFontSize             100307
#define kbsButtonAutoResize             100308
#define kbsButtonLbLineBreak            100309
#define kbsButtonLbLines                100310

#define kbsButtonBtnImg                 100311
#define kbsButtonLbText                 100312
#define kbsButtonLbShadowColor          100313
#define kbsButtonLbColor                100314

#define kbsButtonBtnImgHighlight        100321
#define kbsButtonLbTextHighlight        100322
#define kbsButtonLbShadowColorHighlight 100323
#define kbsButtonLbColorHighlight       100324

#define kbsButtonBtnImgDisabled         100331
#define kbsButtonLbTextDisabled         100332
#define kbsButtonLbShadowColorDisabled  100333
#define kbsButtonLbColorDisabled        100334

#define kbsButtonBtnImgSelected         100341
#define kbsButtonLbTextSelected         100342
#define kbsButtonLbShadowColorSelected  100343
#define kbsButtonLbColorSelected        100344

#define kbsButtonCapInset               100350

@interface bsButton : bsDisplay {
    
    UIButton *button_;
    NSString *fontName_;
    BOOL autoResize_; //이미지에 맞게 리사이즈 할 것인가? 단,Normal상태 이미지 기준임
    NSString *img_; //Normal State image
    NSString *imgH_; //Highlight State image
    NSString *imgD_; //Disabled State image
    NSString *imgS_; //Selected State image
    //__weak bsButtonTouchedBlock block_;
    NSString *blockKey_;
    BOOL addedTouch_;
    UIEdgeInsets capInsets_;
}

- (id)__g:(NSString*)key;
- (NSArray *)__s:(NSArray *)params;
- (void)__touched:(id)sender;
- (void)blockTouched:(bsButtonTouchedBlock)block;

@end