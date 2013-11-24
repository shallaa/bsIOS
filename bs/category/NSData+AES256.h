//
//  NSData+AES256.h
//  i-order-pos
//
//  Created by Jidolstar on 13. 1. 9..
//  Copyright (c) 2013년 TwoPeople. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end
