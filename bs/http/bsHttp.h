#import <Foundation/Foundation.h>
#import "bsCallback.h"

@class bsError;
@class bsHttpFile;

@interface bsHttp : NSObject

+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end;
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file endBlock:(bsCallbackBlock)end;
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector;
+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end;
+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file endBlock:(bsCallbackBlock)end;
+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector;
+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file error:(bsError **)error;
+ (void)cancel:(NSString *)key;
+ (NSString *)ipAddr;

@end
