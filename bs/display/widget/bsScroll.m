//
//  bsScroll.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/18.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsScroll.h"

#import "bsStr.h"

static NSDictionary *__bsScroll_keyValues = nil;

@implementation bsScroll

- (void)ready {
    
    if( scrollView_ == nil ) {
        scrollView_ = [[UIScrollView alloc] initWithFrame:self.frame];
        [self addSubview:scrollView_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"scrollView_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(scrollView_)];
    }
    if( __bsScroll_keyValues == nil ) {
        __bsScroll_keyValues =
        @{
          @"hidden-vbar": @kbsScrollVerticalHidden, @"hidden-vertical-bar": @kbsScrollVerticalHidden,
          @"hidden-hbar": @kbsScrollHorizontalHidden, @"hidden-horizontal-bar": @kbsScrollHorizontalHidden,
          @"scroll-enabled": @kbsScrollEnabled, @"animation": @kbsScrollAnimation,
          @"page-enabled": @kbsScrollPageEnabled, @"to-top" : @kbsScrollToTap, @"flash-bar" : @kbsScrollFlashBar,
          @"dragging": @kbsScrollDragging, @"traking": @kbsScrollTracking, @"decelerating": @kbsScrollDecelerating,
          @"bounce": @kbsScrollBounce, @"bounce-zoom": @kbsScrollBounceZoom,
          @"bounce-v": @kbsScrollVerticalBounce, @"bounce-vertical": @kbsScrollVerticalBounce,
          @"bounce-h": @kbsScrollHorizontalBounce, @"bounce-horizontal": @kbsScrollHorizontalBounce,
          @"zoom": @kbsScrollZoomScale, @"zoom-min": @kbsScrollMinZoomScale, @"zoom-max": @kbsScrollMaxZoomScale, @"zooming": @kbsScrollZooming,
          @"content-size": @kbsScrollContentSize, @"content-offset": @kbsScrollContentOffset, @"content-inset": @kbsScrollContentInset,
          @"content-rect": @kbsScrollContentRect, @"direction-lock": @kbsScrollDirectionalLock, @"directional-lock": @kbsScrollDirectionalLock
          };
    }
    animation_ = YES;
    dragging_ = NO;
    decelerating_ = NO;
    zooming_ = NO;
    zoomView_ = nil;
    scrollView_.delegate = nil;
    scrollView_.showsHorizontalScrollIndicator = YES;
    scrollView_.showsVerticalScrollIndicator = YES;
    scrollView_.scrollEnabled = YES;
    scrollView_.pagingEnabled = NO;
    scrollView_.scrollsToTop = NO;
    scrollView_.bounces = NO;
    scrollView_.bouncesZoom = YES;
    scrollView_.alwaysBounceVertical = NO;
    scrollView_.alwaysBounceHorizontal = NO;
    scrollView_.zoomScale = 1.0;
    scrollView_.minimumZoomScale = 1.0;
    scrollView_.maximumZoomScale = 1.0;
    scrollView_.contentOffset = CGPointZero;
    scrollView_.contentSize = CGSizeZero;
    scrollView_.contentInset = UIEdgeInsetsZero;
    scrollView_.directionalLockEnabled = NO;
}

- (void)dealloc {
    
    NSLog(@"bsScroll dealloc");
    objc_removeAssociatedObjects( self );
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    scrollView_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsScroll_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsScrollVerticalHidden: value = @(!scrollView_.showsVerticalScrollIndicator); break;
        case kbsScrollHorizontalHidden: value = @(!scrollView_.showsHorizontalScrollIndicator); break;
        case kbsScrollEnabled: value = @(scrollView_.scrollEnabled); break;
        case kbsScrollPageEnabled: value = @(scrollView_.pagingEnabled); break;
        case kbsScrollToTap: value = @(scrollView_.scrollsToTop); break;
        case kbsScrollDragging: value = @(scrollView_.dragging); break;
        case kbsScrollTracking: value = @(scrollView_.tracking); break;
        case kbsScrollDecelerating: value = @(scrollView_.isDecelerating); break;
        case kbsScrollAnimation: value = @(animation_); break;
        case kbsScrollBounce: value = @(scrollView_.bounces); break;
        case kbsScrollBounceZoom: value = @(scrollView_.bouncesZoom); break;
        case kbsScrollVerticalBounce: value = @(scrollView_.alwaysBounceVertical); break;
        case kbsScrollHorizontalBounce: value = @(scrollView_.alwaysBounceHorizontal); break;
        case kbsScrollZoomScale: value = @(scrollView_.zoomScale); break;
        case kbsScrollMinZoomScale: value = @(scrollView_.minimumZoomScale); break;
        case kbsScrollMaxZoomScale: value = @(scrollView_.maximumZoomScale); break;
        case kbsScrollZooming: value = @(scrollView_.zooming); break;
        case kbsScrollContentSize: value = [bsSize G:scrollView_.contentSize]; break;
        case kbsScrollContentOffset: value = [bsPoint G:scrollView_.contentOffset]; break;
        case kbsScrollContentInset: value = [bsEdgeInsets G:scrollView_.contentInset]; break;
        case kbsScrollDirectionalLock: value = @(scrollView_.directionalLockEnabled); break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    NSMutableArray *remain = [NSMutableArray array];
    BOOL contentOffsetChange = NO;
    BOOL contentRectChange = NO;
    BOOL zoomScaleChange = NO;
    CGPoint contentOffset;
    CGRect contentRect;
    float zoomScale;
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsScroll_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsScrollVerticalHidden: scrollView_.showsVerticalScrollIndicator = ![bsStr BOOLEAN:v]; break;
            case kbsScrollHorizontalHidden: scrollView_.showsHorizontalScrollIndicator = ![bsStr BOOLEAN:v]; break;
            case kbsScrollEnabled: scrollView_.scrollEnabled = [bsStr BOOLEAN:v]; break;
            case kbsScrollPageEnabled: scrollView_.pagingEnabled = [bsStr BOOLEAN:v]; break;
            case kbsScrollToTap: scrollView_.scrollsToTop = [bsStr BOOLEAN:v]; break;
            case kbsScrollAnimation: animation_ = [bsStr BOOLEAN:v]; break;
            case kbsScrollFlashBar: [scrollView_ flashScrollIndicators]; break;
            case kbsScrollBounce: scrollView_.bounces = [bsStr BOOLEAN:v] ; break;
            case kbsScrollBounceZoom: scrollView_.bouncesZoom = [bsStr BOOLEAN:v]; break;
            case kbsScrollVerticalBounce: scrollView_.alwaysBounceVertical = [bsStr BOOLEAN:v]; break;
            case kbsScrollHorizontalBounce: scrollView_.alwaysBounceHorizontal = [bsStr BOOLEAN:v]; break;
            case kbsScrollZoomScale: zoomScaleChange = YES; zoomScale = [bsStr FLOAT:v]; break;
            case kbsScrollMinZoomScale: scrollView_.minimumZoomScale = [bsStr FLOAT:v]; break;
            case kbsScrollMaxZoomScale: scrollView_.maximumZoomScale = [bsStr FLOAT:v]; break;
            case kbsScrollDirectionalLock: scrollView_.directionalLockEnabled = [bsStr BOOLEAN:v]; break;
            case kbsScrollContentSize: {
                NSArray *c = [bsStr arg:v];
                if( [c count] != 2 ) {
                    bsException( @"content-size value %@ is invalid. It should be a value of the form sizeWidth|sizeHeight", v );
                }
                scrollView_.contentSize = CGSizeMake( [c[0] floatValue], [c[1] floatValue] );
            } break;
            case kbsScrollContentOffset: {
                NSArray *c = [bsStr arg:v];
                if( [c count] != 2 ) {
                    bsException( @"content-offset value %@ is invalid. It should be a value of the form offsetX|offsetY", v );
                }
                contentOffsetChange = YES;
                contentOffset = CGPointMake( [c[0] floatValue], [c[1] floatValue] );
            } break;
            case kbsScrollContentInset: {
                NSArray *c = [bsStr arg:v];
                if( [c count] != 4 ) {
                    bsException( @"padding value %@ is invalid. It should be a value of the form top|right|bottom|left", v );
                }
                scrollView_.contentInset = UIEdgeInsetsMake( [c[0] floatValue], [c[3] floatValue], [c[2] floatValue], [c[1] floatValue] );
            } break;
            case kbsScrollContentRect: {
                NSArray *c = [bsStr arg:v];
                if( [c count] != 4 ) {
                    bsException( @"content-rect value %@ is invalid. It should be a value of the form x|y|w|z", v );
                }
                contentRectChange = YES;
                contentRect = CGRectMake( [c[0] floatValue], [c[1] floatValue], [c[2] floatValue], [c[3] floatValue] );
            } break;
                
        }
    }
    if( contentOffsetChange ) {
        [scrollView_ setContentOffset:contentOffset animated:animation_];
    }
    if( zoomScaleChange ) {
        [scrollView_ setZoomScale:zoomScale animated:animation_];
    }
    if( contentRectChange ) {
        [scrollView_ scrollRectToVisible:contentRect animated:animation_];
    }
    return remain;
}

