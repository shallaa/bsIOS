//
//  NSString+HMACSHA1.h
//  NewYearUnsae2011
//
//  Created by Yongho Ji on 10. 12. 13..
//  Copyright 2010 Wecon Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (HMACSHA1)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
- (NSString *) base64StringWithHMACSHA1Digest:(NSString *)secretKey;
@end
