//
//  bsImage.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsImage.h"

NSString * const kbsImageCacheTypeNone = @"none";
NSString * const kbsImageCacheTypeOriginal = @"original";
NSString * const kbsImageCacheTypeResize = @"resize";

NSString * const kbsImageSpinStyleNone = @"none";
NSString * const kbsImageSpinStyleLargeWhite = @"large-white";
NSString * const kbsImageSpinStyleWhite = @"white";
NSString * const kbsImageSpinStyleGray = @"gray";

static NSDictionary* __bsImage_keyValues = nil;

@implementation bsImage

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (imageView_ == nil) {
        imageView_ = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:imageView_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"imageView_", @"imageViewVertical", @"imageViewHorizontal"]] views:NSDictionaryOfVariableBindings(imageView_)];
    }
    self.frame = CGRectMake( 0, 0, 100, 100);
    if (__bsImage_keyValues == nil) {
        __bsImage_keyValues =
        @{ @"src": @kbsImageSrc, @"cache-type": @kbsImageCacheType,
           @"default-src": @kbsImageDefaultSrc, @"default-color": @kbsImageDefaultColor,
           @"fail-src": @kbsImageFailSrc, @"fail-color": @kbsImageFailColor,
           @"spin-style": @kbsImageSpinStyle, @"spin-color": @kbsImageSpinColor, @"padding": @kbsImagePadding,
           @"fade": @kbsImageFadeTime, @"fade-time": @kbsImageFadeTime,
           @"auto-resize": @kbsImageAutoResize, @"cap-insets": @kbsImageCapInset
           };
    }
    if ( queKeyString_) {
        [bsWorker D:queKeyString_];
        queKeyString_ = nil;
    }
    self.backgroundColor = [UIColor clearColor];
    padding_ = UIEdgeInsetsMake(0, 0, 0, 0);
    capInsets_ = UIEdgeInsetsMake(0, 0, 0, 0);
    autoResize_ = NO;
    cacheType_ = kbsImageCacheTypeResize;
    defaultSrc_ = @"";
    defaultColor_ = [UIColor whiteColor];
    failSrc_ = @"";
    failColor_ = [UIColor whiteColor];
    spinStyle_ = kbsImageSpinStyleNone;
    spinColor_ = [UIColor whiteColor];
    src_ = @"";
    srcChange_ = NO;
    defaultChange_ = YES;
    failChange_ = NO;
    spinStyleChange_ = YES;
    fadeTime_ = 0;
    loadStatus_ = -1;
    [imageView_ setImage:[bsDisplayUtil image1x1WhiteColor]];
    if (spinner_) {
        spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [spinner_ stopAnimating];
        [spinner_ setHidden:YES];
    }
    self.userInteractionEnabled = NO;
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
}

- (void)layoutSubviews {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [super layoutSubviews];
    CGFloat w,h,t,l,b,r;
    w = self.bounds.size.width;
    h = self.bounds.size.height;
    t = padding_.top;
    l = padding_.left;
    b = padding_.bottom;
    r = padding_.right;
    imageView_.frame = CGRectMake(l, t, w-r-l, h-b-t);
    if (spinner_ && spinner_.superview) {
        spinner_.center = CGPointMake( (w-r-l) * 0.5 + l, (h-b-t) * 0.5 + t );
    }
}

- (id)__g:(NSString*)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger num = [[__bsImage_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsImageSrc: value = src_; break;
        case kbsImageCacheType: value = cacheType_; break;
        case kbsImageDefaultSrc: value = defaultSrc_; break;
        case kbsImageDefaultColor: value = defaultColor_; break;
        case kbsImageFailSrc: value = failSrc_; break;
        case kbsImageFailColor: value = failColor_; break;
        case kbsImageSpinStyle: value = spinStyle_; break;
        case kbsImageSpinColor: value = spinColor_; break;
        case kbsImagePadding: value = [bsEdgeInsets G:padding_]; break;
        case kbsImageCapInset: value = [bsEdgeInsets G:capInsets_]; break;
        case kbsImageFadeTime: value = @(fadeTime_); break;
        case kbsImageAutoResize: value = @(autoResize_); break;
    }
    return value;
}

