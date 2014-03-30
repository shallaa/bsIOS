//
//  bsIni.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsIni.h"

#import "bsIO.h"
#import "bsMacro.h"
#import "bsStr.h"

static NSMutableDictionary *__bsIni_ini = nil;

@implementation bsIni

+ (id)alloc {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsIni' cannot be instantiated!");
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsIni' cannot be instantiated!");
    return nil;
}

+ (void)onCreate {
    
    if (__bsIni_ini) {
        bsException(NSInvalidArgumentException, @"Wrong call");
    }
    __bsIni_ini = [[NSMutableDictionary alloc] init];
    @try {
        NSArray *lines = [bsStr row:[bsStr str:[bsIO assetG:@"bs.ini"]]];
        [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
            NSArray *data = [bsStr split:line seperator:@"=" trim:YES];
            [__bsIni_ini setObject:[data objectAtIndex:1] forKey:[data objectAtIndex:0]];
        }];
    }
    @catch (NSException *exception) {
        [NSException raise:NSInvalidArgumentException format:@"%s(%d)'bs.ini' has wrong value.", __FUNCTION__, __LINE__];
    }
}

+ (NSString *)ini:(NSString *)item {
    
    // TODO: nil을 반환해도 상관없는가?
    return [__bsIni_ini objectForKey:item];
}

+ (BOOL)iniBool:(NSString *)item {
    
    item = [bsIni ini:item];
    return item != nil && [bsStr BOOLEAN:item];
}

@end
