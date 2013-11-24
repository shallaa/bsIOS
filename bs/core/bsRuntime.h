#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "bsPrimitive.h"
#import "bsStr.h"
/*
#pragma mark - bsObjectNode
//Root객체를 하이라키구조의 node로 관리하고 참조한다.
//사용시 유의할 점은
//1. Root객체는 앱이 종료할때까지 계속 유지해야만 한다.
//2. 이 클래스로 값을 set/get하면 끝까지 이것만 사용해야 한다. 왜냐하면 속도때문에 값을 캐싱하는데 다른 방법으로 셋팅하면 값이 꼬일 수 있다.
//3. 값은 반드시 NSObject계열이어야만 한다. int, NSInteger같은건 안된다.
@interface bsObjectNode : NSObject
@property (nonatomic, strong, readonly) NSString *nodeName;   //노드이름(키값)
@property (nonatomic, strong, readonly) NSString *propName;   //속성이름
@property (nonatomic, strong, readonly) NSString *className;  //속성의 클래스이름
@property (nonatomic, strong, readonly) id value;              //속성의 값
@property (nonatomic, readonly) Class clazz;                  //속성의 클래스
@property (nonatomic, readonly) Ivar ivar;                    //속성에 대한 instance variable 참조. object_getIvar( object, self.propName ) 형태로 참조할 수 있다.
@property (nonatomic, readonly) objc_property_t property;     //속성참조
@property (nonatomic, readonly) BOOL readonly;                //이 속성이 읽기허용인가?(뭐 아직 사용안함!)
@property (nonatomic, strong, readonly) id root;              //전체노트의 시작점. root는 싱글턴이거나 앱이 종료때까지 지워지지 않을 객체를 사용하자. (예: Model객체)
@property (nonatomic, strong, readonly) bsObjectNode *parent; //부모노드(부모 속성이 있는 경우이다.)
@end
@implementation bsObjectNode
static NSMutableDictionary *__bsObjectNodeCache;
-(BOOL)isArray { return self.clazz ? (self.clazz == [NSMutableArray class] || self.clazz == [NSArray class]) : NO; }
-(BOOL)isDic { return self.clazz ? (self.clazz == [NSMutableDictionary class] || self.clazz == [NSDictionary class]) : NO; }
-(BOOL)isString { return self.clazz ? (self.clazz == [NSString class] || self.clazz == [NSMutableString class]) : NO; }
-(BOOL)isPrimitive { return self.clazz ? (class_getSuperclass( self.clazz ) == [bsPrimitive class]) : NO; }
-(BOOL)isObject { return self.clazz ? YES : NO; }
+(void)__initCache {
    @synchronized( __bsObjectNodeCache ) {
        if( __bsObjectNodeCache == nil ) {
            __bsObjectNodeCache = [[NSMutableDictionary alloc]init];
        }
    }
}
+(bsObjectNode*)GWithRoot:(id)root nodeName:(NSString*)nodeName {
    if( root == nil || nodeName == nil ) return nil;
    [self __initCache];
    @synchronized( __bsObjectNodeCache ) {
        //root의 hash값으로 키를 삼아 node dictionary를 잡아준다. 
        NSString *rootKey = [NSString stringWithFormat:@"%d", [root hash]];
        NSMutableDictionary *dicRoot = __bsObjectNodeCache[rootKey];
        if( dicRoot == nil ) {
            dicRoot = [[NSMutableDictionary alloc] init];
            [__bsObjectNodeCache setObject:dicRoot forKey:rootKey];
        }
        //노드가 없으면 노드를 생성한다. 이때 해당 노드의 부모노드도 생성해준다. 
        bsObjectNode *node = dicRoot[nodeName];
        if( node == nil ) {
            NSArray *t0 = [bsStr split:nodeName seperator:@"." trim:YES];
            NSUInteger cnt = [t0 count];
            NSString *propName = t0[ cnt - 1 ];
            bsObjectNode *parent = nil;
            id clazz = nil;
            if( cnt - 1 > 0 ) {
                NSMutableString *parentName = [[NSMutableString alloc] init];
                for ( int i = 0, j = cnt - 1; i < j; i++ ) {
                    [parentName appendString:t0[i]];
                    if( i < j - 1 ) [parentName appendString:@"."];
                }
                parent = [self GWithRoot:root nodeName:[NSString stringWithString:parentName]]; //재귀함수. 부모노드는 모두 생성한다.
                if( parent == nil ) return nil;
                clazz = parent.clazz;
            } else {
                clazz = [root class];
            }
            objc_property_t property = class_getProperty( clazz, [propName UTF8String] );
            if( !property ) return nil;
            Ivar ivar = class_getInstanceVariable( clazz, [[NSString stringWithFormat:@"_%@", propName] UTF8String] );
            if( !ivar ) return nil;
            node = [[bsObjectNode alloc]initWithRoot:root parent:parent nodeName:nodeName propName:propName property:property ivar:ivar];
            dicRoot[nodeName] = node;
        }
        return node;
    }
}
//주의! 외부에서 직접 이 함수로 초기화 하지 말자!
-(id)initWithRoot:(id)root parent:(bsObjectNode*)parent nodeName:(NSString*)nodeName propName:(NSString*)propName property:(objc_property_t)property ivar:(Ivar)ivar  {
    if( self = [super init] ) {
        _root = root;
        _parent = parent;
        _nodeName = nodeName;
        _propName = propName;
        _property = property;
        _ivar = ivar;
        NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( property )];
        NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
        if ( [attrSplit count] > 2) {
            _className = [attrSplit objectAtIndex:1];
            _clazz = NSClassFromString( _className );
        } else {
            _className = nil;
            _clazz = NULL;
        }
        if( [attr rangeOfString:@",R,"].location != NSNotFound ) {
            _readonly = YES;
        }
    }
    return self;
}
-(NSArray*)setValue:(id)value {
    if( value == self.value ) return nil;
    @synchronized( self ) {
        id parentValue = self.parent == nil ? self.root : self.parent.value;
        if( parentValue ) {
            object_setIvar( parentValue, self.ivar, value );
            _value = value;
            //부모가 바뀌었으니 자식값은 당연히 초기화 처리 한다.
            NSString *rootKey = [NSString stringWithFormat:@"%d", [self.root hash]];
            NSMutableDictionary *dicRoot = __bsObjectNodeCache[rootKey];
            if( dicRoot == nil ) {
                dicRoot = [[NSMutableDictionary alloc] init];
                [__bsObjectNodeCache setObject:dicRoot forKey:rootKey];
            }
            NSString *prefix = [NSString stringWithFormat:@"%@.", self.nodeName];
            NSMutableArray *changedNodeNames = [[NSMutableArray alloc]init];
            [dicRoot enumerateKeysAndObjectsUsingBlock:^(NSString *key, bsObjectNode *node, BOOL *stop) {
                if( [node.nodeName hasPrefix:prefix] ) {
                    Ivar nodeIvar = class_getInstanceVariable( [node class], [@"_value" UTF8String] );
                    object_setIvar( node, nodeIvar, nil ); //node의 _value를 nil로 셋팅! get을 부를때 다시 셋팅할 수 있도록 한다.
                    [changedNodeNames addObject:node.nodeName];
                }
            }];
            [changedNodeNames addObject:self.nodeName];
            return [[NSArray alloc]initWithArray:changedNodeNames]; //변경된 node이름 집합 반환. 이걸 알아야 Model입장에서 어떤 데이터가 변경되었는지 통보할 수 있다.
        } else {
            _value = nil;
            return @[self.nodeName];
        }
    }
}
-(id)getValue {
    @synchronized( self ) {
        if( self.value == nil ) {
            NSMutableArray *nodes = [[NSMutableArray alloc] init];
            bsObjectNode *node = self;
            [nodes addObject:node];
            while ( 1 ) {
                if( node.parent ) {
                    [nodes addObject:node.parent];
                    node = node.parent;
                } else {
                    break;
                }
            }
            id value = nil;
            Ivar nodeIvar = class_getInstanceVariable( [node class], [@"_value" UTF8String] );
            for (int i = [nodes count]-1; i >= 0; i--) {
                node = nodes[i];
                id parentValue = node.parent == nil ? node.root : node.parent.value;
                value = object_getIvar( parentValue, node.ivar );
                if( value == nil ) break;
                if( value != node.value ) {
                    object_setIvar( node, nodeIvar, value );
                }
            }
        }
        return self.value;
    }
}

//arr[exp]
-(NSArray*)getArrayFromExp:(NSString*)expression {
    
}
//dic[exp]
-(NSDictionary*)getDicFromExp:(NSString*)expression {
    
}
//dic->func()
-(id)getDicFromFunc:(NSString*)funcName {
    
}
//arr->func(), params
-(id)execArrayFromFunc:(NSString*)functionName params:(id)params {
    
}
//dic->func(), params
-(id)exeDicFromFunc:(NSString*)functionName params:(id)params {
    
}

@end

@interface bsObjectNodeCommand : NSObject
@end
@implementation bsObjectNodeCommand
+(bsObjectNodeCommand*)GWithRoot:(id)root command:(NSString*)cmd params:(id)params {
    
}
@end
*/

