//
//  NSDictionary+MutableDeepCopy.h
//
//  Created by Yongho Ji on 11. 2. 28..
//  Copyright 2011 Wecon Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

//NSDictionary에 깊은 복사 기능 추가 
@interface NSDictionary (MutableDeepCopy)

-(NSMutableDictionary*)mutableDeepCopy;

@end
