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
    
    NSLog(@"bsSegment dealloc");
    objc_removeAssociatedObjects(self);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    segment_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
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
    
    bsSegmentValueChangedBlock block = objc_getAssociatedObject(self, &blockKey_);
    if (block) block(self, seg.selectedSegmentIndex);
}

- (void)blockValueChanged:(bsSegmentValueChangedBlock)block {
    
    //if( objc_getAssociatedObject(self, &blockKey_) ) bsException( @"두 번 정의할 수 없습니다." );
    objc_setAssociatedObject(self, &blockKey_, block, OBJC_ASSOCIATION_RETAIN);
    if( addedValueChanged_ == NO ) {
        addedValueChanged_ = YES;
        [segment_ addTarget:self action:@selector(__valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - override
- (NSString *)create:(NSString *)name params:(NSString *)params { bsException( @"호출금지" ); return nil; }
- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params { bsException( @"호출금지" ); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString*)params { bsException( @"호출금지" ); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString*)params replace:(id)replace { bsException( @"호출금지" ); return nil; }
- (bsDisplay *)childG:(NSString *)key { bsException( @"호출금지" ); return nil; }
- (void)childA:(bsDisplay *)child { bsException( @"호출금지" ); }
- (void)childD:(NSString *)key { bsException( @"호출금지" ); }
- (void)childS:(NSString *)key params:(NSString *)params { bsException( @"호출금지" ); }
- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace{ bsException( @"호출금지" ); }

@end
