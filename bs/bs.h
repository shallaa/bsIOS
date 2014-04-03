/*
 Notice:
 1. Default width and height do NOT work property!
 2. Be sure to pass the name of app delegate class 
    as third argument to main function like this:
 
 int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([clAppDelegate class]), NSStringFromClass([clAppDelegate class]));
    }
 }
 */

#import <UIKit/UIKit.h>

//core
#import "bsIni.h"
#import "bsObj.h"
#import "bsGeometry.h"
#import "bsStr.h"
#import "bsError.h"
#import "bsMacro.h"
#import "bsLog.h"
#import "bsRuntime.h"
#import "bsBinding.h"
#import "bsNotification.h"

//display
#import "bsDisplayController.h"
#import "bsDisplayLayer.h"
#import "bsDisplay.h"
#import "bsDisplayUtil.h"
#import "bsLabel.h"
#import "bsImage.h"
#import "bsButton.h"
#import "bsTextField.h"
#import "bsText.h"
#import "bsScroll.h"
#import "bsTablePlain.h"
#import "bsTableGroup.h"
#import "bsControl.h"
#import "bsSpinner.h"
#import "bsSwitch.h"
#import "bsPage.h"
#import "bsStepper.h"
#import "bsMap.h"
#import "bsDatePicker.h"
#import "bsAlert.h"
#import "bsPopover.h"
//#import "bsDoc.h"
#import "bsKeyboard.h"
#import "bsActionSheet.h"
#import "bsText.h"
#import "bsSegment.h"

//http
#import "bsHttp.h"
#import "bsHttpFile.h"

//system
#import "bsIO.h"
#import "bsSimpleSound.h"

//worker
#import "bsCallback.h"
#import "bsQueue.h"
#import "bsWorker.h"

#import "NSNumber+ProjectBS.h"

@interface bs : UIApplication <UIApplicationDelegate>  {
    
    int idleTimeoutMinutes_;
    NSTimer *idleTimer_;
}

@property (nonatomic, readonly) NSString *ID;
@property (nonatomic, readonly) NSString *VERSION;
@property (nonatomic, readonly) NSString *BUILD;
@property (nonatomic, readonly) NSString *APP_DISPLAY_NAME;
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;
@property (nonatomic, readonly) BOOL isReady;
@property (nonatomic, readonly) BOOL isOpenGL;
@property (nonatomic, readonly) BOOL backgroundTaskSupported;
@property (nonatomic, readonly) UIApplication* app;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly)  NSDictionary *launchOptions;
@property (nonatomic, readonly, getter = _getRoot) bsDisplay *root;
@property (nonatomic, readonly, getter = _getRootController) bsDisplayController *rootController;

+ (bs *)SELF;
- (void)ready;
- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification;

- (bsDisplay *)_getRoot;
- (bsDisplayController *)_getRootController;

#pragma mark - Idle timer

- (void)sendEvent:(UIEvent *)event;
- (void)__setIdleTime:(int)minutes;
- (void)__startIdleTimer;
- (void)__stopIdleTimer;
- (void)__resetIdleTimer;
- (void)__idleTimerExceeded;
- (void)__openURL:(NSString *)url;

#pragma mark - Default Value

+ (NSString *)ID;
+ (NSString *)BUILD;
+ (NSString *)VERSION;
+ (NSString *)APP_DISPLAY_NAME;
+ (float)width;
+ (float)height;
+ (BOOL)isOpenGL;
+ (UIApplication *)app;
+ (UIWindow *)window;
+ (NSDictionary *)launchOptions;
+ (bsDisplay *)root;
+ (void)idleTimerSetTime:(int)minutes;
+ (void)idleTimerStart;
+ (void)idleTimerStop;
+ (void)idleTimerReset;
+ (void)openURL:(NSString *)url;
+ (void)showModal:(UIViewController *)controller animated:(BOOL)animated completion:(void(^)(void))completion;

#pragma mark - Device

+ (UIDeviceOrientation)deviceOrientation;

#pragma mark - Root View Orientation

