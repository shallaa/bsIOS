#import <Foundation/Foundation.h>
#import "bsMacro.h"
#import "bsRuntime.h"

@class bsBindingChange;

typedef void (^bsBindingBlock)( NSString* uniqueId, bsBindingChange* change );

#pragma mark - bsBindingChangeKind
STR_CONST( bsBindingChangeKindSetting, "setting" );
STR_CONST( bsBindingChangeKindInsert, "insert" );
STR_CONST( bsBindingChangeKindRemove, "remove" );
STR_CONST( bsBindingChangeKindReplace, "replace" );

#pragma mark - bsBindingChange
@interface bsBindingChange : NSObject
@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSString *kind;
@property (nonatomic, readonly) id valueNew;
@property (nonatomic, readonly) id valueOld;
@end
@implementation bsBindingChange
+(id)GWithKeyPath:(NSString*)keyPath change:(NSDictionary*)change {
    if( keyPath == nil || change == nil ) return nil;
    NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    NSIndexSet *indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
    NSString *kindStr;
    switch ( [kind intValue] ) {
        case NSKeyValueChangeSetting: kindStr = bsBindingChangeKindSetting; break;
        case NSKeyValueChangeInsertion: kindStr = bsBindingChangeKindInsert; break;
        case NSKeyValueChangeRemoval: kindStr = bsBindingChangeKindRemove; break;
        case NSKeyValueChangeReplacement: kindStr = bsBindingChangeKindReplace; break;
    }
    newValue = [newValue isKindOfClass:[NSNull class]] ? nil : newValue;
    oldValue = [oldValue isKindOfClass:[NSNull class]] ? nil : oldValue;
    indexes = [indexes isKindOfClass:[NSNull class]] ? nil : indexes;
    bsBindingChange *bindingChange = [[bsBindingChange alloc] initWithKeyPath:keyPath kind:kindStr newValue:newValue  oldValue:oldValue indexes:indexes];
    return bindingChange;
}
-(id)initWithKeyPath:(NSString*)keyPath kind:(NSString*)kind newValue:(id)newValue oldValue:(id)oldValue indexes:(NSIndexSet*)indexes {
    if( self = [super init] ) {
        _keyPath = keyPath;
        _kind = kind;
        _valueNew = newValue;
        _valueOld = oldValue;
    }
    return self;
}
-(BOOL)isKindSetting {
    return [self.kind isEqualToString:bsBindingChangeKindSetting];
}
-(BOOL)isKindInsert {
    return [self.kind isEqualToString: bsBindingChangeKindInsert];
}
-(BOOL)isKindRemove {
    return [self.kind isEqualToString:bsBindingChangeKindRemove];
}
-(BOOL)isKindReplace {
    return [self.kind isEqualToString:bsBindingChangeKindReplace];
}
-(NSString*)description {
    return [NSString stringWithFormat:@"keyPath=%@, kind=%@", self.keyPath, self.kind];
}
-(BOOL)isEqualKeyPath:(NSString*)keyPath {
    return [self.keyPath isEqualToString:keyPath];
}
@end

#pragma mark - bsBinding
@interface bsBinding : NSObject {
    BOOL valid_;        //이 바인딩 객체가 유효한가?
}
@property (nonatomic, readonly)  BOOL invokeReady;          //invoke 준비상태인가?
@property (nonatomic, copy, readonly) NSString *uniqueId;   //바인딩할때 만들어지는 유일키이다. 이것으로 unbind, invoke를 할 수 있다.
@property (nonatomic, copy, readonly) NSArray *keyPathes;   //바인딩할때 keyPath들이다.
@property (nonatomic, weak, readonly) id rootObject;        //바인딩할 root가 되는 객체다. 이것을 기준으로 keyPath가 잡힌다.
@property (nonatomic, readonly) NSMutableArray *changeList;  //KVO를 통해 keyPath들에 해당하는 속성의 값 변화를 감지할때마다 여기에 변경된 정보를 담은 bsBindingChange객체 리스트가 쌓인다.
@property (nonatomic, copy, readonly) bsBindingBlock block; //바인딩을 처리할 블록함수 
@end
@implementation bsBinding
static NSMutableDictionary *__bsBindingDic = nil;
static dispatch_queue_t __bsBinding_dequeue = NULL;
//static dispatch_semaphore_t __bsBind_dsema = NULL;

