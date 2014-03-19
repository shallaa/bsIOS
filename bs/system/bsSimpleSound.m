//
//  bsSimpleSound.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/14.
//  Copyright (c) 2014年 ProjectBS. All rights reserved.
//

#import "bsSimpleSound.h"

#import <AudioToolbox/AudioServices.h>
#import "bsMacro.h"
#import "bsStr.h"

static NSMutableDictionary* __bsSimpleSound_dic = nil;

@implementation bsSimpleSound

+ (id)alloc {
    
    bsException( @"Static class 'bsSimpleSound' cannot be instantiated!" );
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException( @"Static class 'bsSimpleSound' cannot be instantiated!" );
    return nil;
}

+ (BOOL)AWithKey:(NSString *)key fullFileName:(NSString *)fullFileName {
    
    @synchronized(__bsSimpleSound_dic) {
        if( __bsSimpleSound_dic == nil ) {
            __bsSimpleSound_dic = [[NSMutableDictionary alloc] init];
        }
    }
    NSNumber *num = (NSNumber *)[__bsSimpleSound_dic objectForKey:key];
    SystemSoundID soundID;
    if (num == nil) {
        NSString *fileName = [[fullFileName lastPathComponent] stringByDeletingPathExtension];
        NSString *extension = [fullFileName pathExtension];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[[NSURL alloc] initFileURLWithPath:path], &soundID);
        if (error != kAudioServicesNoError) {
            NSLog(@"Sound not found. fullFileName=%@", fullFileName);
            return NO;
        }
        num = [[NSNumber alloc] initWithUnsignedLong:soundID];
        [__bsSimpleSound_dic setObject:num forKey:key];
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)DWithKey:(NSString *)key {
    
    if (key == nil) return NO;
    if (__bsSimpleSound_dic == nil) return NO;
    @synchronized(__bsSimpleSound_dic) {
        if ([key isEqualToString:@"*"]) {
            NSArray *keyList = [__bsSimpleSound_dic allValues];
            if (keyList != nil) {
                [keyList enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
                    if (num == nil) return;
                    SystemSoundID soundID = [num unsignedLongValue];
                    AudioServicesDisposeSystemSoundID(soundID);
                }];
            }
            [__bsSimpleSound_dic removeAllObjects];
            return YES;
        } else {
            NSNumber *num = (NSNumber *)[__bsSimpleSound_dic objectForKey:key];
            if (num == nil) return NO;
            SystemSoundID soundID = [num unsignedLongValue];
            AudioServicesDisposeSystemSoundID(soundID);
            [__bsSimpleSound_dic removeObjectForKey:key];
            return YES;
        }
    }
}

+ (BOOL)PWithKey:(NSString *)key {
    
    if (key == nil) return NO;
    if (__bsSimpleSound_dic == nil) return NO;
    @synchronized(__bsSimpleSound_dic) {
        NSNumber *num = (NSNumber *)[__bsSimpleSound_dic objectForKey:key];
        if (num == nil) return NO;
        SystemSoundID soundID = [num unsignedLongValue];
        AudioServicesPlaySystemSound(soundID);
    }
    return YES;
}

@end
