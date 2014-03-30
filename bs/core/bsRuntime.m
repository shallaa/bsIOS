//
//  bsRuntime.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsRuntime.h"

@implementation bsRuntime

+ (NSString *)stringFromClass:(Class)clazz {
    
    return NSStringFromClass(clazz);
}

+ (Class)classFromString:(NSString *)className {
    
    return NSClassFromString(className);
}

+ (Class)classFromObject:(id)object {
    
    return [object class];
}

+ (NSString *)classNameFromObject:(id)object {
    
    return NSStringFromClass([object class]);
}

+ (Class)getPropClassOfObject:(id)object key:(NSString*)key {
    
    return [self getPropClassOfClass:[object class] key:key];
}

+ (Class)getPropClassOfClass:(Class)clazz key:(NSString*)key {
    
    const char *nm = [key UTF8String];
    objc_property_t p0 = class_getProperty(clazz, nm);
    if (p0 == NULL) {
        return NULL;
    }
    NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes( p0 )];
    NSArray *attrSplit = [attr componentsSeparatedByString:@"\""]; //"T@"NSString",R,V_test"에서 NSString만 추출해야 한다.
    NSString *className = nil;
    if ([attrSplit count] >= 2) {
        className = [attrSplit objectAtIndex:1];
    }
    if (className == nil) return NULL;
    return NSClassFromString(className);
}

+ (Class)getPropClassOfRootObject:(id)object keyPath:(NSString *)keyPath {
    
    return [self getPropClassOfRootClass:[object class] keyPath:keyPath];
}

+ (Class)getPropClassOfRootClass:(Class)clazz keyPath:(NSString *)keyPath {
    
    NSArray *names = [bsStr split:keyPath seperator:@"." trim:NO];
    if ([names count] == 0) return NULL;
    __block Class c = clazz;
    [names enumerateObjectsUsingBlock:^(NSString *nm, NSUInteger idx, BOOL *stop) {
        objc_property_t p = class_getProperty(c, [nm UTF8String]);
        if (!p) {
            *stop = YES;
            return;
        }
        NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes(p)];
        NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
        if ([attrSplit count] < 2) {
            *stop = YES;
            c = NULL;
        }
        NSString *className = [attrSplit objectAtIndex:1];
        c = NSClassFromString(className);
    }];
    return c;
}

+ (NSArray *)getPropNamesOfClass:(Class)clazz superInquiry:(BOOL)superInquiry {
    
    if (clazz == NULL || clazz == [NSObject class]) {
        return nil;
    }
    NSMutableArray *r = [[NSMutableArray alloc] init];
    unsigned int count, i;
    objc_property_t *ps = class_copyPropertyList(clazz, &count);
    for (i = 0; i < count; i++) {
        objc_property_t p = ps[i];
        const char *pn = property_getName(p);
        if (pn) {
            [r addObject:[NSString stringWithUTF8String:pn]];
        }
    }
    free(ps);
    if (superInquiry) {
        NSArray *sr = [self getPropNamesOfClass:[clazz superclass] superInquiry:YES];
        if (sr) {
            [r addObjectsFromArray:sr];
        }
    }
    return [NSArray arrayWithArray:r];
}

+ (id)getPropValueOfObject:(id)object keyPath:(NSString *)keyPath {
    
    NSArray *t0 = [bsStr split:keyPath seperator:@"." trim:NO];
    if ([t0 count] > 0) {
        __block id t00 = object;
        [t0 enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            Ivar ivar = class_getInstanceVariable([t00 class], [[NSString stringWithFormat:@"_%@", name] UTF8String]);
            t00 = object_getIvar(t00, ivar);
            if (t00 == nil) {
                *stop = YES;
            }
        }];
        return t00;
    }
    return nil;
}

+ (void)setPropValueOfObject:(id)object keyPath:(NSString *)keyPath value:(id)value {
    
    NSArray *t0 = [bsStr split:keyPath seperator:@"." trim:NO];
    if ([t0 count] > 0) {
        id t00 = object;
        Ivar ivar = nil;
        NSInteger i = 0, j = [t0 count];
        while (1)  {
            ivar = class_getInstanceVariable([t00 class], [[NSString stringWithFormat:@"_%@", t0[i]] UTF8String]);
            if (++i < j) {
                t00 = object_getIvar(t00, ivar);
                if (t00 == nil) break;
            } else {
                break;
            }
        }
        object_setIvar(t00, ivar, value);
    }
}

+ (BOOL)hasPropAtObject:(id)object keyPath:(NSString *)keyPath {
    
    return [self hasPropAtClass:[object class] keyPath:keyPath];
}

+ (BOOL)hasPropAtClass:(Class)clazz keyPath:(NSString *)keyPath {
    
    //clazz와 name으로 캐싱필요!
    NSArray *names = [bsStr split:keyPath seperator:@"." trim:NO];
    if ([names count] == 0) return NO;
    __block Class c = clazz;
    __block BOOL has = NO;
    NSUInteger maxIdx = [names count] - 1;
    [names enumerateObjectsUsingBlock:^(NSString *nm, NSUInteger idx, BOOL *stop) {
        objc_property_t p = class_getProperty(c, [nm UTF8String]);
        if (!p) {
            has = NO;
            *stop = YES;
            return;
        }
        if (idx == maxIdx) {
            has = YES;
            return;
        }
        NSString *attr = [NSString stringWithFormat:@"%s", property_getAttributes(p)];
        NSArray *attrSplit = [attr componentsSeparatedByString:@"\""];
        if ([attrSplit count] < 2) {
            has = NO;
            *stop = YES;
            return;
        }
        NSString *className = [attrSplit objectAtIndex:1];
        c = NSClassFromString(className);
    }];
    return has;
}

/*
 +(id)execCommandWithRoot:(id)root commands:(NSArray*)commands getKey:(NSString*)key {
 [commands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 
 //[self k:key v:obj];
 }];
 if( key ) {
 //return [self g:key];
 }
 return nil;
 }
 */

/*
 클래스로 동적으로 객체생성
 속성 동적으로 설정 및 삭제
 메서드 동적으로 설정 및 삭제
 속성리스트
 메서드 리스트
 동적으로 메서드 실행
 */

@end
