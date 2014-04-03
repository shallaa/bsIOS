//
//  bsLabel.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/18.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsLabel.h"

static NSDictionary* __bsLabel_keyValues = nil;

@implementation bsLabel

@synthesize label = label_;

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if( label_ == nil ) {
        label_ = [[UILabel alloc] initWithFrame:self.frame];
        [self addSubview:label_];
    }
    if (__bsLabel_keyValues == nil) {
        __bsLabel_keyValues =
        @{ @"text": @kbsLabelText, @"text-color": @kbsLabelTextColor, @"auto-resize": @kbsLabelAutoResize,
           @"text-shadow-color": @kbsLabelTextShadowColor, @"text-shadow-offset": @kbsLabelTextShadowOffset,
           @"font-name": @kbsLabelFontName, @"font-size": @kbsLabelFontSize,
           @"padding": @kbsLabelPadding, @"linebreak": @kbsLabelLineBreak, @"linebreak-mode": @kbsLabelLineBreak,
           @"lines": @kbsLabelLines, @"max-size": @kbsLabelMaxSize, @"min-size": @kbsLabelMinSize,
           @"highlight-color": @kbsLabelHighlightColor, @"highlight-text-color": @kbsLabelHighlightColor, @"highlight-enable": @kbsLabelHighlightEnable,
           @"align": @kbsLabelAlign
           };
    }
    padding_ = UIEdgeInsetsMake(0, 0, 0, 0);
    autoResize_ = YES;
    maxSizeSetting_ = NO;
    minSizeSetting_ = NO;
    fontName_ = @"system";
    maxSize_ = CGSizeMake( CGFLOAT_MAX, CGFLOAT_MAX );
    minSize_ = CGSizeMake( 0, 0 );
    label_.backgroundColor = [UIColor clearColor];
    label_.lineBreakMode = NSLineBreakByTruncatingTail;
    label_.textAlignment = NSTextAlignmentCenter;
    label_.text = @"Test";
    label_.font = [UIFont systemFontOfSize:14];
    label_.numberOfLines = 1;
    label_.highlighted = YES;
    label_.highlightedTextColor = nil;
    label_.shadowColor = nil;
    label_.shadowOffset = CGSizeMake(0, -1);
    //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"label_", @"labelVertical", @"labelHorizontal"]] views:NSDictionaryOfVariableBindings(label_)];
    self.userInteractionEnabled = NO;
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
}

- (void)layoutSubviews {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    [super layoutSubviews];
    CGFloat w,h,t,l,b,r;
    w = self.bounds.size.width;
    h = self.bounds.size.height;
    t = padding_.top;
    l = padding_.left;
    b = padding_.bottom;
    r = padding_.right;
    label_.frame = CGRectMake( l, t, w-r-l, h-b-t );
}

