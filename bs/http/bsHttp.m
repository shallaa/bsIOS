//
//  bsHttp.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsHttp.h"

#import "bsLog.h"
#import "bsStr.h"
#import "bsWorker.h"
#import "bsError.h"
#import "bsHttpFile.h"
#import "bsHttpQueue.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSUInteger __bsHttp_httpKey = 0;

@interface bsHttp ()

@end

@implementation bsHttp

+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *key = [NSString stringWithFormat:@"bsHttpKey=%lu", (unsigned long)__bsHttp_httpKey++];
    [bsHttp sendWithkey:key url:url get:get post:post file:file end:end];
    return key;
}

+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file endBlock:(bsCallbackBlock)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *key = [NSString stringWithFormat:@"bsHttpKey=%lu", (unsigned long)__bsHttp_httpKey++];
    [bsHttp sendWithkey:key url:url get:get post:post file:file end:end];
    return key;
}

+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *key = [NSString stringWithFormat:@"bsHttpKey=%lu", (unsigned long)__bsHttp_httpKey++];
    [bsHttp sendWithkey:key url:url get:get post:post file:file target:target selector:selector];
    return key;
}

+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [bsWorker A:[bsHttpQueue GWithKey:key url:url get:get post:post file:file end:end]];
}

+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file endBlock:(bsCallbackBlock)end {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [bsWorker A:[bsHttpQueue GWithKey:key url:url get:get post:post file:file end:[bsCallback GWithBlock:end]]];
}

+ (void)sendWithkey:(NSString *)key url:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [bsWorker A:[bsHttpQueue GWithKey:key url:url get:get post:post file:file end:[bsCallback GWithTarget:target selector:selector]]];
}

+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file error:(bsError **)error {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [bsHttpQueue sendWithUrl:url get:get post:post file:file error:error];
}

+ (void)cancel:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [bsWorker D:key];
}

+ (NSString *)ipAddr {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    //http://stackoverflow.com/questions/7072989/iphone-ipad-how-to-get-my-ip-address-programmatically
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                bsLog(nil, bsLogLevelDebug, @"name:%@, addr:%@", name, addr); // see for yourself
                if ([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else {
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

@end
