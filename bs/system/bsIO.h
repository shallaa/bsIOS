#import <Foundation/Foundation.h>

@interface bsIO : NSObject

+ (void)onCreate;

#pragma mark - asset
+(NSString *)__assetPath:(NSString *)name;
+(NSData *)assetG:(NSString *)name;

#pragma mark - storage
+(NSString *)__storagePath:(NSString *)name;
+(BOOL)__checkStoragePath:(NSString *)name;
+(NSData *)storageG:(NSString *)name;
+(BOOL)storageS:(NSString *)name data:(NSData *)data;
+(BOOL)storageD:(NSString *)name;

#pragma mark - cache
+(NSString *)__cachePath:(NSString *)name;
+(BOOL)__checkCachePath:(NSString *)name;
+(NSData *)cacheG:(NSString *)name;
+(BOOL)cacheS:(NSString *)name data:(NSData *)data;
+(BOOL)cacheD:(NSString *)name;

@end
