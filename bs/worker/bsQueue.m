//
//  bsQueue.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsQueue.h"

#import "bsCallback.h"
#import "bsError.h"
#import "bsLog.h"
#import "bsMacro.h"

static dispatch_queue_t syncQueue;
static NSMutableDictionary *__bsQue_pool = nil;

@interface bsQueue ()

@end

@implementation bsQueue

@synthesize key = key_;
@synthesize callbackMainThread = callbackMainThread_;

+ (bsQueue *)GWithClassName:(NSString *)className key:(NSString *)key end:(bsCallback *)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsQueue *result = nil;
    @synchronized (__bsQue_pool) {
        if (__bsQue_pool == nil) {
            __bsQue_pool = [[NSMutableDictionary alloc] init];
        }
        if ([className hasPrefix:@"bs"] && [className hasSuffix:@"Queue"]) {
        } else {
            bsException(NSInvalidArgumentException, @"className(=%@) is not queue name", className);
        }
        Class clazz = NSClassFromString(className);
        if (!clazz) {
            bsException(NSInvalidArgumentException, @"class(=%@) is undefined", className);
        }
        NSMutableArray *list = [__bsQue_pool objectForKey:className];
        if (list == nil) {
            list = [[NSMutableArray alloc] init];
            __bsQue_pool[className] = list;
        }
        if ([list count] > 0) {
            result = (bsQueue *)[list lastObject];
            [list removeLastObject];
        } else {
            result = [[clazz alloc] init];
        }
        [result __setWithKey:key end:end];
    }
    return result;
}

- (void)__setWithKey:(NSString *)key end:(bsCallback *)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    key_ = key;
    end_ = end;
    callbackMainThread_ = YES;
    self.cancel = NO;
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [self clear];
}

- (id)run:(bsError **)error {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return nil;
}

- (void)callback:(id)data error:(bsError *)error {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (end_) {
        [end_ callbackWithKey:key_ data:data error:error];
    }
}

- (void)clear {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    self.cancel = NO;
    key_ = nil;
    end_ = nil;
    @synchronized (__bsQue_pool) {
        NSString *className = NSStringFromClass([self class]);
        NSMutableArray *list = (NSMutableArray *)__bsQue_pool[className];
        if ([list indexOfObject:self] == NSNotFound) {
            [list addObject:self];
        }
    }
}

@end
