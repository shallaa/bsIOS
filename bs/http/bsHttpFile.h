#import <Foundation/Foundation.h>
#import "bsMacro.h"

#pragma mark - bsHttpFile interface
@interface bsHttpFile :NSObject {
@private
    NSMutableDictionary *_files;
}
+(bsHttpFile*)pop;
+(void)put:(bsHttpFile*)httpFiles;
-(void)sWithKey:(NSString*)key name:(NSString*)name data:(NSData*)data;
-(void)loop:(void (^)(NSString *key, NSString *name, NSData *data))block;
-(NSUInteger)c; //cancel
-(void)d; //delete
@end

#pragma mark - bsHttpFile implementation
@implementation bsHttpFile
static NSMutableArray *__bsHttpFile_pool = nil;
+(bsHttpFile*)pop {
    @synchronized( __bsHttpFile_pool ) {
        if( __bsHttpFile_pool == nil ) {
            __bsHttpFile_pool = [[NSMutableArray alloc]init];
        }
        bsHttpFile *r;
        if( [__bsHttpFile_pool count] > 0 ) {
            r = [__bsHttpFile_pool lastObject];
            [__bsHttpFile_pool removeLastObject];
        } else {
            r = [[bsHttpFile alloc] init];
        }
        return r;
    }
}
+(void)put:(bsHttpFile*)httpFiles {
    if( httpFiles == nil ) return;
    @synchronized( __bsHttpFile_pool ) {
        if( __bsHttpFile_pool == nil ) {
            __bsHttpFile_pool = [[NSMutableArray alloc] init];
        }
        [httpFiles d];
        [__bsHttpFile_pool addObject:httpFiles];
    }
}
-(void)sWithKey:(NSString*)key name:(NSString*)name data:(NSData*)data {
    if( key == nil ) bsException( @"key is nil" );
    if( name == nil ) bsException( @"name is nil" );
    if( data == nil ) bsException( @"data is nil" );
    @synchronized( _files ) {
        if( _files == nil ) {
            _files = [[NSMutableDictionary alloc]init];
        }
        _files[key] = @{@"name": [name copy], @"data": data};
    }
}
-(void)loop:(void (^)(NSString *key, NSString *name, NSData *data))block {
    @synchronized( _files ) {
        [_files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if( block ) block( key, obj[@"name"], obj[@"data"] );
        }];
    }
}
-(NSUInteger)c {
    @synchronized( _files ) {
        if( _files ) {
            return [_files count];
        }
    }
    return 0;
}
-(void)d {
    @synchronized( _files ) {
        [_files removeAllObjects];
    }
}
@end