//
//  bsParam.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsParam.h"

#import "bsMacro.h"

static NSMutableDictionary *__bsParam_dic = nil;

@implementation bsParam

+ (NSString *)G:(NSString *)key {
    
    if (__bsParam_dic == nil) {
        bsException(@"key(=%@) is undefined", key);
    }
    @synchronized( __bsParam_dic ) {
        NSString *params = __bsParam_dic[key];
        if (params == nil) {
            bsException(@"key(=%@) is undefined", key);
        }
        return params;
    }
}

+ (void)A:(NSString *)key params:(NSString *)params {
    if( key == nil || params == nil ) {
        bsException( @"key or params is null" );
    }
    @synchronized( __bsParam_dic ) {
        if( __bsParam_dic == nil ) {
            __bsParam_dic = [[NSMutableDictionary alloc]init];
        }
        if( __bsParam_dic[key] ) {
            bsException( @"Already this key(=%@) is defined", key );
        }
        __bsParam_dic[key] = params;
    }
}

@end
