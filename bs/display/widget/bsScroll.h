#import "bsDisplay.h"

@class bsScroll;

typedef void (^bsScrollZoomBlock)(bsScroll *scroll, float scale, BOOL zoomStart, BOOL zoomEnd);
typedef void (^bsScrollPanBlock)(bsScroll *scroll, float x, float y, BOOL dragStart, BOOL dragging, BOOL dragWillEnd, BOOL dragEnd, BOOL decelerateStart, BOOL decelerating, BOOL decelerateEnd);
typedef void (^bsScrollAnimateEndBlock)(bsScroll *scroll, float x, float y, float scale);

#define kbsScrollVerticalHidden     100401
#define kbsScrollHorizontalHidden     100402
#define kbsScrollEnabled 100403
#define kbsScrollPageEnabled 100404
#define kbsScrollToTap 100405
#define kbsScrollDragging 100406 //readonly
#define kbsScrollTracking 100407 //readonly
#define kbsScrollDecelerating 100408 //readonly
#define kbsScrollAnimation 100409
#define kbsScrollFlashBar 100410 //writeonly
#define kbsScrollDirectionalLock 100411
//Zoom
#define kbsScrollMinZoomScale 100420
#define kbsScrollMaxZoomScale 100421
#define kbsScrollZoomScale 100422
#define kbsScrollZooming 100423 //readonly
//Bounce
#define kbsScrollVerticalBounce 100425
#define kbsScrollHorizontalBounce 100426
#define kbsScrollBounce 100427
#define kbsScrollBounceZoom 100428
//Content
#define kbsScrollContentSize 100430
#define kbsScrollContentOffset 100431
#define kbsScrollContentInset 100432 
#define kbsScrollContentRect 100433 //writeonly

@interface bsScroll : bsDisplay <UIScrollViewDelegate> {
    
    UIScrollView *scrollView_;
    BOOL animation_;
    NSString *blockKeyZoom_;
    NSString *blockKeyPan_;
    NSString *blockKeyAnimateEnd_;
    BOOL dragging_;
    BOOL decelerating_;
    BOOL zooming_;
    UIView *zoomView_;
}

#pragma mark - zoom & pan blocks
- (void)blockZoom:(bsScrollZoomBlock)block zoomView:(UIView *)zoomView;
- (void)blockPan:(bsScrollPanBlock)block;
- (void)blockAnimateEnd:(bsScrollAnimateEndBlock)block;

@end
