//
//  bsTextField.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/19.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsTextField.h"

#import "bsStr.h"
#import "bsMacro.h"

NSString * const kbsTextBorderStyleNone = @"none";
NSString * const kbsTextBorderStyleLine = @"line";
NSString * const kbsTextBorderStyleBezel = @"bezel";
NSString * const kbsTextBorderStyleRoundedRect = @"round-rect";

NSString * const kbsTextFieldClearButtonNever = @"never";
NSString * const kbsTextFieldClearButtonWhileEditing = @"while";
NSString * const kbsTextFieldClearButtonUnlessEditing = @"unless";
NSString * const kbsTextFieldClearButtonAlways = @"always";

NSString * const kbsTextFieldCapitalizationNone = @"none";
NSString * const kbsTextFieldCapitalizationWord = @"word";
NSString * const kbsTextFieldCapitalizationSentence = @"sentence";
NSString * const kbsTextFieldCapitalizationAll = @"all";

NSString * const kbsTextFieldCorrectionDefault = @"default";
NSString * const kbsTextFieldCorrectionYes = @"yes";
NSString * const kbsTextFieldCorrectionNo = @"no";

NSString * const kbsTextFieldKeyboardAppearanceDefault = @"default";
NSString * const kbsTextFieldKeyboardAppearanceAlert = @"alert";

NSString * const kbsTextFieldKeyboardTypeDefault = @"default";
NSString * const kbsTextFieldKeyboardTypeAlphabet = @"alphabet";
NSString * const kbsTextFieldKeyboardTypeAscii = @"ascii";
NSString * const kbsTextFieldKeyboardTypeNumberPunctuation = @"number-punctuation";
NSString * const kbsTextFieldKeyboardTypeURL = @"url";
NSString * const kbsTextFieldKeyboardTypeNumber = @"number";
NSString * const kbsTextFieldKeyboardTypePhone = @"phone";
NSString * const kbsTextFieldKeyboardTypeNamePhone = @"name-phone";
NSString * const kbsTextFieldKeyboardTypeEmail = @"email";
NSString * const kbsTextFieldKeyboardTypeDecimal = @"decimal";
NSString * const kbsTextFieldKeyboardTypeTwitter = @"twitter";

NSString * const kbsTextFieldReturnKeyDefault = @"default";
NSString * const kbsTextFieldReturnKeyDone = @"done";
NSString * const kbsTextFieldReturnKeyGo = @"go";
NSString * const kbsTextFieldReturnKeyGoogle = @"google";
NSString * const kbsTextFieldReturnKeyJoin = @"join";
NSString * const kbsTextFieldReturnKeyNext = @"next";
NSString * const kbsTextFieldReturnKeyRoute = @"route";
NSString * const kbsTextFieldReturnKeySearch = @"search";
NSString * const kbsTextFieldReturnKeySend = @"send";
NSString * const kbsTextFieldReturnKeyYahoo = @"yahoo";
NSString * const kbsTextFieldReturnKeyEmergency = @"emergency";

static NSDictionary *__bsTextField_keyValues = nil;

@implementation bsTextField

