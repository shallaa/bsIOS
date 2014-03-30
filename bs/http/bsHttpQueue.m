//
//  bsHttpQueue.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsHttpQueue.h"

#import "bsError.h"
#import "bsHttpFile.h"
#import "bsMacro.h"
#import "bsStr.h"

@interface bsHttpQueue ()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *get;
@property (nonatomic, strong) NSDictionary *post;
@property (nonatomic, strong) bsHttpFile *file;

@end

@implementation bsHttpQueue

+ (bsHttpQueue *)GWithKey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end {
    
    bsHttpQueue *queue = (bsHttpQueue *)[bsQueue GWithClassName:@"bsHttpQueue" key:key end:end];
    queue.url = url;
    queue.get = get;
    queue.post = post;
    queue.file = file;
    return queue;
}

- (id)run:(bsError **)error {
    
    return [bsHttpQueue sendWithUrl:_url get:_get post:_post file:_file error:error];
}

- (void)clear {
    
    self.url = nil;
    self.get = nil;
    self.post = nil;
    self.file = nil;
    [super clear];
}

+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file error:(bsError **)error {
    
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
        if (get) {
            NSMutableString *str = [[NSMutableString alloc] init];
            if ([url rangeOfString:BMARK].length > 0) {
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
                if ([obj isKindOfClass:[NSString class]]) {
                } else {
                    obj = [bsStr str:obj];
                }
                [str appendString:[bsStr urlEncode:obj]];
                if (i < j - 1) [str appendString:GLUE1];
                i++;
            }];
            if (book) {
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
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:TIMEOUT];
        [request setValue:KEEPALIVE forHTTPHeaderField:CONNECTION];
        if (post || file) {
            [request setHTTPMethod:POST];
        } else {
            [request setHTTPMethod:GET];
        }
        [request setValue:GZIP1 forHTTPHeaderField:GZIP0];
        if (file && [file c] > 0) {
            [request setValue:[NSString stringWithFormat:@"%@%@", MULTIPART, BOUNDARY] forHTTPHeaderField:CONTENT_TYPE];
            NSData *crlf =[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
            NSData *boundary = [[NSString stringWithFormat:@"--%@", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp0 = [DISP0 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp1 = [DISP1 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *disp2 = [DISP2 dataUsingEncoding:NSUTF8StringEncoding];
            NSData *octet = [OCTET dataUsingEncoding:NSUTF8StringEncoding];
            if (post) {
                [post enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                    [body appendData:boundary];
                    [body appendData:crlf];
                    [body appendData:disp0];
                    [body appendData:[key dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:disp2];
                    [body appendData:crlf];
                    [body appendData:crlf];
                    if ([obj isKindOfClass:[NSString class]]) {
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
        } else if (post) {
            [request setValue:FORM forHTTPHeaderField:CONTENT_TYPE];
            NSMutableString *bodyStr = [[NSMutableString alloc] init];
            __block NSInteger i, j;
            i = 0;
            j = [post count];
            [post enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [bodyStr appendString:[bsStr urlEncode:key]];
                [bodyStr appendString:GLUE0];
                if ([obj isKindOfClass:[NSString class]]) {
                    [bodyStr appendString:[bsStr urlEncode:obj]];
                } else {
                    [bodyStr appendString:[bsStr urlEncode:[bsStr str:obj]]];
                }
                if (i < j - 1) [bodyStr appendString:GLUE1];
                i++;
            }];
            [body appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        if (file) {
            [bsHttpFile put:file];
        }
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:CONTENT_LENGTH];
        [request setHTTPBody:body];
        returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        if (!err) {
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
