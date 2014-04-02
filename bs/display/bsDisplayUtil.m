//
//  bsDisplayUtil.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014年 ProjectBS. All rights reserved.
//

#import "bsDisplayUtil.h"

#import "bsLog.h"
#import "bsMacro.h"
#import "bsStr.h"

static UIImage *__bsImage_1x1_white = nil;
static UIImage *__bsImage_1x1_clear = nil;

@implementation bsDisplayUtil

+ (NSString *)paramsTemplate:(NSString*)paramsTemplate replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSArray *t;
    if (replace == nil) {
        replace = @"";
    }
    if ([replace isKindOfClass:[NSString class]]) {
        t = @[[(NSString*)replace stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]];
    } else if ([replace isKindOfClass:[NSArray class]]) {
        NSMutableArray *r = [[NSMutableArray alloc] init];
        [replace enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [r addObject:[(NSString*)obj stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]];
            } else {
                [r addObject:[bsStr str:obj]];
            }
        }];
        t = r;
    } else {
        t = @[[bsStr str:replace]];
        //bsException(NSInvalidArgumentException, @"replace parameter should be string or array");
    }
    return [bsStr templateSrc:paramsTemplate replace:t];
}

+ (void)borderWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = 0;
    //layer.shouldRasterize = YES;
}

+ (void)borderWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = cornerRadius;
    layer.borderWidth = borderWidth;
    layer.borderColor = borderColor;
    //layer.shouldRasterize = YES;
}

+ (void)shadowWithView:(UIView *)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    CALayer *layer = view.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = radius;
    layer.shadowColor = color;
    layer.shadowOpacity = opacity;
    layer.shadowOffset = CGSizeMake(2, 2);
    //layer.shouldRasterize = YES;
}

+ (void)shadowWithView:(UIView *)view cornerRadius:(CGFloat)radius opacity:(CGFloat)opacity color:(CGColorRef)color offset:(CGSize)offset path:(CGPathRef)path {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    CALayer *layer = view.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = radius;
    layer.shadowColor = color;
    layer.shadowOpacity = opacity;
    layer.shadowOffset = offset;
    //layer.shouldRasterize = YES;
    if (path) {
        layer.shadowPath = path;
    }
}

+ (void)clearLayerWithView:(UIView *)view {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
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

+ (UIImage *)image1x1WithColor:(id)color {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    UIColor *c;
    if ([color isKindOfClass:[UIColor class]]) {
        c = (UIColor *)color;
    } else if ([color isKindOfClass:[NSString class]]) {
        c = [bsStr color:color];
    } else {
        bsException(NSInvalidArgumentException, @"color argument should be String or UIColor");
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithW:(CGFloat)w h:(CGFloat)h color:(id)color {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    UIColor *c;
    if ([color isKindOfClass:[UIColor class]]) {
        c = (UIColor *)color;
    } else if ([color isKindOfClass:[NSString class]]) {
        c = [bsStr color:color];
    } else {
        bsException(NSInvalidArgumentException, @"color argument should be String or UIColor");
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [c CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)image1x1WhiteColor {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __bsImage_1x1_white = [bsDisplayUtil image1x1WithColor:[UIColor whiteColor]];
    });
    return __bsImage_1x1_white;
}

+ (UIImage *)image1x1ClearColor {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __bsImage_1x1_clear = [bsDisplayUtil image1x1WithColor:[UIColor clearColor]];
    });
    return __bsImage_1x1_clear;
}

+ (UIImage *)imageWithView:(UIView *)view {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)resizedImage:(UIImage *)inImage inRect:(CGRect)thumbRect {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
	return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)crop:(UIImage *)image frame:(CGRect)frame {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
	CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
	UIImage *cropedImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return cropedImage;
}

@end