#pragma mark - child
- (NSString *)create:(NSString *)name params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay G:name params:params];
    [scrollView_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay G:name params:params replace:replace];
    [scrollView_ addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay GT:key params:params];
    [scrollView_ addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay GT:key params:params replace:replace];
    [scrollView_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params];
    [scrollView_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params replace:replace];
    [scrollView_ addSubview:o];
    return o.key;
}

- (bsDisplay *)childG:(NSString *)key {
    
    __block bsDisplay *c = nil;
    [scrollView_.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if( [obj isKindOfClass:[bsDisplay class]] && [((bsDisplay*)obj).key isEqualToString:key] ) {
            c = (bsDisplay*)obj;
            *stop = YES;
        }
    }];
    return c;
}

- (void)childA:(bsDisplay *)child {
    
    [scrollView_ addSubview:child];
}

- (void)childD:(NSString *)key {
    
    if( [key isEqualToString:@"*"] ) {
        NSArray *childs = scrollView_.subviews;
        [childs enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    } else {
        bsDisplay *child = [self childG:key];
        if( child ) [child removeFromSuperview];
    }
}

- (void)childS:(NSString *)key params:(NSString *)params {
    
    bsDisplay *child = [self childG:key];
    if( child ) {
        [child s:params];
    }
}

- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsDisplay *child = [self childG:key];
    if( child ) {
        [child s:params replace:replace];
    }
}

