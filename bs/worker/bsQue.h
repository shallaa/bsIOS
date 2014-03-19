#import <Foundation/Foundation.h>

@class bsCallback;
@class bsError;

@interface bsQue : NSObject {
    
@private
    NSString *key_;
    bsCallback *end_;
    BOOL callbackMainThread_;
}

@property (nonatomic, readonly) NSString *key;
@property (atomic) BOOL cancel; //worker에서 run 실행을 하지 못하도록 한다. 이미 run이 구동된 상태면 run내부에서 cancel을 보고 다른 처리를 할 수 있도록 해야한다.
@property (atomic) BOOL callbackMainThread; //worker에서 callback함수를 호출시 main thread상태에서 호출시킬 것인가? 기본은 YES다.

+ (bsQue *)GWithClassName:(NSString *)className key:(NSString *)key end:(bsCallback *)end;
- (void)__setWithKey:(NSString*)key end:(bsCallback*)end;
- (void)runWithData:(id*)data error:(bsError**)error;
- (void)callback:(id)data error:(bsError*)error;
- (void)clear;

@end
