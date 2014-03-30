//
//  bsWorker.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsWorker.h"

#import "bsQueue.h"
#import "bsMacro.h"

static dispatch_queue_t __bsWorker_dequeue = NULL;
static dispatch_semaphore_t __bsWorker_dsema = NULL;
static NSMutableArray *__bsWorker_ques = nil;

@implementation bsWorker

+ (void)A:(bsQueue *)queue {
    
    if (queue == nil) {
        bsException(NSInvalidArgumentException, @"queue argument should be not null");
    }
    if (__bsWorker_dequeue == nil) {
        @synchronized (__bsWorker_dequeue) {
            if (__bsWorker_dequeue == NULL) {
                __bsWorker_dequeue = dispatch_queue_create("bsWorker", NULL);
                __bsWorker_dsema = dispatch_semaphore_create(3);
            }
        }
    }
    @synchronized (__bsWorker_ques) {
        if (__bsWorker_ques == nil) {
            __bsWorker_ques = [[NSMutableArray alloc] init];
        }
        [__bsWorker_ques addObject:queue];
    }
    dispatch_async(__bsWorker_dequeue, ^{
        dispatch_semaphore_wait(__bsWorker_dsema, DISPATCH_TIME_FOREVER);
        @autoreleasepool {
            id data = nil;
            bsError *error = nil;
            if (!queue.cancel) {
                data = [queue run:&error];
            }
            if (queue.callbackMainThread) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [queue callback:data error:error];
                });
            } else {
                [queue callback:data error:error];
            }
            [queue clear];
        }
        dispatch_semaphore_signal(__bsWorker_dsema);
    });
}

+ (void)D:(NSString *)queKey {
    
    if (__bsWorker_ques == nil) {
        return;
    }
    @synchronized(__bsWorker_ques) {
        [__bsWorker_ques enumerateObjectsUsingBlock:^(bsQueue *que, NSUInteger idx, BOOL *stop) {
            if ([que.key isEqualToString:queKey]) {
                que.cancel = YES;
                *stop = YES;
            }
        }];
    }
}

@end
