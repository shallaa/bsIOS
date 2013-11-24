#import <Foundation/Foundation.h>

/*
 bsObj *obj = [bsObj pop:NO];
 [obj set:@"k":@"v"];
 NSAssert( [[obj get:@"k"] isEqualToString:@"v"], @"k키에 대한 값은 v이어야 한다." );
 [obj del:@"k"];
 NSAssert( [obj get:@"k"] == nil, @"k키에 대한 값은 nil이어야 한다." );
 [obj set:@"k2":@"v2"];
 NSAssert( [[obj get:@"k2"] isEqualToString:@"v2"], @"k2에 대한 값은 v2여야 한다." );
 [obj del];
 NSAssert( [obj get:@"k2"] == nil, @"k키에 대한 값은 nil이어야 한다." );
 [bsObj put:obj];
 */


@class bsObj;
@class bsObjSync;

@interface bsObj : NSObject {
@protected
    NSMutableDictionary *_data;
}
@end

@interface bsObjSync : bsObj
@end

@implementation bsObj
static NSMutableArray *__bsObj_pool = nil;
static NSMutableArray *__bsObj_poolSync = nil;
+(bsObj*)pop:(BOOL)isSync {
    if( isSync ) {
        @synchronized( __bsObj_poolSync ) {
            if( __bsObj_poolSync == nil ) {
                __bsObj_poolSync = [[NSMutableArray alloc] init];
            }
            if( [__bsObj_poolSync count] > 0 ) {
                id object = [__bsObj_poolSync lastObject];
                [__bsObj_poolSync removeLastObject];
                return object;
            } else {
                return [[bsObjSync alloc] init];
            }
        }
    } else {
        @synchronized( __bsObj_pool ) {
            if( __bsObj_pool == nil ) {
                __bsObj_pool = [[NSMutableArray alloc] init];
            }
            if( [__bsObj_pool count] > 0 ) {
                id object = [__bsObj_pool lastObject];
                [__bsObj_pool removeLastObject];
                return object;
            } else {
                return [[bsObj alloc] init];
            }
        }
    }
}
+(void)put:(bsObj*)target {
    [target d];
    if( [target isMemberOfClass:[bsObjSync class]] ) {
        @synchronized( __bsObj_poolSync ) {
            if( __bsObj_poolSync == nil ) {
                __bsObj_poolSync = [[NSMutableArray alloc] init];
            }
            [__bsObj_poolSync addObject:target];
        }
    } else {
        @synchronized( __bsObj_pool ) {
            if( __bsObj_pool == nil ) {
                __bsObj_pool = [[NSMutableArray alloc] init];
            }
            [__bsObj_pool addObject:target];
        }
    }
}
-(id)init {
    if( self = [super init]) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)dealloc {
     _data = nil;
}
-(void)k:(NSString*)key v:(NSString*)value {
    [_data setObject:[value copy] forKey:key];
}
-(NSString*)g:(NSString*)$key {
    return (NSString*)[_data objectForKey:$key];
}
-(void)d {
    [_data removeAllObjects];
}
-(void)d:(NSString*)key {
    [_data removeObjectForKey:key];
}
@end

@implementation bsObjSync
-(void)k:(NSString*)key v:(NSString*)value {
    @synchronized( _data ) {
        [_data setObject:[value copy] forKey:key];
    }
}
-(NSString*)g:(NSString*)key {
    @synchronized( _data ) {
        return (NSString*)[_data objectForKey:key];
    }
}
-(void)d {
    @synchronized( _data ) {
        [_data removeAllObjects];
    }
}
-(void)d:(NSString*)key {
    @synchronized( _data ) {
        [_data removeObjectForKey:key];
    }
}
@end