- (NSArray *)__s:(NSArray*)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    static int queKey = 0;
    NSMutableArray *remain = [NSMutableArray array];
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsImage_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsImageSrc:
                src_ = v;
                srcChange_ = YES;
                if (loadStatus_ > 0) { //이전 로딩중인거 있으면 취소시킨다.
                    [bsWorker D:[NSString stringWithFormat:@"bsImageQueKey=%d",loadStatus_]];
                    loadStatus_ = -1; //준비
                }
                break;
            case kbsImageCacheType: {
                if ([v isEqualToString:kbsImageCacheTypeNone]) cacheType_ = kbsImageCacheTypeNone;
                else if ([v isEqualToString:kbsImageCacheTypeResize]) cacheType_ = kbsImageCacheTypeResize;
                else if ([v isEqualToString:kbsImageCacheTypeOriginal]) cacheType_ = kbsImageCacheTypeOriginal;
            } break;
            case kbsImageDefaultSrc: defaultSrc_ = v; defaultChange_ = YES; break;
            case kbsImageDefaultColor: defaultColor_ = [bsStr color:v]; defaultChange_ = YES; break;
            case kbsImageFailSrc: failSrc_ = v; failChange_ = YES; break;
            case kbsImageFailColor: failColor_ = [bsStr color:v]; failChange_ = YES; break;
            case kbsImageSpinStyle: {
                if ([v isEqualToString:kbsImageSpinStyleNone]) spinStyle_ = kbsImageSpinStyleNone;
                else if ([v isEqualToString:kbsImageSpinStyleWhite]) spinStyle_ = kbsImageSpinStyleWhite;
                else if ([v isEqualToString:kbsImageSpinStyleGray]) spinStyle_ = kbsImageSpinStyleGray;
                else if ([v isEqualToString:kbsImageSpinStyleLargeWhite]) spinStyle_ = kbsImageSpinStyleLargeWhite;
                spinStyleChange_ = YES;
            }; break;
            case kbsImageSpinColor: spinColor_ = [bsStr color:v]; spinColorChange_ = YES; break;
            case kbsImagePadding: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 4) {
                    bsException(NSInvalidArgumentException, @"padding value %@ is invalid. It should be a value of the form top|right|bottom|left", v);
                }
                //NSString *layout = [bsStr templateSrc:kbsDisplayConstraintPadding replace:@[@"imageView_", @"imageViewVertical", c[0],c[1],@"imageViewHorizontal",c[2],c[3]]];
                //[self autolayout:layout views:NSDictionaryOfVariableBindings(imageView_)];
                padding_.top = [c[0] floatValue];
                padding_.right = [c[1] floatValue];
                padding_.bottom = [c[2] floatValue];
                padding_.left = [c[3] floatValue];
                [self setNeedsLayout];
            } break;
            case kbsImageCapInset: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 4) {
                    bsException(NSInvalidArgumentException, @"cap-insets value %@ is invalid. It should be a value of the form top|right|bottom|left", v);
                }
                capInsets_.top = [c[0] floatValue];
                capInsets_.right = [c[1] floatValue];
                capInsets_.bottom = [c[2] floatValue];
                capInsets_.left = [c[3] floatValue];
            } break;
            case kbsImageFadeTime: fadeTime_ = [bsStr FLOAT:v]; break;
            case kbsImageAutoResize: autoResize_ = [bsStr BOOLEAN:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    CGFloat imageW = [[self g:@"w"] floatValue] - padding_.left - padding_.right;
    CGFloat imageH = [[self g:@"h"] floatValue] - padding_.left - padding_.right;
    if (srcChange_) {
        srcChange_ = NO;
        bsSize *cacheSize = nil;
        if ([cacheType_ isEqualToString:kbsImageCacheTypeOriginal]) {
            cacheSize = [bsSize G:CGSizeMake( -1, -1 )];
        } else if ([cacheType_ isEqualToString:kbsImageCacheTypeResize]) {
            cacheSize = [bsSize G:CGSizeMake( imageW, imageH )];
        }
        if (queKeyString_) {
            [bsWorker D:queKeyString_];
            queKeyString_ = nil;
        }
        bsCallbackBlock block = ^(NSString *key, UIImage* image, bsError *error) {
            queKeyString_ = nil;
            if (key && [self superview] == nil) {
                return;
            }
            //if( cacheSize ) {
            //    [bsSize put:cacheSize];
            //}
            if (error) {
                loadStatus_ = -3; //실패
                failChange_ = YES;
                [self __showFailImage];
                return;
            }
            if (image == nil) {
                loadStatus_ = -1; //취소된 경우로 준비상태로 전환
                defaultChange_ = YES;
                [self __showDefaultImage];
                return;
            }
            loadStatus_ = -2; //완료
            if (autoResize_) {
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height)];
            }
            if (UIEdgeInsetsEqualToEdgeInsets(capInsets_, UIEdgeInsetsZero)) {
                [imageView_ setImage:image];
            } else {
                [imageView_ setImage:[image resizableImageWithCapInsets:capInsets_]];
            }
            [self __showSpinner];
            if (fadeTime_ > 0) {
                imageView_.alpha = 0;
                [UIView animateWithDuration:fadeTime_
                                      delay:0
                                    options:UIViewAnimationOptionLayoutSubviews
                                 animations:^{
                                     imageView_.alpha = 1.0;
                                 } completion:^(BOOL finished){
                                 }];
            } else {
                imageView_.alpha = 1;
            }
        };
        if ([src_ hasPrefix:@"http://"] || [src_ hasPrefix:@"https://"] || [src_ hasPrefix:@"assets://"] || [src_ hasPrefix:@"asset://"] || [src_ hasPrefix:@"a://"] || [src_ hasPrefix:@"storage://"] || [src_ hasPrefix:@"s://"]) {
            queKeyString_ = [NSString stringWithFormat:@"bsImageQueKey=%d",queKey++];
            [bsWorker A:[bsImageQueue GWithKey:queKeyString_ src:src_ cacheSize:cacheSize end:block]];
        } else {
            block(nil, [UIImage imageNamed:src_], nil);
        }
        
        loadStatus_ = queKey;
    }
    [self __showDefaultImage];
    [self __showFailImage];
    [self __showSpinner];
    return remain;
}

