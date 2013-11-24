#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - bsDisplayUtil
@interface bsDisplayUtil : NSObject
@end
@implementation bsDisplayUtil
static UIImage* __bsImage_1x1_white;
static UIImage* __bsImage_1x1_clear;
+(NSString*)paramsTemplate:(NSString*)paramsTemplate replace:(id)replace {
    NSArray *t;
    if( replace == nil ) {
        replace = @"";
    }
    if( [replace isKindOfClass:[NSString class]] ) {
        t = @[[(NSString*)replace stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]];
    } else if( [replace isKindOfClass:[NSArray class]] ) {
        NSMutableArray *r = [[NSMutableArray alloc] init];
        [replace enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if( [obj isKindOfClass:[NSString class]] ) {
                [r addObject:[(NSString*)obj stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]];
            } else {
                [r addObject:[bsStr str:obj]];
            }
        }];
        t = r;
    } else {
        t = @[[bsStr str:replace]];
        //bsException(@"replace parameter should be string or array");
    }
    return [bsStr templateSrc:paramsTemplate replace:t];
}
+(void)borderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius {
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = 0;
    //layer.shouldRasterize = YES;
}
+(void)borderWithView:(UIView*)view cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor {
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = borderWidth;
    layer.borderColor = borderColor;
    //layer.shouldRasterize = YES;
}
+(void)shadowWithView:(UIView*)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color {
    CALayer *layer = view.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = radius;
    layer.shadowColor = color;
    layer.shadowOpacity = opacity;
    layer.shadowOffset = CGSizeMake(2, 2);
    //layer.shouldRasterize = YES;
}
+(void)shadowWithView:(UIView*)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color offset:(CGSize)offset path:(CGPathRef)path {
    CALayer *layer = view.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = radius;
    layer.shadowColor = color;
    layer.shadowOpacity = opacity;
    layer.shadowOffset = offset;
    //layer.shouldRasterize = YES;
    if( path != nil ) {
        layer.shadowPath = path;
    }
}
+(void)clearLayerWithView:(UIView*)view {
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    //layer.shouldRasterize = NO;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.borderWidth = 0.0;
    layer.cornerRadius = 0.0;
    layer.shadowOpacity = 0.0;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowPath = nil;
    layer.shadowOffset = CGSizeMake(0.0, -3.0);
    layer.shadowRadius = 3.0;
}
+(UIImage*)image1x1WithColor:(id)color {
    UIColor *c;
    if( [color isKindOfClass:[UIColor class]] ) c = (UIColor*)color;
    else if( [color isKindOfClass:[NSString class]] ) c = [bsStr color:color];
    else bsException( @"color argument should be String or UIColor" );
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage*)imageWithW:(CGFloat)w h:(CGFloat)h color:(id)color {
    UIColor *c;
    if( [color isKindOfClass:[UIColor class]] ) c = (UIColor*)color;
    else if( [color isKindOfClass:[NSString class]] ) c = [bsStr color:color];
    else bsException( @"color argument should be String or UIColor" );
    CGRect rect = CGRectMake(0.0f, 0.0f, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage*)image1x1WhiteColor {
    if( __bsImage_1x1_white == nil ) {
        @synchronized( __bsImage_1x1_white ) {
            if( __bsImage_1x1_white == nil ) {
                __bsImage_1x1_white = [bsDisplayUtil image1x1WithColor:[UIColor whiteColor]];
            }
        }
    }
    return __bsImage_1x1_white;
}
+(UIImage*)image1x1ClearColor {
    if( __bsImage_1x1_clear == nil ) {
        @synchronized( __bsImage_1x1_clear ) {
            if( __bsImage_1x1_clear == nil ) {
                __bsImage_1x1_clear = [bsDisplayUtil image1x1WithColor:[UIColor clearColor]];
            }
        }
    }
    return __bsImage_1x1_white;
}
+(UIImage*)imageWithView:(UIView*)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect {
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
	return UIGraphicsGetImageFromCurrentImageContext();
}
+(UIImage *)crop:(UIImage *)image frame:(CGRect)frame {
	CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
	UIImage *cropedImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropedImage;
}
@end
