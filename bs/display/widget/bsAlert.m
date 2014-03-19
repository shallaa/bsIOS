//
//  bsAlert.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsAlert.h"

#import "bsStr.h"

static NSMutableDictionary *__bsAlert_blockDic = nil;
static NSMutableArray *__bsAlert_reserve = nil;
static BOOL __bsAlert_showing = NO;

@implementation bsAlert

+ (void)__alert:(NSString *)params block:(bsAlertBlock)block reserved:(BOOL)reserved {
    
    static int keyNumber = 0;
    if( __bsAlert_blockDic == nil ) {
        __bsAlert_blockDic = [[NSMutableDictionary alloc] init];
    }
    if( __bsAlert_reserve == nil ) {
        __bsAlert_reserve = [NSMutableArray array];
    }
    if( __bsAlert_showing == YES && reserved == NO ) {
        [__bsAlert_reserve addObject:@{@"params":params, @"block":block==nil?[NSNull null]:[block copy]}];
        return;
    }
    __bsAlert_showing = YES;
    NSArray *p = [bsStr col:params];
    NSString *title = nil, *message = nil, *cancelTitle = nil;
    NSArray *otherTitles = nil;
    if( [p count] % 2 != 0 ) {
        bsException(@"A count of params should be even. a split string of params is ',' and pattern is 'k, v, k, v, k, v...'. params=%@", params);
    }
    for ( NSInteger i = 0, j = [p count]; i < j; ) {
        NSString *k = p[i++];
        NSString *v = p[i++];
        if( [k isEqualToString:@"title"] ) title = v;
        else if( [k isEqualToString:@"message"] ) message = v;
        else if( [k isEqualToString:@"cancel"] || [k isEqualToString:@"title-cancel"] ) cancelTitle = v;
        else if( [k isEqualToString:@"others"] || [k isEqualToString:@"title-others"] ) {
            otherTitles = [bsStr arg:v];
        }
    }
    if( cancelTitle == nil ) {
        cancelTitle = @"확인";
    }
    if( title == nil ) {
        title = @"undefined";
    }
    if( message == nil ) {
        message = @"undefined";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil];
    if( otherTitles ) {
        for( NSString *title in otherTitles ) [alert addButtonWithTitle:title];
    }
    if( block ) {
        alert.tag = ++keyNumber;
        __bsAlert_blockDic[[NSString stringWithFormat:@"%d",keyNumber]] = block;
    } else {
        alert.tag = 0;
    }
    [alert show];
}

+ (void)alert:(NSString *)params block:(bsAlertBlock)block {
    
    [self __alert:params block:block reserved:NO];
}

+ (void)alert:(NSString *)params replace:(id)replace block:(bsAlertBlock)block {
    
    NSString *p = [bsDisplayUtil paramsTemplate:params replace:replace];
    [self __alert:p block:block reserved:NO];
}

#pragma mark - delegate
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSInteger keyNumber = alertView.tag;
    if( keyNumber != 0 ) {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)keyNumber];
        bsAlertBlock block = __bsAlert_blockDic[key];
        if( buttonIndex == [alertView cancelButtonIndex] ) {
            block( 0, YES );
        } else {
            block( buttonIndex - 1, NO );
        }
        [__bsAlert_blockDic removeObjectForKey:key];
    }
    //예약된 alert이 있으면 그 alert을 띄우자.
    if( [__bsAlert_reserve count] > 0 ) {
        NSDictionary *alertInfo = [__bsAlert_reserve objectAtIndex:0];
        [__bsAlert_reserve removeObjectAtIndex:0];
        [self __alert:alertInfo[@"params"] block:alertInfo[@"block"] == [NSNull null] ? nil : alertInfo[@"block"] reserved:YES];
    } else {
        __bsAlert_showing = NO;
    }
}

@end
