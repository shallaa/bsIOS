#import <Foundation/Foundation.h>
#import "bsQueue.h"

@class bsHttpFile;

/*
#define BOUNDARY       @"-----------------bs-----"
#define UTF8           @"UTF-8"
#define CGI            @"?"
#define BMARK          @"#"
#define GLUE0          @"="
#define GLUE1          @"&"
#define CONNECTION     @"Connection"
#define KEEPALIVE      @"Keep-Alive"
#define GZIP0          @"Accept-Encoding"
#define GZIP1          @"gzip"
#define GZIP2          @"Content-Encoding"
#define POST           @"POST"
#define GET            @"GET"
#define CONTENT_TYPE   @"Content-Type"
#define MULTIPART      @"multipart/form-data, boundary="
#define FORM           @"application/x-www-form-urlencoded"
#define OCTET          @"Content-Type: application/octet-stream"
#define DISP0          @"Content-Disposition: form-data; name=\""
#define DISP1          @"\"; filename=\""
#define DISP2          @"\""
#define CONTENT_LENGTH @"Content-Length"
#define TIMEOUT        10
*/

@interface bsHttpQueue : bsQueue

+ (bsHttpQueue *)GWithKey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end;
- (id)run:(bsError **)error;
- (void)clear;
+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file error:(bsError **)error;

@end



