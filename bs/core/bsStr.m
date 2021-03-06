//
//  bsStr.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/15.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsStr.h"

#import "bsLog.h"
#import "bsMacro.h"
#include <arpa/inet.h> // IP address check
#import "NSNumber+ProjectBS.h"

static NSArray *__bsStr_template = nil;

@implementation bsStr

+ (id)alloc {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsStr' cannot be instantiated!");
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    bsException(NSInternalInconsistencyException, @"Static class 'bsStr' cannot be instantiated!");
    return nil;
}

// to String
+ (NSString *)str:(id)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (val == nil || val == [NSNull null]) {
        return nil;
    }
    if ([val isKindOfClass:[NSString class]]) {
        return val;
    } else if ([val isKindOfClass:[NSData class]]) {
        NSString *s = [[NSString alloc] initWithData:(NSData *)val encoding:NSUTF8StringEncoding];
        return [bsStr trim:s ? s : @""];
    } else if ([val isKindOfClass:[NSNumber class]]) {
        if (strcmp([val objCType], @encode(BOOL)) == 0) {
            return [val boolValue] ? @"true" : @"false";
        } else {
            return [val stringValue];
        }
    } else if ([val isKindOfClass:[NSArray class]]) {
        return [[val valueForKey:@"description"] componentsJoinedByString:__bsStr_COMMA];
    } else if ([val isKindOfClass:[NSDictionary class]]) {
        NSMutableString *s = [[NSMutableString alloc] init];
        [(NSDictionary *)val enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [s appendFormat:@"%@,%@,", key, obj];
        }];
        [s deleteCharactersInRange:NSMakeRange([s length] - 1, 1)];
        return [NSString stringWithString:s];
    } else if ([val isKindOfClass:[NSNumber class]]) {
        return [val bs_description];
    } else if ([val isKindOfClass:[UIColor class]]) {
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        UIColor *color = (UIColor *)val;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        return [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(255 * alpha), (int)(255 * red), (int)(255 * green), (int)(255 * blue)];
    } else {
        bsException(NSInvalidArgumentException, @"wrong argument");
    }
    // bsGeometry also to be processed?
    return nil;
}

//to Another
+ (NSInteger)INTEGER:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return [val integerValue];
}

+ (int)INT:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return [val intValue];
}

+ (long long)LONGLONG:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return [val longLongValue];
}

+ (float)FLOAT:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return [val floatValue];
}

+ (double)DOUBLE:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return [val doubleValue];
}

+ (BOOL)BOOLEAN:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    if ([val caseInsensitiveCompare:@"true"] == NSOrderedSame || [val isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSDictionary *)DIC:(NSString *)$val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    NSArray *getArr = [bsStr col:$val];
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for( NSInteger i = 0, j = [getArr count]; i < j; ) {
        [keys addObject:getArr[i++]];
        [objs addObject:getArr[i++]];
    }
    return [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
}

+ (CGFloat)__colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)color:(NSString *)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if ([val hasPrefix:@"#"]) {
        NSString *colorString = [[val stringByReplacingOccurrencesOfString:@"#" withString: @""] uppercaseString];
        CGFloat alpha = 0.0, red = 0.0, blue = 0.0, green = 0.0;
        switch ([colorString length]) {
            case 3: // #RGB
                alpha = 1.0f;
                red   = [self __colorComponentFrom:colorString start:0 length:1];
                green = [self __colorComponentFrom:colorString start:1 length:1];
                blue  = [self __colorComponentFrom:colorString start:2 length:1];
                break;
            case 4: // #ARGB
                alpha = [self __colorComponentFrom:colorString start:0 length:1];
                red   = [self __colorComponentFrom:colorString start:1 length:1];
                green = [self __colorComponentFrom:colorString start:2 length:1];
                blue  = [self __colorComponentFrom:colorString start:3 length:1];
                break;
            case 6: // #RRGGBB
                alpha = 1.0f;
                red   = [self __colorComponentFrom:colorString start:0 length:2];
                green = [self __colorComponentFrom:colorString start:2 length:2];
                blue  = [self __colorComponentFrom:colorString start:4 length:2];
                break;
            case 8: // #AARRGGBB
                alpha = [self __colorComponentFrom:colorString start:0 length:2];
                red   = [self __colorComponentFrom:colorString start:2 length:2];
                green = [self __colorComponentFrom:colorString start:4 length:2];
                blue  = [self __colorComponentFrom:colorString start:6 length:2];
                break;
            default:
                bsException(NSInvalidArgumentException, @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", val);
                break;
        }
        return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    } else {
        NSArray *colors = [bsStr arg:val];
        CGFloat alpha = 0.0, red = 0.0, blue = 0.0, green = 0.0;
        switch ([colors count]) {
            case 3:
                alpha = 1.0f;
                red = [colors[0] floatValue]/255.0;
                green = [colors[1] floatValue]/255.0;
                blue = [colors[2] floatValue]/255.0;
                return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            case 4:
                alpha = [colors[0] floatValue];
                red = [colors[1] floatValue]/255.0;
                green = [colors[2] floatValue]/255.0;
                blue = [colors[3] floatValue]/255.0;
                return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            default:
                bsException(NSInvalidArgumentException, @"Color value %@ is invalid.  It should be a value of the form R|G|B or A|R|G|B. A,R,G,B should be a number value.", val);
                break;
        }
        return nil;
    }
}

