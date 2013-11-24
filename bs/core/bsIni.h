#import <Foundation/Foundation.h>
#import "bsIO.h"
#import "bsStr.h"

@interface bsIni : NSObject
@end

@implementation bsIni
static NSMutableDictionary* __bsIni_ini = nil;
-(id)alloc {
    [NSException raise:NSInvalidArgumentException format:@"%s(%d)Static class 'bsIni' cannot be instantiated!", __FUNCTION__, __LINE__];
    return nil;
}
+(void)onCreate {
    if( __bsIni_ini ) bsException(@"Wrong call");
    __bsIni_ini = [[NSMutableDictionary alloc] init];
    @try {
        NSArray *lines = [bsStr row:[bsStr str:[bsIO assetG:@"bs.ini"]]];
        [lines enumerateObjectsUsingBlock:^(NSString* line, NSUInteger idx, BOOL *stop) {
            NSArray *data = [bsStr split:line seperator:@"=" trim:YES];
            [__bsIni_ini setObject:[data objectAtIndex:1] forKey:[data objectAtIndex:0]];
        }];
    }
    @catch (NSException *exception) {
        [NSException raise:NSInvalidArgumentException format:@"%s(%d)'bs.ini' has wrong value.", __FUNCTION__, __LINE__];
    }
}
+(NSString*)ini:(NSString*)item {
    return [__bsIni_ini objectForKey:item]; //TODO : nil을 반환해도 상관없는가?
}
+(BOOL)iniBool:(NSString*)item {
    item = [bsIni ini:item];
    return item != nil && [bsStr BOOLEAN:item];
}
@end
