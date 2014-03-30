#import <Foundation/Foundation.h>

@class bsQueue;

@interface bsWorker : NSObject

+ (void)A:(bsQueue *)queue;
+ (void)D:(NSString *)queKey;

@end
