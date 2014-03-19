#import <Foundation/Foundation.h>

typedef void (^bsBlock)( NSString *blockKey );
typedef void (^bsUserDefaultChangeBlock)( NSString *blockKey, NSUserDefaults *defaults );
typedef void (^bsOrientationChangeBlock)( NSString *blockKey, UIDeviceOrientation orientation );
typedef void (^bsBackgroundTaskBlock)( NSString *blockKey, UIBackgroundTaskIdentifier *backgroundTaskId );
typedef void (^bsLocaleChangeBlock)( NSString *blockKey, NSLocale *currentLocale );
typedef void (^bsBatteryBlock)( NSString *blockKey, NSString *batteryState, float batteryLevel );
typedef void (^bsKeyboradBlock)( NSString *blockKey );

@interface bsNotification : NSObject

+ (void)onCreate;
+ (void)blockRemove:(NSString *)key;

+ (NSString *)blockWillUnactive:(bsBlock)block;
+ (NSString *)blockDidUnactive:(bsBlock)block;
+ (NSString *)blockWillActive:(bsBlock)block;
+ (NSString *)blockDidActive:(bsBlock)block;
+ (NSString *)blockDidMemoryWarning:(bsBlock)block;
+ (NSString *)blockWillTerminate:(bsBlock)block;
+ (NSString *)blockIdleTimeout:(bsBlock)block;
+ (NSString *)blockBackgroundTask:(bsBackgroundTaskBlock)block;
+ (NSString *)blockBattery:(bsBatteryBlock)block;
+ (NSString *)blockLocaleChange:(bsLocaleChangeBlock)block;
+ (NSString *)blockOrientationChange:(bsOrientationChangeBlock)block;
+ (NSString *)blockUserDefaultChange:(bsUserDefaultChangeBlock)block;
+ (NSString *)blockKeyboardWillShow:(bsKeyboradBlock)block;
+ (NSString *)blockKeyboardDidShow:(bsKeyboradBlock)block;
+ (NSString *)blockKeyboardWillHide:(bsKeyboradBlock)block;
+ (NSString *)blockKeyboardDidHide:(bsKeyboradBlock)block;

@end
