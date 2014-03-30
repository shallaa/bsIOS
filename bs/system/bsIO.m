//
//  bsIO.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsIO.h"

#import "bsMacro.h"
#import "bsStr.h"

static NSString *__bsIO_storagePath = nil;
static NSString * __bsIO_assetPath = nil;
static NSString *__bsIO_cachePath = nil;
static NSFileManager *__bsIO_fm = nil;

@implementation bsIO

+ (id)alloc {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsIO' cannot be instantiated!");
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsIO' cannot be instantiated!");
    return nil;
}

+ (void)onCreate {
    
    if (__bsIO_storagePath) {
        bsException(NSInvalidArgumentException, @"Wrong call");
    }
    __bsIO_storagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __bsIO_cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    __bsIO_assetPath = [NSString stringWithFormat:@"%@/assets", [[NSBundle mainBundle] bundlePath]];
    __bsIO_fm = [NSFileManager defaultManager];
    if (![__bsIO_fm fileExistsAtPath:__bsIO_storagePath]) {
        NSError *error = nil;
        [__bsIO_fm createDirectoryAtPath:__bsIO_storagePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            bsException(NSInternalInconsistencyException, @"A storage creation failded");
        }
    }
}

#pragma mark - asset

+ (NSString *)__assetPath:(NSString *)name {
    
    return [NSString stringWithFormat:@"%@/%@", __bsIO_assetPath, name];
}

+ (NSData *)assetG:(NSString *)name {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    NSString *path = [bsIO __assetPath:name];
    NSData *data = [__bsIO_fm contentsAtPath:path];
    if (data == nil) {
        bsException(NSInvalidArgumentException, @"A filename or a file path is wrong. name=%@", name);
    }
    return data;
}

#pragma mark - storage

+ (NSString *)__storagePath:(NSString *)name {
    
    return [NSString stringWithFormat:@"%@/%@", __bsIO_storagePath, name];
}

+ (BOOL)__checkStoragePath:(NSString *)name {
    
    NSArray *names = [bsStr split:name seperator:@"/" trim:NO];
    BOOL success = YES;
    if ([names count] > 1) {
        NSInteger i = [name length] - [names[[names count]-1] length];
        NSString *path = [bsIO __storagePath:[name substringToIndex:i]];
        NSFileManager *manager = [NSFileManager defaultManager];
        if( ![manager fileExistsAtPath:path] ) {
            success = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return success;
}

+ (NSData *)storageG:(NSString *)name {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    NSString *path = [bsIO __storagePath:name];
    NSData *data = [__bsIO_fm contentsAtPath:path];
    return data;
}

+ (BOOL)storageS:(NSString *)name data:(NSData *)data {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    if (data == nil) {
        return [self storageD:name];
    }
    if (![bsIO __checkStoragePath:name]) {
        return NO;
    }
    NSString *path = [bsIO __storagePath:name];
    BOOL success = [__bsIO_fm createFileAtPath:path contents:data attributes:nil];
    return success;
}

+ (BOOL)storageD:(NSString *)name {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    NSString *path = [bsIO __storagePath:name];
    BOOL success = [__bsIO_fm removeItemAtPath:path error:nil];
    return success;
}

#pragma mark - cache

+ (NSString *)__cachePath:(NSString *)name {
    
    return [NSString stringWithFormat:@"%@/%@", __bsIO_cachePath, name];
}

+ (BOOL)__checkCachePath:(NSString *)name {
    
    NSArray *names = [bsStr split:name seperator:@"/" trim:NO];
    BOOL success = YES;
    if ([names count] > 1) {
        NSInteger i = [name length] - [names[[names count]-1] length];
        NSString *path = [bsIO __cachePath:[name substringToIndex:i]];
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            success = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return success;
}

+ (NSData *)cacheG:(NSString *)name {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    NSString *path = [bsIO __cachePath:name];
    NSData *data = nil;
    if ([__bsIO_fm fileExistsAtPath:path]) {
        data = [__bsIO_fm contentsAtPath:path];
    }
    return data;
}

+ (BOOL)cacheS:(NSString *)name data:(NSData *)data {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    if (data == nil) {
        bsException(NSInvalidArgumentException, @"A data is NULL");
    }
    if (![bsIO __checkCachePath:name]) {
        return NO;
    }
    NSString *path = [bsIO __cachePath:name];
    BOOL success = [__bsIO_fm createFileAtPath:path contents:data attributes:nil];
    return success;
}

+ (BOOL)cacheD:(NSString *)name {
    
    if (name == nil) {
        bsException(NSInvalidArgumentException, @"A name is NULL");
    }
    NSString *path = [bsIO __cachePath:name];
    BOOL success = [__bsIO_fm removeItemAtPath:path error:nil];
    return success;
}

@end
