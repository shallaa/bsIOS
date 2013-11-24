#import <Foundation/Foundation.h>
#import "bsCallback.h"
#import "bsError.h"

#pragma mark - bsQue
@interface bsQue : NSObject {
@private
    NSString *key_;
    bsCallback *end_;
    BOOL callbackMainThread_;
}
@property (nonatomic, readonly) NSString *key;
@property (atomic) BOOL cancel; //worker에서 run 실행을 하지 못하도록 한다. 이미 run이 구동된 상태면 run내부에서 cancel을 보고 다른 처리를 할 수 있도록 해야한다.
@property (atomic) BOOL callbackMainThread; //worker에서 callback함수를 호출시 main thread상태에서 호출시킬 것인가? 기본은 YES다.
@end
@implementation bsQue
@synthesize key = key_;
@synthesize callbackMainThread = callbackMainThread_;
static NSMutableDictionary *__bsQue_pool = nil;
+(bsQue*)GWithClassName:(NSString*)className key:(NSString*)key end:(bsCallback*)end {
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
-(void)__setWithKey:(NSString*)key end:(bsCallback*)end {
    key_ = key;
    end_ = end;
    callbackMainThread_ = YES;
    self.cancel = NO;
}
-(void)dealloc {
    [self clear];
}
-(void)runWithData:(id*)data error:(bsError**)error {
}
-(void)callback:(id)data error:(bsError*)error{
    if( end_ ) {
        [end_ callbackWithKey:key_ data:data error:error];
    }
}
-(void)clear {
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