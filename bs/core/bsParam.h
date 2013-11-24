#pragma mark - bsParam
@interface bsParam : NSObject
@end
@implementation bsParam
static NSMutableDictionary *__bsParam_dic = nil;
+(NSString*)G:(NSString*)key {
    if( __bsParam_dic == nil ) {
        bsException( @"key(=%@) is undefined", key );
    }
    @synchronized( __bsParam_dic ) {
        NSString *params = __bsParam_dic[key];
        if( params == nil ) {
            bsException( @"key(=%@) is undefined", key );
        }
        return params;
    }
}
+(void)A:(NSString*)key params:(NSString*)params {
    if( key == nil || params == nil ) {
        bsException( @"key or params is null" );
    }
    @synchronized( __bsParam_dic ) {
        if( __bsParam_dic == nil ) {
            __bsParam_dic = [[NSMutableDictionary alloc]init];
        }
        if( __bsParam_dic[key] ) {
            bsException( @"Already this key(=%@) is defined", key );
        }
        __bsParam_dic[key] = params;
    }
}
@end
