//
//  bsText.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/20.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsText.h"

NSString * const kbsTextClearButtonNever = @"never";
NSString * const kbsTextClearButtonWhileEditing = @"while";
NSString * const kbsTextClearButtonUnlessEditing = @"unless";
NSString * const kbsTextClearButtonAlways = @"always";

NSString * const kbsTextCapitalizationNone = @"none";
NSString * const kbsTextCapitalizationWord = @"word";
NSString * const kbsTextCapitalizationSentence = @"sentence";
NSString * const kbsTextCapitalizationAll = @"all";

NSString * const kbsTextCorrectionDefault = @"default";
NSString * const kbsTextCorrectionYes = @"yes";
NSString * const kbsTextCorrectionNo = @"no";

NSString * const kbsTextKeyboardAppearanceDefault = @"default";
NSString * const kbsTextKeyboardAppearanceAlert = @"alert";

NSString * const kbsTextKeyboardTypeDefault = @"default";
NSString * const kbsTextKeyboardTypeAlphabet = @"alphabet";
NSString * const kbsTextKeyboardTypeAscii = @"ascii";
NSString * const kbsTextKeyboardTypeNumberPunctuation = @"number-punctuation";
NSString * const kbsTextKeyboardTypeURL = @"url";
NSString * const kbsTextKeyboardTypeNumber = @"number";
NSString * const kbsTextKeyboardTypePhone = @"phone";
NSString * const kbsTextKeyboardTypeNamePhone = @"name-phone";
NSString * const kbsTextKeyboardTypeEmail = @"email";
NSString * const kbsTextKeyboardTypeDecimal = @"decimal";
NSString * const kbsTextKeyboardTypeTwitter = @"twitter";

NSString * const kbsTextReturnKeyDefault = @"default";
NSString * const kbsTextReturnKeyDone = @"done";
NSString * const kbsTextReturnKeyGo = @"go";
NSString * const kbsTextReturnKeyGoogle = @"google";
NSString * const kbsTextReturnKeyJoin = @"join";
NSString * const kbsTextReturnKeyNext = @"number";
NSString * const kbsTextReturnKeyRoute = @"route";
NSString * const kbsTextReturnKeySearch = @"search";
NSString * const kbsTextReturnKeySend = @"send";
NSString * const kbsTextReturnKeyYahoo = @"yahoo";
NSString * const kbsTextReturnKeyEmergency = @"emergency";

static NSDictionary *__bsText_keyValues = nil;

@implementation bsText

