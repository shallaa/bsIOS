
#import "bsDisplay.h"

@interface bsDoc : NSObject

+ (id)G:(bsDisplay *)parent query:(id)query;
+ (void)S:(bsDisplay *)parent query:(id)query params:(id)params;
+ (void)D:(bsDisplay *)parent query:(id)query;
+ (void)A:(bsDisplay *)parent child:(id)child params:(id)params;

@end
