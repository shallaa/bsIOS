#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "bsDisplayUtil.h"
#import "bsStr.h"
#import "bsPrimitive.h"
#import "bsGeometry.h"
#import "bsParam.h"
#import "bsMacro.h"
#import "bsLog.h"

//#define kbsDisplayConstraintDefault @"@@1, V:|-0-[@@0]-0-|, @@2, H:|-0-[@@0]-0-|"
//#define kbsDisplayConstraintPadding @"@@1, V:|-@@2-[@@0]-@@3-|, @@4, H:|-@@5-[@@0]-@@6-|"

#define kbsDisplayKey             100
#define kbsDisplayX               10001
#define kbsDisplayY               10002
//#define kbsDisplayCX              10003
//#define kbsDisplayCY              10004
#define kbsDisplayW               10006
#define kbsDisplayH               10007
#define kbsDisplayBG              10010
#define kbsDisplayOpacity          10011
#define kbsDisplayHidden          10012
#define kbsDisplayBorderColor     10020
#define kbsDisplayBorderWidth     10021
#define kbsDisplayBorderRadius    10022
#define kbsDisplayShadowColor     10030
#define kbsDisplayShadowOpacity   10031
#define kbsDisplayShadowRadius    10032
#define kbsDisplayShadowOffset    10033
#define kbsDisplayTag             10035
#define kbsDisplayInteraction       10036

@interface bsDisplay : UIView {
    
    NSString *key_;
    //NSMutableDictionary *layoutConstraints_;
    UIColor *borderColor_;
    CGFloat borderWidth_;
    CGFloat borderRadius_;
    UIColor *shadowColor_;
    CGFloat shadowOpacity_;
    CGFloat shadowRadius_;
    CGSize shadowOffset_;
    NSDictionary *keyValues_;
}

@property (nonatomic, readonly) NSString *key;

+ (bsDisplay *)G:(NSString *)name params:(NSString *)params;
+ (bsDisplay *)G:(NSString *)name params:(NSString *)params replace:(id)replace;
// Create object from template
+ (bsDisplay *)GT:(NSString *)key params:(NSString*)params;
+ (bsDisplay*)GT:(NSString*)key params:(NSString*)params replace:(id)replace;
// Create object from style
+ (bsDisplay *)G:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params;
+ (bsDisplay *)G:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace;
// Add template
+ (void)AT:(NSString *)key name:(NSString *)name params:(NSString *)params;
// Add style
+ (void)AS:(NSString*)styleName params:(NSString *)params;
- (void)ready;
- (id)g:(NSString *)key;
- (NSDictionary *)gDic:(NSString*)keys;
- (id)__g:(NSString *)key;
- (void)s:(NSString *)params;
- (void)s:(NSString *)params replace:(id)replace;
- (NSArray *)__s:(NSArray *)params;

//- (void)autolayout:(NSString *)formats views:(NSDictionary *)views;
//- (void)autolayout:(NSString *)formats views:(NSDictionary *)views options:(NSLayoutFormatOptions)opts;

#pragma mark - child
- (NSString *)create:(NSString *)name params:(NSString *)params;
- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace;
- (NSString *)createT:(NSString *)key params:(NSString *)params;
- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace;
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params;
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace;
- (bsDisplay *)childG:(NSString *)key;
- (void)childA:(bsDisplay *)child;
- (void)childD:(NSString *)key;
- (void)childS:(NSString *)key params:(NSString *)params;
- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace;

@end