- (void)ready {
    
    if (textField_ == nil) {
        textField_ = [[UITextField alloc] initWithFrame:self.frame];
        [self addSubview:textField_];
        //[self autolayout:[bsStr templateSrc:kbsDisplayConstraintDefault replace:@[@"textField_", @"buttonVertical", @"buttonHorizontal"]] views:NSDictionaryOfVariableBindings(textField_)];
    }
    if( __bsTextField_keyValues == nil ) {
        __bsTextField_keyValues =
        @{ @"text": @kbsTextFieldText, @"text-color" : @kbsTextFieldTextColor, @"font-name": @kbsTextFieldFontName, @"font-size": @kbsTextFieldFontSize,
           @"placeholder": @kbsTextFieldPlaceholder, @"align": @kbsTextFieldAlign, @"valign": @kbsTextFieldVAlign,
           @"border-style": @kbsTextFieldBorderStyle, @"enabled": @kbsTextFieldEnabled,
           @"clear-button": @kbsTextFieldClearButton, @"clear-begin-edit": @kbsTextFieldClearBeginEdit,
           @"capitalization": @kbsTextFieldCapitalization, @"correction": @kbsTextFieldCorrection,
           @"keyboard-appearance": @kbsTextFieldKeyboardAppearance, @"keyboard-type": @kbsTextFieldKeyboardType,
           @"return-key": @kbsTextFieldReturnKey, @"secure": @kbsTextFieldSecure, @"focus": @kbsTextFieldFocus,
           @"input-view": @kbsTextFieldInputView, @"input-accessory-view": @kbsTextFieldInputAccessoryView,
           };
    }
    fontName_ = @"system";
    textField_.delegate = nil;
    textField_.enabled = YES;
    textField_.placeholder = @"";
    textField_.text = @"";
    textField_.borderStyle = UITextBorderStyleLine;
    textField_.font = [UIFont systemFontOfSize:14];
    textField_.clearsOnBeginEditing = NO;
    textField_.clearButtonMode = UITextFieldViewModeNever;
    textField_.textAlignment = NSTextAlignmentLeft;
    textField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField_.autocorrectionType = UITextAutocorrectionTypeNo;
    textField_.keyboardAppearance = UIKeyboardAppearanceDefault;
    textField_.spellCheckingType = UITextSpellCheckingTypeNo;
    textField_.keyboardType = UIKeyboardTypeDefault;
    textField_.returnKeyType = UIReturnKeyDefault;
    textField_.enablesReturnKeyAutomatically = NO;
    textField_.secureTextEntry = NO;
    textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField_.inputView = nil;
    textField_.inputAccessoryView = nil;
}

- (void)dealloc {
    
    NSLog(@"bsTextField dealloc");
    objc_removeAssociatedObjects( self );
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    textField_.frame = self.bounds;
}

