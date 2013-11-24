//
//  NSDictionary+MutableDeepCopy.m
//
//  Created by Yongho Ji on 11. 2. 28..
//  Copyright 2011 Wecon Communications. All rights reserved.
//

#import "NSDictionary+MutableDeepCopy.h"


@implementation  NSDictionary (MutableDeepCopy)

-(NSMutableDictionary*)mutableDeepCopy
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
	NSArray *keys = [self allKeys];
	for(id key in keys) 
	{
		id oneValue = [self valueForKey:key];
		id oneCopy = nil;
		if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) 
		{
			oneCopy = [oneValue mutableDeepCopy];
		}
		else if([oneValue respondsToSelector:@selector(mutableCopy)]) 
		{
			oneCopy = [oneValue mutableCopy];
		}
		if (oneCopy == nil) 
		{
			oneCopy = [oneValue copy];
		}
		[ret setValue:oneCopy forKey:key];
	}
	return ret;
}

@end
