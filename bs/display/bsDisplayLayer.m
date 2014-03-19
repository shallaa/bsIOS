//
//  bsDisplayLayer.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsDisplayLayer.h"

static bsDisplayLayer *__bsDisplayLayer = nil;

@implementation bsDisplayLayer

+ (bsDisplayLayer *)center {
    
    //DCL(Double Checked Locking)
    if (__bsDisplayLayer == nil) {
        @synchronized(__bsDisplayLayer) {
            if (__bsDisplayLayer == nil) {
                bsDisplayLayer *l = [[bsDisplayLayer alloc] init];
                __bsDisplayLayer = l;
            }
        }
    }
    return __bsDisplayLayer;
}

- (id)init {
    
    if (self = [super init]) {
        if (__bsDisplayLayer) bsException(@"bsDisplayLayer은 두 번 이상 초기화 될 수 없습니다.");
        @synchronized(parents_) {
            if (parents_ == nil) {
                parents_ = [[NSMutableDictionary alloc]init];
            }
        }
    }
    return self;
}

- (void)parentA:(bsDisplay *)parent parentName:(NSString *)parentName {
    
    if (parent == nil) bsException(@"parent view should be not nil");
    if (parentName == nil) bsException(@"parent name should be not nil");
    if (![parent isMemberOfClass:[bsDisplay class]]) bsException(@"parent should be a member of bsDisplay");
    @synchronized(parents_) {
        if (parents_[parentName] || [[parents_ allKeysForObject:parent] count] > 0) {
            bsException(@"already has parent(=%@) or parent view(=%@)", parentName, parent);
        } else {
            parents_[parentName] = [[NSMutableDictionary alloc] initWithObjectsAndKeys:parent, @"parent", [[NSMutableDictionary alloc] init], @"layers" ,nil];
        }
    }
    parent.clipsToBounds = NO;
}
-(void)parentD:(NSString*)parentName {
    [parents_ removeObjectForKey:parentName];
}
-(bsDisplay*)parentG:(NSString*)parentName {
    NSDictionary *parent = parents_[parentName];
    if( parent == nil ) {
        bsException( @"parent(=%@) is none.", parentName );
    }
    return parent[@"parent"];
}
-(void)parentS:(NSString*)parentName params:(NSString*)params {
    bsDisplay *parent = [self parentG:parentName];
    [parent s:params];
}
-(void)parentS:(NSString *)parentName params:(NSString *)params replace:(id)replace {
    bsDisplay *parent = [self parentG:parentName];
    [parent s:params replace:replace];
}
-(bsDisplay*)layerG:(NSString*)layerName parentName:(NSString*)parentName {
    NSDictionary *dic = parents_[parentName];
    if( dic == nil ) bsException( @"parent(=%@) is not exist", parentName );
    bsDisplay *layer = dic[@"layers"][layerName];
    if( layer == nil ) bsException( @"layer(=%@) is not exist", layerName );
    return layer;
}

- (NSArray *)layersG:(NSString *)layerNames parentName:(NSString *)parentName {
    
    NSMutableArray *r = [NSMutableArray array];
    NSArray *names = [bsStr col:layerNames];
    [names enumerateObjectsUsingBlock:^(NSString *layerName, NSUInteger idx, BOOL *stop) {
        [r addObject: [[bsDisplayLayer center] layerG:layerName parentName:parentName]];
    }];
    return r;
}

- (bsDisplay *)layerA:(NSString *)layerName hidden:(BOOL)hidden parentName:(NSString *)parentName {
    
    NSDictionary *dic = parents_[parentName];
    if( dic == nil ) bsException( @"parent(=%@) is not exist", parentName );
    bsDisplay *parent = dic[@"parent"];
    bsDisplay *layer = dic[@"layers"][layerName];
    if( layer ) bsException( @"already has layer(=%@) in parent(=%@)", layerName, parentName );
    layer = [bsDisplay G:@"display" params:@"key,@@0,x,0,y,0,w,@@1,h,@@2,hidden,@@3,bg,#0000" replace:@[layerName, @0, @0, @(hidden)]];
    layer.clipsToBounds = NO;
    [parent addSubview:layer];
    //NSLog(@"%@",parent.subviews);
    //[parent autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"layer", @"layerVertical", @"layerHorizontal"]] views:NSDictionaryOfVariableBindings(layer)];
    dic[@"layers"][layerName] = layer;
    return layer;
}

- (NSArray *)layersA:(NSString*)layerNames hidden:(BOOL)hidden parentName:(NSString *)parentName {
    
    NSMutableArray *r = [NSMutableArray array];
    NSArray *names = [bsStr col:layerNames];
    [names enumerateObjectsUsingBlock:^(NSString *layerName, NSUInteger idx, BOOL *stop) {
        bsDisplay *layer = [[bsDisplayLayer center] layerA:layerName hidden:hidden parentName:parentName];
        [r addObject:layer];
    }];
    return r;
}

- (bsDisplay *)layerD:(NSString *)layerName parentName:(NSString *)parentName {
    
    NSDictionary *dic = parents_[parentName];
    if (dic == nil) bsException( @"parent(=%@) is not exist", parentName );
    bsDisplay *layer = dic[@"layers"][layerName];
    if( !layer ) bsException( @"layer(=%@) is not defined in parent(=%@)", layerName, parentName );
    if( [layer superview] ) [layer removeFromSuperview];
    [(NSMutableDictionary*)dic[@"layers"] removeObjectForKey:layerName];
    return layer;
}

- (NSArray *)layersD:(NSString *)layerNames parentName:(NSString *)parentName {
    NSMutableArray *r = [NSMutableArray array];
    NSArray *names = [bsStr col:layerNames];
    [names enumerateObjectsUsingBlock:^(NSString *layerName, NSUInteger idx, BOOL *stop) {
        bsDisplay *layer = [[bsDisplayLayer center] layerD:layerName parentName:parentName];
        [r addObject:layer];
    }];
    return r;
}

- (void)layerS:(NSString*)layerName parentName:(NSString*)parentName params:(NSString*)params {
    
    bsDisplay *layer = [[bsDisplayLayer center] layerG:layerName parentName:parentName];
    if (layer == nil) return;
    [layer s:params];
}

- (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString *)params replace:(id)replace {
    
    bsDisplay *layer = [[bsDisplayLayer center] layerG:layerName parentName:parentName];
    if (layer == nil) return;
    [layer s:params replace:replace];
}

- (void)layerChildD:(NSString *)layerName parentName:(NSString *)parentName childKeys:(NSString *)childKeys {
    
    bsDisplay *layer = [[bsDisplayLayer center] layerG:layerName parentName:parentName];
    if( layer == nil ) return;
    if( [childKeys isEqualToString:@"*"] ) {
        NSArray *subviews = layer.subviews;
        [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
        [layer s:@"x,0,y,0,w,0,h,0"];
    } else {
        NSArray *keys = [bsStr col:childKeys];
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            UIView *view = [layer childG:key];
            if( view && view.superview ) {
                [view removeFromSuperview];
            }
        }];
    }
}

@end