- (id)__g:(NSString *)key {
    
    NSInteger num = [[__bsTextField_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch ( num ) {
        case kbsTextFieldText: value = textField_.text; break;
        case kbsTextFieldTextColor: value = textField_.textColor; break;
        case kbsTextFieldFontName: value = fontName_; break;
        case kbsTextFieldFontSize: value = @(textField_.font.pointSize); break;
        case kbsTextFieldPlaceholder: value = textField_.placeholder; break;
        case kbsTextFieldEnabled: value = @(textField_.enabled); break;
        case kbsTextFieldAlign: {
            if( textField_.textAlignment == NSTextAlignmentLeft ) value = @"left";
            else if( textField_.textAlignment == NSTextAlignmentRight ) value = @"right";
            else if( textField_.textAlignment == NSTextAlignmentCenter ) value = @"center";
        } break;
        case kbsTextFieldVAlign: {
            if( textField_.contentVerticalAlignment == UIControlContentVerticalAlignmentTop ) value = @"top";
            else if( textField_.contentVerticalAlignment == UIControlContentVerticalAlignmentCenter ) value = @"middle";
            else if( textField_.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom ) value = @"bottom";
        } break;
        case kbsTextFieldBorderStyle: {
            if( textField_.borderStyle == UITextBorderStyleNone ) value = kbsTextBorderStyleNone;
            else if( textField_.borderStyle == UITextBorderStyleLine ) value = kbsTextBorderStyleLine;
            else if( textField_.borderStyle == UITextBorderStyleBezel ) value = kbsTextBorderStyleBezel;
            else if( textField_.borderStyle == UITextBorderStyleRoundedRect ) value = kbsTextBorderStyleRoundedRect;
        } break;
        case kbsTextFieldClearButton: {
            if( textField_.clearButtonMode == UITextFieldViewModeNever ) value = kbsTextFieldClearButtonNever;
            else if( textField_.clearButtonMode == UITextFieldViewModeWhileEditing ) value = kbsTextFieldClearButtonWhileEditing;
            else if( textField_.clearButtonMode == UITextFieldViewModeUnlessEditing ) value = kbsTextFieldClearButtonUnlessEditing;
            else if( textField_.clearButtonMode == UITextFieldViewModeAlways ) value = kbsTextFieldClearButtonAlways;
        } break;
        case kbsTextFieldClearBeginEdit: value = @(textField_.clearsOnBeginEditing); break;
        case kbsTextFieldCapitalization: {
            if( textField_.autocapitalizationType == UITextAutocapitalizationTypeNone) value = kbsTextFieldCapitalizationNone;
            else if( textField_.autocapitalizationType == UITextAutocapitalizationTypeWords) value = kbsTextFieldCapitalizationWord;
            else if( textField_.autocapitalizationType == UITextAutocapitalizationTypeSentences) value = kbsTextFieldCapitalizationSentence;
            else if( textField_.autocapitalizationType == UITextAutocapitalizationTypeAllCharacters) value = kbsTextFieldCapitalizationAll;
        } break;
        case kbsTextFieldCorrection: {
            if( textField_.autocorrectionType == UITextAutocorrectionTypeDefault) value = kbsTextFieldCorrectionDefault;
            else if( textField_.autocorrectionType == UITextAutocorrectionTypeYes) value = kbsTextFieldCorrectionYes;
            else if( textField_.autocorrectionType == UITextAutocorrectionTypeNo) value = kbsTextFieldCorrectionNo;
        } break;
        case kbsTextFieldKeyboardAppearance: {
            if( textField_.keyboardAppearance == UIKeyboardAppearanceDefault) value = kbsTextFieldKeyboardAppearanceDefault;
            else if( textField_.keyboardAppearance == UIKeyboardAppearanceAlert) value = kbsTextFieldKeyboardAppearanceAlert;
        } break;
        case kbsTextFieldKeyboardType: {
            if( textField_.keyboardType == UIKeyboardTypeAlphabet) value = kbsTextFieldKeyboardTypeAlphabet;
            else if( textField_.keyboardType == UIKeyboardTypeASCIICapable) value = kbsTextFieldKeyboardTypeAscii;
            else if( textField_.keyboardType == UIKeyboardTypeDecimalPad) value = kbsTextFieldKeyboardTypeDecimal;
            else if( textField_.keyboardType == UIKeyboardTypeDefault) value = kbsTextFieldKeyboardTypeDefault;
            else if( textField_.keyboardType == UIKeyboardTypeEmailAddress) value = kbsTextFieldKeyboardTypeEmail;
            else if( textField_.keyboardType == UIKeyboardTypeNamePhonePad) value = kbsTextFieldKeyboardTypeNamePhone;
            else if( textField_.keyboardType == UIKeyboardTypeNumberPad) value = kbsTextFieldKeyboardTypeNumber;
            else if( textField_.keyboardType == UIKeyboardTypeNumbersAndPunctuation) value = kbsTextFieldKeyboardTypeNumberPunctuation;
            else if( textField_.keyboardType == UIKeyboardTypePhonePad) value = kbsTextFieldKeyboardTypePhone;
            else if( textField_.keyboardType == UIKeyboardTypeTwitter) value = kbsTextFieldKeyboardTypeTwitter;
            else if( textField_.keyboardType == UIKeyboardTypeURL) value = kbsTextFieldKeyboardTypeURL;
        } break;
        case kbsTextFieldReturnKey: {
            if( textField_.returnKeyType == UIReturnKeyDefault) value = kbsTextFieldReturnKeyDefault;
            else if( textField_.returnKeyType == UIReturnKeyDone) value = kbsTextFieldReturnKeyDone;
            else if( textField_.returnKeyType == UIReturnKeyEmergencyCall) value = kbsTextFieldReturnKeyEmergency;
            else if( textField_.returnKeyType == UIReturnKeyGo) value = kbsTextFieldReturnKeyGo;
            else if( textField_.returnKeyType == UIReturnKeyGoogle) value = kbsTextFieldReturnKeyGoogle;
            else if( textField_.returnKeyType == UIReturnKeyJoin) value = kbsTextFieldReturnKeyJoin;
            else if( textField_.returnKeyType == UIReturnKeyNext) value = kbsTextFieldReturnKeyNext;
            else if( textField_.returnKeyType == UIReturnKeyRoute) value = kbsTextFieldReturnKeyRoute;
            else if( textField_.returnKeyType == UIReturnKeySearch) value = kbsTextFieldReturnKeySearch;
            else if( textField_.returnKeyType == UIReturnKeySend) value = kbsTextFieldReturnKeySend;
            else if( textField_.returnKeyType == UIReturnKeyYahoo) value = kbsTextFieldReturnKeyYahoo;
        } break;
        case kbsTextFieldInputView: value = textField_.inputView; break;
        case kbsTextFieldInputAccessoryView: value = textField_.inputAccessoryView; break;
        case kbsTextFieldSecure: value = @(textField_.secureTextEntry); break;
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
        NSInteger num = [[__bsTextField_keyValues objectForKey:k] integerValue];
        switch ( num ) {
            case kbsTextFieldText: textField_.text = v; break;
            case kbsTextFieldTextColor: textField_.textColor = [bsStr color:v]; break;
            case kbsTextFieldFontName: {
                if( [v isEqualToString:@"system-bold"] || [v isEqualToString:@"bold"] ) { f0 = 1; fontName_ = @"system-bold"; }
                else if( [v isEqualToString:@"system-italic"] || [v isEqualToString:@"italic"] ) { f0 = 2; fontName_ = @"system-italic"; }
                else if( [v isEqualToString:@"system"] ) { f0 = 3; fontName_=@"system"; }
                else {
                    f0 = 4;
                    fontName_ = v; //http://iphonedevsdk.com/forum/iphone-sdk-development/6000-list-uifonts-available.html
                }
            } break;
            case kbsTextFieldFontSize: fontSize = [v floatValue]; break;
            case kbsTextFieldPlaceholder: textField_.placeholder = v; break;
            case kbsTextFieldEnabled: textField_.enabled = [bsStr BOOLEAN:v]; break;
            case kbsTextFieldAlign: {
                if( [v isEqualToString:@"left"] ) textField_.textAlignment = NSTextAlignmentLeft;
                else if( [v isEqualToString:@"center"] ) textField_.textAlignment = NSTextAlignmentCenter;
                else if( [v isEqualToString:@"right"] ) textField_.textAlignment = NSTextAlignmentRight;
            } break;
            case kbsTextFieldVAlign: {
                if( [v isEqualToString:@"top"] ) textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                else if( [v isEqualToString:@"middle"] ) textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                else if( [v isEqualToString:@"bottom"] ) textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            } break;
            case kbsTextFieldBorderStyle: {
                if( [v isEqualToString:kbsTextBorderStyleNone] ) textField_.borderStyle = UITextBorderStyleNone;
                else if( [v isEqualToString:kbsTextBorderStyleLine] ) textField_.borderStyle = UITextBorderStyleLine;
                else if( [v isEqualToString:kbsTextBorderStyleBezel] ) textField_.borderStyle = UITextBorderStyleBezel;
                else if( [v isEqualToString:kbsTextBorderStyleRoundedRect] ) textField_.borderStyle = UITextBorderStyleRoundedRect;
            } break;
            case kbsTextFieldClearButton: {
                if( [v isEqualToString:kbsTextFieldClearButtonNever] ) textField_.clearButtonMode = UITextFieldViewModeNever;
                else if( [v isEqualToString:kbsTextFieldClearButtonWhileEditing] ) textField_.clearButtonMode = UITextFieldViewModeWhileEditing;
                else if( [v isEqualToString:kbsTextFieldClearButtonUnlessEditing] ) textField_.clearButtonMode = UITextFieldViewModeUnlessEditing;
                else if( [v isEqualToString:kbsTextFieldClearButtonAlways] ) textField_.clearButtonMode = UITextFieldViewModeAlways;
            } break;
            case kbsTextFieldClearBeginEdit: textField_.clearsOnBeginEditing = [bsStr BOOLEAN:v]; break;
            case kbsTextFieldCapitalization: {
                if( [v isEqualToString:kbsTextFieldCapitalizationNone] ) textField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
                else if( [v isEqualToString:kbsTextFieldCapitalizationWord] ) textField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
                else if( [v isEqualToString:kbsTextFieldCapitalizationSentence] ) textField_.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                else if( [v isEqualToString:kbsTextFieldCapitalizationAll] ) textField_.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            } break;
            case kbsTextFieldCorrection: {
                if( [v isEqualToString:kbsTextFieldCorrectionDefault] ) textField_.autocorrectionType = UITextAutocorrectionTypeDefault;
                else if( [v isEqualToString:kbsTextFieldCorrectionYes] ) textField_.autocorrectionType = UITextAutocorrectionTypeYes;
                else if( [v isEqualToString:kbsTextFieldCorrectionNo] ) textField_.autocorrectionType = UITextAutocorrectionTypeNo;
            } break;
            case kbsTextFieldKeyboardAppearance: {
                if( [v isEqualToString:kbsTextFieldKeyboardAppearanceDefault] ) textField_.keyboardAppearance = UIKeyboardAppearanceDefault;
                else if( [v isEqualToString:kbsTextFieldKeyboardAppearanceAlert] ) textField_.keyboardAppearance = UIKeyboardAppearanceAlert;
            } break;
            case kbsTextFieldKeyboardType: {
                if( [v isEqualToString:kbsTextFieldKeyboardTypeAlphabet] ) textField_.keyboardType = UIKeyboardTypeAlphabet;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeAscii] ) textField_.keyboardType = UIKeyboardTypeASCIICapable;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeDecimal] ) textField_.keyboardType = UIKeyboardTypeDecimalPad;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeDefault] ) textField_.keyboardType = UIKeyboardTypeDefault;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeEmail] ) textField_.keyboardType = UIKeyboardTypeEmailAddress;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeNamePhone] ) textField_.keyboardType = UIKeyboardTypeNamePhonePad;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeNumber] ) textField_.keyboardType = UIKeyboardTypeNumberPad;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeNumberPunctuation] ) textField_.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypePhone] ) textField_.keyboardType = UIKeyboardTypePhonePad;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeTwitter] ) textField_.keyboardType = UIKeyboardTypeTwitter;
                else if( [v isEqualToString:kbsTextFieldKeyboardTypeURL] ) textField_.keyboardType = UIKeyboardTypeURL;
            } break;
                
            case kbsTextFieldReturnKey: {
                if( [v isEqualToString:kbsTextFieldReturnKeyDefault] ) textField_.returnKeyType = UIReturnKeyDefault;
                else if( [v isEqualToString:kbsTextFieldReturnKeyDone] ) textField_.returnKeyType = UIReturnKeyDone;
                else if( [v isEqualToString:kbsTextFieldReturnKeyEmergency] ) textField_.returnKeyType = UIReturnKeyEmergencyCall;
                else if( [v isEqualToString:kbsTextFieldReturnKeyGo] ) textField_.returnKeyType = UIReturnKeyGo;
                else if( [v isEqualToString:kbsTextFieldReturnKeyGoogle] ) textField_.returnKeyType = UIReturnKeyGoogle;
                else if( [v isEqualToString:kbsTextFieldReturnKeyJoin] ) textField_.returnKeyType = UIReturnKeyJoin;
                else if( [v isEqualToString:kbsTextFieldReturnKeyNext] ) textField_.returnKeyType = UIReturnKeyNext;
                else if( [v isEqualToString:kbsTextFieldReturnKeyRoute] ) textField_.returnKeyType = UIReturnKeyRoute;
                else if( [v isEqualToString:kbsTextFieldReturnKeySearch] ) textField_.returnKeyType = UIReturnKeySearch;
                else if( [v isEqualToString:kbsTextFieldReturnKeySend] ) textField_.returnKeyType = UIReturnKeySend;
                else if( [v isEqualToString:kbsTextFieldReturnKeyYahoo] ) textField_.returnKeyType = UIReturnKeyYahoo;
            } break;
            case kbsTextFieldSecure: textField_.secureTextEntry = [bsStr BOOLEAN:v]; break;
            case kbsTextFieldFocus: {
                if( [bsStr BOOLEAN:v] ) {
                    [textField_ becomeFirstResponder];
                } else {
                    [textField_ resignFirstResponder];
                }
            } break;
            case kbsTextFieldInputView: {
                Class clazz = NSClassFromString(v);
                if (!clazz) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) for inputView is undefined", v);
                }
                UIView *view = [[clazz alloc] performSelector:@selector(initWithTextField:) withObject:textField_];
                if( ![view conformsToProtocol:@protocol(UITextInputTraits)] ) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) is not implement UITextInputTraits", v);
                }
                textField_.inputView = view;
            } break;
            case kbsTextFieldInputAccessoryView: {
                Class clazz = NSClassFromString(v);
                if (!clazz) {
                    bsException(NSInvalidArgumentException, @"Class name(=%@) for inputAccessoryView is undefined", v);
                }
                UIView *view = [[clazz alloc] performSelector:@selector(initWithTextField:) withObject:textField_];
                textField_.inputAccessoryView = view;
            } break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if(f0 > 0 || fontSize > 0) {
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
            if( fontSize == 0 ) fontSize = textField_.font.pointSize;
        }
        switch ( f0 ) {
            case 1: font = [UIFont boldSystemFontOfSize:fontSize]; break;
            case 2: font = [UIFont italicSystemFontOfSize:fontSize]; break;
            case 3: font = [UIFont systemFontOfSize:fontSize]; break;
            case 4: font = [UIFont fontWithName:textField_.font.fontName size:fontSize]; break;
        }
        textField_.font = font;
    }
    return remain;
}

