//
//  bsButton2.m
//  bsIOSDemo
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsButton.h"

static NSDictionary* __bsButton_keyValues = nil;

@implementation bsButton

- (void)ready {
    if( button_ == nil ) {
        button_ = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"button_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(button_)];
    }
    if( __bsButton_keyValues == nil ) {
        __bsButton_keyValues =
        @{ @"enabled": @kbsButtonEnabled, @"selected": @kbsButtonSelected, @"highlighted": @kbsButtonHighlighted, @"text-shadow-offset": @kbsButtonLbShadowOffset,
           @"align": @kbsButtonLbAlign, @"font-name": @kbsButtonLbFontName, @"font-size": @kbsButtonLbFontSize, @"auto-resize": @kbsButtonAutoResize,
           @"linebreak": @kbsButtonLbLineBreak, @"linebreak-mode": @kbsButtonLbLineBreak, @"lines": @kbsButtonLbLines,
           @"img": @kbsButtonBtnImg, @"text": @kbsButtonLbText, @"text-color": @kbsButtonLbColor, @"text-shadow-color": @kbsButtonLbShadowColor,
           @"img-h": @kbsButtonBtnImgHighlight, @"text-h": @kbsButtonLbTextHighlight, @"text-color-h": @kbsButtonLbColorHighlight, @"text-shadow-color-h": @kbsButtonLbShadowColorHighlight,
           @"img-highlight": @kbsButtonBtnImgHighlight, @"text-highlight": @kbsButtonLbTextHighlight, @"text-color-highlight": @kbsButtonLbColorHighlight, @"text-shadow-color-highlight": @kbsButtonLbShadowColorHighlight,
           @"img-d": @kbsButtonBtnImgDisabled, @"text-d": @kbsButtonLbTextDisabled, @"text-color-d": @kbsButtonLbColorDisabled, @"text-shadow-color-d": @kbsButtonLbShadowColorDisabled,
           @"img-disabled": @kbsButtonBtnImgDisabled, @"text-disabled": @kbsButtonLbTextDisabled, @"text-color-disabled": @kbsButtonLbColorDisabled, @"text-shadow-color-disabled": @kbsButtonLbShadowColorDisabled,
           @"img-s": @kbsButtonBtnImgSelected, @"text-s": @kbsButtonLbTextSelected, @"text-color-s": @kbsButtonLbColorSelected, @"text-shadow-color-s": @kbsButtonLbShadowColorSelected,
           @"img-selected": @kbsButtonBtnImgSelected, @"text-selected": @kbsButtonLbTextSelected, @"text-color-selected": @kbsButtonLbColorSelected, @"text-shadow-color-selected": @kbsButtonLbShadowColorSelected,
           @"cap-insets": @kbsButtonCapInset
           };
    }
    if (addedTouch_) {
        [button_ removeTarget:self action:@selector(__touched:) forControlEvents:UIControlEventTouchUpInside];
        addedTouch_ = NO;
    }
    fontName_ = @"system";
    img_ = @"";
    imgH_ = @"";
    imgS_ = @"";
    imgD_ = @"";
    autoResize_ = YES;
    button_.enabled = YES;
    button_.selected = NO;
    button_.highlighted = NO;
    button_.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button_.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button_.titleLabel.numberOfLines = 1;
    capInsets_ = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //UIImage *img = [bsDisplayUtil imageWithW:100 h:50 color:[UIColor grayColor]];
    //self.frame = CGRectMake( 0, 0, img.size.width, img.size.height );
    self.frame = CGRectMake( 0, 0, 100, 50 );
    [button_ setBackgroundColor:nil];
    [button_ setImage:nil forState:UIControlStateNormal];
    [button_ setBackgroundImage:nil forState:UIControlStateNormal];
    [button_ setTitleColor:nil forState:UIControlStateNormal];
    [button_ setTitle:nil forState:UIControlStateNormal];
    [button_ setTitleShadowColor:nil forState:UIControlStateNormal];
    
    [button_ setImage:nil forState:UIControlStateHighlighted];
    [button_ setBackgroundImage:nil forState:UIControlStateHighlighted];
    [button_ setTitleColor:nil forState:UIControlStateHighlighted];
    [button_ setTitle:nil forState:UIControlStateHighlighted];
    [button_ setTitleShadowColor:nil forState:UIControlStateHighlighted];
    
    [button_ setImage:nil forState:UIControlStateDisabled];
    [button_ setBackgroundImage:nil forState:UIControlStateDisabled];
    [button_ setTitleColor:nil forState:UIControlStateDisabled];
    [button_ setTitle:nil forState:UIControlStateDisabled];
    [button_ setTitleShadowColor:nil forState:UIControlStateDisabled];
    
    [button_ setImage:nil forState:UIControlStateSelected];
    [button_ setBackgroundImage:nil forState:UIControlStateSelected];
    [button_ setTitleColor:nil forState:UIControlStateSelected];
    [button_ setTitle:nil forState:UIControlStateSelected];
    [button_ setTitleShadowColor:nil forState:UIControlStateSelected];
}

