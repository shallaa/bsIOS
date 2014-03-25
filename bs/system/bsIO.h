#import <Foundation/Foundation.h>

@interface bsIO : NSObject

+ (void)onCreate;

#pragma mark - Asset

/**
 Returns the contents of specified file in the asset directory.
 @param name The name of file to load.
 @returns Returns data loaded from specified file.
 @exception Throws bsException if  given file name is nil.
 */
+ (NSData *)assetG:(NSString *)name;

#pragma mark - Storage

/**
 Returns the contents of specified file in the document directory.
 @param name The name of file to load.
 @returns Returns data loaded from specified file.
 @exception Throws bsException if given file name is nil.
 */
+ (NSData *)storageG:(NSString *)name;

/**
 Creates a file in the document directory with given data and file name.
 @param name The name of file to save.
 @returns Returns YES if the file is saved successfully, otherwise NO.
 @exception Throws bsException if given file name is nil.
 */
+ (BOOL)storageS:(NSString *)name data:(NSData *)data;

/**
 Removes specified file from the document directory.
 @param name The name of file to remove.
 @returns Returns YES if the file is removed successfully, otherwise NO.
 @exception Throws bsException if given file name is nil.
 */
+ (BOOL)storageD:(NSString *)name;

#pragma mark - Cache

/**
 Returns the contents of specified file in the cache directory.
 @param name The name of file to load.
 @returns Returns data loaded from specified file.
 @exception Throws bsException if given file name is nil.
 */
+ (NSData *)cacheG:(NSString *)name;

/**
 Creates a file in the cache directory with given data and file name.
 @param name Destination file name.
 @returns Returns YES if the file is saved successfully, otherwise NO.
 @exception Throws bsException if given file name is nil.
 */
+ (BOOL)cacheS:(NSString *)name data:(NSData *)data;

/**
 Removes specified file from the cache directory.
 @param name The name of file to remove.
 @returns Returns YES if the file is removed successfully, otherwise NO.
 @exception Throws bsException if given file name is nil.
 */
+ (BOOL)cacheD:(NSString *)name;

@end
