//
//  bsImageQue.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/18.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsImageQue.h"

#import "bsDisplayUtil.h"
#import "bsError.h"
#import "bsGeometry.h"
#import "bsIO.h"
#import "bsMacro.h"
#import "bsStr.h"

@implementation bsImageQue

+ (bsImageQue *)GWithKey:(NSString *)key src:(NSString *)src cacheSize:(bsSize *)cacheSize end:(bsCallbackBlock)end {
    
    bsImageQue *que = (bsImageQue *)[bsQue GWithClassName:@"bsImageQue" key:key end:[bsCallback GWithBlock:end]];
    [que __setWithSrc:src cacheSize:cacheSize];
    return que;
}

- (void)__setWithSrc:(NSString *)src cacheSize:(bsSize *)cacheSize {
    
    if ( src == nil ) {
        bsException( @"src argument should be not null" );
    }
    src_ = src;
    cacheSize_ = cacheSize;
    if( cacheSize_ ) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if( scale > 1.0 ) {
            CGFloat w = cacheSize_.w;
            CGFloat h = cacheSize_.h;
            //[bsSize put:cacheSize_];
            cacheSize_ = [bsSize G:CGSizeMake( w * scale, h * scale)];
        }
    }
}

- (void)clear {
    
    src_ = nil;
    cacheSize_ = nil;
    [super clear];
}

- (void)runWithData:(id *)data error:(bsError **)error {
    
    *error = nil;
    *data = nil;
    NSData *d;
    NSString *cacheName = nil;
    NSString *originName = nil;
    UIImage *image = nil;
    BOOL resize;
    if( cacheSize_ != nil ) {
        //캐쉬데이타 있으면 그것을 보내줌
        cacheName = [NSString stringWithFormat:@"images/%@", [bsStr urlEncode:src_]];
        originName = cacheName;
        if( cacheSize_.w < 0 || cacheSize_.h < 0 ) {
            resize = NO;
        } else {
            cacheName = [NSString stringWithFormat:@"images/%@_%fx%f", [bsStr urlEncode:src_], cacheSize_.w, cacheSize_.h];
            resize = YES;
        }
        d = [bsIO cacheG:cacheName];
        if( d ) {
            image = [UIImage imageWithData:d];
            if( image == nil ) {
                *error = [bsError popWithMsg:@"캐싱된 이미지를 읽지 못했습니다." data:src_ func:__FUNCTION__ line:__LINE__];
                return;
            }
            *data = image;
            return;
        }
        //리사이즈 요청이 왔으면 원본이미지 캐싱되어 있을때 그것을 리사이즈 해서 보내줌. 리사이즈된 것은 캐싱처리
        if( resize == YES ) {
            d = [bsIO cacheG:originName];
            if( d ) {
                image = [UIImage imageWithData:d];
                if( image == nil ) {
                    *error = [bsError popWithMsg:@"캐싱된 이미지를 읽지 못했습니다." data:src_ func:__FUNCTION__ line:__LINE__];
                    return;
                }
                CGFloat w = cacheSize_.w;
                CGFloat h = cacheSize_.h;
                if ( image.size.width > image.size.height ) {
                    image = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, image.size.width / image.size.height * h, h)];
                } else {
                    image = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, w, image.size.height / image.size.width * w)];
                }
                image = [bsDisplayUtil crop:image frame:CGRectMake(0, 0, w, h)];
                d = UIImagePNGRepresentation(image);
                if( NO == [bsIO cacheS:cacheName data:d] ) {
                    NSLog( @"리사이즈 이미지 캐쉬 저장 실패 src=%@ width=%f height=%f", src_, image.size.width, image.size.height );
                }
                *data = image;
                return;
            }
        }
    }
    //프로토콜에 따라 이미지 데이타 읽어옴.
    if( [src_ hasPrefix:@"http://"] || [src_ hasPrefix:@"https://"] ) {
        d = [NSData dataWithContentsOfURL:[NSURL URLWithString:src_]];
    } else if( [src_ hasPrefix:@"assets://"] || [src_ hasPrefix:@"asset://"] || [src_ hasPrefix:@"a://"] ) {
        d = [bsIO assetG:[bsStr replace:src_ search:@[@"assets://", @"asset://", @"a://"] dest:@""]];
    } else if( [src_ hasPrefix:@"storage://"] || [src_ hasPrefix:@"s://"] ) {
        d = [bsIO storageG:[bsStr replace:src_ search:@[@"storage://", @"s://"] dest:@""]];
    } else {
        *data = [UIImage imageNamed:src_]; //번들이미지의 경우 그냥 반환
        return;
    }
    if( d == nil ) {
        *error = [bsError popWithMsg:@"이미지를 읽지 못했습니다." data:src_ func:__FUNCTION__ line:__LINE__];
        return;
    }
    image = [UIImage imageWithData:d];
    if( image == nil ) {
        *error = [bsError popWithMsg:@"데이터를 이미지로 변환하지 못했습니다." data:src_ func:__FUNCTION__ line:__LINE__];
        return;
    }
    //이미지 반환(캐싱이 필요하면 처리)
    if ( cacheSize_ ) {
        //원본 캐싱
        if( NO == [bsIO cacheS:originName data:d] ) {
            NSLog( @"원본 이미지 캐쉬 저장 실패 src=%@", src_ );
        }
        //리사이즈 캐싱
        if ( resize ) {
            CGFloat w = cacheSize_.w;
            CGFloat h = cacheSize_.h;
            if ( image.size.width > image.size.height ) {
                image = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, image.size.width / image.size.height * h, h)];
            } else {
                image = [bsDisplayUtil resizedImage:image inRect:CGRectMake(0, 0, w, image.size.height / image.size.width * w)];
            }
            image = [bsDisplayUtil crop:image frame:CGRectMake(0, 0, w, h)];
            d = UIImagePNGRepresentation(image);
            if( NO == [bsIO cacheS:cacheName data:d] ) {
                NSLog( @"리사이즈 이미지 캐쉬 저장 실패 src=%@ width=%f height=%f", src_, image.size.width, image.size.height );
            }
        }
    }
    *data = image;
}

@end
