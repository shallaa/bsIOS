@interface bsParam : NSObject

/**
 Returns the string that represents parameters for given key.
 @param key
 @returns Parameters in one string.
 @exception Throws bsException if key is nil.
*/
+ (NSString *)G:(NSString *)key;

/**
 Set parameters for key.
 @param key key
 @param params parameters
 @returns Set parameters for key.
 @exception Throws bsException if key and/or parameters is nil;
*/
+ (void)A:(NSString *)key params:(NSString *)params;

@end
