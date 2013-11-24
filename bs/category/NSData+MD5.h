//
//  NSData+MD5.h
//  ReadBook
//
//  Created by Yongho Ji on 11. 3. 8..
//  Copyright 2011 Wecon Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> 

@interface NSData (MD5)

- (NSString*)md5;

@end
