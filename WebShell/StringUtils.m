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

#import "StringUtils.h"

@implementation StringUtils

+(BOOL)isNumeric:(NSString *)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    return[scanner scanInteger:NULL] && [scanner isAtEnd];
}

//search for existence of substring in string;
+(BOOL) contains:(NSString *)_source searchFor:(NSString *)_target{
	BOOL b=TRUE;
	
	if(NSEqualRanges(NSMakeRange(NSNotFound, 0), [_source rangeOfString:_target])){
		b=FALSE;
	}
	
	return b;
}


//search for existence of substring in string;
-(BOOL) containsAny:(NSString *)_source searchFor:(NSString *)_target delimeter:(NSString *)delim{
	NSArray *split=nil;
	if([StringUtils contains: _target searchFor:delim]){
		split=[_target componentsSeparatedByString:delim];
	}
	
	for(int i=0;i<split.count;i++){
		NSString *filter = [split objectAtIndex:i];
		if([StringUtils contains:_source searchFor:filter]){
			return TRUE;
		}
		
	}
	return FALSE;
}

+(NSString *) trim:(NSString *) target{
	NSString *temp = [target stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	return temp;
}

+(NSString *) doubleToString:(double) dbl{
	NSString *str=[NSString stringWithFormat:@"%f", dbl];
	return str;
}

+(NSString*) formatCurrencyValue:(double)value{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setCurrencySymbol:@"$"];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSNumber *c = [NSNumber numberWithFloat:value];
	NSString *strCurrency = [numberFormatter stringFromNumber:c];
	return strCurrency;
}

+(NSString *)left:(NSString*)value position:(int)position {
	NSString *strValue= [value substringToIndex:position];
	return strValue;
}

+(NSString *)right:(NSString*)value position:(int)position {
	NSString *strValue= [value substringFromIndex:position];
	return strValue;
}

+(NSArray*)toArray:(NSString*)value delim:(NSString*)delim{
    return [value componentsSeparatedByString: delim];
}

+(NSMutableString*)replaceSubstring:(NSMutableString*)source replace:(NSString*)replace replaceWith:(NSString*)replaceWith{
    [source replaceOccurrencesOfString:replace  withString:replaceWith  options:NSLiteralSearch range:NSMakeRange(0, [source length])];
    return source;
}


+(BOOL) isEmpty:(NSString*)str{
    return str==nil || [str isEqualToString:@""] || [str isEqualToString:@"null"];
}

@end
