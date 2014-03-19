#import <Foundation/Foundation.h>

@interface bsIni : NSObject

+ (void)onCreate;
+ (NSString *)ini:(NSString *)item;
+ (BOOL)iniBool:(NSString *)item;

@end
