//
//  bsQue.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsQue.h"

#import "bsCallback.h"
#import "bsError.h"
#import "bsMacro.h"

static NSMutableDictionary *__bsQue_pool = nil;

@implementation bsQue

@synthesize key = key_;
@synthesize callbackMainThread = callbackMainThread_;

+ (bsQue *)GWithClassName:(NSString *)className key:(NSString *)key end:(bsCallback *)end {
    
    bsQue *result = nil;
    @synchronized( __bsQue_pool ) {
        if( __bsQue_pool == nil ) {
            __bsQue_pool = [[NSMutableDictionary alloc] init];
        }
        if( [className hasPrefix:@"bs"] && [className hasSuffix:@"Que"] ) {} else {
            bsException( @"className(=%@) is not queue name", className );
        }
        Class clazz = NSClassFromString(className);
        if( !clazz ) {
            bsException( @"class(=%@) is undefined", className );
        }
        NSMutableArray *list = [__bsQue_pool objectForKey:className];
        if ( list == nil ) {
            list = [[NSMutableArray alloc] init];
            __bsQue_pool[className] = list;
        }
        if( [list count] > 0 ) {
            result = (bsQue*)[list lastObject];
            [list removeLastObject];
        } else {
            result = [[clazz alloc] init];
        }
        [result __setWithKey:key end:end];
    }
    return result;
}

- (void)__setWithKey:(NSString*)key end:(bsCallback*)end {
    key_ = key;
    end_ = end;
    callbackMainThread_ = YES;
    self.cancel = NO;
}

- (void)dealloc {
    [self clear];
}

- (void)runWithData:(id*)data error:(bsError**)error {
}

- (void)callback:(id)data error:(bsError*)error{
    if( end_ ) {
        [end_ callbackWithKey:key_ data:data error:error];
    }
}

- (void)clear {
    self.cancel = NO;
    key_ = nil;
    end_ = nil;
    @synchronized( __bsQue_pool ) {
        NSString *className = NSStringFromClass( [self class] );
        NSMutableArray *list = (NSMutableArray*)__bsQue_pool[className];
        if( [list indexOfObject:self] == NSNotFound ) {
            [list addObject: self];
        }
    }
}

@end
