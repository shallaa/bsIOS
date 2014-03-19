#import "bsDisplay.h"
#import "bsStr.h"

#define kbsSpinnerStyle       100801
#define kbsSpinnerColor       100802

FOUNDATION_EXPORT NSString * const kbsSpinnerStyleNone;
FOUNDATION_EXPORT NSString * const kbsSpinnerStyleLargeWhite;
FOUNDATION_EXPORT NSString * const kbsSpinnerStyleWhite;
FOUNDATION_EXPORT NSString * const kbsSpinnerStyleGray;

@interface bsSpinner : bsDisplay {
    
    UIActivityIndicatorView *spinner_;
    NSString *spinStyle_;
    UIColor *spinColor_;
}

@property (nonatomic, readonly) UITableView *tableView;

@end
