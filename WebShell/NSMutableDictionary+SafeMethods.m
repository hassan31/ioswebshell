/*
 * Copyright (C) 2013 Tek Counsel LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */


#import "NSMutableDictionary+SafeMethods.h"

@implementation NSMutableDictionary (SafeMethods)

//Returns NO if `anObject` is nil; can be used by the sender of the message or ignored if it is irrelevant.
- (BOOL)setObjectSafely:(id)anObject forKey:(id)aKey{
    
	if(anObject!=nil) {
		[self setObject:anObject forKey:aKey];
		return YES;
	}
	else {
		[self setObject:@"NULL" forKey:aKey];
		return NO;
	}
    
}

-(NSString*)getString:(id)aKey{
    NSObject *object = [self getObjectSafely:aKey];
    
    if(object==nil){
        object = @"";
    }
    
    return [object description];
}

- (NSMutableString*)getMutableString:(id)aKey{
    NSString *str = [self getString:aKey];
    NSMutableString *mutable = [[NSMutableString alloc] initWithString:str];
    return mutable;
}

//Returns NO if `anObject` is nil; can be used by the sender of the message or ignored if it is irrelevant.
- (NSObject*)getObjectSafely:(id)aKey{
    
    NSObject *object = [self objectForKey:aKey];
    
    if (object==nil || [object isKindOfClass:[NSNull class]]) {
        object= nil;
    }
    return object;
    
}


@end



@implementation NSDictionary (SafeMethods)

//Returns NO if `anObject` is nil; can be used by the sender of the message or ignored if it is irrelevant.
- (NSObject*)getObjectSafely:(id)aKey{
    
    NSObject *object = [self objectForKey:aKey];
    
    if (object==nil || [object isKindOfClass:[NSNull class]]) {
        object= @"";
    }
    return object;
    
}

-(NSString*)getString:(id)aKey{
    return [[self getObjectSafely:aKey] description];
}

- (NSMutableString*)getMutableString:(id)aKey{
    NSString *str = [self getString:aKey];
    NSMutableString *mutable = [[NSMutableString alloc] initWithString:str];
    return mutable;
}

@end