- (void)ready {
    
    if (text_ == nil) {
        text_ = [[UITextView alloc] initWithFrame:self.frame];
        [self addSubview:text_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"text_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(text_)];
    }
    if (__bsText_keyValues == nil) {
        __bsText_keyValues =
        @{ @"text": @kbsTextText, @"text-color" : @kbsTextTextColor, @"font-name": @kbsTextFontName, @"font-size": @kbsTextFontSize,
           @"placeholder": @kbsTextPlaceholder, @"align": @kbsTextAlign, @"editable": @kbsTextEditable,
           @"capitalization": @kbsTextCapitalization, @"correction": @kbsTextCorrection,
           @"keyboard-appearance": @kbsTextKeyboardAppearance, @"keyboard-type": @kbsTextKeyboardType,
           @"return-key": @kbsTextReturnKey, @"secure": @kbsTextSecure, @"focus": @kbsTextFocus,
           @"input-view": @kbsTextInputView,@"input-accessory-view": @kbsTextInputAccessoryView,
           };
    }
    fontName_ = @"system";
    text_.delegate = nil;
    text_.editable = YES;
    text_.font = [UIFont systemFontOfSize:14];
    text_.textAlignment = NSTextAlignmentLeft;
    text_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    text_.autocorrectionType = UITextAutocorrectionTypeNo;
    text_.keyboardAppearance = UIKeyboardAppearanceDefault;
    text_.spellCheckingType = UITextSpellCheckingTypeNo;
    text_.keyboardType = UIKeyboardTypeDefault;
    text_.returnKeyType = UIReturnKeyDefault;
    text_.enablesReturnKeyAutomatically = NO;
    text_.secureTextEntry = NO;
    text_.inputView = nil;
    text_.inputAccessoryView = nil;
    text_.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    objc_removeAssociatedObjects( self );
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    text_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsText_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsTextText: value = text_.text; break;
        case kbsTextTextColor: value = text_.textColor; break;
        case kbsTextFontName: value = fontName_; break;
        case kbsTextFontSize: value = @(text_.font.pointSize); break;
        case kbsTextEditable: value = @(text_.editable); break;
        case kbsTextAlign: {
            if( text_.textAlignment == NSTextAlignmentLeft ) value = @"left";
            else if( text_.textAlignment == NSTextAlignmentRight ) value = @"right";
            else if( text_.textAlignment == NSTextAlignmentCenter ) value = @"center";
        } break;
        case kbsTextCapitalization: {
            if( text_.autocapitalizationType == UITextAutocapitalizationTypeNone) value = kbsTextCapitalizationNone;
            else if( text_.autocapitalizationType == UITextAutocapitalizationTypeWords) value = kbsTextCapitalizationWord;
            else if( text_.autocapitalizationType == UITextAutocapitalizationTypeSentences) value = kbsTextCapitalizationSentence;
            else if( text_.autocapitalizationType == UITextAutocapitalizationTypeAllCharacters) value = kbsTextCapitalizationAll;
        } break;
        case kbsTextCorrection: {
            if( text_.autocorrectionType == UITextAutocorrectionTypeDefault) value = kbsTextCorrectionDefault;
            else if( text_.autocorrectionType == UITextAutocorrectionTypeYes) value = kbsTextCorrectionYes;
            else if( text_.autocorrectionType == UITextAutocorrectionTypeNo) value = kbsTextCorrectionNo;
        } break;
        case kbsTextKeyboardAppearance: {
            if( text_.keyboardAppearance == UIKeyboardAppearanceDefault) value = kbsTextKeyboardAppearanceDefault;
            else if( text_.keyboardAppearance == UIKeyboardAppearanceAlert) value = kbsTextKeyboardAppearanceAlert;
        } break;
        case kbsTextKeyboardType: {
            if( text_.keyboardType == UIKeyboardTypeAlphabet) value = kbsTextKeyboardTypeAlphabet;
            else if( text_.keyboardType == UIKeyboardTypeASCIICapable) value = kbsTextKeyboardTypeAscii;
            else if( text_.keyboardType == UIKeyboardTypeDecimalPad) value = kbsTextKeyboardTypeDecimal;
            else if( text_.keyboardType == UIKeyboardTypeDefault) value = kbsTextKeyboardTypeDefault;
            else if( text_.keyboardType == UIKeyboardTypeEmailAddress) value = kbsTextKeyboardTypeEmail;
            else if( text_.keyboardType == UIKeyboardTypeNamePhonePad) value = kbsTextKeyboardTypeNamePhone;
            else if( text_.keyboardType == UIKeyboardTypeNumberPad) value = kbsTextKeyboardTypeNumber;
            else if( text_.keyboardType == UIKeyboardTypeNumbersAndPunctuation) value = kbsTextKeyboardTypeNumberPunctuation;
            else if( text_.keyboardType == UIKeyboardTypePhonePad) value = kbsTextKeyboardTypePhone;
            else if( text_.keyboardType == UIKeyboardTypeTwitter) value = kbsTextKeyboardTypeTwitter;
            else if( text_.keyboardType == UIKeyboardTypeURL) value = kbsTextKeyboardTypeURL;
        } break;
        case kbsTextReturnKey: {
            if( text_.returnKeyType == UIReturnKeyDefault) value = kbsTextReturnKeyDefault;
            else if( text_.returnKeyType == UIReturnKeyDone) value = kbsTextReturnKeyDone;
            else if( text_.returnKeyType == UIReturnKeyEmergencyCall) value = kbsTextReturnKeyEmergency;
            else if( text_.returnKeyType == UIReturnKeyGo) value = kbsTextReturnKeyGo;
            else if( text_.returnKeyType == UIReturnKeyGoogle) value = kbsTextReturnKeyGoogle;
            else if( text_.returnKeyType == UIReturnKeyJoin) value = kbsTextReturnKeyJoin;
            else if( text_.returnKeyType == UIReturnKeyNext) value = kbsTextReturnKeyNext;
            else if( text_.returnKeyType == UIReturnKeyRoute) value = kbsTextReturnKeyRoute;
            else if( text_.returnKeyType == UIReturnKeySearch) value = kbsTextReturnKeySearch;
            else if( text_.returnKeyType == UIReturnKeySend) value = kbsTextReturnKeySend;
            else if( text_.returnKeyType == UIReturnKeyYahoo) value = kbsTextReturnKeyYahoo;
        } break;
        case kbsTextInputView: value = text_.inputView; break;
        case kbsTextInputAccessoryView: value = text_.inputAccessoryView; break;
        case kbsTextSecure: value = @(text_.secureTextEntry); break;
    }
    return value;
}

