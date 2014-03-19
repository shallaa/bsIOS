#import <Foundation/Foundation.h>

@interface bsError : NSObject {
    
    NSString *_func;
    NSUInteger _line;
    NSString *_msg;
    id _data;
}

@property (weak, nonatomic, readonly, getter=msg) NSString *msg;
@property (weak, nonatomic, readonly, getter=func) NSString *func;
@property (weak, nonatomic, readonly, getter=data) id data;
@property (nonatomic, readonly, getter=line) NSUInteger line;

+ (bsError *)popWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line;
+ (void)put:(bsError *)error;
+ (BOOL)isError:(id)data;
- (void)setWithMsg:(NSString *)msg data:(id)data func:(const char *)func line:(unsigned int)line;
- (NSString *)msg;
- (NSString *)func;
- (NSUInteger)line;
- (id)data;
- (NSString *)str;

@end
