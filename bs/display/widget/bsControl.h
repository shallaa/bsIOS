#import "bsDisplay.h"
#import "bsStr.h"

//bsDisplay에 UIControl기능이 필요할때 쓴다. 극히 기능이 제한적이므로 주의해서 써야함.
//특히나 자식insert기능을 없다! 오동작할 것이다.
/*
@interface bsControl : bsDisplay{
    UIControl *control_;
}
@property (nonatomic, readonly) UIControl *control;
@end

@implementation bsControl
@synthesize control = control_;
static NSDictionary* __bsContol_keyValues = nil;
-(void)ready {
    if( control_ == nil ) {
        control_ = [[UIControl alloc] initWithFrame:self.frame];
        [super addSubview:control_];
        [self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"control_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(control_)];
    }
    if( __bsContol_keyValues == nil ) {
        __bsContol_keyValues =
        @{ 
           };
    }
}
-(id)__g:(NSString*)key {
    NSInteger num = [[__bsContol_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
    }
    return value;
}
-(NSArray*)__s:(NSArray*)params {
    NSMutableArray *remain = [NSMutableArray array];
    for( int i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsContol_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    return remain;
}
#pragma mark - child
-(NSString*)create:(NSString*)name params:(NSString*)params {
    bsDisplay *o = [bsDisplay G:name params:params];
    [control_ addSubview:o];
    return o.key;
}
-(NSString*)create:(NSString*)name params:(NSString*)params replace:(id)replace {
    bsDisplay *o = [bsDisplay G:name params:params replace:replace];
    [control_ addSubview:o];
    return o.key;
}
-(NSString*)createT:(NSString*)key params:(NSString*)params {
    bsDisplay *o = [bsDisplay GT:key params:params];
    [control_ addSubview:o];
    return o.key;
}
-(NSString*)createT:(NSString*)key params:(NSString*)params replace:(id)replace {
    bsDisplay *o = [bsDisplay GT:key params:params replace:replace];
    [control_ addSubview:o];
    return o.key;
}
-(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params {
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params];
    [control_ addSubview:o];
    return o.key;
}
-(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params replace:(id)replace{
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params replace:replace];
    [control_ addSubview:o];
    return o.key;
}
-(bsDisplay*)childG:(NSString*)key {
    __block bsDisplay *c = nil;
    [control_.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if( [obj isKindOfClass:[bsDisplay class]] && [((bsDisplay*)obj).key isEqualToString:key] ) {
            c = (bsDisplay*)obj;
            *stop = YES;
        }
    }];
    return c;
}


@end
*/