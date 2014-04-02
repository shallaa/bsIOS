//
//  bsImageQueue.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/18.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsImageQueue.h"

#import "bsDisplayUtil.h"
#import "bsError.h"
#import "bsGeometry.h"
#import "bsIO.h"
#import "bsLog.h"
#import "bsMacro.h"
#import "bsStr.h"

@implementation bsImageQueue

+ (bsImageQueue *)GWithKey:(NSString *)key src:(NSString *)src cacheSize:(bsSize *)cacheSize end:(bsCallbackBlock)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsImageQueue *queue = (bsImageQueue *)[bsQueue GWithClassName:@"bsImageQueue" key:key end:[bsCallback GWithBlock:end]];
    [queue __setWithSrc:src cacheSize:cacheSize];
    return queue;
}

- (void)__setWithSrc:(NSString *)src cacheSize:(bsSize *)cacheSize {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (src == nil) {
        bsException(NSInvalidArgumentException, @"src argument should be not null");
    }
    src_ = src;
    cacheSize_ = cacheSize;
    if (cacheSize_) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            CGFloat w = cacheSize_.w;
            CGFloat h = cacheSize_.h;
            //[bsSize put:cacheSize_];
            cacheSize_ = [bsSize G:CGSizeMake( w * scale, h * scale)];
        }
    }
}

- (void)clear {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    src_ = nil;
    cacheSize_ = nil;
    [super clear];
}

- (id)run:(bsError **)error {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    id result = nil;
    *error = nil;
    
    NSString *cacheName = nil;
    NSString *originName = nil;
    UIImage *image = nil;
    BOOL resize;
    
    // Return cached data if it exists
    if (cacheSize_) {
        cacheName = [NSString stringWithFormat:@"images/%@", [bsStr urlEncode:src_]];
        originName = cacheName;
        if (cacheSize_.w < 0 || cacheSize_.h < 0) {
            resize = NO;
        } else {
            cacheName = [NSString stringWithFormat:@"images/%@_%fx%f", [bsStr urlEncode:src_], cacheSize_.w, cacheSize_.h];
            resize = YES;
        }
        NSData *cachedImageData = [bsIO cacheG:cacheName];
        if (cachedImageData) {
            image = [UIImage imageWithData:cachedImageData];
            if (image == nil) {
                *error = [bsError popWithMsg:@"Faied to load cached image data." data:src_ func:__FUNCTION__ line:__LINE__];
            }
            return image;
        }
        // If resizing is required, resize the original image and return it, which is cached.
        if (resize) {
            NSData *originalImageData = [bsIO cacheG:originName];
            if (originalImageData) {
                image = [UIImage imageWithData:originalImageData];
                if (image) {
                    image = [self p_resizedImageWithImage:image size:cacheSize_];
                    if (![self p_saveImage:image name:cacheName]) {
                        bsLog(nil, bsLogLevelError, @"Failed to cache resized image. src=%@ width=%f height=%f", src_, image.size.width, image.size.height);
                    }
                } else {
                    *error = [bsError popWithMsg:@"Faied to load cached image data." data:src_ func:__FUNCTION__ line:__LINE__];
                }
                return image;
            }
        }
    }
    
    id imageObj = [self p_loadImageFromDataSource:src_];
    if (imageObj == nil) {
        *error = [bsError popWithMsg:@"Failed to load image." data:src_ func:__FUNCTION__ line:__LINE__];
        return nil;
    } else if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    } else if ([imageObj isKindOfClass:[NSData class]]) {
        NSData *d = (NSData *)imageObj;
        image = [UIImage imageWithData:imageObj];
        if (image == nil) {
            *error = [bsError popWithMsg:@"Failed to convert format from data to image." data:src_ func:__FUNCTION__ line:__LINE__];
            return nil;
        }
        
        // Return image (and cache it)
        if (cacheSize_) {
            
            // Cache original image
            if (![bsIO cacheS:originName data:d]) {
                bsLog(nil, bsLogLevelError, @"Failed to cache original image. src=%@", src_);
            }
            
            // Save resized image
            if (resize) {
                image = [self p_resizedImageWithImage:image size:cacheSize_];
                if (![self p_saveImage:image name:cacheName]) {
                    bsLog(nil, bsLogLevelError, @"Failed to cache resized image. src=%@ width=%f height=%f", src_, image.size.width, image.size.height);
                }
            }
        }
        result = image;
    }
    return nil;
}

#pragma mark - Private methods

/** 
 Reads image data from source depending on the protocol.
 
 @param src
    Data source.
 @returns Image data.
 */
- (id)p_loadImageFromDataSource:(NSString *)src {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if ([src hasPrefix:@"http://"] || [src hasPrefix:@"https://"]) {
        return [NSData dataWithContentsOfURL:[NSURL URLWithString:src_]];
    } else if ([src hasPrefix:@"assets://"] || [src hasPrefix:@"asset://"] || [src hasPrefix:@"a://"]) {
        return [bsIO assetG:[bsStr replace:src_ search:@[@"assets://", @"asset://", @"a://"] dest:@""]];
    } else if ([src hasPrefix:@"storage://"] || [src hasPrefix:@"s://"]) {
        return [bsIO storageG:[bsStr replace:src_ search:@[@"storage://", @"s://"] dest:@""]];
    } else {
        // Just return bundled image.
        return [UIImage imageNamed:src_];
    }
}

/**
 Resizes given image.
 
 @param image
    Original image.
 @param size
    size.
 @returns Resized image.
 @exception Throws NSInvalidArgumentException if specified image is nil.
 */
- (UIImage *)p_resizedImageWithImage:(UIImage *)image size:(bsSize *)size {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (!image) {
        bsException(NSInvalidArgumentException, @"image should not be nil.");
    }
    if (size) {
        // return original image if size is not specified
        return image;
    }
    
    UIImage *resizedImage = nil;
    CGFloat w = size.w;
    CGFloat h = size.h;
    if (image.size.width > image.size.height) {
        resizedImage = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, image.size.width / image.size.height * h, h)];
    } else {
        resizedImage = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, w, image.size.height / image.size.width * w)];
    }
    return [bsDisplayUtil crop:resizedImage frame:CGRectMake(0, 0, w, h)];
}

/**
 <#description#>
 @param image
    a
 @param name
    b
 @returns YES if given image is saved successfully, otherwise NO.
 */
- (BOOL)p_saveImage:(UIImage *)image name:(NSString *)name {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        bsLog(nil, bsLogLevelError, @"Failed to convert format from image to data.");
        return NO;
    }
    return [bsIO cacheS:name data:data];
}

@end
