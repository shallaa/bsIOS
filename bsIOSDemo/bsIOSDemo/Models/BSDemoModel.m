//
//  BSDemoModel.m
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2014/03/22.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "BSDemoModel.h"

@interface BSDemoModel ()

@end

@implementation BSDemoModel

+ (id)sharedModel {
    
    static BSDemoModel *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

- (id)init {
    
    self = [super init];
    if (self) {
        [self p_start];
    }
    return self;
}

#pragma mark - Private methods

- (void)p_start {
    
}

@end
