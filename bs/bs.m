//
//  bs.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/14.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bs.h"

static bs *__bs_SELF = nil;

@implementation bs

+ (bs *)SELF {
    
    return __bs_SELF;
}

- (void)ready {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (__bs_SELF) {
        bsException(NSInternalInconsistencyException, @"bs cannot create twice!");
    }
    __bs_SELF = self;
    
    // Detault idle timeout: 30 minutes
    idleTimeoutMinutes_ = 30;
    
    // Initialization
    [bsIO onCreate];
    [bsIni onCreate];
    [bsNotification onCreate];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    } else {
        // handling statusBar (iOS7)
        application.statusBarStyle = UIStatusBarStyleLightContent;
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        _window.clipsToBounds = YES;
        // handling screen rotations for statusBar (iOS7)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    _ID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    _BUILD = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    _VERSION = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _APP_DISPLAY_NAME = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    _app = [UIApplication sharedApplication];
    _launchOptions = launchOptions;
    [self.app setStatusBarHidden:![bsIni iniBool:@"statusBar"]];
    
    // Detect multitask support
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]){
        _backgroundTaskSupported = [UIDevice currentDevice].multitaskingSupported;
    }
    // Create controller
    bsDisplayController *controller = [[bsDisplayController alloc] initWithLoadBlock:^(bsDisplayController *controller) {
        // Start
        _isReady = YES;
        [self ready];
    }];
    self.window.rootViewController = controller;
    
    // Show window
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    
    // handling statusBar (iOS7)
    self.window.frame = [UIScreen mainScreen].applicationFrame;
}

- (bsDisplay *)_getRoot {
    
    return (bsDisplay *)self.window.rootViewController.view;
}

- (bsDisplayController *)_getRootController {
    
    return (bsDisplayController *)self.window.rootViewController;
}

#pragma mark - Idle timer

- (void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    
    // Initialize if the idle timer is running
    if ( idleTimer_ ) {
        NSSet *allTouches = [event allTouches];
        if ([allTouches count] > 0) {
            UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
            if (phase == UITouchPhaseBegan) {
                [self __resetIdleTimer];
            }
        }
    }
}

- (void)__setIdleTime:(int)minutes {
    
    idleTimeoutMinutes_ = minutes;
    if (idleTimer_) {
        [self __startIdleTimer];
    }
}

- (void)__startIdleTimer {
    
    if (idleTimer_) {
        [self __stopIdleTimer];
    }
    int timeout = idleTimeoutMinutes_ * 60;
    idleTimer_ = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(__idleTimerExceeded) userInfo:nil repeats:NO];
}

- (void)__stopIdleTimer {
    
    if (idleTimer_ && idleTimer_.isValid) {
        [idleTimer_ invalidate];
    }
    idleTimer_ = nil;
}

- (void)__resetIdleTimer {
    
    if (idleTimer_ == nil) {
        return;
    }
    if (idleTimer_.isValid) {
        [idleTimer_ invalidate];
    }
    int timeout = idleTimeoutMinutes_ * 60;
    idleTimer_ = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(__idleTimerExceeded) userInfo:nil repeats:NO];
}

- (void)__idleTimerExceeded {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimeOut" object:nil];
    [self __startIdleTimer];
}

