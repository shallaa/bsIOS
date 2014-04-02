//
//  bsDisplayController.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsDisplayController.h"

static bsDisplayController *__bsDisplayController_singleton = nil;

@implementation bsDisplayController

@synthesize currentOrientation = currentOrientation_;

- (id)initWithLoadBlock:(bsDisplayControllerLoadBlock)loadBlock {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (self = [super init]) {
        blockKey_ = 0;
        loadBlock_ = loadBlock;
        _rotateAuto = YES;
        willRotateBlockDic_ = [[NSMutableDictionary alloc]init];
        didRotateBlockDic_ = [[NSMutableDictionary alloc]init];
        currentOrientation_ = self.interfaceOrientation;
        //번들 정보를 가지고 회전 설정
        NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
        [self rotateAutoAllowWithLandLeft:[supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"]
                                landRight:[supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeRight"]
                                 portrait:[supportedOrientations containsObject:@"UIInterfaceOrientationPortrait"]
                       portraitUpsideDown:[supportedOrientations containsObject:@"UIInterfaceOrientationPortraitUpsideDown"]];
    }
    return self;
}

- (void)loadView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (__bsDisplayController_singleton) {
        bsException(NSInternalInconsistencyException, @"bsDisplayController can not create directly.");
    }
    self.view = [bsDisplay G:@"display" params:@"key,root,x,0,y,0,bg,#000"];
    __bsDisplayController_singleton = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (loadBlock_) {
        loadBlock_(self);
    }
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    return self.rotateAuto;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSUInteger r = 0;
    if (self.rotateAutoAllowLandLeft) r |= UIInterfaceOrientationMaskLandscapeLeft;
    if (self.rotateAutoAllowLandRight) r |= UIInterfaceOrientationMaskLandscapeRight;
    if (self.rotateAutoAllowPortrait) r |= UIInterfaceOrientationMaskPortrait;
    if (self.rotateAutoAllowPortraitUpsideDown) r |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return r;
}

- (NSString *)blockWillRotate:(bsDisplayControllerWillRotateBlock)willRotateBlock {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (willRotateBlock == nil) {
        bsException(NSInvalidArgumentException, @"willRotateBlock argument is undefined");
    }
    NSString *k = [NSString stringWithFormat:@"bsDisplayControllerWillRotateBlock-%lu", (unsigned long)blockKey_++];
    willRotateBlockDic_[k] = willRotateBlock;
    return k;
}

- (NSString *)blockDidRotate:(bsDisplayControllerDidRotateBlock)didRotateBlock {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (didRotateBlock == nil) {
        bsException(NSInvalidArgumentException, @"didRotateBlock argument is undefined");
    }
    NSString *k = [NSString stringWithFormat:@"bsDisplayControllerDidRotateBlock-%lu", (unsigned long)blockKey_++];
    didRotateBlockDic_[k] = didRotateBlock;
    return k;
}

- (void)blockRemove:(NSString *)blockKey {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (willRotateBlockDic_[blockKey]) {
        [willRotateBlockDic_ removeObjectForKey:blockKey];
    } else if (didRotateBlockDic_[blockKey]) {
        [didRotateBlockDic_ removeObjectForKey:blockKey];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (self.rotateAuto) {
        currentOrientation_ = self.interfaceOrientation;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:willRotateBlockDic_]; //이렇게 하는 이유는 block안에서 blockRemove 호출했을때 문제가 안되도록 하기 위함이다.
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *blockKey, bsDisplayControllerWillRotateBlock block, BOOL *stop) {
        block( blockKey, currentOrientation_, toInterfaceOrientation, duration );
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (self.rotateAuto) {
        currentOrientation_ = self.interfaceOrientation;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:didRotateBlockDic_]; //이렇게 하는 이유는 block안에서 blockRemove 호출했을때 문제가 안되도록 하기 위함이다.
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *blockKey, bsDisplayControllerDidRotateBlock block, BOOL *stop) {
        block( blockKey, fromInterfaceOrientation, currentOrientation_ );
    }];
}