#pragma mark - bsRuntime 유틸
@interface bsRuntime : NSObject
@end

@implementation bsRuntime
//클래스로부터 클래스 이름을 가져온다.
+(NSString*)stringFromClass:(Class)clazz {
    return NSStringFromClass( clazz );
}
//클래스 이름으로부터 클래스를 가져온다.
+(Class)classFromString:(NSString*)className {
    return NSClassFromString( className );
}
//객체로부터 클래스를 가져온다.
+(Class)classFromObject:(id)object {
    return [object class];
}
//객체로부터 클래스 이름을 가져온다.  
+(NSString*)classNameFromObject:(id)object {
    return NSStringFromClass( [object class] );
}
//객체의 프로퍼티의 클래스를 가져온다. 
+(Class)getPropClassOfObject:(id)object key:(NSString*)key {
    return [self getPropClassOfClass:[object class] key:key];
}
//클래스의 프로퍼티의 클래스를 가져온다. 
+(Class)getPropClassOfClass:(Class)clazz key:(NSString*)key {
    const char *nm = [key UTF8String];
    objc_property_t p0 = class_getProperty( clazz, nm );
    if( p0 == NULL ) {
        return NULL;
    }
    NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( p0 )];
    NSArray *attrSplit = [attr componentsSeparatedByString:@"\""]; //"T@"NSString",R,V_test"에서 NSString만 추출해야 한다.
    NSString *className = nil;
    if ([attrSplit count] >= 2) {
        className = [attrSplit objectAtIndex:1];
    }
    if( className == nil ) return NULL;
    return NSClassFromString( className );
}
//기반객체로부터 keyPath에 해당하는 속성의 클래스를 얻어온다.
+(Class)getPropClassOfRootObject:(id)object keyPath:(NSString*)keyPath {
    return [self getPropClassOfRootClass:[object class] keyPath:keyPath];
}
//기반클래스로부터 keyPath에 해당하는 속성의 클래스를 얻어온다.
+(Class)getPropClassOfRootClass:(Class)clazz keyPath:(NSString*)keyPath {
    NSArray *names = [bsStr split:keyPath seperator:@"." trim:NO];
    if( [names count] == 0 ) return NULL;
    __block Class c = clazz;
    [names enumerateObjectsUsingBlock:^(NSString *nm, NSUInteger idx, BOOL *stop) {
        objc_property_t p = class_getProperty(c, [nm UTF8String]);
        if( !p ) {
            *stop = YES;
            return;
        }
        NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( p )];
        NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
        if ( [attrSplit count] < 2) {
            *stop = YES;
            c = NULL;
        }
        NSString *className = [attrSplit objectAtIndex:1];
        c = NSClassFromString( className );
    }];
    return c;
}
//클래스의 프로퍼티 이름을 배열로 가져온다. superInquiry는 해당클래스의 부모클래스 프로퍼티도 탐색할 것인지 결정하는 플래그다.
+(NSArray*)getPropNamesOfClass:(Class)clazz superInquiry:(BOOL)superInquiry{
    if( clazz == NULL || clazz == [NSObject class] ) {
        return nil;
    }
    NSMutableArray *r = [[NSMutableArray alloc] init];
    unsigned int count, i;
    objc_property_t *ps = class_copyPropertyList( clazz, &count );
    for( i = 0; i < count; i++ ) {
        objc_property_t p = ps[i];
        const char *pn = property_getName( p );
        if( pn ) {
            [r addObject:[NSString stringWithUTF8String:pn]];
        }
    }
    free( ps );
    if( superInquiry ) {
        NSArray *sr = [self getPropNamesOfClass:[clazz superclass] superInquiry:YES];
        if( sr != nil ) [r addObjectsFromArray:sr];
    }
    return [NSArray arrayWithArray:r];
}
//객체에서 주어진 이름을 가진 프로퍼티의 값을 가져온다. 
+(id)getPropValueOfObject:(id)object keyPath:(NSString*)keyPath {
    NSArray *t0 = [bsStr split:keyPath seperator:@"." trim:NO];
    if( [t0 count] > 0 ) {
        __block id t00 = object;
        [t0 enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            Ivar ivar = class_getInstanceVariable([t00 class], [[NSString stringWithFormat:@"_%@", name] UTF8String]);
            t00 = object_getIvar( t00, ivar );
            if( t00 == nil ) *stop = YES;
        }];
        return t00;
    }
    return nil;
}
//객체에서 주어진 이름을 가진 프로퍼티의 값을 셋팅한다.(KVO, KVC에 적용안됨)
+(void)setPropValueOfObject:(id)object keyPath:(NSString*)keyPath value:(id)value {
    NSArray *t0 = [bsStr split:keyPath seperator:@"." trim:NO];
    if( [t0 count] > 0 ) {
        id t00 = object;
        Ivar ivar = nil;
        int i = 0, j = [t0 count];
        while( 1 )  {
            ivar = class_getInstanceVariable([t00 class], [[NSString stringWithFormat:@"_%@", t0[i]] UTF8String]);
            if( ++i < j ) {
                t00 = object_getIvar( t00, ivar );
                if( t00 == nil ) break;
            } else {
                break;
            }
        }
        object_setIvar( t00, ivar, value );
    }
}
//객체에서 주어진 이름의 프로퍼티를 가지고 있는가?
+(BOOL)hasPropAtObject:(id)object keyPath:(NSString*)keyPath {
    return [self hasPropAtClass:[object class] keyPath:keyPath];
}
//클래스에서 주어진 이름의 프로퍼티를 가지고 있는가?
+(BOOL)hasPropAtClass:(Class)clazz keyPath:(NSString*)keyPath {
    //clazz와 name으로 캐싱필요!
    NSArray *names = [bsStr split:keyPath seperator:@"." trim:NO];
    if( [names count] == 0 ) return NO;
    __block Class c = clazz;
    __block BOOL has = NO;
    NSUInteger maxIdx = [names count] - 1;
    [names enumerateObjectsUsingBlock:^(NSString *nm, NSUInteger idx, BOOL *stop) {
        objc_property_t p = class_getProperty(c, [nm UTF8String]);
        if ( !p ) {
            has = NO;
            *stop = YES;
            return;
        }
        if( idx == maxIdx ) {
            has = YES;
            return;
        }
        NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( p )];
        NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
        if ( [attrSplit count] < 2) {
            has = NO;
            *stop = YES;
            return;
        }
        NSString *className = [attrSplit objectAtIndex:1];
        c = NSClassFromString( className );
    }];
    return has;
}
/*
+(id)execCommandWithRoot:(id)root commands:(NSArray*)commands getKey:(NSString*)key {
    [commands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        //[self k:key v:obj];
    }];
    if( key ) {
        //return [self g:key];
    }
    return nil;
}
*/

/*
 클래스로 동적으로 객체생성
 속성 동적으로 설정 및 삭제 
 메서드 동적으로 설정 및 삭제
 속성리스트
 메서드 리스트 
 동적으로 메서드 실행 
 */
 
@end