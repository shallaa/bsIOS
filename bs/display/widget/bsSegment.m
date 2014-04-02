//
//  bsSegment.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/18.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsSegment.h"

#import "bsStr.h"
#import "bsDisplayUtil.h"

static NSDictionary* __bsSegment_keyValues = nil;

@implementation bsSegment

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (segment_ == nil) {
        segment_ = [[UISegmentedControl alloc] init] ;
        //segment_.segmentedControlStyle = UISegmentedControlStylePlain;
        segment_.tintColor = RGB(179, 195, 27);
        [self addSubview:segment_];
    }
    if (__bsSegment_keyValues == nil) {
        __bsSegment_keyValues = @{@"titles":@kbsSegmentTitles, @"selected-index": @kbsSegmentSelectedIndex};
    }
    if (addedValueChanged_) {
        [segment_ removeTarget:self action:@selector(__valueChanged:) forControlEvents:UIControlEventValueChanged];
        addedValueChanged_ = NO;
    }
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    objc_removeAssociatedObjects(self);
}

- (void)layoutSubviews {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [super layoutSubviews];
    segment_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger num = [[__bsSegment_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsSegmentTitles: {
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < segment_.numberOfSegments; i++) {
                NSString *title = [segment_ titleForSegmentAtIndex:i];
                [titles addObject:title];
            }
            value = [titles componentsJoinedByString:@"|"];
        } break;
        case kbsSegmentSelectedIndex:
            value = @(segment_.selectedSegmentIndex);
            break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSMutableArray *remain = [NSMutableArray array];
    NSArray *titles = nil;
    for (NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString *)params[i++];
        NSString *v = (NSString *)params[i++];
        NSInteger num = [[__bsSegment_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsSegmentTitles: {
                [segment_ removeAllSegments];
                if (titles == nil) {
                    titles = [bsStr arg:v];
                }
                [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
                    [segment_ insertSegmentWithTitle:title atIndex:0 animated:NO];
                }];
            } break;
            case kbsSegmentSelectedIndex:
                if (segment_.selectedSegmentIndex != [v integerValue]) {
                    segment_.selectedSegmentIndex = [v integerValue];
                    [segment_ sendActionsForControlEvents:UIControlEventValueChanged];
                }
                break;
            default:
                [remain addObject:k];
                [remain addObject:v];
                break;
        }
    }
    return remain;
}

- (void)__valueChanged:(UISegmentedControl *)seg {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsSegmentValueChangedBlock block = objc_getAssociatedObject(self, &blockKey_);
    if (block) {
        block(self, seg.selectedSegmentIndex);
    }
}

- (void)blockValueChanged:(bsSegmentValueChangedBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    //if( objc_getAssociatedObject(self, &blockKey_) ) bsException(NSInvalidArgumentException, @"두 번 정의할 수 없습니다.");
    objc_setAssociatedObject(self, &blockKey_, block, OBJC_ASSOCIATION_RETAIN);
    if (!addedValueChanged_) {
        addedValueChanged_ = YES;
        [segment_ addTarget:self action:@selector(__valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - override
- (NSString *)create:(NSString *)name params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (bsDisplay *)childG:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)childA:(bsDisplay *)child { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childD:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childS:(NSString *)key params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
