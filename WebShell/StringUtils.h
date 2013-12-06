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

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject{
    
}

+(BOOL) isNumeric:(NSString*)str;
+(BOOL) contains:(NSString *)_source searchFor:(NSString *)_target;
-(BOOL) containsAny:(NSString *)_source searchFor:(NSString *)_target delimeter:(NSString *)delim;
+(NSString *) trim:(NSString *) target;
+(NSString *) doubleToString:(double) dbl;
+(NSString*) formatCurrencyValue:(double)value;
+(NSString *)left:(NSString*)value position:(int)position;
+(NSString *)right:(NSString*)value position:(int)position;
+(NSArray*)toArray:(NSString*)value delim:(NSString*)delim;
+(NSMutableString*)replaceSubstring:(NSMutableString*)source replace:(NSString*)replace replaceWith:(NSString*)replaceWith;
+(BOOL) isEmpty:(NSString*)str;
@end
