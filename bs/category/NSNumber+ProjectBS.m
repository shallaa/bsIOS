//
//  NSNumber+ProjectBS.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/04/03.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "NSNumber+ProjectBS.h"

@implementation NSNumber (ProjectBS)

- (NSString *)bs_description {
    
    const char *type = [self objCType];
    if (strcmp(type, @encode(BOOL)) == 0) {
        return self.boolValue ? @"true" : @"false";
    } else {
        return [self stringValue];
    }
}

@end
