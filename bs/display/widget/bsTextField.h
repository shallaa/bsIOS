#import "bsDisplay.h"

@class bsTextField;

typedef void (^bsTextFieldWillBeginEditBlock)(bsTextField *textField, BOOL *allowEdit);
typedef void (^bsTextFieldDidBeginEditBlock)(bsTextField *textField);
typedef void (^bsTextFieldWillEndEditBlock)(bsTextField *textField, BOOL *allowStop);
typedef void (^bsTextFieldDidEndEditBlock)(bsTextField *textField);
typedef void (^bsTextFieldChangeCharBlock)(bsTextField *textField, NSRange changeCharRange, NSString *replaceString, BOOL *allowChange);
typedef void (^bsTextFieldChangeCharWithFullStringBlock)(bsTextField *textField, NSRange changeCharRange, NSString *replaceString, NSString *fullString, BOOL *allowChange);
typedef void (^bsTextFieldChangePhoneBlock)(bsTextField *textField, NSString *phoneNumber);
typedef void (^bsTextFieldClearBlock)(bsTextField *textField, BOOL *allowClear);
typedef void (^bsTextFieldReturnBlock)(bsTextField *textField, BOOL *allowReturn);

#define kbsTextFieldText            100501
#define kbsTextFieldTextColor       100502
#define kbsTextFieldFontName        100503
#define kbsTextFieldFontSize        100504
#define kbsTextFieldPlaceholder     100505
#define kbsTextFieldAlign           100506
#define kbsTextFieldVAlign          100507
#define kbsTextFieldBorderStyle     100508
#define kbsTextFieldEnabled        100509

#define kbsTextFieldClearButton     100510
#define kbsTextFieldClearBeginEdit  100511

#define kbsTextFieldCapitalization  100520
#define kbsTextFieldCorrection      100521
#define kbsTextFieldKeyboardAppearance 100522
#define kbsTextFieldKeyboardType      100523
#define kbsTextFieldReturnKey       100524
#define kbsTextFieldSecure          100525

#define kbsTextFieldFocus           100530  //writeonly
#define kbsTextFieldInputView       100540
#define kbsTextFieldInputAccessoryView       100541

//경계선 스타일
FOUNDATION_EXPORT NSString * const kbsTextBorderStyleNone;
FOUNDATION_EXPORT NSString * const kbsTextBorderStyleLine;
FOUNDATION_EXPORT NSString * const kbsTextBorderStyleBezel;
FOUNDATION_EXPORT NSString * const kbsTextBorderStyleRoundedRect;

//clear 버튼이 나타날때
FOUNDATION_EXPORT NSString * const kbsTextFieldClearButtonNever;
FOUNDATION_EXPORT NSString * const kbsTextFieldClearButtonWhileEditing;
FOUNDATION_EXPORT NSString * const kbsTextFieldClearButtonUnlessEditing;
FOUNDATION_EXPORT NSString * const kbsTextFieldClearButtonAlways;

//대문자 처리
FOUNDATION_EXPORT NSString * const kbsTextFieldCapitalizationNone;
FOUNDATION_EXPORT NSString * const kbsTextFieldCapitalizationWord;
FOUNDATION_EXPORT NSString * const kbsTextFieldCapitalizationSentence;
FOUNDATION_EXPORT NSString * const kbsTextFieldCapitalizationAll;

//맞춤법 처리
FOUNDATION_EXPORT NSString * const kbsTextFieldCorrectionDefault;
FOUNDATION_EXPORT NSString * const kbsTextFieldCorrectionYes;
FOUNDATION_EXPORT NSString * const kbsTextFieldCorrectionNo;

//키보드 모양
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardAppearanceDefault;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardAppearanceAlert;

//키보드 타입
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeDefault;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeAlphabet;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeAscii;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeNumberPunctuation;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeURL;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeNumber;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypePhone;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeNamePhone;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeEmail;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeDecimal;
FOUNDATION_EXPORT NSString * const kbsTextFieldKeyboardTypeTwitter;

//키보드 리턴키
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyDefault;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyDone;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyGo;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyGoogle;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyJoin;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyNext;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyRoute;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeySearch;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeySend;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyYahoo;
FOUNDATION_EXPORT NSString * const kbsTextFieldReturnKeyEmergency;

@interface bsTextField : bsDisplay <UITextFieldDelegate> {
    
    UITextField *textField_;
    NSString *fontName_;
    NSString *blockKeyWillBeginEdit_;
    NSString *blockKeyDidBeginEdit_;
    NSString *blockKeyWillEndEdit_;
    NSString *blockKeyDidEndEdit_;
    NSString *blockKeyChangeChar_;
    NSString *blockKeyChangeCharWithFullString_;
    NSString *blockKeyChangePhone_;
    NSString *blockKeyClear_;
    NSString *blockKeyReturn_;
}

- (void)blockEditWillBegin:(bsTextFieldWillBeginEditBlock)block;
- (void)blockEditDidBegin:(bsTextFieldDidBeginEditBlock)block;
- (void)blockEditWillEnd:(bsTextFieldWillEndEditBlock)block;
- (void)blockEditDidEnd:(bsTextFieldDidEndEditBlock)block;
- (void)blockChangeChar:(bsTextFieldChangeCharBlock)block;
- (void)blockChangeCharWithFullString:(bsTextFieldChangeCharWithFullStringBlock)block;
- (void)blockChangeCharPhone:(bsTextFieldChangePhoneBlock)block;
- (void)blockClear:(bsTextFieldClearBlock)block;
- (void)blockReturn:(bsTextFieldReturnBlock)block;

@end
