#import "bsDisplay.h"
#import "bsStr.h"

#define kbsSpinnerStyle       100801
#define kbsSpinnerColor       100802

STR_CONST(kbsSpinnerStyleNone, "none");
STR_CONST(kbsSpinnerStyleLargeWhite, "large-white");
STR_CONST(kbsSpinnerStyleWhite, "white");
STR_CONST(kbsSpinnerStyleGray, "gray");

@interface bsSpinner : bsDisplay{
    UIActivityIndicatorView *spinner_;
    NSString *spinStyle_;
    UIColor *spinColor_;
}
@property (nonatomic, readonly) UITableView *tableView;
@end

@implementation bsSpinner
static NSDictionary* __bsSpinner_keyValues = nil;
-(void)ready {
    if( spinner_ == nil ) {
        spinner_ = [[UIActivityIndicatorView alloc] init];
        [self addSubview:spinner_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"spinner_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(spinner_)];
    }
    if( __bsSpinner_keyValues == nil ) {
        __bsSpinner_keyValues =
        @{ @"spin-style": @kbsSpinnerStyle, @"spin-color": @kbsSpinnerColor
          };
    }
    spinStyle_ = kbsSpinnerStyleWhite;
    spinColor_ = [UIColor whiteColor];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    spinner_.frame = self.bounds;
}
-(id)__g:(NSString*)key {
    NSInteger num = [[__bsSpinner_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsSpinnerStyle: value = spinStyle_; break;
        case kbsSpinnerColor: value = spinColor_; break;
    }
    return value;
}
-(NSArray*)__s:(NSArray*)params {
    NSMutableArray *remain = [NSMutableArray array];
    BOOL styleChange = NO;
    BOOL colorChange = NO;
    for( int i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsSpinner_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsSpinnerStyle: {
                if( [v isEqualToString:kbsSpinnerStyleNone] ) spinStyle_ = kbsSpinnerStyleNone;
                else if( [v isEqualToString:kbsSpinnerStyleLargeWhite] ) spinStyle_ = kbsSpinnerStyleLargeWhite;
                else if( [v isEqualToString:kbsSpinnerStyleWhite] ) spinStyle_ = kbsSpinnerStyleWhite;
                else if( [v isEqualToString:kbsSpinnerStyleGray] ) spinStyle_ = kbsSpinnerStyleGray;
                styleChange = YES;
            } break;
            case kbsSpinnerColor: spinColor_ = [bsStr color:v]; colorChange = YES; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if( styleChange || colorChange )  {
        if( [spinStyle_ isEqualToString:kbsSpinnerStyleNone] ) {
            [spinner_ stopAnimating];
            [spinner_ setHidden:YES];
        } else {
            if( [spinStyle_ isEqualToString:kbsImageSpinStyleWhite] ) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            else if( [spinStyle_ isEqualToString:kbsImageSpinStyleGray] ) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            else if( [spinStyle_ isEqualToString:kbsImageSpinStyleLargeWhite] ) spinner_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            if( colorChange ) {
                spinner_.color = spinColor_;
            } else {
                spinColor_ = spinner_.color;
            }
            [spinner_ setHidden:NO];
            [spinner_ startAnimating];
        }
    }
    return remain;
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