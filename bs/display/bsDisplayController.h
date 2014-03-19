#import <UIKit/UIKit.h>
#import "bsDisplay.h"

//UIViewController이지만 bs에 특화된 것이다. bs자체에서 사용하므로 직접 생성하지는 말자!
@class bsDisplayController;

typedef void (^bsDisplayControllerLoadBlock)(bsDisplayController* controller);
typedef void (^bsDisplayControllerWillRotateBlock)(NSString *blockKey, UIInterfaceOrientation from, UIInterfaceOrientation to, NSTimeInterval duration);
typedef void (^bsDisplayControllerDidRotateBlock)(NSString *blockKey, UIInterfaceOrientation from, UIInterfaceOrientation to);

@interface bsDisplayController : UIViewController {
    
    bsDisplayControllerLoadBlock loadBlock_;
    NSMutableDictionary *willRotateBlockDic_;
    NSMutableDictionary *didRotateBlockDic_;
    NSUInteger blockKey_;
    UIInterfaceOrientation currentOrientation_;
}

@property (nonatomic, readonly) BOOL rotateAuto;    //자동회전모드인가?
@property (nonatomic, readonly) BOOL rotateAutoAllowLandLeft;   //LandscapeLeft 회전허용?
@property (nonatomic, readonly) BOOL rotateAutoAllowLandRight;  //LandscapeRight 회전허용?
@property (nonatomic, readonly) BOOL rotateAutoAllowPortrait;   //Portrait 회전 허용?
@property (nonatomic, readonly) BOOL rotateAutoAllowPortraitUpsideDown; //PortraitUpsideDown 회전 허용?
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

- (id)initWithLoadBlock:(bsDisplayControllerLoadBlock)loadBlock;
- (NSString *)blockWillRotate:(bsDisplayControllerWillRotateBlock)willRotateBlock;
- (NSString *)blockDidRotate:(bsDisplayControllerDidRotateBlock)didRotateBlock;
- (void)blockRemove:(NSString*)blockKey;
- (void)rotateAutoAllowWithLandLeft:(BOOL)landLeft
                          landRight:(BOOL)landRight
                           portrait:(BOOL)portrait
                 portraitUpsideDown:(BOOL)portraitUpsideDown;
- (void)rotateAutoOn;
- (void)rotateLandRight;
- (void)rotateLandLeft;
- (void)rotatePortrait;
- (void)rotatePortraitUpsideDown;

@end
