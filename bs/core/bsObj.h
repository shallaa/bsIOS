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

@interface bsObj : NSObject {
    
@protected
    NSMutableDictionary *_data;
}

+ (bsObj *)pop:(BOOL)isSync;
+ (void)put:(bsObj*)target;
- (void)k:(NSString *)key v:(NSString *)value;
- (NSString *)g:(NSString *)key;
- (void)d;
- (void)d:(NSString *)key;

@end

@interface bsObjSync : bsObj

- (void)k:(NSString *)key v:(NSString *)value;
- (NSString *)g:(NSString *)key;
- (void)d;
- (void)d:(NSString *)key;

@end
