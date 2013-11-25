#import <Foundation/Foundation.h>
#import "bsMacro.h"

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
#pragma mark - bsHttpQue interface
@interface bsHttpQue : bsQue {
@private
    NSString *_url;
    NSDictionary *_get;
    NSDictionary *_post;
    bsHttpFile *_file;
}
@end

#pragma mark - bsHttpQue implementation
@implementation bsHttpQue
+(bsHttpQue*)GWithKey:(NSString*)key url:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post file:(bsHttpFile*)file end:(bsCallback*)end {
    bsHttpQue *que = (bsHttpQue*)[bsQue GWithClassName:@"bsHttpQue" key:key end:end];
    [que __setWithUrl:url get:get post:post file:file];
    return que;
}
-(void)__setWithUrl:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post file:(bsHttpFile*)file {
    _url = url;
    _get = get;
    _post = post;
    _file = file;
}
-(void)runWithData:(id*)data error:(bsError**)error {
    *data = [bsHttpQue sendWithUrl:_url get:_get post:_post file:_file error:error];
}
-(void)clear {
    _url = nil;
    _get = nil;
    _post = nil;
    _file = nil;
    [super clear];
}
+(NSData*)sendWithUrl:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post file:(bsHttpFile*)file error:(bsError**)error {
    static NSString *const BOUNDARY =      @"-----------------bs-----";
    //static NSString *const UTF8 =          @"UTF-8";
    static NSString *const CGI =           @"?";
    static NSString *const BMARK =         @"#";
    static NSString *const GLUE0 =         @"=";
    static NSString *const GLUE1 =         @"&";
    static NSString *const CONNECTION =    @"Connection";
    static NSString *const KEEPALIVE =     @"Keep-Alive";
    static NSString *const GZIP0 =         @"Accept-Encoding";
    static NSString *const GZIP1 =         @"gzip";
    //static NSString *const GZIP2 =         @"Content-Encoding";
    static NSString *const POST =          @"POST";
    static NSString *const GET =           @"GET";
    static NSString *const CONTENT_TYPE =  @"Content-Type";
    static NSString *const MULTIPART =     @"multipart/form-data, boundary=";
    static NSString *const FORM =          @"application/x-www-form-urlencoded";
    static NSString *const OCTET =         @"Content-Type: application/octet-stream";
    static NSString *const DISP0 =         @"Content-Disposition: form-data; name=\"";
    static NSString *const DISP1 =         @"\"; filename=\"";
    static NSString *const DISP2 =         @"\"";
    static NSString *const CONTENT_LENGTH = @"Content-Length";
    static const int TIMEOUT =       10;
    
    NSString *book = nil;
    *error = nil;
    @try {
        if( get != nil ) {
            NSMutableString *str = [[NSMutableString alloc] init];
            if( [url rangeOfString:BMARK].length > 0 ) {
                NSArray *urlMark = [bsStr split:url seperator:BMARK trim:YES];
                url = urlMark[0];
                book = urlMark[1];
            }
            [str appendString:url];
            [str appendString:CGI];
            __block NSInteger i, j;
            i = 0;
            j = [get count];
            [get enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
                [str appendString:[bsStr urlEncode:key]];
                [str appendString:GLUE0];
                if( [obj isKindOfClass:[NSString class]] ) {} else {
                    obj = [bsStr str:obj];
                }
                [str appendString:[bsStr urlEncode:obj]];
                if( i < j - 1 ) [str appendString:GLUE1];
                i++;
            }];
            if( book != nil ) {
                [str appendString:BMARK];
                [str appendString:book];
            }
            url = [NSString stringWithString:str];
        }
        NSHTTPURLResponse *response = nil;
        NSError *err = nil;
        NSMutableURLRequest *request;
        NSData *returnData;
        NSMutableData *body = [NSMutableData data];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                          cachePolicy:NSURLRequestReloadIgnoringCacheData
                                      timeoutInterval:TIMEOUT];
        [request setValue:KEEPALIVE forHTTPHeaderField:CONNECTION];
        if( post != nil || file != nil ) {
            [request setHTTPMethod:POST];
        } else {
            [request setHTTPMethod:GET];
        }
        [request setValue:GZIP1 forHTTPHeaderField:GZIP0];
        if( file && [file c] > 0 ) {
            [request setValue:[NSString stringWithFormat:@"%@%@", MULTIPART, BOUNDARY] forHTTPHeaderField:CONTENT_TYPE];
            NSData *crlf =[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
            NSData *boundary = [[NSString stringWithFormat:@"--%@", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp0 = [DISP0 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp1 = [DISP1 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp2 = [DISP2 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *octet = [OCTET dataUsingEncoding:NSUTF8StringEncoding];
            if( post != nil ) {
                [post enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
                    [body appendData:boundary];
                    [body appendData:crlf];
                    [body appendData:disp0];
                    [body appendData:[key dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:disp2];
                    [body appendData:crlf];
                    [body appendData:crlf];
                    if( [obj isKindOfClass:[NSString class]] ) {
                        [body appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
                    } else {
                        [body appendData:[[bsStr str:obj] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    [body appendData:crlf];
                }];
            }
            [file loop:^(NSString *key, NSString *name, NSData *data) {
                [body appendData:boundary];
                [body appendData:crlf];
                [body appendData:disp0];
                [body appendData:[key dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:disp1];
                [body appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:disp2];
                [body appendData:crlf];
                [body appendData:octet];
                [body appendData:crlf];
                [body appendData:crlf];
                [body appendData:data];
                [body appendData:crlf];
            }];
            [body appendData:boundary];
            [body appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:crlf];
            [body appendData:crlf];
            //NSLog(@"%@", [bsStr str:body]);
        } else if( post != nil ) {
            [request setValue:FORM forHTTPHeaderField:CONTENT_TYPE];
            NSMutableString *bodyStr = [[NSMutableString alloc] init];
            __block NSInteger i, j;
            i = 0;
            j = [post count];
            [post enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [bodyStr appendString:[bsStr urlEncode:key]];
                [bodyStr appendString:GLUE0];
                if( [obj isKindOfClass:[NSString class]] ) {
                    [bodyStr appendString:[bsStr urlEncode:obj]];
                } else {
                    [bodyStr appendString:[bsStr urlEncode:[bsStr str:obj]]];
                }
                if( i < j - 1 ) [bodyStr appendString:GLUE1];
                i++;
            }];
            [body appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        if( file ) [bsHttpFile put:file];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:CONTENT_LENGTH];
        [request setHTTPBody:body];
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if ( err == nil ) {
            return returnData;
        } else {
            *error = [bsError popWithMsg:[NSString stringWithFormat:@"%@", err] data:err.userInfo func:__FUNCTION__ line:__LINE__];
            return nil;
        }
    }
    @catch (NSException *e) {
        *error = [bsError popWithMsg:[NSString stringWithFormat:@"[%@]%@", [e name], [e reason]] data:[e userInfo] func:__FUNCTION__ line:__LINE__];
    }
}
@end
