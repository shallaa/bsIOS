#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface bsDisplayUtil : NSObject

+(NSString*)paramsTemplate:(NSString*)paramsTemplate replace:(id)replace;
+(void)borderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius;
+(void)borderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor;
+(void)shadowWithView:(UIView*)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color;
+(void)shadowWithView:(UIView*)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color offset:(CGSize)offset path:(CGPathRef)path;
+(void)clearLayerWithView:(UIView*)view;
+(UIImage*)image1x1WithColor:(id)color;
+(UIImage*)imageWithW:(CGFloat)w h:(CGFloat)h color:(id)color;
+(UIImage*)image1x1WhiteColor;
+(UIImage*)image1x1ClearColor;
+(UIImage*)imageWithView:(UIView*)view;
+(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;
+(UIImage *)crop:(UIImage *)image frame:(CGRect)frame;

@end