- (void)rotateAutoAllowWithLandLeft:(BOOL)landLeft
                          landRight:(BOOL)landRight
                           portrait:(BOOL)portrait
                 portraitUpsideDown:(BOOL)portraitUpsideDown {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    _rotateAutoAllowLandLeft = landLeft;
    _rotateAutoAllowLandRight = landRight;
    _rotateAutoAllowPortrait = portrait;
    _rotateAutoAllowPortraitUpsideDown = portraitUpsideDown;
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)rotateAutoOn {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    //원래상태로 수동으로 복원!
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft: [self rotateLandLeft]; break;
        case UIInterfaceOrientationLandscapeRight: [self rotateLandRight]; break;
        case UIInterfaceOrientationPortrait: [self rotatePortrait]; break;
        case UIInterfaceOrientationPortraitUpsideDown: [self rotatePortraitUpsideDown]; break;
    }
    _rotateAuto = YES;
    //로테이션 확인
    [UIViewController attemptRotationToDeviceOrientation]; //>= ios 5.0
}

- (void)rotateLandRight {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    _rotateAuto = NO;
    [self willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight duration:0.8];
    [UIView animateWithDuration:0.8
                     animations:^{
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int w = screenBounds.size.width;
                         int h = screenBounds.size.height;
                         int sh;
                         if( [UIApplication sharedApplication].statusBarHidden ) {
                             sh = 0;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
                         } else {
                             sh = 20;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
                         }
                         self.view.transform = CGAffineTransformMakeRotation( M_PI * 0.5 );
                         self.view.frame =  CGRectMake(0, 0, w - sh, h);
                         self.view.bounds = CGRectMake(0, 0, h, w - sh);
                     } completion:^(BOOL finished) {
                         UIInterfaceOrientation fromOrientation = currentOrientation_;
                         currentOrientation_ = UIInterfaceOrientationLandscapeRight;
                         [self didRotateFromInterfaceOrientation:fromOrientation];
                     }];
}

- (void)rotateLandLeft {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    _rotateAuto = NO;
    [self willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0.8];
    [UIView animateWithDuration:0.8
                     animations:^{
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int w = screenBounds.size.width;
                         int h = screenBounds.size.height;
                         int sh;
                         if( [UIApplication sharedApplication].statusBarHidden ) {
                             sh = 0;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
                         } else {
                             sh = 20;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
                         }
                         self.view.transform = CGAffineTransformMakeRotation( M_PI * -0.5 );
                         self.view.frame =  CGRectMake(sh, 0, w - sh, h);
                         self.view.bounds = CGRectMake(0, 0, h, w - sh);
                     } completion:^(BOOL finished) {
                         UIInterfaceOrientation fromOrientation = currentOrientation_;
                         currentOrientation_ = UIInterfaceOrientationLandscapeLeft;
                         [self didRotateFromInterfaceOrientation:fromOrientation];
                     }];
}

- (void)rotatePortrait {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    _rotateAuto = NO;
    [self willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0.8];
    [UIView animateWithDuration:0.8
                     animations:^{
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int w = screenBounds.size.width;
                         int h = screenBounds.size.height;
                         int sh;
                         if ([UIApplication sharedApplication].statusBarHidden) {
                             sh = 0;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
                         } else {
                             sh = 20;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
                         }
                         self.view.transform = CGAffineTransformMakeRotation(0);
                         self.view.frame =  CGRectMake(0, sh, w, h - sh);
                         self.view.bounds = CGRectMake(0, 0, w, h - sh);
                     } completion:^(BOOL finished) {
                         UIInterfaceOrientation fromOrientation = currentOrientation_;
                         currentOrientation_ = UIInterfaceOrientationPortrait;
                         [self didRotateFromInterfaceOrientation:fromOrientation];
                     }];
}

- (void)rotatePortraitUpsideDown {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    _rotateAuto = NO;
    [self willRotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown duration:0.8];
    [UIView animateWithDuration:0.8
                     animations:^{
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int w = screenBounds.size.width;
                         int h = screenBounds.size.height;
                         int sh;
                         if ([UIApplication sharedApplication].statusBarHidden) {
                             sh = 0;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:NO];
                         } else {
                             sh = 20;
                             [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:YES];
                         }
                         self.view.transform = CGAffineTransformMakeRotation(M_PI);
                         self.view.frame =  CGRectMake(0, 0, w, h - sh);
                         self.view.bounds = CGRectMake(0, 0, w, h - sh);
                     } completion:^(BOOL finished) {
                         UIInterfaceOrientation fromOrientation = currentOrientation_;
                         currentOrientation_ = UIInterfaceOrientationPortraitUpsideDown;
                         [self didRotateFromInterfaceOrientation:fromOrientation];
                     }];
}

@end
