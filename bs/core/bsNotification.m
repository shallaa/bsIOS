//
//  bsNotification.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsNotification.h"

#import "bsMacro.h"
#import "bsStr.h"

static NSMutableDictionary* __bsNotification__observers = nil;
static UIBackgroundTaskIdentifier __bsNotification__backgroundTaskId;
static BOOL __bsNotification_backgroundSupported;

@implementation bsNotification

+ (id)alloc {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsNotification' cannot be instantiated!");
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsNotification' cannot be instantiated!");
    return nil;
}

+ (void)onCreate {
    
    if (__bsNotification__observers) {
        bsException(NSInternalInconsistencyException, @"Wrong call");
    }
    __bsNotification__observers = [[NSMutableDictionary alloc] init];
    __bsNotification__backgroundTaskId = UIBackgroundTaskInvalid;
    //백그라운드 작업 진행 지원판단
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]){
        __bsNotification_backgroundSupported = [UIDevice currentDevice].multitaskingSupported;
    }
}

+ (void)blockRemove:(NSString *)key {
    
    id o = __bsNotification__observers[key];
    if (o) {
        [[NSNotificationCenter defaultCenter] removeObserver:o];
        [__bsNotification__observers removeObjectForKey:key];
    }
}

+ (NSString *)blockWillUnactive:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockDidUnactive:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockWillActive:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockDidActive:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockDidMemoryWarning:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockWillTerminate:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}
+ (NSString *)blockIdleTimeout:(bsBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:@"IdleTimeOut" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockBackgroundTask:(bsBackgroundTaskBlock)block {
    
    if (block == nil) return nil;
    if (!__bsNotification_backgroundSupported) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        //백그라운드 작업실시. 최대 10분 지원. 저장해야할 데이터가 있거나 할때 쓸 수 있음
        __bsNotification__backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:__bsNotification__backgroundTaskId];
            __bsNotification__backgroundTaskId = UIBackgroundTaskInvalid;
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            block(uuid, &__bsNotification__backgroundTaskId);
            [[UIApplication sharedApplication] endBackgroundTask:__bsNotification__backgroundTaskId];
            __bsNotification__backgroundTaskId = UIBackgroundTaskInvalid;
        });
    }];
    //백그라운드 작업을 중지시킨다.
    [self blockWillActive:^(NSString *blockKey) {
        __bsNotification__backgroundTaskId = UIBackgroundTaskInvalid;
        [self blockRemove:blockKey];
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockBattery:(bsBatteryBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryStateDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        UIDevice *device = [UIDevice currentDevice];
        NSString *batteryState;
        switch(device.batteryState) {
            case UIDeviceBatteryStateUnplugged: batteryState = @"Unplugged"; break;
            case UIDeviceBatteryStateCharging: batteryState = @"Charging"; break;
            case UIDeviceBatteryStateFull: batteryState = @"Full"; break;
            default: batteryState = @"Unknown"; break;
        }
        block(uuid, batteryState, device.batteryLevel/*0~1*/);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockLocaleChange:(bsLocaleChangeBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:NSCurrentLocaleDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid, [NSLocale currentLocale]);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockOrientationChange:(bsOrientationChangeBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid, [[UIDevice currentDevice] orientation]);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockUserDefaultChange:(bsUserDefaultChangeBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid, (NSUserDefaults *) [note object]);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockKeyboardWillShow:(bsKeyboradBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockKeyboardDidShow:(bsKeyboradBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockKeyboardWillHide:(bsKeyboradBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

+ (NSString *)blockKeyboardDidHide:(bsKeyboradBlock)block {
    
    if (block == nil) return nil;
    NSString *uuid = [bsStr UUID];
    id o = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        block(uuid);
    }];
    [__bsNotification__observers setObject:o forKey:uuid];
    return uuid;
}

@end