- (id)__g:(NSString*)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger num = [[__bsLabel_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsLabelText: value = label_.text; break;
        case kbsLabelTextColor: value = label_.textColor; break;
        case kbsLabelAutoResize: value = @(autoResize_); break;
        case kbsLabelTextShadowColor: value = label_.shadowColor ? label_.shadowColor : [UIColor clearColor]; break;
        case kbsLabelTextShadowOffset: value = [bsSize G:label_.shadowOffset]; break;
        case kbsLabelFontName: value = fontName_; break;
        case kbsLabelFontSize: value = @(label_.font.pointSize); break;
        case kbsLabelPadding: value = [bsEdgeInsets G:padding_]; break;
        case kbsLabelAlign: {
            if( label_.textAlignment == NSTextAlignmentLeft ) value = @"left";
            else if( label_.textAlignment == NSTextAlignmentRight ) value = @"right";
            else if( label_.textAlignment == NSTextAlignmentCenter ) value = @"center";
        } break;
        case kbsLabelHighlightEnable: value = @(label_.highlighted); break;
        case kbsLabelHighlightColor: value = label_.highlightedTextColor ? label_.highlightedTextColor : [UIColor clearColor]; break;
        case kbsLabelLineBreak: {
            if( label_.lineBreakMode == NSLineBreakByClipping ) value = @"clip";
            else if( label_.lineBreakMode == NSLineBreakByWordWrapping ) value = @"word-wrap";
            else if( label_.lineBreakMode == NSLineBreakByCharWrapping ) value = @"char-wrap";
            else if( label_.lineBreakMode == NSLineBreakByTruncatingHead ) value = @"head";
            else if( label_.lineBreakMode == NSLineBreakByTruncatingMiddle ) value = @"middle";
            else if( label_.lineBreakMode == NSLineBreakByTruncatingTail ) value = @"tail";
        } break;
        case kbsLabelLines: value = @(label_.numberOfLines); break;
        case kbsLabelMaxSize: value = [bsSize G:maxSize_]; break;
        case kbsLabelMinSize: value = [bsSize G:minSize_]; break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSString *text = nil;
    NSInteger f0 = 0;
    CGFloat fontSize = 0;
    BOOL sizeChangeReq = NO;
    NSMutableArray *remain = [NSMutableArray array];
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsLabel_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsLabelText: sizeChangeReq = YES; text = v; break;
            case kbsLabelTextColor: label_.textColor = [bsStr color:v]; break;
            case kbsLabelAutoResize: {
                autoResize_ = [bsStr BOOLEAN:v];
                if (autoResize_) {
                    sizeChangeReq = YES;
                }
            } break;
            case kbsLabelTextShadowColor: label_.shadowColor = [bsStr color:v]; break;
            case kbsLabelTextShadowOffset: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 2) {
                    bsException(NSInvalidArgumentException, @"text-shadow-offset value %@ is invalid. It should be a value of the form offsetX|offsetY", v);
                }
                label_.shadowOffset = CGSizeMake( [c[0] floatValue], [c[1] floatValue] );
            } break;
            case kbsLabelFontName: {
                if ([v isEqualToString:@"system-bold"] || [v isEqualToString:@"bold"]) { f0 = 1; fontName_ = @"system-bold"; }
                else if ([v isEqualToString:@"system-italic"] || [v isEqualToString:@"italic"]) { f0 = 2; fontName_ = @"system-italic"; }
                else if ([v isEqualToString:@"system"]) { f0 = 3; fontName_=@"system"; }
                else {
                    f0 = 4;
                    fontName_ = v; //http://iphonedevsdk.com/forum/iphone-sdk-development/6000-list-uifonts-available.html
                }
                sizeChangeReq = YES;
            } break;
            case kbsLabelFontSize: fontSize = [v floatValue]; break;
            case kbsLabelPadding: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 4) {
                    bsException(NSInvalidArgumentException, @"padding value %@ is invalid. It should be a value of the form top|right|bottom|left", v);
                }
                //NSString *layout = [bsStr templateSrc:kbsDisplayConstraintPadding replace:@[@"label_", @"labelVertical", c[0],c[1],@"labelHorizontal",c[2],c[3]]];
                //[self autolayout:layout views:NSDictionaryOfVariableBindings(label_)];
                padding_.top = [c[0] floatValue];
                padding_.right = [c[1] floatValue];
                padding_.bottom = [c[2] floatValue];
                padding_.left = [c[3] floatValue];
                sizeChangeReq = YES;
                [self setNeedsLayout];
            } break;
            case kbsLabelAlign: {
                if ([v isEqualToString:@"left"]) label_.textAlignment = NSTextAlignmentLeft;
                else if ([v isEqualToString:@"center"]) label_.textAlignment = NSTextAlignmentCenter;
                else if ([v isEqualToString:@"right"]) label_.textAlignment = NSTextAlignmentRight;
            } break;
            case kbsLabelHighlightEnable: label_.highlighted = [bsStr BOOLEAN:v]; break;
            case kbsLabelHighlightColor: label_.highlighted = YES; label_.highlightedTextColor = [bsStr color:v]; break;
            case kbsLabelLineBreak: {
                if ([v isEqualToString:@"clip"]) label_.lineBreakMode = NSLineBreakByClipping;
                else if ([v isEqualToString:@"wordwrap"] || [v isEqualToString:@"word-wrap"]) label_.lineBreakMode = NSLineBreakByWordWrapping;
                else if ([v isEqualToString:@"charwrap"] || [v isEqualToString:@"char-wrap"]) label_.lineBreakMode = NSLineBreakByCharWrapping;
                else if ([v isEqualToString:@"head"]) label_.lineBreakMode = NSLineBreakByTruncatingHead;
                else if ([v isEqualToString:@"middle"]) label_.lineBreakMode = NSLineBreakByTruncatingMiddle;
                else if ([v isEqualToString:@"tail"]) label_.lineBreakMode = NSLineBreakByTruncatingTail;
                sizeChangeReq = YES;
            } break;
            case kbsLabelLines: label_.numberOfLines = [bsStr INTEGER:v]; break;
            case kbsLabelMaxSize: {
                maxSizeSetting_ = YES;
                sizeChangeReq = YES;
                NSArray *c = [bsStr arg:v];
                if ([c count] != 2) {
                    bsException(NSInvalidArgumentException, @"max-size value %@ is invalid. It should be a value of the form maxWidth|maxHeight", v);
                }
                maxSize_ = CGSizeMake([c[0] floatValue], [c[1] floatValue]);
            } break;
            case kbsLabelMinSize: {
                minSizeSetting_ = YES;
                sizeChangeReq = YES;
                NSArray *c = [bsStr arg:v];
                if ([c count] != 2) {
                    bsException(NSInvalidArgumentException, @"min-size value %@ is invalid. It should be a value of the form minWidth|minHeight", v);
                }
                minSize_ = CGSizeMake([c[0] floatValue], [c[1] floatValue]);
            } break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
        //label_.lineBreakMode = NSLineBreakByWordWrapping;
    }
    if (f0 > 0 || fontSize > 0) {
        if (f0 == 0) {
            if( [fontName_ hasPrefix:@"system"] ) {
                if( [fontName_ isEqualToString:@"system-bold"]) f0 = 1;
                else if( [fontName_ isEqualToString:@"system-italic"]) f0 = 2;
                else f0 = 3;
            } else {
                f0 = 4;
            }
        } else {
            if( fontSize == 0 ) fontSize = label_.font.pointSize;
        }
        UIFont *font;
        switch ( f0 ) {
            case 1: font = [UIFont boldSystemFontOfSize:fontSize]; break;
            case 2: font = [UIFont italicSystemFontOfSize:fontSize]; break;
            case 3: font = [UIFont systemFontOfSize:fontSize]; break;
            case 4: font = [UIFont fontWithName:label_.font.fontName size:fontSize]; break;
        }
        label_.font = font;
    }
    if (text != nil) {
        label_.text = text;
    }
    if (sizeChangeReq && autoResize_) {
        UIFont *font = label_.font;
        CGSize labelSize = [label_.text sizeWithAttributes:@{NSFontAttributeName:font}];
        if (maxSizeSetting_ || minSizeSetting_) {
            //UIFont *font = label_.font;
            CGFloat minW, minH, maxW, maxH, w, h;
            CGSize size;
            if ( maxSizeSetting_) {
                maxW = maxSize_.width - padding_.left - padding_.right;
                maxH = maxSize_.height - padding_.top - padding_.bottom;
                if (maxW < 0) maxW = 0;
                if (maxH < 0) maxH = 0;
            } else {
                maxW = CGFLOAT_MAX;
                maxH = CGFLOAT_MAX;
            }
            if (minSizeSetting_) {
                minW = minSize_.width - padding_.left - padding_.right;
                minH = minSize_.height - padding_.top - padding_.bottom;
                if (minW < 0) minW = 0;
                if (minH < 0) minH = 0;
            } else {
                minW = 0;
                minH = 0;
            }
            if (minW > maxW || minH > maxH) {
                bsException(NSInvalidArgumentException, @"min-size greater than max-size.");
            }
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = label_.lineBreakMode;
            paragraphStyle.alignment = label_.textAlignment;
            NSDictionary *attributes = @{NSFontAttributeName: label_.font, NSParagraphStyleAttributeName: paragraphStyle};
            size = [label_.text boundingRectWithSize:CGSizeMake(maxW, maxH)
                                             options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil].size;
            //size = [label_.text sizeWithFont:font constrainedToSize:CGSizeMake(maxW, maxH) lineBreakMode:label_.lineBreakMode];
            w = size.width;
            h = size.height;
            if (w < minW) w = minW;
            if (h < minH) h = minH;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w + padding_.left + padding_.right, h + padding_.top + padding_.bottom);
        } else {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + padding_.left + padding_.right, labelSize.height + padding_.top + padding_.bottom);
        }
    }
    return remain;
}

#pragma mark - override
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (bsDisplay *)subviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)removeSubviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString *)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
