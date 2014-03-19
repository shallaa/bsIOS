#import <Foundation/Foundation.h>
#import "bsMacro.h"
#import "bsRuntime.h"

@class bsBindingChange;

typedef void (^bsBindingBlock)(NSString *uniqueId, bsBindingChange *change);

FOUNDATION_EXPORT NSString * const bsBindingChangeKindSetting;
FOUNDATION_EXPORT NSString * const bsBindingChangeKindInsert;
FOUNDATION_EXPORT NSString * const bsBindingChangeKindRemove;
FOUNDATION_EXPORT NSString * const bsBindingChangeKindReplace;

@interface bsBindingChange : NSObject

@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSString *kind;
@property (nonatomic, readonly) id valueNew;
@property (nonatomic, readonly) id valueOld;

+ (id)GWithKeyPath:(NSString *)keyPath change:(NSDictionary *)change;
- (id)initWithKeyPath:(NSString *)keyPath kind:(NSString *)kind newValue:(id)newValue oldValue:(id)oldValue indexes:(NSIndexSet *)indexes;
- (BOOL)isKindSetting;
- (BOOL)isKindInsert;
- (BOOL)isKindRemove;
- (BOOL)isKindReplace;
- (BOOL)isEqualKeyPath:(NSString *)keyPath;

@end


@interface bsBinding : NSObject {
    
    BOOL valid_; //이 바인딩 객체가 유효한가?
}

@property (nonatomic, readonly) BOOL invokeReady; // invoke 준비상태인가?
@property (nonatomic, copy, readonly) NSString *uniqueId; // 바인딩할때 만들어지는 유일키이다. 이것으로 unbind, invoke를 할 수 있다.
@property (nonatomic, copy, readonly) NSArray *keyPathes; // 바인딩할때 keyPath들이다.
@property (nonatomic, weak, readonly) id rootObject; //바인딩할 root가 되는 객체다. 이것을 기준으로 keyPath가 잡힌다.
@property (nonatomic, readonly) NSMutableArray *changeList; //KVO를 통해 keyPath들에 해당하는 속성의 값 변화를 감지할때마다 여기에 변경된 정보를 담은 bsBindingChange객체 리스트가 쌓인다.
@property (nonatomic, copy, readonly) bsBindingBlock block; //바인딩을 처리할 블록함수 

+ (NSString *)bind:(id)rootObject keyPathes:(NSArray *)keyPathes block:(bsBindingBlock)block;
+ (void)unbindWithUniqueId:(NSString *)uniqueId;
+ (void)invoke:(NSString *)uniqueId;
- (id)initWithObject:(id)rootObject keyPathes:(NSArray *)keyPathes block:(bsBindingBlock)block;
- (void)unbind;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
- (void)invoke;

@end