+ (NSString *)rootOrientBlockWillRotate:(bsDisplayControllerWillRotateBlock)willRotateBlock;
+ (NSString *)rootOrientBlockDidRotate:(bsDisplayControllerDidRotateBlock)didRotateBlock;
+ (void)rootOrientBlockRemove:(NSString *)blockKey;
+ (void)rootOrientAutorotateAllowWithLandLeft:(BOOL)landLeft landRight:(BOOL)landRight portrait:(BOOL)portrait portraitUpsideDown:(BOOL)portraitUpsideDown;
+ (BOOL)rootOrientAutorotateAllowLandLeft;
+ (BOOL)rootOrientAutorotateAllowLandRight;
+ (BOOL)rootOrientAutorotateAllowPortrait;
+ (BOOL)rootOrientAutorotateAllowPortraitUpsideDown;
+ (BOOL)rootOrientAutorotate;
+ (void)rootOrientAutorotateOn;
+ (void)rootOrientRotateLandLeft;
+ (void)rootOrientRotateLandRight;
+ (void)rootOrientRotatePortrait;
+ (void)rootOrientRotatePortraitUpsideDown;
+ (UIInterfaceOrientation)rootOrientCurrent;

#pragma mark - System Notification

+ (void)sysNotiBlockRemove:(NSString *)key;
+ (NSString *)sysNotiBlockIdleTimeout:(bsBlock)block;
+ (NSString *)sysNotiBlockWillUnactive:(bsBlock)block;
+ (NSString *)sysNotiBlockDidUnactive:(bsBlock)block;
+ (NSString *)sysNotiBlockWillActive:(bsBlock)block;
+ (NSString *)sysNotiBlockDidActive:(bsBlock)block;
+ (NSString *)sysNotiBlockDidMemoryWarning:(bsBlock)block;
+ (NSString *)sysNotiBlockWillTerminate:(bsBlock)block;
+ (NSString *)sysNotiBlockBackgroundTask:(bsBackgroundTaskBlock)block;
+ (NSString *)sysNotiBlockBattery:(bsBatteryBlock)block;
+ (NSString *)sysNotiBlockLocaleChange:(bsLocaleChangeBlock)block;
+ (NSString *)sysNotiBlockOrientationChange:(bsOrientationChangeBlock)block;
+ (NSString *)sysNotiBlockUserDefaultChange:(bsUserDefaultChangeBlock)block;
+ (NSString *)sysNotiBlockKeyboardWillShow:(bsKeyboradBlock)block;
+ (NSString *)sysNotiBlockKeyboardDidShow:(bsKeyboradBlock)block;
+ (NSString *)sysNotiBlockKeyboardWillHide:(bsKeyboradBlock)block;
+ (NSString *)sysNotiBlockKeyboardDidHide:(bsKeyboradBlock)block;

#pragma mark - IO

+ (NSData *)ioAssetG:(NSString *)name;
+ (NSData *)ioStorageG:(NSString *)name;
+ (BOOL)ioStorageS:(NSString *)name data:(NSData *)data;
+ (BOOL)ioStorageD:(NSString *)name;
+ (NSData *)ioCacheG:(NSString *)name;
+ (BOOL)ioCacheS:(NSString *)name data:(NSData *)data;
+ (BOOL)ioCacheD:(NSString *)name;

#pragma mark - INI

+ (NSString *)iniG:(NSString *)item;
+ (BOOL)iniGBool:(NSString *)item;

#pragma mark - OBJ

+ (bsObj *)objPopAsync;
+ (bsObjSync *)objPopSync;
+ (void)objPut:(bsObj *)target;

#pragma mark - STR