#pragma mark - zoom & pan blocks

- (void)blockZoom:(bsScrollZoomBlock)block zoomView:(UIView *)zoomView {
    
    if( !zoomView ) bsException( @"zoomView is nil" );
    if( scrollView_.delegate == nil ) scrollView_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyZoom_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockPan:(bsScrollPanBlock)block {
    
    if( scrollView_.delegate == nil ) scrollView_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyPan_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockAnimateEnd:(bsScrollAnimateEndBlock)block {
    
    if( scrollView_.delegate == nil ) scrollView_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyAnimateEnd_, block, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - delegate

// Zooming
- (void)__zoomWithStart:(BOOL)start end:(BOOL)end {
    
    bsScrollZoomBlock block = objc_getAssociatedObject( self, &blockKeyZoom_ );
    if( block ) block( self, scrollView_.zoomScale, start, end );
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self __zoomWithStart:NO end:NO];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return zoomView_;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    [self __zoomWithStart:YES end:NO];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    [self __zoomWithStart:NO end:YES];
}

// Dragging
- (void)__panWithDragStart:(BOOL)dragStart dragWillEnd:(BOOL)dragWillEnd dragEnd:(BOOL)dragEnd decelerateStart:(BOOL)decelerateStart decelerateEnd:(BOOL)decelerateEnd {
    
    bsScrollPanBlock block = objc_getAssociatedObject( self, &blockKeyPan_ );
    if( block ) block( self, scrollView_.contentOffset.x, scrollView_.contentOffset.y, dragStart, dragging_, dragWillEnd, dragEnd, decelerateStart, decelerating_, decelerateEnd );
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self __panWithDragStart:NO dragWillEnd:NO dragEnd:NO decelerateStart:NO decelerateEnd:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    dragging_ = YES;
    [self __panWithDragStart:YES dragWillEnd:NO dragEnd:NO decelerateStart:NO decelerateEnd:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    
    [self __panWithDragStart:NO dragWillEnd:YES dragEnd:NO decelerateStart:NO decelerateEnd:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self __panWithDragStart:NO dragWillEnd:NO dragEnd:NO decelerateStart:NO decelerateEnd:NO];
    dragging_ = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    decelerating_ = YES;
    [self __panWithDragStart:NO dragWillEnd:NO dragEnd:NO decelerateStart:YES decelerateEnd:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self __panWithDragStart:NO dragWillEnd:NO dragEnd:NO decelerateStart:NO decelerateEnd:YES];
    decelerating_ = NO;
}

//Animation End관련
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    bsScrollAnimateEndBlock block = objc_getAssociatedObject( self, &blockKeyAnimateEnd_ );
    if( block ) block( self, scrollView_.contentOffset.x, scrollView_.contentOffset.y, scrollView_.zoomScale );
}

@end