- (void)__openURL:(NSString *)url {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Default Value
+ (NSString *)ID { return [bs SELF].ID; }
+ (NSString *)BUILD { return [bs SELF].BUILD; }
+ (NSString *)VERSION { return [bs SELF].VERSION; }
+ (NSString *)APP_DISPLAY_NAME { return [bs SELF].APP_DISPLAY_NAME; }
+ (float)width { return [bs SELF].width; }
+ (float)height { return [bs SELF].height; }
+ (BOOL)isOpenGL { return [bs SELF].isOpenGL; }
+ (UIApplication *)app { return [bs SELF].app; }
+ (UIWindow *)window { return [bs SELF].window; }
+ (NSDictionary *)launchOptions { return [bs SELF].launchOptions; }
+ (bsDisplay*)root { return [bs SELF].root; }
+ (void)idleTimerSetTime:(int)minutes { [[bs SELF] __setIdleTime:minutes]; }
+ (void)idleTimerStart { [[bs SELF] __startIdleTimer]; }
+ (void)idleTimerStop { [[bs SELF] __stopIdleTimer]; }
+ (void)idleTimerReset { [[bs SELF] __resetIdleTimer]; }
+ (void)openURL:(NSString *)url { [[bs SELF] __openURL:url]; }
+ (void)showModal:(UIViewController *)controller animated:(BOOL)animated completion:(void(^)(void))completion {
    [[[bs SELF] _getRootController] presentViewController:controller animated:animated completion:completion];
}

#pragma mark - Device
+ (UIDeviceOrientation)deviceOrientation { return [UIDevice currentDevice].orientation; }

#pragma mark - Root View Orientation
+ (NSString *)rootOrientBlockWillRotate:(bsDisplayControllerWillRotateBlock)willRotateBlock { return [[bs SELF].rootController blockWillRotate:willRotateBlock]; }
+ (NSString *)rootOrientBlockDidRotate:(bsDisplayControllerDidRotateBlock)didRotateBlock { return [[bs SELF].rootController blockDidRotate:didRotateBlock]; }
+ (void)rootOrientBlockRemove:(NSString *)blockKey { [[bs SELF].rootController blockRemove:blockKey]; }
+ (void)rootOrientAutorotateAllowWithLandLeft:(BOOL)landLeft landRight:(BOOL)landRight portrait:(BOOL)portrait portraitUpsideDown:(BOOL)portraitUpsideDown { [[bs SELF].rootController rotateAutoAllowWithLandLeft:landLeft landRight:landRight portrait:portrait portraitUpsideDown:portraitUpsideDown]; }
+ (BOOL)rootOrientAutorotateAllowLandLeft { return [bs SELF].rootController.rotateAutoAllowLandLeft; }
+ (BOOL)rootOrientAutorotateAllowLandRight { return [bs SELF].rootController.rotateAutoAllowLandRight; }
+ (BOOL)rootOrientAutorotateAllowPortrait { return [bs SELF].rootController.rotateAutoAllowPortrait; }
+ (BOOL)rootOrientAutorotateAllowPortraitUpsideDown { return [bs SELF].rootController.rotateAutoAllowPortraitUpsideDown; }
+ (BOOL)rootOrientAutorotate { return [bs SELF].rootController.rotateAuto; }
+ (void)rootOrientAutorotateOn { [[bs SELF].rootController rotateAutoOn]; }
+ (void)rootOrientRotateLandLeft { [[bs SELF].rootController rotateLandLeft]; }
+ (void)rootOrientRotateLandRight { [[bs SELF].rootController rotateLandRight]; }
+ (void)rootOrientRotatePortrait { [[bs SELF].rootController rotatePortrait]; }
+ (void)rootOrientRotatePortraitUpsideDown { [[bs SELF].rootController rotatePortraitUpsideDown]; }
+ (UIInterfaceOrientation)rootOrientCurrent { return [bs SELF].rootController.currentOrientation; }

#pragma mark - System Notification
+ (void)sysNotiBlockRemove:(NSString *)key { [bsNotification blockRemove:key]; }
+ (NSString *)sysNotiBlockIdleTimeout:(bsBlock)block { return [bsNotification blockIdleTimeout:block]; }
+ (NSString *)sysNotiBlockWillUnactive:(bsBlock)block { return [bsNotification blockWillUnactive:block]; }
+ (NSString *)sysNotiBlockDidUnactive:(bsBlock)block { return [bsNotification blockDidUnactive:block]; }
+ (NSString *)sysNotiBlockWillActive:(bsBlock)block { return [bsNotification blockWillActive:block]; }
+ (NSString *)sysNotiBlockDidActive:(bsBlock)block { return [bsNotification blockDidActive:block]; }
+ (NSString *)sysNotiBlockDidMemoryWarning:(bsBlock)block { return [bsNotification blockDidMemoryWarning:block]; }
+ (NSString *)sysNotiBlockWillTerminate:(bsBlock)block { return [bsNotification blockWillTerminate:block]; }
+ (NSString *)sysNotiBlockBackgroundTask:(bsBackgroundTaskBlock)block { return [bsNotification blockBackgroundTask:block]; }
+ (NSString *)sysNotiBlockBattery:(bsBatteryBlock)block { return [bsNotification blockBattery:block]; }
+ (NSString *)sysNotiBlockLocaleChange:(bsLocaleChangeBlock)block { return [bsNotification blockLocaleChange:block]; }
+ (NSString *)sysNotiBlockOrientationChange:(bsOrientationChangeBlock)block { return [bsNotification blockOrientationChange:block]; }
+ (NSString *)sysNotiBlockUserDefaultChange:(bsUserDefaultChangeBlock)block { return [bsNotification blockUserDefaultChange:block]; }
+ (NSString *)sysNotiBlockKeyboardWillShow:(bsKeyboradBlock)block { return [bsNotification blockKeyboardWillShow:block]; }
+ (NSString *)sysNotiBlockKeyboardDidShow:(bsKeyboradBlock)block { return [bsNotification blockKeyboardDidShow:block]; }
+ (NSString *)sysNotiBlockKeyboardWillHide:(bsKeyboradBlock)block { return [bsNotification blockKeyboardWillHide:block]; }
+ (NSString *)sysNotiBlockKeyboardDidHide:(bsKeyboradBlock)block { return [bsNotification blockKeyboardDidHide:block]; }

#pragma mark - IO
+ (NSData *)ioAssetG:(NSString *)name { return [bsIO assetG:name]; }
+ (NSData *)ioStorageG:(NSString *)name { return [bsIO storageG:name]; }
+ (BOOL)ioStorageS:(NSString *)name data:(NSData *)data { return [bsIO storageS:name data:data]; }
+ (BOOL)ioStorageD:(NSString *)name { return [bsIO storageD:name]; }
+ (NSData *)ioCacheG:(NSString *)name { return [bsIO cacheG:name]; }
+ (BOOL)ioCacheS:(NSString *)name data:(NSData *)data { return [bsIO cacheS:name data:data]; }
+ (BOOL)ioCacheD:(NSString *)name { return [bsIO cacheD:name]; }

#pragma mark - INI
+ (NSString*)iniG:(NSString*)item { return [bsIni ini:item]; }
+ (BOOL)iniGBool:(NSString*)item { return [bsIni iniBool:item]; }

#pragma mark - OBJ
+ (bsObj*)objPopAsync { return [bsObj pop:NO]; }
+ (bsObjSync*)objPopSync { return (bsObjSync*)[bsObj pop:YES]; }
+ (void)objPut:(bsObj*)target { [bsObj put:target]; }

#pragma mark - STR
+ (NSString*)str:(id)val { return [bsStr str:val]; }
+ (NSInteger)strInteger:(NSString*)val { return [bsStr INTEGER:val]; }
+ (int)strInt:(NSString*)val { return [bsStr INT:val]; }
+ (long long)strLongLong:(NSString*)val { return [bsStr LONGLONG:val]; }
+ (float)strFloat:(NSString*)val { return [bsStr FLOAT:val]; }
+ (double)strDouble:(NSString*)val { return [bsStr DOUBLE:val]; }
+ (BOOL)strBool:(NSString*)val { return [bsStr BOOLEAN:val]; }
+ (NSDictionary*)strDic:(NSString*)val { return [bsStr DIC:val]; }
+ (UIColor*)strColor:(NSString*)val { return [bsStr color:val]; }
+ (id)strTrim:(id)val { return [bsStr trim:val]; }
+ (NSString*)strSubstrForPrintKoreanWithString:(NSString*)str length:(NSUInteger)length { return [bsStr substrForPrintKoreanWithString:str length:length]; }
+ (NSString*)strReplace:(NSString*)source search:(id)search dest:(NSString*)dest { return [bsStr replace:source search:search dest:dest]; }
+ (NSString*)strTemplate:(NSString*)source replace:(id)replace { return [bsStr templateSrc:source replace:replace]; }
+ (BOOL)strIsUrl:(NSString*)url { return [bsStr isUrl:url]; }
+ (NSString*)strUrlEncode:(NSString*)string { return [bsStr urlEncode:string]; }
+ (NSString*)strUrlDecode:(NSString*)string { return [bsStr urlDecode:string]; }
+ (NSArray*)strSplit:(NSString*)string seperator:(NSString*)seperator trim:(BOOL)isTrim { return [bsStr split:string seperator:seperator trim:isTrim]; }
+ (NSArray*)strRow:(NSString*)string { return [bsStr row:string]; }
+ (NSArray*)strCol:(NSString*)string { return [bsStr col:string]; }
+ (NSArray*)strArg:(NSString*)string { return [bsStr arg:string]; }
+ (NSArray*)strTag:(NSString*)string { return [bsStr tag:string]; }
+ (NSString*)strJsonEncode:(id)obj { return [bsStr jsonEncode:obj]; }
+ (id)strJsonDecode:(id)json { return [bsStr jsonDecode:json]; }
+ (NSString*)strUUID { return [bsStr UUID]; }
+ (BOOL)strIsIpAddress:(NSString*)ipAddr { return [bsStr isIpAddress:ipAddr]; }
+ (NSString*)strAddSlashes:(NSString*)str { return [bsStr addSlashes:str]; }
+ (BOOL)strRegExpTestWithPattern:(NSString*)pattern value:(NSString*)value { return [bsStr regExpTestWithPattern:pattern value:value]; }

#pragma mark - Binding
+ (NSString *)bindStart:(id)rootObject keyPathes:(NSArray *)keyPathes block:(bsBindingBlock)block { return [bsBinding bind:rootObject keyPathes:keyPathes block:block]; }
+ (void)bindEndWithUniqueId:(NSString *)uniqueId { [bsBinding unbindWithUniqueId:uniqueId]; }
+ (void)bindInvoke:(NSString *)uniqueId { [bsBinding invoke:uniqueId]; }

#pragma mark - Param
+ (NSString *)paramG:(NSString *)key { return [bsParam G:key]; }
+ (void)paramsA:(NSString *)key params:(NSString *)params { [bsParam A:key params:params]; }

#pragma mark - HTTP
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file end:(bsCallback *)end { return [bsHttp sendWithUrl:url get:get post:post file:file end:end]; }
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file endBlock:(bsCallbackBlock)end { return [bsHttp sendWithUrl:url get:get post:post file:file endBlock:end]; }
+ (NSString *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file target:(id)target selector:(SEL)selector { return [bsHttp sendWithUrl:url get:get post:post file:file target:target selector:selector]; }
+ (NSData *)sendWithUrl:(NSString *)url get:(NSDictionary *)get post:(NSDictionary *)post file:(bsHttpFile *)file error:(bsError **)error { return [bsHttp sendWithUrl:url get:get post:post file:file error:error]; }
+ (void)cancel:(NSString *)key { [bsHttp cancel:key]; }
+ (NSString *)ipAddr { return [bsHttp ipAddr]; }

#pragma mark - display
+ (bsDisplay *)displayG:(NSString *)name params:(NSString *)params { return [bsDisplay G:name params:params]; }
+ (bsDisplay *)displayG:(NSString *)name params:(NSString *)params replace:(id)replace { return [bsDisplay G:name params:params replace:replace]; }
+ (bsDisplay *)displayGT:(NSString *)key params:(NSString *)params { return [bsDisplay GT:key params:params]; }
+ (bsDisplay *)displayGT:(NSString *)key params:(NSString *)params replace:(id)replace { return [bsDisplay GT:key params:params replace:replace]; }
+ (bsDisplay *)displayG:(NSString *)name styleNames:(NSString *)styleNames params:(NSString*)params { return [bsDisplay G:name styleNames:styleNames params:params]; }
+ (bsDisplay *)displayG:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace { return [bsDisplay G:name styleNames:styleNames params:params replace:replace]; }
+ (void)displayAT:(NSString *)key name:(NSString *)name params:(NSString *)params { [bsDisplay AT:key name:name params:params]; }
+ (void)displayAS:(NSString *)styleName params:(NSString *)params { [bsDisplay AS:styleName params:params]; }

#pragma mark - alert
+ (void)alert:(NSString *)params block:(bsAlertBlock)block { [bsAlert alert:params block:block]; }
+ (void)alert:(NSString *)params replace:(id)replace block:(bsAlertBlock)block { [bsAlert alert:params replace:replace block:block]; }

#pragma mark - display layer
+ (void)layerParentA:(bsDisplay *)parent parentName:(NSString *)parentName { [[bsDisplayLayer center] parentA:parent parentName:parentName]; }
+ (void)layerParentD:(NSString *)parentName { [[bsDisplayLayer center] parentD:parentName]; }
+ (bsDisplay *)layerParentG:(NSString *)parentName { return [[bsDisplayLayer center] parentG:parentName]; }
+ (void)layerParentS:(NSString *)parentName params:(NSString *)params { [[bsDisplayLayer center] parentS:parentName params:params]; }
+ (void)layerParentS:(NSString *)parentName params:(NSString *)params replace:(id)replace { [[bsDisplayLayer center] parentS:parentName params:params replace:replace]; }
+ (bsDisplay *)layerG:(NSString *)layerName parentName:(NSString *)parentName { return [[bsDisplayLayer center] layerG:layerName parentName:parentName]; }
+ (NSArray *)layersG:(NSString *)layerNames parentName:(NSString *)parentName { return [[bsDisplayLayer center] layersG:layerNames parentName:parentName]; }
+ (bsDisplay *)layerA:(NSString *)layerName hidden:(BOOL)hidden parentName:(NSString *)parentName { return [[bsDisplayLayer center] layerA:layerName hidden:hidden parentName:parentName]; }
+ (NSArray *)layersA:(NSString *)layerNames hidden:(BOOL)hidden parentName:(NSString *)parentName { return [[bsDisplayLayer center] layersA:layerNames hidden:hidden parentName:parentName]; }
+ (bsDisplay *)layerD:(NSString *)layerName parentName:(NSString *)parentName { return [[bsDisplayLayer center] layerD:layerName parentName:parentName]; }
+ (NSArray *)layersD:(NSString *)layerNames parentName:(NSString *)parentName { return [[bsDisplayLayer center] layersD:layerNames parentName:parentName]; }
+ (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString *)params { [[bsDisplayLayer center] layerS:layerName parentName:parentName params:params]; }
+ (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString *)params replace:(id)replace { [[bsDisplayLayer center] layerS:layerName parentName:parentName params:params replace:replace]; }
+ (void)layerChildD:(NSString *)layerName parentName:(NSString *)parentName childKeys:(NSString *)childKeys { [[bsDisplayLayer center] layerChildD:layerName parentName:parentName childKeys:childKeys]; }

#pragma mark - sound
+ (BOOL)soundA:(NSString *)key fullFileName:(NSString *)fullFileName { return [bsSimpleSound AWithKey:key fullFileName:fullFileName]; }
+ (BOOL)soundD:(NSString *)key { return [bsSimpleSound DWithKey:key]; }
+ (BOOL)soundP:(NSString *)key { return [bsSimpleSound PWithKey:key]; }

#pragma mark - keyboard
+ (void)keyboardHide { [bsKeyboard hideKeyboard]; }
@end
