//
//  bsGeometry.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsGeometry.h"

@implementation bsPoint

+ (bsPoint *)G:(CGPoint)val {
    
    return [[bsPoint alloc] initWithValue:val];
}

- (id)initWithValue:(CGPoint)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

/*
 static NSMutableArray *__bsPoint_pool = nil;
 +(bsPoint*)pop:(CGPoint)val {
 @synchronized( __bsPoint_pool ) {
 if( __bsPoint_pool == nil ) {
 __bsPoint_pool = [[NSMutableArray alloc] init];
 }
 bsPoint *result;
 if( [__bsPoint_pool count] > 0 ) {
 result = [__bsPoint_pool lastObject];
 [__bsPoint_pool removeLastObject];
 } else {
 result = [[bsPoint alloc] init];
 }
 [result s:val];
 return result;
 }
 }
 +(void)put:(bsPoint*)val {
 @synchronized( __bsPoint_pool ) {
 if( __bsPoint_pool == nil ) {
 __bsPoint_pool = [[NSMutableArray alloc] init];
 }
 [__bsPoint_pool addObject:val];
 }
 }
 -(void)s:(CGPoint)val {
 _val = val;
 }
 */

- (CGPoint)g {
    
    return _val;
}

- (float)x {
    
    return _val.x;
}

- (float)y {
    
    return _val.x;
}

- (NSString *)str {
    
    return [self description];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%f|%f", self.x, self.y];
}

@end


@implementation bsSize

+ (bsSize *)G:(CGSize)val {
    
    return [[bsSize alloc] initWithValue:val];
}

- (id)initWithValue:(CGSize)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}
/*
 static NSMutableArray *__bsSize_pool = nil;
 +(bsSize*)pop:(CGSize)val {
 @synchronized( __bsSize_pool ) {
 if( __bsSize_pool == nil ) {
 __bsSize_pool = [[NSMutableArray alloc] init];
 }
 bsSize *result;
 if( [__bsSize_pool count] > 0 ) {
 result = [__bsSize_pool lastObject];
 [__bsSize_pool removeLastObject];
 } else {
 result = [[bsSize alloc] init];
 }
 [result s:val];
 return result;
 }
 }
 +(void)put:(bsSize*)val {
 @synchronized( __bsSize_pool ) {
 if( __bsSize_pool == nil ) {
 __bsSize_pool = [[NSMutableArray alloc] init];
 }
 [__bsSize_pool addObject:val];
 }
 }
 -(void)s:(CGSize)val {
 _val = val;
 }
 */

- (CGSize)g {
    
    return _val;
}

- (float)w {
    
    return _val.width;
}

- (float)h {
    
    return _val.height;
}

- (NSString *)str {
    
    return [self description];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%f|%f", self.w, self.h];
}

@end


@implementation bsRect

+ (bsRect *)G:(CGRect)val {
    
    return [[bsRect alloc] initWithValue:val];
}

- (id)initWithValue:(CGRect)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

/*
 static NSMutableArray *__bsRect_pool = nil;
 +(bsRect*)pop:(CGRect)val {
 @synchronized( __bsRect_pool ) {
 if( __bsRect_pool == nil ) {
 __bsRect_pool = [[NSMutableArray alloc] init];
 }
 bsRect *result;
 if( [__bsRect_pool count] > 0 ) {
 result = [__bsRect_pool lastObject];
 [__bsRect_pool removeLastObject];
 } else {
 result = [[bsRect alloc] init];
 }
 [result s:val];
 return result;
 }
 }
 +(void)put:(bsRect*)val {
 @synchronized( __bsRect_pool ) {
 if( __bsRect_pool == nil ) {
 __bsRect_pool = [[NSMutableArray alloc] init];
 }
 [__bsRect_pool addObject:val];
 }
 }
 -(void)s:(CGRect)val {
 _val = val;
 }
 */

- (CGRect)g {
    
    return _val;
}

- (float)x {
    return _val.origin.x;
}

- (float)y {
    
    return _val.origin.x;
}
- (float)w {

    return _val.size.width;
}

- (float)h {
    return _val.size.height;
}

- (NSString *)str {
    
    return [self description];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%f|%f|%f|%f", self.x, self.y, self.w, self.h];
}

@end


@implementation bsEdgeInsets

+ (bsEdgeInsets *)G:(UIEdgeInsets)val {
    
    return [[bsEdgeInsets alloc] initWithValue:val];
}

- (id)initWithValue:(UIEdgeInsets)val {
    
    if( self = [super init] ) {
        _val = val;
    }
    return self;
}

/*
 static NSMutableArray *__bsEdgeInsets_pool = nil;
 +(bsEdgeInsets*)pop:(UIEdgeInsets)val {
 @synchronized( __bsEdgeInsets_pool ) {
 if( __bsEdgeInsets_pool == nil ) {
 __bsEdgeInsets_pool = [[NSMutableArray alloc] init];
 }
 bsEdgeInsets *result;
 if( [__bsEdgeInsets_pool count] > 0 ) {
 result = [__bsEdgeInsets_pool lastObject];
 [__bsEdgeInsets_pool removeLastObject];
 } else {
 result = [[bsEdgeInsets alloc] init];
 }
 [result s:val];
 return result;
 }
 }
 +(void)put:(bsEdgeInsets*)val {
 @synchronized( __bsEdgeInsets_pool ) {
 if( __bsEdgeInsets_pool == nil ) {
 __bsEdgeInsets_pool = [[NSMutableArray alloc] init];
 }
 [__bsEdgeInsets_pool addObject:val];
 }
 }
 -(void)s:(UIEdgeInsets)val {
 _val = val;
 }
 */

- (UIEdgeInsets)g {
    
    return _val;
}

- (float)top {
    
    return _val.top;
}

- (float)right {
    
    return _val.right;
}

- (float)bottom {
    
    return _val.bottom;
}

- (float)left {
    
    return _val.left;
}

- (NSString *)str {
    
    return [self description];
}

 -(NSString *)description {
    
    return [NSString stringWithFormat:@"%f|%f|%f|%f", self.top, self.right, self.bottom, self.left];
}

@end
