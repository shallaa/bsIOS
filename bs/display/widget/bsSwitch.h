#import "bsDisplay.h"
#import "bsStr.h"

@class bsSwitch;
typedef void (^bsSwitchOnBlock)( bsSwitch *sw, BOOL on );

#define kbsSwitchOn 100901
#define kbsSwitchAnimation 100902
#define kbsSwitchTintOffColor 100903
#define kbsSwitchTintOnColor 100904
#define kbsSwitchTintThumbColor 100905
#define kbsSwitchImgOn 100910 //77x27 이미지이어야 함
#define kbsSwitchImgOff 100911 //77x27 이미지이어야 함 

@interface bsSwitch : bsDisplay {
    UISwitch *switch_;
    BOOL animation_;
    NSString *blockKey_;
    BOOL addedOn_;
}
@end
@implementation bsSwitch
static NSDictionary* __bsSwitch_keyValues = nil;
-(void)ready {
    if( switch_ == nil ) {
        switch_ = [[UISwitch alloc] init];
        [self addSubview:switch_];
        self.frame = switch_.frame;
    }
    if( __bsSwitch_keyValues == nil ) {
        __bsSwitch_keyValues =
        @{ @"on": @kbsSwitchOn, @"animation": @kbsSwitchAnimation, @"tint-off-color": @kbsSwitchTintOffColor,
           @"tint-on-color": @kbsSwitchTintOnColor, @"tint-thumb-color": @kbsSwitchTintThumbColor,
           @"img-on": @kbsSwitchImgOn, @"img-off": @kbsSwitchImgOff
           };
    }
    animation_ = YES;
}
-(void)dealloc {
    NSLog(@"bsSwitch dealloc");
    objc_removeAssociatedObjects( self );
}
-(id)__g:(NSString*)key {
    NSInteger num = [[__bsSwitch_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsSwitchOn: value = @(switch_.on); break;
        case kbsSwitchAnimation: value = @(animation_); break;
        case kbsSwitchTintOffColor: value = switch_.tintColor; break;
        case kbsSwitchTintOnColor: value = switch_.onTintColor; break;
        case kbsSwitchTintThumbColor: value = switch_.thumbTintColor; break;
        case kbsSwitchImgOn: value = switch_.onImage; break;
        case kbsSwitchImgOff: value = switch_.offImage; break;
    }
    return value;
}
-(NSArray*)__s:(NSArray*)params {
    NSMutableArray *remain = [NSMutableArray array];
    BOOL onChange = NO;
    BOOL on;
    for( int i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsSwitch_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsSwitchOn: on = [bsStr BOOLEAN:v]; onChange = YES; break;
            case kbsSwitchAnimation: animation_ = [bsStr BOOLEAN:v]; break;
            case kbsSwitchTintOffColor: switch_.tintColor = [bsStr color:v]; break;
            case kbsSwitchTintOnColor: switch_.onTintColor = [bsStr color:v]; break;
            case kbsSwitchTintThumbColor: switch_.thumbTintColor = [bsStr color:v]; break;
            case kbsSwitchImgOn: switch_.onImage = [UIImage imageNamed:v]; break;
            case kbsSwitchImgOff: switch_.offImage = [UIImage imageNamed:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if( onChange ) {
        [switch_ setOn:on animated:animation_];
    }
    return remain;
}

#pragma mark - block
-(void)blockOn:(bsSwitchOnBlock)block {
    if( addedOn_ == NO ) {
        addedOn_ = YES;
        [switch_ addTarget:self action:@selector(__valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    objc_setAssociatedObject(self, &blockKey_, block, OBJC_ASSOCIATION_RETAIN);
}
-(void)__valueChanged:(id)sender {
    bsSwitchOnBlock block = objc_getAssociatedObject(self, &blockKey_);
    if( block ) block( self, switch_.on );
}
#pragma mark - override
-(NSString*)create:(NSString*)name params:(NSString*)params { bsException( @"호출금지" ); return nil; }
-(NSString*)create:(NSString*)name params:(NSString*)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
-(NSString*)createT:(NSString*)key params:(NSString*)params { bsException( @"호출금지" ); return nil; }
-(NSString*)createT:(NSString*)key params:(NSString*)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
-(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params { bsException( @"호출금지" ); return nil; }
-(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
-(bsDisplay*)childG:(NSString*)key { bsException( @"호출금지" ); return nil; }
-(void)childA:(bsDisplay*)child { bsException( @"호출금지" ); }
-(void)childD:(NSString*)key { bsException( @"호출금지" ); }
-(void)childS:(NSString*)key params:(NSString*)params { bsException( @"호출금지" ); }
-(void)childS:(NSString*)key params:(NSString*)params replace:(id)replace{ bsException( @"호출금지" ); }

@end