+(NSString*)bind:(id)rootObject keyPathes:(NSArray*)keyPathes block:(bsBindingBlock)block {
    if( rootObject == nil ) return nil;
    if( keyPathes == nil || [keyPathes count] == 0 ) return nil;
    if( block == nil ) return nil;
    if( __bsBinding_dequeue == NULL ) {
        @synchronized( __bsBinding_dequeue ) {
            if( __bsBinding_dequeue == NULL ) {
                __bsBinding_dequeue = dispatch_queue_create( "bind", NULL );
                //__bsBind_dsema = dispatch_semaphore_create( 3 );
            }
        }
    }
    @synchronized( __bsBindingDic ) {
        if( __bsBindingDic == nil ) {
            __bsBindingDic = [[NSMutableDictionary alloc]init];
        }
        NSMutableArray *newKeyPathes = [NSMutableArray array];
        [keyPathes enumerateObjectsUsingBlock:^(NSString* keyPath, NSUInteger idx, BOOL *stop) {
            NSArray *t = [bsStr split:keyPath seperator:@"." trim:YES];
            if( [t.lastObject isEqualToString:@"*"] ) {
                NSMutableString *prefix = [[NSMutableString alloc] init];
                for ( NSInteger i = 0, j = [t count] - 1; i < j; i++ ) {
                    [prefix appendString:t[i]];
                    if( i < j - 1 ) [prefix appendString:@"."];
                }
                Class clazz = [prefix length] == 0 ? [rootObject class] : [bsRuntime getPropClassOfRootObject:rootObject keyPath:prefix];
                NSArray *propNames = [bsRuntime getPropNamesOfClass:clazz superInquiry:YES];
                [propNames enumerateObjectsUsingBlock:^(NSString* propName, NSUInteger idx, BOOL *stop) {
                    if( [prefix length] == 0 ) {
                        [newKeyPathes addObject:propName];
                    } else {
                        [newKeyPathes addObject:[NSString stringWithFormat:@"%@.%@", prefix, propName]];
                    }
                }];
            } else {
                if( [bsRuntime hasPropAtObject:rootObject keyPath:keyPath] ) {
                    [newKeyPathes addObject:keyPath];
                }
            }
        }];
        if( [newKeyPathes count] == 0 ) return nil;
        bsBinding *binding = [[bsBinding alloc] initWithObject:rootObject keyPathes:newKeyPathes block:block];
        [__bsBindingDic setObject:binding forKey:binding.uniqueId];
        return binding.uniqueId;
    }
}
+(void)unbindWithUniqueId:(NSString*)uniqueId {
    @synchronized( __bsBindingDic ) {
        if( __bsBindingDic == nil ) return;
        bsBinding *binding = [__bsBindingDic objectForKey:uniqueId];
        if( binding ) {
            [binding unbind];
            [__bsBindingDic removeObjectForKey:uniqueId];
        }
    }
}
+(void)invoke:(NSString*)uniqueId {
    @synchronized( __bsBindingDic ) {
        if( __bsBindingDic == nil ) return;
        bsBinding *binding = [__bsBindingDic objectForKey:uniqueId];
        if( binding && binding.invokeReady ) {
            [binding invoke];
        }
    }
}
-(id)initWithObject:(id)rootObject keyPathes:(NSArray*)keyPathes block:(bsBindingBlock)block {
    if( self = [super init] ) {
        NSString *uuid = [bsStr UUID];
        valid_ = YES;
        _invokeReady = NO;
        _uniqueId = uuid;
        _block = block;
        _changeList = [NSMutableArray array];
        _rootObject = rootObject;
        [keyPathes enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
            [(id)self.rootObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        }];
        _keyPathes = keyPathes;
    }
    return self;
}
-(void)unbind {
    @synchronized( self ) {
        if( valid_ ) {
            valid_ = NO;
            [self.keyPathes enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
                [(id)self.rootObject removeObserver:self forKeyPath:keyPath];
            }];
            _changeList = nil;
            _keyPathes = nil;
            _rootObject = nil;
            _block = nil;
        }
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    @synchronized( self ) {
        //if( change[NSKeyValueChangeNewKey] == nil && change[NSKeyValueChangeOldKey] == nil ) return;
        if( valid_ ) {
            bsBindingChange *bindingChange = [bsBindingChange GWithKeyPath:keyPath change:change];
            self.block( self.uniqueId, bindingChange );
            /*
            bsBindingChange *bindingChange = [bsBindingChange GWithKeyPath:keyPath change:change];
            [_changeList addObject:bindingChange];
            if( _invokeReady == NO ) {
                _invokeReady = YES;
                __block id observer;
                observer  = [[NSNotificationCenter defaultCenter]
                             addObserverForName:self.uniqueId
                             object:nil
                             queue:nil
                             usingBlock:^(NSNotification *note) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                 [self invoke];
                                 observer = nil;
                             }];
                //[self performSelector:@selector(__notify) withObject:nil afterDelay:0.1];
                dispatch_async( __bsBinding_dequeue, ^{
                    //dispatch_semaphore_wait( __bsBind_dsema, DISPATCH_TIME_FOREVER );
                    sleep( 0.1 );
                    dispatch_sync( dispatch_get_main_queue(), ^{
                        [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:self.uniqueId object:nil] postingStyle:NSPostNow];
                    });
                    //dispatch_semaphore_signal( __bsBind_dsema );
                });
            }
             */
        }
    }
}
-(void)invoke {
    @synchronized( self ) {
        _invokeReady = NO;
        if( valid_ ) {
            NSArray *list = [[NSArray alloc]initWithArray:self.changeList];
            [list enumerateObjectsUsingBlock:^(bsBindingChange* change, NSUInteger idx, BOOL *stop) {
                self.block( self.uniqueId, change );
            }];
            [self.changeList removeAllObjects];
        }
    }
}
-(void)dealloc {
    if( valid_ ) {
        [self unbind];
    }
}
@end