- (void)__showDefaultImage {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (!defaultChange_) return;
    defaultChange_ = NO;
    if (loadStatus_ != -1) return;
    if (defaultSrc_) {
        [imageView_ setImage:[UIImage imageNamed:defaultSrc_]];
    } else if (defaultColor_) {
        [imageView_ setImage:[bsDisplayUtil image1x1WithColor:defaultColor_]];
    }
}

- (void)__showFailImage {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (!failChange_) return;
    failChange_ = NO;
    if (loadStatus_ != -3) return;
    if (failSrc_) {
        [imageView_ setImage:[UIImage imageNamed:failSrc_]];
    } else if (failColor_) {
        [imageView_ setImage:[bsDisplayUtil image1x1WithColor:failColor_]];
    }
}

- (void)__showSpinner {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (!spinStyleChange_ && !spinColorChange_) return;
    if ([spinStyle_ isEqualToString:kbsImageSpinStyleNone] || loadStatus_ < 0) {
        if (spinner_) {
            [spinner_ stopAnimating];
            [spinner_ setHidden:YES];
        }
        return;
    }
    if (spinner_ == nil) {
        spinner_ = [[UIActivityIndicatorView alloc]init];
        [self addSubview:spinner_];
        [self setNeedsLayout];
        //NSString *layout = [bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"spinner_", @"spinnerVertical", @"spinnerHorizontal"]];
        //[self autolayout:layout views:NSDictionaryOfVariableBindings(spinner_)];
    }
    if ([spinStyle_ isEqualToString:kbsImageSpinStyleWhite]) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    else if ([spinStyle_ isEqualToString:kbsImageSpinStyleGray]) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    else if ([spinStyle_ isEqualToString:kbsImageSpinStyleLargeWhite]) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    if (spinColorChange_) {
        spinner_.color = spinColor_;
    } else {
        spinColor_ = spinner_.color;
    }
    [spinner_ setHidden:NO];
    [spinner_ startAnimating];
}

#pragma mark - override
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (bsDisplay *)subviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)removeSubviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
