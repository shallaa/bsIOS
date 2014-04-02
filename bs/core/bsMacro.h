#import <Foundation/Foundation.h>

//#define bs_io_storageS( name, data )  [bsIO storageS:name data:data];

#define bsException( name, s, ... ) [NSException raise:name format:@"%s(%d)%@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ]

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]