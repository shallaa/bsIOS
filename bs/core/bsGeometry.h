#import <Foundation/Foundation.h>

//아직 불안정하다. 왜냐하면 retain/release가 애매하기 때문이다. 

@interface bsPoint : NSObject {
    
@private
    CGPoint _val;
}

@property (readonly, getter = x) float x;
@property (readonly, getter = y) float y;
@property (readonly, getter = g) CGPoint g;

+ (bsPoint *)G:(CGPoint)val;
- (id)initWithValue:(CGPoint)val;
- (CGPoint)g;
- (float)x;
- (float)y;
- (NSString *)str;

@end


@interface bsSize : NSObject {
    
@private
    CGSize _val;
}

@property (readonly, getter = w) float w;
@property (readonly, getter = h) float h;
@property (readonly, getter = g) CGSize g;

+ (bsSize *)G:(CGSize)val;
- (id)initWithValue:(CGSize)val;
- (CGSize)g;
- (float)w;
- (float)h;
- (NSString *)str;

@end


@interface bsRect : NSObject {
    
@private
    CGRect _val;
}

@property (readonly, getter = x) float x;
@property (readonly, getter = y) float y;
@property (readonly, getter = w) float w;
@property (readonly, getter = h) float h;
@property (readonly, getter = g) CGRect g;

+ (bsRect *)G:(CGRect)val;
- (id)initWithValue:(CGRect)val;
- (CGRect)g;
- (float)x;
- (float)y;
- (float)w;
- (float)h;
- (NSString *)str;

@end


@interface bsEdgeInsets : NSObject {
    
@private
    UIEdgeInsets _val;
}

@property (readonly, getter = top) float top;
@property (readonly, getter = left) float left;
@property (readonly, getter = bottom) float bottom;
@property (readonly, getter = right) float right;
@property (readonly, getter = g) UIEdgeInsets g;

+ (bsEdgeInsets *)G:(UIEdgeInsets)val;
- (id)initWithValue:(UIEdgeInsets)val;
- (UIEdgeInsets)g;
- (float)top;
- (float)right;
- (float)bottom;
- (float)left;
- (NSString *)str;

@end
