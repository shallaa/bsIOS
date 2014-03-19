//
//  bsError.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsError.h"

static NSMutableArray *__bsError_pool = nil;

@implementation bsError

+ (bsError *)popWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line {
    
    @synchronized(__bsError_pool) {
        if (__bsError_pool == nil) {
            __bsError_pool = [[NSMutableArray alloc] init];
        }
        bsError *result;
        if ([__bsError_pool count] > 0) {
            result = [__bsError_pool lastObject];
            [__bsError_pool removeLastObject];
        } else {
            result = [[bsError alloc] init];
        }
        [result setWithMsg:msg data:data func:func line:line];
        return result;
    }
}

+ (void)put:(bsError *)error {
    @synchronized( __bsError_pool) {
        if (__bsError_pool == nil) {
            __bsError_pool = [[NSMutableArray alloc] init];
        }
        [__bsError_pool addObject:error];
    }
}

+ (BOOL)isError:(id)data {
    return [data isKindOfClass:[bsError class]] ? YES : NO;
}

- (void)setWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line {
    
    _msg = [msg copy];
    _line = line;
    _data = data;
    _func = [NSString stringWithFormat:@"%s", func];
}

- (NSString *)msg {
    
    return _msg;
}

- (NSString *)func {
    
    return _func;
}

- (NSUInteger)line {
    
    return _line;
}

- (id)data {
    
    return _data;
}

- (NSString *)str {
    
    // TODO: 보통때는 _func, _line은 표시하지 않는다.
    if (_data) {
        return [NSString stringWithFormat:@"(\n\tfunc: %@(%lu)\n\tmsg: %@\n\tdata: %@\n)", _func, (unsigned long)_line, _msg, _data];
    } else {
        return [NSString stringWithFormat:@"(\n\tfunc: %@(%lu)\n\tmsg: %@\n)", _func, (unsigned long)_line, _msg];
    }
}

- (NSString *)description {
    
    return [self str];
}

@end
