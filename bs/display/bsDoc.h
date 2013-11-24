
#import "bsDisplay.h"

@interface bsDoc : NSObject
@end
@implementation bsDoc
+(id)G:(bsDisplay*)parent query:(id)query {
    
}
+(void)S:(bsDisplay*)parent query:(id)query params:(id)params {
    
}
+(void)D:(bsDisplay*)parent query:(id)query {
    
}
+(void)A:(bsDisplay*)parent child:(id)child params:(id)params {
    
}
@end

/*

[bsDoc A:self child:@"image" params:@"x,10,y,10"];
[bsDoc A:self child:image params:@"x,10,y,10"];
 [bsDoc A:self child:@{image, @"image", @"image"} params:@"x,10,y,10"];
 [bsDoc A:self child:@{image, @"image", @"image"} params:[@"x,10,y,10", @"", @""]];
 
*/