#import "bsDisplay.h"
#import "bsWorker.h"
#import "bsImageQueue.h"
#import "bsDisplayUtil.h"

#define kbsImageSrc             100201
#define kbsImageCacheType       100202
#define kbsImageDefaultSrc      100203
#define kbsImageDefaultColor    100204
#define kbsImageFailSrc         100205
#define kbsImageFailColor       100206
#define kbsImageSpinStyle       100207
#define kbsImageSpinColor       100208
#define kbsImagePadding         100209
#define kbsImageFadeTime        100210
#define kbsImageAutoResize      100211
#define kbsImageCapInset        100212

FOUNDATION_EXPORT NSString * const kbsImageCacheTypeNone;
FOUNDATION_EXPORT NSString * const kbsImageCacheTypeOriginal;
FOUNDATION_EXPORT NSString * const kbsImageCacheTypeResize;

FOUNDATION_EXPORT NSString * const kbsImageSpinStyleNone;
FOUNDATION_EXPORT NSString * const kbsImageSpinStyleLargeWhite;
FOUNDATION_EXPORT NSString * const kbsImageSpinStyleWhite;
FOUNDATION_EXPORT NSString * const kbsImageSpinStyleGray;

@interface bsImage : bsDisplay {
    
    UIImageView* imageView_;
    BOOL autoResize_;   //텍스트 크기에 맞게 자동 리사이즈 여부
    BOOL srcChange_;
    NSString *src_;
    BOOL defaultChange_;
    NSString *defaultSrc_;
    UIColor *defaultColor_;
    BOOL failChange_;
    NSString *failSrc_;
    UIColor *failColor_;
    UIEdgeInsets padding_;
    BOOL spinStyleChange_;
    NSString *spinStyle_;
    BOOL spinColorChange_;
    UIColor *spinColor_;
    float fadeTime_;
    UIActivityIndicatorView *spinner_;
    int loadStatus_;    //-1:로드준비, -2:로드완료, -3:로드실패, 0>= 로딩중 
    NSString *cacheType_;   //이미지를 리사이즈/크롭 캐싱할 것인가?
    NSString *queKeyString_;
    UIEdgeInsets capInsets_;
}

@end
