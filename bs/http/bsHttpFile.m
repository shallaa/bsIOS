//
//  bsHttpFile.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsHttpFile.h"

#import "bsLog.h"
#import "bsMacro.h"

static NSMutableArray *__bsHttpFile_pool = nil;

@implementation bsHttpFile

+ (bsHttpFile *)pop {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    @synchronized (__bsHttpFile_pool) {
        if (__bsHttpFile_pool == nil) {
            __bsHttpFile_pool = [[NSMutableArray alloc]init];
        }
        bsHttpFile *r;
        if ([__bsHttpFile_pool count] > 0) {
            r = [__bsHttpFile_pool lastObject];
            [__bsHttpFile_pool removeLastObject];
        } else {
            r = [[bsHttpFile alloc] init];
        }
        return r;
    }
}

+ (void)put:(bsHttpFile *)httpFiles {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (httpFiles == nil) {
        return;
    }
    @synchronized ( __bsHttpFile_pool) {
        if (__bsHttpFile_pool == nil) {
            __bsHttpFile_pool = [[NSMutableArray alloc] init];
        }
        [httpFiles d];
        [__bsHttpFile_pool addObject:httpFiles];
    }
}

- (void)sWithKey:(NSString *)key name:(NSString *)name data:(NSData *)data {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (key == nil) bsException(NSInvalidArgumentException, @"key is nil");
    if (name == nil) bsException(NSInvalidArgumentException, @"name is nil");
    if (data == nil) bsException(NSInvalidArgumentException, @"data is nil");
    @synchronized (_files) {
        if (_files == nil) {
            _files = [[NSMutableDictionary alloc] init];
        }
        _files[key] = @{@"name":[name copy], @"data":data};
    }
}

- (void)loop:(void (^)(NSString *key, NSString *name, NSData *data))block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    @synchronized (_files) {
        [_files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if(block) block(key, obj[@"name"], obj[@"data"]);
        }];
    }
}

- (NSUInteger)c {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    @synchronized (_files) {
        if (_files) {
            return [_files count];
        }
    }
    return 0;
}

- (void)d {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    @synchronized (_files) {
        [_files removeAllObjects];
    }
}

@end
