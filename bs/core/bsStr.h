#import <Foundation/Foundation.h>

#define __bsStr_P0      @"("
#define __bsStr_P1      @")"
#define __bsStr_SHARP   @"#"
#define __bsStr_EQUAL   @"="
#define __bsStr_SPACE   @" "
#define __bsStr_QUOT    @"\""
#define __bsStr_COMMA   @","
#define __bsStr_VBAR    @"|"
#define __bsStr_UNDER   @"_"
#define __bsStr_row0    @"\n"
#define __bsStr_row1    @"\r"

@interface bsStr : NSObject

+ (NSString *)str:(id)val;
//to Another
+ (NSInteger)INTEGER:(NSString *)val;
+ (int)INT:(NSString *)val;
+ (long long)LONGLONG:(NSString *)val;
+ (float)FLOAT:(NSString *)val;
+ (double)DOUBLE:(NSString *)val;
+ (BOOL)BOOLEAN:(NSString *)val;
+ (NSDictionary *)DIC:(NSString *)$val;
+ (CGFloat)__colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;
+ (UIColor *)color:(NSString *)val;
+ (id)trim:(id)val;
+ (NSString *)substrForPrintKoreanWithString:(NSString *)str length:(NSUInteger)length;
+ (NSString *)replace:(NSString *)source search:(id)search dest:(NSString *)dest;
+ (NSString *)templateSrc:(NSString *)source replace:(id)replace;
+ (BOOL)isUrl:(NSString *)url;
+ (NSString *)urlEncode:(NSString *)string;
+ (NSString *)urlDecode:(NSString *)string;
+ (NSArray *)split:(NSString *)string seperator:(NSString *)seperator trim:(BOOL)isTrim;
+ (NSArray *)row:(NSString *)string;
+ (NSArray *)col:(NSString *)string;
+ (NSArray *)arg:(NSString *)string;
+ (NSArray *)tag:(NSString *)string;
+ (NSString *)jsonEncode:(id)obj;
+ (id)jsonDecode:(id)json;
+ (NSString*)UUID;

+ (BOOL)isIpAddress:(NSString *)ipAddr;
+ (NSString *)addSlashes:(NSString *)str;
+ (BOOL)regExpTestWithPattern:(NSString *)pattern value:(NSString *)value;

@end
