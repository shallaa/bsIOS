//
//  NSString+HMACSHA1.m
//  NewYearUnsae2011
//
//  Created by Yongho Ji on 10. 12. 13..
//  Copyright 2010 Wecon Communications. All rights reserved.
//

#import "NSString+HMACSHA1.h"


static char base64EncodingTable[64] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


@implementation NSString (HMACSHA1)

- (NSString *) base64StringWithHMACSHA1Digest:(NSString *)secretKey {
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];
	char *keyCharPtr = strdup([secretKey UTF8String]);
	char *dataCharPtr = strdup([self UTF8String]);
	
	CCHmacContext hctx;
	CCHmacInit(&hctx, kCCHmacAlgSHA1, keyCharPtr, strlen(keyCharPtr));
	CCHmacUpdate(&hctx, dataCharPtr, strlen(dataCharPtr));
	CCHmacFinal(&hctx, digest);
	NSData *encryptedStringData = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	
	free(keyCharPtr);
	free(dataCharPtr);
	
	return [NSString base64StringFromData:encryptedStringData length:[encryptedStringData length]];
}

+ (NSString *) base64StringFromData: (NSData *)data length: (int)length {
	unsigned long ixtext, lentext;
	long ctremaining;
	unsigned char input[3], output[4];
	short i, charsonline = 0, ctcopy;
	const unsigned char *raw;
	NSMutableString *result;
	
	lentext = [data length]; 
	if (lentext < 1)
		return @"";
	result = [NSMutableString stringWithCapacity: lentext];
	raw = [data bytes];
	ixtext = 0; 
	
	while (true) {
		ctremaining = lentext - ixtext;
		if (ctremaining <= 0) 
			break;        
		for (i = 0; i < 3; i++) { 
			unsigned long ix = ixtext + i;
			if (ix < lentext)
				input[i] = raw[ix];
			else
				input[i] = 0;
		}
		output[0] = (input[0] & 0xFC) >> 2;
		output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
		output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
		output[3] = input[2] & 0x3F;
		ctcopy = 4;
		
		switch (ctremaining) {
			case 1: 
				ctcopy = 2; 
				break;
			case 2: 
				ctcopy = 3; 
				break;
		}
		
		for (i = 0; i < ctcopy; i++)
			[result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
		
		for (i = ctcopy; i < 4; i++)
			[result appendString: @"="];
		
		ixtext += 3;
		charsonline += 4;
		
		if ((length > 0) && (charsonline >= length))
			charsonline = 0;
		
	}
	return result;
}	
@end
