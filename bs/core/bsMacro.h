#import <Foundation/Foundation.h>

//#define bs_io_storageS( name, data )  [bsIO storageS:name data:data];
#define bsLog( s, ... ) NSLog(@"\nAt: %s(%d)\nmsg: %@\n\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define bsException( s, ... ) [NSException raise:NSInvalidArgumentException format:@"%s(%d)%@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ]
#define bsLogInfo( s, ... );
#define bsLogDebug( s, ... );
#define bsLogWarning( s, ... );
#define bsLogError( s, ... );
#define bsLogFatal( s, ... );
#define STR_CONST(name, value) FOUNDATION_EXPORT NSString* const name; NSString* const name = @ value;

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]