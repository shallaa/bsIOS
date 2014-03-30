#import <Foundation/Foundation.h>

@interface bsError : NSObject

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *functionName;
@property (nonatomic, strong, readonly) id data;
@property (nonatomic, readonly) NSUInteger line;

+ (bsError *)popWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line;
+ (void)put:(bsError *)error;
+ (BOOL)isError:(id)data;
- (void)setWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line;
- (NSString *)str;

@end
