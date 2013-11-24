#import <Foundation/Foundation.h>
#import "bsQue.h"

#pragma mark - bsWorker
@interface bsWorker : NSObject
@end
@implementation bsWorker
static dispatch_queue_t __bsWorker_dequeue = NULL;
static dispatch_semaphore_t __bsWorker_dsema = NULL;
static NSMutableArray *__bsWorker_ques = nil;
+(void)A:(bsQue*)que {
    if( que == nil ) {
        bsException( @"que argument should be not null" );
    }
    if( __bsWorker_dequeue == nil ) {
        @synchronized( __bsWorker_dequeue ) {
            if( __bsWorker_dequeue == NULL ) {
                __bsWorker_dequeue = dispatch_queue_create( "bsWorker", NULL );
                __bsWorker_dsema = dispatch_semaphore_create( 3 );
            }
        }
    }
    @synchronized( __bsWorker_ques ) {
        if( __bsWorker_ques == nil ) {
            __bsWorker_ques = [[NSMutableArray alloc] init];
        }
        [__bsWorker_ques addObject:que];
    }
    dispatch_async( __bsWorker_dequeue, ^{
        dispatch_semaphore_wait( __bsWorker_dsema, DISPATCH_TIME_FOREVER );
        @autoreleasepool {
            id data = nil;
            bsError *error = nil;
            if( que.cancel == NO ) {
                [que runWithData:&data error:&error];
            }
            if( que.cancel == YES ) {
                data = nil;
                error = nil;
            }
            if( que.callbackMainThread ) {
                dispatch_sync( dispatch_get_main_queue(), ^{
                    [que callback:data error:error];
                });
            } else {
                [que callback:data error:error];
            }
            [que clear];
        }
        dispatch_semaphore_signal( __bsWorker_dsema );
    });
}
+(void)D:(NSString*)queKey {
    if( __bsWorker_ques == nil ) return;
    @synchronized( __bsWorker_ques ) {
        [__bsWorker_ques enumerateObjectsUsingBlock:^(bsQue *que, NSUInteger idx, BOOL *stop) {
            if( [que.key isEqualToString:queKey] ) {
                que.cancel = YES;
                *stop = YES;
            }
        }];
    }
}
@end