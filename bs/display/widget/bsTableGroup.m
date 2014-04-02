//
//  bsTableGroup.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/20.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsTableGroup.h"

#import "bsStr.h"

static NSDictionary *__bsTableGroup_keyValues = nil;

@implementation bsTableGroup

@synthesize tableView = table_;

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (table_ == nil) {
        table_ = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        [self addSubview:table_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"table_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(table_)];
    }
    if (__bsTableGroup_keyValues == nil) {
        __bsTableGroup_keyValues =
        @{ @"table-style": @kbsTableStyle, @"separator": @kbsTableSeparator, @"separator-color": @kbsTableSeparatorColor,
           @"row-height": @kbsTableRowHeight
           };
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    table_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsTableGroup_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsTableStyle: {
            value = @"group";
        } break;
        case kbsTableSeparator: {
            if( table_.separatorStyle == UITableViewCellSeparatorStyleNone ) value = @"none";
            else if( table_.separatorStyle == UITableViewCellSeparatorStyleSingleLine ) value = @"line";
            else if( table_.separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched ) value = @"line-etched";
        } break;
        case kbsTableSeparatorColor: value = table_.separatorColor ? table_.separatorColor : [UIColor clearColor]; break;
        case kbsTableRowHeight: value = @(table_.rowHeight); break;
            
    }
    return value;
}

- (NSArray*)__s:(NSArray*)params {
    
    NSMutableArray *remain = [NSMutableArray array];
    for (NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsTableGroup_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsTableSeparator: {
                if ([v isEqualToString:@"none"]) table_.separatorStyle = UITableViewCellSeparatorStyleNone;
                else if( [v isEqualToString:@"line"] ) table_.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                else if( [v isEqualToString:@"line-etched"] ) table_.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
            } break;
            case kbsTableSeparatorColor: table_.separatorColor = [bsStr color:v]; break;
            case kbsTableRowHeight: table_.rowHeight = [bsStr FLOAT:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    return remain;
}

#pragma mark - child

- (NSString *)create:(NSString *)name params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay G:name params:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay G:name params:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay GT:key params:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay GT:key params:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params {
    
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (bsDisplay *)childG:(NSString *)key {
    
    __block bsDisplay *c = nil;
    [table_.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if( [obj isKindOfClass:[bsDisplay class]] && [((bsDisplay*)obj).key isEqualToString:key] ) {
            c = (bsDisplay*)obj;
            *stop = YES;
        }
    }];
    return c;
}

- (void)childA:(bsDisplay *)child {
    
    [table_ addSubview:child];
}

- (void)childD:(NSString *)key {
    
    if ([key isEqualToString:@"*"]) {
        NSArray *childs = table_.subviews;
        [childs enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    } else {
        bsDisplay *child = [self childG:key];
        if (child) [child removeFromSuperview];
    }
}

- (void)childS:(NSString *)key params:(NSString *)params {
    
    bsDisplay *child = [self childG:key];
    if (child) {
        [child s:params];
    }
}

- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsDisplay *child = [self childG:key];
    if (child) {
        [child s:params replace:replace];
    }
}

/*
 #pragma mark - override
 -(NSString*)create:(NSString*)name params:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(NSString*)create:(NSString*)name params:(NSString*)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(NSString*)createT:(NSString*)key params:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(NSString*)createT:(NSString*)key params:(NSString*)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(NSString*)create:(NSString*)name styleNames:(NSString*)styleNames params:(NSString*)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(bsDisplay*)childG:(NSString*)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
 -(void)childA:(bsDisplay*)child { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
 -(void)childD:(NSString*)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
 -(void)childS:(NSString*)key params:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
 -(void)childS:(NSString*)key params:(NSString*)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
 */
@end