- (NSArray *)__s:(NSArray *)params {
    
    NSMutableArray *remain = [NSMutableArray array];
    NSInteger f0 = 0;
    CGFloat fontSize = 0;
    for( NSInteger i = 0, j = [params count]; i < j; ) {
        NSString *k = (NSString*)params[i++];
        NSString *v = (NSString*)params[i++];
        NSInteger num = [[__bsText_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsTextText: text_.text = v; break;
            case kbsTextTextColor: text_.textColor = [bsStr color:v]; break;
            case kbsTextFontName: {
                if( [v isEqualToString:@"system-bold"] || [v isEqualToString:@"bold"] ) { f0 = 1; fontName_ = @"system-bold"; }
                else if( [v isEqualToString:@"system-italic"] || [v isEqualToString:@"italic"] ) { f0 = 2; fontName_ = @"system-italic"; }
                else if( [v isEqualToString:@"system"] ) { f0 = 3; fontName_=@"system"; }
                else {
                    f0 = 4;
                    fontName_ = v; //http://iphonedevsdk.com/forum/iphone-sdk-development/6000-list-uifonts-available.html
                }
            } break;
            case kbsTextFontSize: fontSize = [v floatValue]; break;
            case kbsTextEditable: text_.editable = [bsStr BOOLEAN:v]; break;
            case kbsTextAlign: {
                if( [v isEqualToString:@"left"] ) text_.textAlignment = NSTextAlignmentLeft;
                else if( [v isEqualToString:@"center"] ) text_.textAlignment = NSTextAlignmentCenter;
                else if( [v isEqualToString:@"right"] ) text_.textAlignment = NSTextAlignmentRight;
            } break;
            case kbsTextCapitalization: {
                if( [v isEqualToString:kbsTextCapitalizationNone] ) text_.autocapitalizationType = UITextAutocapitalizationTypeNone;
                else if( [v isEqualToString:kbsTextCapitalizationWord] ) text_.autocapitalizationType = UITextAutocapitalizationTypeWords;
                else if( [v isEqualToString:kbsTextCapitalizationSentence] ) text_.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                else if( [v isEqualToString:kbsTextCapitalizationAll] ) text_.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            } break;
            case kbsTextCorrection: {
                if( [v isEqualToString:kbsTextCorrectionDefault] ) text_.autocorrectionType = UITextAutocorrectionTypeDefault;
                else if( [v isEqualToString:kbsTextCorrectionYes] ) text_.autocorrectionType = UITextAutocorrectionTypeYes;
                else if( [v isEqualToString:kbsTextCorrectionNo] ) text_.autocorrectionType = UITextAutocorrectionTypeNo;
            } break;
            case kbsTextKeyboardAppearance: {
                if( [v isEqualToString:kbsTextKeyboardAppearanceDefault] ) text_.keyboardAppearance = UIKeyboardAppearanceDefault;
                else if( [v isEqualToString:kbsTextKeyboardAppearanceAlert] ) text_.keyboardAppearance = UIKeyboardAppearanceAlert;
            } break;
            case kbsTextKeyboardType: {
                if( [v isEqualToString:kbsTextKeyboardTypeAlphabet] ) text_.keyboardType = UIKeyboardTypeAlphabet;
                else if( [v isEqualToString:kbsTextKeyboardTypeAscii] ) text_.keyboardType = UIKeyboardTypeASCIICapable;
                else if( [v isEqualToString:kbsTextKeyboardTypeDecimal] ) text_.keyboardType = UIKeyboardTypeDecimalPad;
                else if( [v isEqualToString:kbsTextKeyboardTypeDefault] ) text_.keyboardType = UIKeyboardTypeDefault;
                else if( [v isEqualToString:kbsTextKeyboardTypeEmail] ) text_.keyboardType = UIKeyboardTypeEmailAddress;
                else if( [v isEqualToString:kbsTextKeyboardTypeNamePhone] ) text_.keyboardType = UIKeyboardTypeNamePhonePad;
                else if( [v isEqualToString:kbsTextKeyboardTypeNumber] ) text_.keyboardType = UIKeyboardTypeNumberPad;
                else if( [v isEqualToString:kbsTextKeyboardTypeNumberPunctuation] ) text_.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                else if( [v isEqualToString:kbsTextKeyboardTypePhone] ) text_.keyboardType = UIKeyboardTypePhonePad;
                else if( [v isEqualToString:kbsTextKeyboardTypeTwitter] ) text_.keyboardType = UIKeyboardTypeTwitter;
                else if( [v isEqualToString:kbsTextKeyboardTypeURL] ) text_.keyboardType = UIKeyboardTypeURL;
            } break;
                
            case kbsTextReturnKey: {
                if( [v isEqualToString:kbsTextReturnKeyDefault] ) text_.returnKeyType = UIReturnKeyDefault;
                else if( [v isEqualToString:kbsTextReturnKeyDone] ) text_.returnKeyType = UIReturnKeyDone;
                else if( [v isEqualToString:kbsTextReturnKeyEmergency] ) text_.returnKeyType = UIReturnKeyEmergencyCall;
                else if( [v isEqualToString:kbsTextReturnKeyGo] ) text_.returnKeyType = UIReturnKeyGo;
                else if( [v isEqualToString:kbsTextReturnKeyGoogle] ) text_.returnKeyType = UIReturnKeyGoogle;
                else if( [v isEqualToString:kbsTextReturnKeyJoin] ) text_.returnKeyType = UIReturnKeyJoin;
                else if( [v isEqualToString:kbsTextReturnKeyNext] ) text_.returnKeyType = UIReturnKeyNext;
                else if( [v isEqualToString:kbsTextReturnKeyRoute] ) text_.returnKeyType = UIReturnKeyRoute;
                else if( [v isEqualToString:kbsTextReturnKeySearch] ) text_.returnKeyType = UIReturnKeySearch;
                else if( [v isEqualToString:kbsTextReturnKeySend] ) text_.returnKeyType = UIReturnKeySend;
                else if( [v isEqualToString:kbsTextReturnKeyYahoo] ) text_.returnKeyType = UIReturnKeyYahoo;
            } break;
            case kbsTextSecure: text_.secureTextEntry = [bsStr BOOLEAN:v]; break;
            case kbsTextFocus: {
                if( [bsStr BOOLEAN:v] ) {
                    [text_ becomeFirstResponder];
                } else {
                    [text_ resignFirstResponder];
                }
            } break;
            case kbsTextInputView: {
                Class clazz = NSClassFromString( v );
                if( !clazz ) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) for inputView is undefined", v);
                }
                UIView *view = [[clazz alloc] performSelector:@selector(initWithTextField:) withObject:text_];
                if( ![view conformsToProtocol:@protocol(UITextInputTraits)] ) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) is not implement UITextInputTraits", v);
                }
                text_.inputView = view;
            } break;
            case kbsTextInputAccessoryView: {
                Class clazz = NSClassFromString( v );
                if( !clazz ) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) for inputAccessoryView is undefined", v);
                }
                UIView *view = [[clazz alloc] performSelector:@selector(initWithTextField:) withObject:text_];
                text_.inputAccessoryView = view;
            } break;
            default: [remain addObject:k]; [remain addObject:v]; break;
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
            if (fontSize == 0) {
                fontSize = text_.font.pointSize;
            }
        }
        switch (f0) {
            case 1: font = [UIFont boldSystemFontOfSize:fontSize]; break;
            case 2: font = [UIFont italicSystemFontOfSize:fontSize]; break;
            case 3: font = [UIFont systemFontOfSize:fontSize]; break;
            case 4: font = [UIFont fontWithName:text_.font.fontName size:fontSize]; break;
        }
        text_.font = font;
    }
    return remain;
}