+ (NSString *)str:(id)val;
+ (NSInteger)strInteger:(NSString *)val;
+ (int)strInt:(NSString *)val;
+ (long long)strLongLong:(NSString *)val;
+ (float)strFloat:(NSString *)val;
+ (double)strDouble:(NSString *)val;
+ (BOOL)strBool:(NSString *)val;
+ (NSDictionary *)strDic:(NSString *)val;
+ (UIColor *)strColor:(NSString *)val;
+ (id)strTrim:(id)val;
+ (NSString *)strSubstrForPrintKoreanWithString:(NSString*)str length:(NSUInteger)length;
+ (NSString *)strReplace:(NSString *)source search:(id)search dest:(NSString *)dest;
+ (NSString *)strTemplate:(NSString *)source replace:(id)replace;
+ (BOOL)strIsUrl:(NSString *)url;
+ (NSString *)strUrlEncode:(NSString*)string;
+ (NSString *)strUrlDecode:(NSString*)string;
+ (NSArray *)strSplit:(NSString*)string seperator:(NSString*)seperator trim:(BOOL)isTrim;
+ (NSArray *)strRow:(NSString*)string;
+ (NSArray *)strCol:(NSString*)string;
+ (NSArray *)strArg:(NSString*)string;
+ (NSArray *)strTag:(NSString*)string;
+ (NSString *)strJsonEncode:(id)obj;
+ (id)strJsonDecode:(id)json;
+ (NSString *)strUUID;
+ (BOOL)strIsIpAddress:(NSString *)ipAddr;
+ (NSString *)strAddSlashes:(NSString *)str;
+ (BOOL)strRegExpTestWithPattern:(NSString *)pattern value:(NSString *)value;

#pragma mark - Binding

+ (NSString *)bindStart:(id)rootObject keyPathes:(NSArray *)keyPathes block:(bsBindingBlock)block;
+ (void)bindEndWithUniqueId:(NSString *)uniqueId;
+ (void)bindInvoke:(NSString *)uniqueId;

#pragma mark - Param

+ (NSString *)paramG:(NSString *)key;
+ (void)paramsA:(NSString *)key params:(NSString *)params;

#pragma mark - HTTP

+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end;
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile*)file endBlock:(bsCallbackBlock)end;
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector;
+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary*)post file:(bsHttpFile *)file error:(bsError **)error;
+ (void)cancel:(NSString *)key;
+ (NSString *)ipAddr;

#pragma mark - display
+ (bsDisplay *)displayG:(NSString *)name params:(NSString *)params;
+ (bsDisplay *)displayG:(NSString*)name params:(NSString*)params replace:(id)replace;
+ (bsDisplay *)displayGT:(NSString*)key params:(NSString*)params;
+ (bsDisplay *)displayGT:(NSString *)key params:(NSString *)params replace:(id)replace;
+ (bsDisplay *)displayG:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params;
+ (bsDisplay *)displayG:(NSString*)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace;
+ (void)displayAT:(NSString *)key name:(NSString *)name params:(NSString *)params;
+ (void)displayAS:(NSString *)styleName params:(NSString *)params;

#pragma mark - alert

+ (void)alert:(NSString *)params block:(bsAlertBlock)block;
+ (void)alert:(NSString *)params replace:(id)replace block:(bsAlertBlock)block;

#pragma mark - display layer

+ (void)layerParentA:(bsDisplay *)parent parentName:(NSString *)parentName;
+ (void)layerParentD:(NSString *)parentName;
+ (bsDisplay *)layerParentG:(NSString* )parentName;
+ (void)layerParentS:(NSString *)parentName params:(NSString *)params;
+ (void)layerParentS:(NSString *)parentName params:(NSString *)params replace:(id)replace;
+ (bsDisplay *)layerG:(NSString*)layerName parentName:(NSString *)parentName;
+ (NSArray *)layersG:(NSString*)layerNames parentName:(NSString *)parentName;
+ (bsDisplay *)layerA:(NSString*)layerName hidden:(BOOL)hidden parentName:(NSString *)parentName;
+ (NSArray *)layersA:(NSString*)layerNames hidden:(BOOL)hidden parentName:(NSString *)parentName;
+ (bsDisplay *)layerD:(NSString *)layerName parentName:(NSString *)parentName;
+ (NSArray *)layersD:(NSString *)layerNames parentName:(NSString *)parentName;
+ (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString *)params;
+ (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString*)params replace:(id)replace;
+ (void)layerChildD:(NSString *)layerName parentName:(NSString *)parentName childKeys:(NSString *)childKeys;

#pragma mark - sound

+ (BOOL)soundA:(NSString *)key fullFileName:(NSString *)fullFileName;
+ (BOOL)soundD:(NSString *)key;
+ (BOOL)soundP:(NSString *)key;

#pragma mark - keyboard

+ (void)keyboardHide;

@end