//util
+ (id)trim:(id)val {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if ([val isKindOfClass:[NSString class]]) {
        return [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if( [val isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[val count]];
        [val enumerateObjectsUsingBlock:^(id str, NSUInteger idx, BOOL *stop) {
            [result addObject:[bsStr trim:str]];
        }];
        return result;
    } else {
//        bsException(NSInvalidArgumentException, @"argument is nil or wrong type.");
        return @"";
    }
}

+ (NSString *)substrForPrintKoreanWithString:(NSString *)str length:(NSUInteger)length { //한글은 2글자취급, 영문은 1글자 취급해서 잘라온다.
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger i;
    NSString *returned;
    NSUInteger (^getLength)(NSString *) = ^(NSString *s) {
        return [s lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    };
    if (str == nil) return @"";
    if (getLength(str) <= length) return str;
    for (i = 1; i <= length; i++) {
        NSString *temp = [str substringToIndex:i];
        NSUInteger len = getLength(temp);
        if (len == length) {
            return temp;
        } else if (len > length) {
            return returned;
        } else {
            returned = temp;
        }
    }
    return returned;
}

+ (NSString *)replace:(NSString *)source search:(id)search dest:(NSString *)dest {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (source == nil || search == nil || dest == nil ) return source;
    if ([search isKindOfClass:[NSString class]]) {
        return [source stringByReplacingOccurrencesOfString:(NSString*)search withString:dest];
    } else if( [search isKindOfClass:[NSArray class]]) {
        __block NSString *r = source;
        [(NSArray *)search enumerateObjectsUsingBlock:^(id s, NSUInteger idx, BOOL *stop) {
            if ([s isKindOfClass:[NSString class]]) {
                r = [r stringByReplacingOccurrencesOfString:(NSString *)s withString:dest];
            } else {
                *stop = YES;
            }
        }];
        return r;
    } else {
        return source;
    }
}

+ (NSString *)templateSrc:(NSString*)source replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (source == nil || replace == nil) {
        return source;
    }
    NSArray *replaceArray = nil;
    if ([replace isKindOfClass:[NSString class]]) {
        replaceArray = [replace componentsSeparatedByString:__bsStr_VBAR];
    } else if ([replace isKindOfClass:[NSArray class]]) {
        replaceArray = (NSArray*)replace;
    } else {
        bsException(NSInvalidArgumentException, @"a value of replace parameter should be string(type of a|b|c|d) or array");
    }
    if (__bsStr_template == nil) {
        __bsStr_template =
        @[@"@@0", @"@@1", @"@@2", @"@@3", @"@@4", @"@@5", @"@@6", @"@@7", @"@@8", @"@@9",
          @"@@10", @"@@11", @"@@12", @"@@13", @"@@14", @"@@15", @"@@16", @"@@17", @"@@18", @"@@19",
          @"@@20", @"@@21", @"@@22", @"@@23", @"@@24", @"@@25", @"@@26", @"@@27", @"@@28", @"@@29",
          @"@@30", @"@@31", @"@@32", @"@@33", @"@@34", @"@@35", @"@@36", @"@@37", @"@@38", @"@@39",
          @"@@40", @"@@41", @"@@42", @"@@43", @"@@44", @"@@45", @"@@46", @"@@47", @"@@48", @"@@49",
          @"@@50", @"@@51", @"@@52", @"@@53", @"@@54", @"@@55", @"@@56", @"@@57", @"@@58", @"@@59"];
    }
    NSMutableString *result = [[NSMutableString alloc] initWithString:source];
    [replaceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [bsStr str:obj];
        }
        NSString* t = (NSString*)__bsStr_template[idx];
        [result replaceOccurrencesOfString:t withString:(NSString*)obj options:NSCaseInsensitiveSearch range:(NSRange){0,[result length]}];
    }];
    return [NSString stringWithString:result];;
}