#pragma mark - blocks

- (void)blockEditWillBegin:(bsTextWillBeginEditBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyWillBeginEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditDidBegin:(bsTextDidBeginEditBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyDidBeginEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditWillEnd:(bsTextWillEndEditBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyWillEndEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditDidEnd:(bsTextDidEndEditBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyDidEndEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockChangeChar:(bsTextChangeCharBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyChangeChar_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockDidChange:(bsTextDidChangeBlock)block {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyDidChange_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockDidChangeSelection:(bsTextDidChangeSelectionBlock)block {
    
    if (text_.delegate == nil) {
        text_.delegate = self;
    }
    objc_setAssociatedObject(self, &blockKeyDidChangeSelection_, block, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    BOOL allowEdit = YES;
    bsTextWillBeginEditBlock block = objc_getAssociatedObject(self, &blockKeyWillBeginEdit_);
    if (block) {
        block(self, &allowEdit);
    }
    return allowEdit;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    bsTextDidBeginEditBlock block = objc_getAssociatedObject(self, &blockKeyDidBeginEdit_);
    if (block) {
        block(self);
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    BOOL stopEdit = YES;
    bsTextWillEndEditBlock block = objc_getAssociatedObject(self, &blockKeyWillEndEdit_);
    if (block) {
        block(self, &stopEdit);
    }
    return stopEdit;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsTextDidEndEditBlock block = objc_getAssociatedObject(self, &blockKeyDidEndEdit_);
    if (block) {
        block(self);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    BOOL allowChange = YES;
    bsTextChangeCharBlock block = objc_getAssociatedObject(self, &blockKeyChangeChar_);
    if (block) {
        block(self, range, text, &allowChange);
    }
    return allowChange;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsTextDidChangeBlock block = objc_getAssociatedObject( self, &blockKeyDidChange_);
    if(block) {
        block(self);
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    bsTextDidChangeSelectionBlock block = objc_getAssociatedObject(self, &blockKeyDidChangeSelection_);
    if(block) {
        block(self);
    }
}

#pragma mark - override
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params { bsException(NSInternalInconsistencyException, @"Do not call this method!" ); return nil; }
- (NSString *)addSubviewWithTemplateKey:(NSString *)key parameters:(NSString *)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (NSString *)addSubviewWithName:(NSString *)name styles:(NSString *)styleNames parameters:(NSString*)params replace:(id)replace { bsException(NSInternalInconsistencyException, @"Do not call this method!" ); return nil; }
- (bsDisplay *)subviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); return nil; }
- (void)removeSubviewWithName:(NSString *)key { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString*)params { bsException(NSInternalInconsistencyException, @"Do not call this method!"); }
- (void)applyStylesToSubviewWithName:(NSString *)key parameters:(NSString*)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
