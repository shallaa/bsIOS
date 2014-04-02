//
//  bsPrimitive.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsPrimitive.h"

@implementation bsPrimitive

- (NSString *)str {
    
    return nil;
}

- (NSString *)description {
    
    return [self str];
}

- (NSNumber *)number {
    
    return nil;
}

- (id)clone {
    
    return nil;
}

@end


@implementation bsInt

+ (bsInt *)G:(int)val {
    
    return [[bsInt alloc] initWithValue:val];
}

- (id)initWithValue:(int)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (int)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%d", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithInt:_val];
}

- (id)clone {
    
    return [bsInt G:_val];
}

@end


@implementation bsUInt

+ (bsUInt *)G:(unsigned int)val {
    
    return [[bsUInt alloc] initWithValue:val];
}

- (id)initWithValue:(unsigned int)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (unsigned int)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%u", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedInt:_val];
}

- (id)clone {
    
    return [bsUInt G:_val];
}

@end


@implementation bsShort

+ (bsShort *)G:(short)val {
    
    return [[bsShort alloc] initWithValue:val];
}

- (id)initWithValue:(short)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (short)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%d", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithShort:_val];
}

- (id)clone {
    
    return [bsShort G:_val];
}

@end


@implementation bsUShort

+ (bsUShort *)G:(unsigned short)val {
    
    return [[bsUShort alloc] initWithValue:val];
}

- (id)initWithValue:(unsigned short)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (unsigned short)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%d", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedShort:_val];
}

- (id)clone {
    
    return [bsUShort G:_val];
}

@end


@implementation bsBool

+ (bsBool *)G:(BOOL)val {
    
    return [[bsBool alloc] initWithValue:val];
}

- (id)initWithValue:(BOOL)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (BOOL)g {
    
    return _val;
}

- (NSString *)str {
    
    return _val ? @"true" : @"false";
}

- (NSNumber *)number {
    
    return [NSNumber numberWithBool:_val];
}

- (id)clone {
    
    return [bsBool G:_val];
}

@end


@implementation bsChar

+ (bsChar *)G:(char)val {
    
    return [[bsChar alloc] initWithValue:val];
}

- (id)initWithValue:(char)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (char)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%c", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithChar:_val];
}

- (id)clone {
    
    return [bsChar G:_val];
}

@end


@implementation bsUChar

+ (bsUChar *)G:(unsigned char)val {
    
    return [[bsUChar alloc] initWithValue:val];
}

- (id)initWithValue:(unsigned char)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (unsigned char)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%c", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedChar:_val];
}

- (id)clone {
    
    return [bsUChar G:_val];
}

@end


@implementation bsInteger

+ (bsInteger *)G:(NSInteger)val {
    
    return [[bsInteger alloc] initWithValue:val];
}

- (id)initWithValue:(NSInteger)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (NSInteger)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%ld", (long)_val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithInteger:_val];
}

- (id)clone {
    
    return [bsInteger G:_val];
}

@end


@implementation bsUInteger

+ (bsUInteger *)G:(NSUInteger)val {
    
    return [[bsUInteger alloc] initWithValue:val];
}

- (id)initWithValue:(NSUInteger)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (NSUInteger)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%lu", (unsigned long)_val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedInteger:_val];
}

- (id)clone {
    
    return [bsUInteger G:_val];
}

@end


@implementation bsFloat

+ (bsFloat *)G:(float)val {
    
    return [[bsFloat alloc] initWithValue:val];
}

- (id)initWithValue:(float)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (float)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%f", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithFloat:_val];
}

- (id)clone {
    
    return [bsFloat G:_val];
}

@end


@implementation bsDouble

+ (bsDouble *)G:(double)val {
    
    return [[bsDouble alloc] initWithValue:val];
}

- (id)initWithValue:(double)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (double)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%lf", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithDouble:_val];
}

- (id)clone {
    
    return [bsDouble G:_val];
}

@end


@implementation bsLong

+ (bsLong *)G:(long)val {
    
    return [[bsLong alloc] initWithValue:val];
}

- (id)initWithValue:(long)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (long)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%ld", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithLong:_val];
}

- (id)clone {
    
    return [bsLong G:_val];
}

@end


@implementation bsULong

+ (bsULong *)G:(unsigned long)val {
    
    return [[bsULong alloc] initWithValue:val];
}

- (id)initWithValue:(unsigned long)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (unsigned long)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%lu", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedLong:_val];
}

- (id)clone {
    
    return [bsULong G:_val];
}

@end


@implementation bsLongLong

+ (bsLongLong *)G:(long long)val {
    
    return [[bsLongLong alloc] initWithValue:val];
}

- (id)initWithValue:(long long)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (long long)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%lld", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithLongLong:_val];
}

- (id)clone {
    
    return [bsLongLong G:_val];
}

@end


@implementation bsULongLong

+ (bsULongLong *)G:(unsigned long long)val {
    
    return [[bsULongLong alloc] initWithValue:val];
}

- (id)initWithValue:(unsigned long long)val {
    
    if (self = [super init]) {
        _val = val;
    }
    return self;
}

- (unsigned long long)g {
    
    return _val;
}

- (NSString *)str {
    
    return [NSString stringWithFormat:@"%llu", _val];
}

- (NSNumber *)number {
    
    return [NSNumber numberWithUnsignedLongLong:_val];
}

- (id)clone {
    
    return [bsULongLong G:_val];
}
@end
