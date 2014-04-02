//
//  BSDemoModel.h
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2014/03/22.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDemoModel : NSObject

@property (nonatomic, strong) NSString *layerA;

+ (id)sharedModel;

@end
