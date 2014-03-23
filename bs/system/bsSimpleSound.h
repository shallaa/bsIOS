@interface bsSimpleSound : NSObject

/**
 Loads a sound file and create a system sound for it.
 @param key The key for which to return the corresponding value. Note that when using key-value coding, the key must be a string.
 @param fullFileName Sound file path.
 @returns Returns YES if a system sound is created successfully, otherwise NO.
 @exception
 */
+ (BOOL)AWithKey:(NSString *)key fullFileName:(NSString *)fullFileName;

/**
 Disposes system sounds associated with given key.
 @param key key for dispose target. Use "*" to dispose all of system sounds managed by receiver of this method.
 @returns Returns YES if audio services disposed sounds, otherwise NO.
 @exception
 */
+ (BOOL)DWithKey:(NSString *)key;

/**
 Plays system sound for given key.
 @param key
 @returns Returns YES if audio services play the sound, otherwise NO.
 @exception
 */
+ (BOOL)PWithKey:(NSString *)key;

@end
