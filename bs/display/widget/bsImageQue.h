#import "bsQue.h"
#import "bsCallback.h"

@class bsSize;

@interface bsImageQue : bsQue {
    
@private
    NSString *src_;
    bsSize *cacheSize_;
}

+ (bsImageQue *)GWithKey:(NSString *)key src:(NSString *)src cacheSize:(bsSize *)cacheSize end:(bsCallbackBlock)end;
- (void)__setWithSrc:(NSString *)src cacheSize:(bsSize *)cacheSize;
- (void)clear;
- (void)runWithData:(id *)data error:(bsError **)error;

@end
