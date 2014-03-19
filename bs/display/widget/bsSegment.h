#import "bsDisplay.h"

@class bsSegment;

typedef void (^bsSegmentValueChangedBlock)(bsSegment *segment, NSInteger selectedIdx);

#define kbsSegmentTitles            102001
#define kbsSegmentSelectedIndex     102002

@interface bsSegment : bsDisplay {
    
    UISegmentedControl *segment_;
    NSString *blockKey_;
    BOOL addedValueChanged_;
}

- (void)blockValueChanged:(bsSegmentValueChangedBlock)block;

@end
