#import <Foundation/Foundation.h>

@interface bsHttpFile :NSObject {
    
@private
    NSMutableDictionary *_files;
}

+ (bsHttpFile *)pop;
+ (void)put:(bsHttpFile *)httpFiles;
- (void)sWithKey:(NSString *)key name:(NSString *)name data:(NSData *)data;
- (void)loop:(void (^)(NSString *key, NSString *name, NSData *data))block;
- (NSUInteger)c; //cancel
- (void)d; //delete

@end
