#import "bsDisplay.h"
#import "bsStr.h"

@class bsText;

typedef void (^bsTextWillBeginEditBlock)(bsText* text, BOOL *allowEdit);
typedef void (^bsTextDidBeginEditBlock)(bsText* text);
typedef void (^bsTextWillEndEditBlock)(bsText* text, BOOL *allowStop);
typedef void (^bsTextDidEndEditBlock)(bsText* text);
typedef void (^bsTextChangeCharBlock)(bsText* text, NSRange changeCharRange, NSString* replaceString, BOOL *allowChange);
typedef void (^bsTextDidChangeBlock)(bsText* text);
typedef void (^bsTextDidChangeSelectionBlock)(bsText* text);

#define kbsTextText            101501
#define kbsTextTextColor       101502
#define kbsTextFontName        101503
#define kbsTextFontSize        101504
#define kbsTextPlaceholder     101505
#define kbsTextAlign           101506
#define kbsTextEditable        101507

#define kbsTextCapitalization  101520
#define kbsTextCorrection      101521
#define kbsTextKeyboardAppearance 101522
#define kbsTextKeyboardType      101523
#define kbsTextReturnKey       101524
#define kbsTextSecure          101525

#define kbsTextFocus           101530  //writeonly
#define kbsTextInputView       101540
#define kbsTextInputAccessoryView       101541

//clear 버튼이 나타날때
FOUNDATION_EXPORT NSString * const kbsTextClearButtonNever;
FOUNDATION_EXPORT NSString * const kbsTextClearButtonWhileEditing;
FOUNDATION_EXPORT NSString * const kbsTextClearButtonUnlessEditing;
FOUNDATION_EXPORT NSString * const kbsTextClearButtonAlways;

//대문자 처리
FOUNDATION_EXPORT NSString * const kbsTextCapitalizationNone;
FOUNDATION_EXPORT NSString * const kbsTextCapitalizationWord;
FOUNDATION_EXPORT NSString * const kbsTextCapitalizationSentence;
FOUNDATION_EXPORT NSString * const kbsTextCapitalizationAll;

//맞춤법 처리
FOUNDATION_EXPORT NSString * const kbsTextCorrectionDefault;
FOUNDATION_EXPORT NSString * const kbsTextCorrectionYes;
FOUNDATION_EXPORT NSString * const kbsTextCorrectionNo;

//키보드 모양
FOUNDATION_EXPORT NSString * const kbsTextKeyboardAppearanceDefault;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardAppearanceAlert;

//키보드 타입
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeDefault;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeAlphabet;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeAscii;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeNumberPunctuation;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeURL;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeNumber;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypePhone;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeNamePhone;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeEmail;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeDecimal;
FOUNDATION_EXPORT NSString * const kbsTextKeyboardTypeTwitter;

//키보드 리턴키
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyDefault;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyDone;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyGo;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyGoogle;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyJoin;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyNext;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyRoute;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeySearch;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeySend;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyYahoo;
FOUNDATION_EXPORT NSString * const kbsTextReturnKeyEmergency;

@interface bsText : bsDisplay <UITextViewDelegate> {
    
    UITextView *text_;
    NSString *fontName_;
    NSString *blockKeyWillBeginEdit_;
    NSString *blockKeyDidBeginEdit_;
    NSString *blockKeyWillEndEdit_;
    NSString *blockKeyDidEndEdit_;
    NSString *blockKeyChangeChar_;
    NSString *blockKeyDidChange_;
    NSString *blockKeyDidChangeSelection_;
}

- (void)blockEditWillBegin:(bsTextWillBeginEditBlock)block;
- (void)blockEditDidBegin:(bsTextDidBeginEditBlock)block;
- (void)blockEditWillEnd:(bsTextWillEndEditBlock)block;
- (void)blockEditDidEnd:(bsTextDidEndEditBlock)block;
- (void)blockChangeChar:(bsTextChangeCharBlock)block;
- (void)blockDidChange:(bsTextDidChangeBlock)block;
- (void)blockDidChangeSelection:(bsTextDidChangeSelectionBlock)block;

@end
