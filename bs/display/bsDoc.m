//
//  bsDoc.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/16.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsDoc.h"

@implementation bsDoc

+(id)G:(bsDisplay*)parent query:(id)query {
    return nil;
}

+(void)S:(bsDisplay*)parent query:(id)query params:(id)params {

}

+(void)D:(bsDisplay*)parent query:(id)query {

}

+(void)A:(bsDisplay*)parent child:(id)child params:(id)params {
    
}

@end

/*
 
 [bsDoc A:self child:@"image" params:@"x,10,y,10"];
 [bsDoc A:self child:image params:@"x,10,y,10"];
 [bsDoc A:self child:@{image, @"image", @"image"} params:@"x,10,y,10"];
 [bsDoc A:self child:@{image, @"image", @"image"} params:[@"x,10,y,10", @"", @""]];
 
 */
