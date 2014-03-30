#import "bsQueue.h"
#import "bsCallback.h"

@class bsSize;

@interface bsImageQueue : bsQueue {
    
@private
    NSString *src_;
    bsSize *cacheSize_;
}

+ (bsImageQueue *)GWithKey:(NSString *)key src:(NSString *)src cacheSize:(bsSize *)cacheSize end:(bsCallbackBlock)end;
- (void)__setWithSrc:(NSString *)src cacheSize:(bsSize *)cacheSize;
- (void)clear;
- (id)run:(bsError **)error;

@end
