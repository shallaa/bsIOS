//
//  NSData+AES128.h
//  NewYearUnsae2011
//
//  Created by Yongho Ji on 10. 12. 13..
//  Copyright 2010 Wecon Communications. All rights reserved.
//
//  http://pastie.org/426530
//

#import <Foundation/Foundation.h>
@interface NSData (AES128)

- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKey:(NSString *)key;

@end