#pragma mark - blocks

- (void)blockEditWillBegin:(bsTextFieldWillBeginEditBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyWillBeginEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditDidBegin:(bsTextFieldDidBeginEditBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyDidBeginEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditWillEnd:(bsTextFieldWillEndEditBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyWillEndEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockEditDidEnd:(bsTextFieldDidEndEditBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyDidEndEdit_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockChangeChar:(bsTextFieldChangeCharBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyChangeChar_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockChangeCharWithFullString:(bsTextFieldChangeCharWithFullStringBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyChangeCharWithFullString_, block, OBJC_ASSOCIATION_RETAIN);
}

- (void)blockChangeCharPhone:(bsTextFieldChangePhoneBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyChangePhone_, block, OBJC_ASSOCIATION_RETAIN);
}

-(void)blockClear:(bsTextFieldClearBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyClear_, block, OBJC_ASSOCIATION_RETAIN);
}

-(void)blockReturn:(bsTextFieldReturnBlock)block {
    
    if( textField_.delegate == nil ) textField_.delegate = self;
    objc_setAssociatedObject(self, &blockKeyReturn_, block, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    BOOL allowEdit = YES;
    bsTextFieldWillBeginEditBlock block = objc_getAssociatedObject(self, &blockKeyWillBeginEdit_);
    if (block) {
        block(self, &allowEdit);
    }
    return allowEdit;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    bsTextFieldDidBeginEditBlock block = objc_getAssociatedObject(self, &blockKeyDidBeginEdit_);
    if (block) {
        block(self);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    BOOL stopEdit = YES;
    bsTextFieldWillEndEditBlock block = objc_getAssociatedObject( self, &blockKeyWillEndEdit_);
    if (block) {
        block(self, &stopEdit);
    }
    return stopEdit;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    bsTextFieldDidEndEditBlock block = objc_getAssociatedObject(self, &blockKeyDidEndEdit_);
    if (block) {
        block(self);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    {
        bsTextFieldChangeCharBlock block = objc_getAssociatedObject(self, &blockKeyChangeChar_);
        if (block) {
            BOOL allowChange = YES;
            block(self, range, string, &allowChange);
            return allowChange;
        }
    }
    {
        //한글은 문제있음
        bsTextFieldChangeCharWithFullStringBlock block = objc_getAssociatedObject(self, &blockKeyChangeCharWithFullString_);
        if (block) {
            BOOL allowChange = YES;
            NSString *tmpStr;
            tmpStr = textField.text;
            if( [string length] > 0 ) {
                NSString *first = [tmpStr substringToIndex:range.location];
                NSString *second = [tmpStr substringFromIndex:range.location];
                tmpStr = [NSString stringWithFormat:@"%@%@%@",first, string, second];
            } else {
                tmpStr = [tmpStr stringByReplacingCharactersInRange:range withString:@""];
            }
            block( self, range, string, tmpStr, &allowChange );
            return allowChange;
        }
    }
    {
        bsTextFieldChangePhoneBlock block = objc_getAssociatedObject( self, &blockKeyChangePhone_ );
        if (block) {
            //int length = [self getLength:textField.text];
            NSString *text;
            BOOL textChanged = NO;
            NSUInteger length;
            if ([string length] == 0) { //backspace
                text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                length = text.length;
                textChanged = YES;
            } else {
                NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
                if( [numbers characterIsMember:[string characterAtIndex:0]] ) {
                    text = textField.text;
                    NSString *first = [text substringToIndex:range.location];
                    NSString *second = [text substringFromIndex:range.location];
                    text = [NSString stringWithFormat:@"%@%@%@",first, string, second];
                    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    length = text.length;
                    if( length > 11 ) {
                        return NO;
                    } else {
                        textChanged = YES;
                    }
                } else {
                    return NO;
                }
            }
            if( textChanged ) {
                if( length > 1 ) {
                    NSString *temp = [text substringWithRange:NSMakeRange(0, 2)];
                    if( [temp isEqualToString:@"01"] || ![temp isEqualToString:@"02"] ) {
                        if( length > 3 && length < 7 ) {
                            NSString *a = [text substringWithRange:NSMakeRange(0, 3)];
                            NSString *b = [text substringWithRange:NSMakeRange(3, length-3)];
                            text = [NSString stringWithFormat:@"%@-%@",a, b];
                        } else if( length > 6 && length < 11 ) {
                            NSString *a = [text substringWithRange:NSMakeRange(0, 3)];
                            NSString *b = [text substringWithRange:NSMakeRange(3, 3)];
                            NSString *c = [text substringWithRange:NSMakeRange(6, length-6)];
                            text = [NSString stringWithFormat:@"%@-%@-%@",a, b, c];
                        } else if( length > 10 ){
                            NSString *a = [text substringWithRange:NSMakeRange(0, 3)];
                            NSString *b = [text substringWithRange:NSMakeRange(3, 4)];
                            NSString *c = [text substringWithRange:NSMakeRange(7, length-7)];
                            text = [NSString stringWithFormat:@"%@-%@-%@",a, b, c];
                        }
                    } else {
                        if( length > 2 && length < 6 ) {
                            NSString *a = [text substringWithRange:NSMakeRange(0, 2)];
                            NSString *b = [text substringWithRange:NSMakeRange(2, length-2)];
                            text = [NSString stringWithFormat:@"%@-%@",a, b];
                        } else if( length > 5 && length < 10 ) {
                            NSString *a = [text substringWithRange:NSMakeRange(0, 2)];
                            NSString *b = [text substringWithRange:NSMakeRange(2, 3)];
                            NSString *c = [text substringWithRange:NSMakeRange(5, length-5)];
                            text = [NSString stringWithFormat:@"%@-%@-%@",a, b, c];
                        } else if( length == 10 ){
                            NSString *a = [text substringWithRange:NSMakeRange(0, 2)];
                            NSString *b = [text substringWithRange:NSMakeRange(2, 4)];
                            NSString *c = [text substringWithRange:NSMakeRange(6, length-6)];
                            text = [NSString stringWithFormat:@"%@-%@-%@",a, b, c];
                        } else if( length > 10 ) {
                            return NO;
                        }
                    }
                }
                textField.text = text;
            }
            block(self, textField.text);
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    BOOL allowClear = YES;
    bsTextFieldClearBlock block = objc_getAssociatedObject(self, &blockKeyClear_);
    if (block) {
        block(self, &allowClear);
    }
    return allowClear;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL allowReturn = YES;
    bsTextFieldReturnBlock block = objc_getAssociatedObject(self, &blockKeyReturn_);
    if (block) {
        block(self, &allowReturn);
    }
    return allowReturn;
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
- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace{ bsException(NSInternalInconsistencyException, @"Do not call this method!"); }

@end