+ (BOOL)isUrl:(NSString *)url {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if ([[url substringToIndex:4] caseInsensitiveCompare:@"http"] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)urlEncode:(NSString *)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)urlDecode:(NSString*)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (CFStringRef)string,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}
//------------------------------------------------------------------------------------------------------------------------------
+ (NSArray *)split:(NSString *)string seperator:(NSString *)seperator trim:(BOOL)isTrim {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    static NSString *boundary = @"__!@#$%^&*()__";
    NSString *escape = [NSString stringWithFormat:@"\\%@", seperator];
    string = [string stringByReplacingOccurrencesOfString:escape withString:boundary];
    NSArray *splits = [string componentsSeparatedByString:seperator];
    if (isTrim) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        [splits enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            str = [str stringByReplacingOccurrencesOfString:boundary withString:seperator];
            [result addObject:[bsStr trim:str]];
        }];
        return result;
    } else {
        return splits;
    }
}

+ (NSArray *)row:(NSString *)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSRange range = [string rangeOfString:__bsStr_row1];
    NSString *row;
    if (range.location != NSNotFound) {
        row = __bsStr_row1;
    } else {
        row = __bsStr_row0;
    }
    return [bsStr split:string seperator:row trim:NO];
}

+ (NSArray *)col:(NSString *)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [bsStr split:string seperator:__bsStr_COMMA trim:YES];
}

+ (NSArray *)arg:(NSString *)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [bsStr split:string seperator:__bsStr_VBAR trim:YES];
}

+ (NSArray *)tag:(NSString *)string {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [bsStr split:string seperator:__bsStr_UNDER trim:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)jsonEncode:(id)obj {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)jsonDecode:(id)json {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *t;
    if ([json isKindOfClass:[NSData class]]) {
        t = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSString class]]) {
        t = (NSString*)json;
    } else {
        return nil;
    }
    NSData *jsonData = [t dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return error ? nil : obj;
}
//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)UUID {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    return uuid;
}
//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)isIpAddress:(NSString *)ipAddr {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    const char *utf8 = [ipAddr UTF8String];
    int success;
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return (success == 1);
}
//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)addSlashes:(NSString *)str {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return [str stringByReplacingOccurrencesOfString:@"," withString:@"\\,"];
}

+ (BOOL)regExpTestWithPattern:(NSString *)pattern value:(NSString *)value {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSError *error = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        [NSException raise:NSInvalidArgumentException format:@"%s(%d) Error in regular expression. pattern = %@", __FUNCTION__, __LINE__, pattern];
    }
    NSTextCheckingResult *match = [regExp firstMatchInString:value options:0 range:NSMakeRange(0, [value length])];
    return match ? YES : NO;
}

@end
