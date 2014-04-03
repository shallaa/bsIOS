//
//  bsTablePlain.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/20.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsTablePlain.h"

#import "bsStr.h"

static NSDictionary* __bsTablePlain_keyValues = nil;

@implementation bsTablePlain

@synthesize tableView = table_;

- (void)ready {
    
    if (table_ == nil) {
        table_ = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        [self addSubview:table_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"table_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(table_)];
    }
    if (__bsTablePlain_keyValues == nil) {
        __bsTablePlain_keyValues =
        @{ @"table-style": @kbsTableStyle, @"separator": @kbsTableSeparator, @"separator-color": @kbsTableSeparatorColor,
           @"row-height": @kbsTableRowHeight
           };
    }
    //table_.delegate = self;
    //table_.dataSource = self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    table_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsTablePlain_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsTableStyle: {
            value = @"plain";
        } break;
        case kbsTableSeparator: {
            if (table_.separatorStyle == UITableViewCellSeparatorStyleNone) value = @"none";
            else if (table_.separatorStyle == UITableViewCellSeparatorStyleSingleLine) value = @"line";
            else if (table_.separatorStyle == UITableViewCellSeparatorStyleSingleLineEtched) value = @"line-etched";
        } break;
        case kbsTableSeparatorColor: value = table_.separatorColor ? table_.separatorColor : [UIColor clearColor]; break;
        case kbsTableRowHeight: value = @(table_.rowHeight); break;
            
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    NSMutableArray *remain = [NSMutableArray array];
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsTablePlain_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsTableSeparator: {
                if ([v isEqualToString:@"none"]) table_.separatorStyle = UITableViewCellSeparatorStyleNone;
                else if ([v isEqualToString:@"line"]) table_.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                else if ([v isEqualToString:@"line-etched"]) table_.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
            } break;
            case kbsTableSeparatorColor: table_.separatorColor = [bsStr color:v]; break;
            case kbsTableRowHeight: table_.rowHeight = [bsStr FLOAT:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    return remain;
}

#pragma mark - child

- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params {
    
    bsDisplay *o = [bsDisplay generateViewWithName:name parameters:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay generateViewWithName:name parameters:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params {
    
    bsDisplay *o = [bsDisplay generateViewWithTemplate:key parameters:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay generateViewWithTemplate:key parameters:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params {
    
    bsDisplay *o = [bsDisplay generateViewWithName:name styles:styleNames parameters:params];
    [table_ addSubview:o];
    return o.key;
}

- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params replace:(id)replace {
    
    bsDisplay *o = [bsDisplay generateViewWithName:name styles:styleNames parameters:params replace:replace];
    [table_ addSubview:o];
    return o.key;
}

- (bsDisplay *)subviewWithName:(NSString *)key {
    
    __block bsDisplay *c = nil;
    [table_.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[bsDisplay class]] && [((bsDisplay*)obj).key isEqualToString:key]) {
            c = (bsDisplay*)obj;
            *stop = YES;
        }
    }];
    return c;
}

- (void)addSubview:(UIView *)view {
    
    [table_ addSubview:view];
}

- (void)removeSubviewWithName:(NSString *)key {
    
    if ([key isEqualToString:@"*"]) {
        NSArray *childs = table_.subviews;
        [childs enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    } else {
        bsDisplay *child = [self subviewWithName:key];
        if (child) [child removeFromSuperview];
    }
}

- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params {
    
    bsDisplay *child = [self subviewWithName:key];
    if (child) {
        [child s:params];
    }
}

- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params replace:(id)replace {
    
    bsDisplay *child = [self subviewWithName:key];
    if (child) {
        [child s:params replace:replace];
    }
}




#pragma mark - blocks


#pragma mark - delegate
/*
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
 }
 
 // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
 // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
 
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }
 
 // Default is 1 if not implemented
 -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
 }
 
 // fixed font style. use custom view (UILabel) if you want something different
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 }
 
 -(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
 
 }
 
 // Editing
 
 // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }
 
 // Moving/reordering
 
 // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }
 
 // Index
 
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 
 }// return list of section titles to display in section index view (e.g. "ABCD...Z#")
 
 // tell table which section corresponds to section title/index (e.g. "B",1))
 - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
 
 }
 
 // Data manipulation - insert and delete support
 
 // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }
 
 // Data manipulation - reorder / moving support
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
 
 }
 */
@end
