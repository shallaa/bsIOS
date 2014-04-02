//
//  bsError.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsError.h"

#import "bsLog.h"

static NSMutableArray *__bsError_pool = nil;

@interface bsError ()

@property (nonatomic, strong, readwrite) NSString *message;
@property (nonatomic, strong, readwrite) NSString *functionName;
@property (nonatomic, strong, readwrite) id data;
@property (nonatomic, readwrite) NSUInteger line;

@end

@implementation bsError

+ (bsError *)popWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
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
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    @synchronized( __bsError_pool) {
        if (__bsError_pool == nil) {
            __bsError_pool = [[NSMutableArray alloc] init];
        }
        [__bsError_pool addObject:error];
    }
}

+ (BOOL)isError:(id)data {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [data isKindOfClass:[bsError class]];
}

- (void)setWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    self.message = msg;
    self.line = line;
    self.data = data;
    self.functionName = [NSString stringWithFormat:@"%s", func];
}

- (NSString *)str {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (_data) {
        return [NSString stringWithFormat:@"(\n\tfunc: %@(%lu)\n\tmsg: %@\n\tdata: %@\n)", _functionName, (unsigned long)_line, _message, _data];
    } else {
        return [NSString stringWithFormat:@"(\n\tfunc: %@(%lu)\n\tmsg: %@\n)", _functionName, (unsigned long)_line, _message];
    }
}

- (NSString *)description {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [self str];
}

@end
