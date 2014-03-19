#import <Foundation/Foundation.h>
#import <objc/message.h>

@class bsError;

typedef void (^bsCallbackBlock)(NSString *key, id data, bsError *error);

@interface bsCallback : NSObject {
    
@private
    id __weak _target;
    SEL _selector;
    bsCallbackBlock block_;
}

+ (bsCallback *)GWithBlock:(bsCallbackBlock)callbackBlock;
+ (bsCallback *)GWithTarget:(id)target selector:(SEL)selector;
- (id)initWithBlock:(bsCallbackBlock)callbackBlock;
- (id)initWithTarget:(id)target selector:(SEL)selector;
- (void)callbackWithKey:(NSString *)key data:(id)data error:(bsError *)error;

@end