- (void)dealloc {
    NSLog(@"bsButton dealloc");
    objc_removeAssociatedObjects( self );
}

- (void)layoutSubviews {
    [super layoutSubviews];
    button_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsButton_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsButtonEnabled: value = @(button_.enabled); break;
        case kbsButtonSelected: value = @(button_.selected); break;
        case kbsButtonHighlighted: value = @(button_.highlighted); break;
        case kbsButtonLbShadowOffset: value = [bsSize G:button_.titleLabel.shadowOffset]; break;
        case kbsButtonLbAlign: {
            if( button_.titleLabel.textAlignment == NSTextAlignmentLeft ) value = @"left";
            else if( button_.titleLabel.textAlignment == NSTextAlignmentRight ) value = @"right";
            else if( button_.titleLabel.textAlignment == NSTextAlignmentCenter ) value = @"center";
        } break;
        case kbsButtonLbFontName: value = fontName_; break;
        case kbsButtonLbFontSize: value = @(button_.titleLabel.font.pointSize); break;
        case kbsButtonLbLineBreak: {
            if( button_.titleLabel.lineBreakMode == NSLineBreakByClipping ) value = @"clip";
            else if( button_.titleLabel.lineBreakMode == NSLineBreakByWordWrapping ) value = @"word-wrap";
            else if( button_.titleLabel.lineBreakMode == NSLineBreakByCharWrapping ) value = @"char-wrap";
            else if( button_.titleLabel.lineBreakMode == NSLineBreakByTruncatingHead ) value = @"head";
            else if( button_.titleLabel.lineBreakMode == NSLineBreakByTruncatingMiddle ) value = @"middle";
            else if( button_.titleLabel.lineBreakMode == NSLineBreakByTruncatingTail ) value = @"tail";
        } break;
        case kbsButtonLbLines: value = @(button_.titleLabel.numberOfLines); break;
        case kbsButtonBtnImg: value = img_; break;
        case kbsButtonLbText: value = [button_ titleForState:UIControlStateNormal]; break;
        case kbsButtonLbShadowColor: value = [button_ titleShadowColorForState:UIControlStateNormal]; break;
        case kbsButtonLbColor: value = [button_ titleColorForState:UIControlStateNormal]; break;
            
        case kbsButtonBtnImgHighlight: value = imgH_; break;
        case kbsButtonLbTextHighlight: value = [button_ titleForState:UIControlStateHighlighted]; break;
        case kbsButtonLbShadowColorHighlight: value = [button_ titleShadowColorForState:UIControlStateHighlighted]; break;
        case kbsButtonLbColorHighlight: value = [button_ titleColorForState:UIControlStateHighlighted]; break;
            
        case kbsButtonBtnImgDisabled: value = imgD_;break;
        case kbsButtonLbTextDisabled: value = [button_ titleForState:UIControlStateDisabled];break;
        case kbsButtonLbShadowColorDisabled: value = [button_ titleShadowColorForState:UIControlStateDisabled];break;
        case kbsButtonLbColorDisabled: value = [button_ titleColorForState:UIControlStateDisabled]; break;
            
        case kbsButtonBtnImgSelected: value = imgS_;break;
        case kbsButtonLbTextSelected: value = [button_ titleForState:UIControlStateSelected];break;
        case kbsButtonLbShadowColorSelected: value = [button_ titleShadowColorForState:UIControlStateSelected];break;
        case kbsButtonLbColorSelected: value = [button_ titleColorForState:UIControlStateSelected]; break;
        case kbsButtonAutoResize: value = @(autoResize_); break;
        case kbsButtonCapInset: value = [bsEdgeInsets G:capInsets_]; break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    NSInteger f0 = 0;
    CGFloat fontSize = 0;
    BOOL imgChange = NO;
    BOOL imgHighlightChange = NO;
    BOOL imgDisabledChange = NO;
    BOOL imgSelectedChange = NO;
    BOOL capInsetsChange = NO;
    UIImage *img = nil;
    NSMutableArray *remain = [NSMutableArray array];
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsButton_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsButtonEnabled: button_.enabled = [bsStr BOOLEAN:v]; break;
            case kbsButtonSelected: button_.selected = [bsStr BOOLEAN:v]; break;
            case kbsButtonHighlighted: button_.highlighted = [bsStr BOOLEAN:v]; break;
            case kbsButtonLbShadowOffset: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 2) {
                    bsException(NSInvalidArgumentException, @"text-shadow-offset value %@ is invalid. It should be a value of the form offsetX|offsetY", v);
                }
                button_.titleLabel.shadowOffset = CGSizeMake( [c[0] floatValue], [c[1] floatValue] );
            } break;
            case kbsButtonLbAlign: {
                if( [v isEqualToString:@"left"] ) button_.titleLabel.textAlignment = NSTextAlignmentLeft;
                else if( [v isEqualToString:@"center"] ) button_.titleLabel.textAlignment = NSTextAlignmentCenter;
                else if( [v isEqualToString:@"right"] ) button_.titleLabel.textAlignment = NSTextAlignmentRight;
            } break;
            case kbsButtonLbFontName: {
                if( [v isEqualToString:@"system-bold"] || [v isEqualToString:@"bold"] ) { f0 = 1; fontName_ = @"system-bold"; }
                else if( [v isEqualToString:@"system-italic"] || [v isEqualToString:@"italic"] ) { f0 = 2; fontName_ = @"system-italic"; }
                else if( [v isEqualToString:@"system"] ) { f0 = 3; fontName_=@"system"; }
                else {
                    f0 = 4;
                    fontName_ = v; //http://iphonedevsdk.com/forum/iphone-sdk-development/6000-list-uifonts-available.html
                }
            } break;
            case kbsButtonLbFontSize: fontSize = [v floatValue]; break;
            case kbsButtonLbLineBreak: {
                if( [v isEqualToString:@"clip"]) button_.titleLabel.lineBreakMode = NSLineBreakByClipping;
                else if( [v isEqualToString:@"wordwrap"] || [v isEqualToString:@"word-wrap"]) button_.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                else if( [v isEqualToString:@"charwrap"] || [v isEqualToString:@"char-wrap"]) button_.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
                else if( [v isEqualToString:@"head"]) button_.titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
                else if( [v isEqualToString:@"middle"]) button_.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
                else if( [v isEqualToString:@"tail"]) button_.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            } break;
            case kbsButtonLbLines: button_.titleLabel.numberOfLines = [bsStr INTEGER:v]; break;
                
            case kbsButtonBtnImg: img_ = v; imgChange = YES; break;
            case kbsButtonLbText: [button_ setTitle:v forState:UIControlStateNormal]; break;
            case kbsButtonLbShadowColor: [button_ setTitleShadowColor:[bsStr color:v] forState:UIControlStateNormal]; break;
            case kbsButtonLbColor: [button_ setTitleColor:[bsStr color:v] forState:UIControlStateNormal]; break;
                
            case kbsButtonBtnImgHighlight: imgH_ = v; imgHighlightChange = YES; break;
            case kbsButtonLbTextHighlight: [button_ setTitle:v forState:UIControlStateHighlighted]; break;
            case kbsButtonLbShadowColorHighlight: [button_ setTitleShadowColor:[bsStr color:v] forState:UIControlStateHighlighted]; break;
            case kbsButtonLbColorHighlight: [button_ setTitleColor:[bsStr color:v] forState:UIControlStateHighlighted]; break;
                
            case kbsButtonBtnImgDisabled: imgD_ = v; imgDisabledChange = YES; break;
            case kbsButtonLbTextDisabled: [button_ setTitle:v forState:UIControlStateDisabled]; break;
            case kbsButtonLbShadowColorDisabled: [button_ setTitleShadowColor:[bsStr color:v] forState:UIControlStateDisabled]; break;
            case kbsButtonLbColorDisabled: [button_ setTitleColor:[bsStr color:v] forState:UIControlStateDisabled]; break;
                
            case kbsButtonBtnImgSelected:imgS_ = v; imgSelectedChange = YES; break;
            case kbsButtonLbTextSelected: [button_ setTitle:v forState:UIControlStateSelected]; break;
            case kbsButtonLbShadowColorSelected: [button_ setTitleShadowColor:[bsStr color:v] forState:UIControlStateSelected]; break;
            case kbsButtonLbColorSelected: [button_ setTitleColor:[bsStr color:v] forState:UIControlStateSelected]; break;
                
            case kbsButtonAutoResize: autoResize_ = [bsStr BOOLEAN:v]; break;
            case kbsButtonCapInset: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 4) {
                    bsException(NSInvalidArgumentException, @"cap-insets value %@ is invalid. It should be a value of the form top|right|bottom|left", v);
                }
                capInsets_.top = [c[0] floatValue];
                capInsets_.right = [c[1] floatValue];
                capInsets_.bottom = [c[2] floatValue];
                capInsets_.left = [c[3] floatValue];
                capInsetsChange = YES;
            } break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if( imgChange || capInsetsChange ) {
        img = [UIImage imageNamed:img_];
        if( capInsets_.top == 0 && capInsets_.bottom == 0 && capInsets_.left == 0 && capInsets_.right == 0 ) {
            [button_ setBackgroundImage:img forState:UIControlStateNormal];
        } else {
            [button_ setBackgroundImage:[img resizableImageWithCapInsets:capInsets_] forState:UIControlStateNormal];
        }
    }
    if( imgHighlightChange || capInsetsChange ) {
        img = [UIImage imageNamed:imgH_];
        if( capInsets_.top == 0 && capInsets_.bottom == 0 && capInsets_.left == 0 && capInsets_.right == 0 ) {
            [button_ setBackgroundImage:img forState:UIControlStateHighlighted];
        } else {
            [button_ setBackgroundImage:[img resizableImageWithCapInsets:capInsets_] forState:UIControlStateHighlighted];
        }
    }
    if( imgDisabledChange || capInsetsChange ) {
        img = [UIImage imageNamed:imgD_];
        if( capInsets_.top == 0 && capInsets_.bottom == 0 && capInsets_.left == 0 && capInsets_.right == 0 ) {
            [button_ setBackgroundImage:img forState:UIControlStateDisabled];
        } else {
            [button_ setBackgroundImage:[img resizableImageWithCapInsets:capInsets_] forState:UIControlStateDisabled];
        }
    }
    if( imgSelectedChange || capInsetsChange ) {
        img = [UIImage imageNamed:imgS_];
        if( capInsets_.top == 0 && capInsets_.bottom == 0 && capInsets_.left == 0 && capInsets_.right == 0 ) {
            [button_ setBackgroundImage:img forState:UIControlStateSelected];
        } else {
            [button_ setBackgroundImage:[img resizableImageWithCapInsets:capInsets_] forState:UIControlStateSelected];
        }
    }
    if( f0 > 0 || fontSize > 0 ) {
        UIFont *font;
        if( f0 == 0 ) {
            if( [fontName_ hasPrefix:@"system"] ) {
                if( [fontName_ isEqualToString:@"system-bold"]) f0 = 1;
                else if( [fontName_ isEqualToString:@"system-italic"]) f0 = 2;
                else f0 = 3;
            } else {
                f0 = 4;
            }
        } else {
            if( fontSize == 0 ) fontSize = button_.titleLabel.font.pointSize;
        }
        switch ( f0 ) {
            case 1: font = [UIFont boldSystemFontOfSize:fontSize]; break;
            case 2: font = [UIFont italicSystemFontOfSize:fontSize]; break;
            case 3: font = [UIFont systemFontOfSize:fontSize]; break;
            case 4: font = [UIFont fontWithName:button_.titleLabel.font.fontName size:fontSize]; break;
        }
        button_.titleLabel.font = font;
    }
    if( imgChange && autoResize_ ) {
        self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, img.size.width, img.size.height ); //이미지에 따른 크기 조절은 Normal상태 기준임
    }
    return remain;
}

- (void)__touched:(id)sender {
    
    bsButtonTouchedBlock block = objc_getAssociatedObject(self, &blockKey_);
    if( block ) block( self );
}

- (void)blockTouched:(bsButtonTouchedBlock)block {
    
    //if (objc_getAssociatedObject(self, &blockKey_)) bsException(NSInvalidArgumentException, @"두 번 정의할 수 없습니다.");
    objc_setAssociatedObject(self, &blockKey_, block, OBJC_ASSOCIATION_RETAIN);
    if (!addedTouch_) {
        addedTouch_ = YES;
        [button_ addTarget:self action:@selector(__touched:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - override
- (NSString *)create:(NSString *)name params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (bsDisplay *)childG:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)childA:(bsDisplay *)child { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childD:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childS:(NSString *)key params:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
