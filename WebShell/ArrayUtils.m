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


#import "ArrayUtils.h"

@implementation ArrayUtils


+(void) sortByAttribute:(NSMutableArray *)arr :(NSString *) attribute ascending:(BOOL)asc{
	NSSortDescriptor *myDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:asc];
	NSArray *sortDescriptors = [NSArray arrayWithObject:myDescriptor];
	NSArray *sortedArray = [arr sortedArrayUsingDescriptors:sortDescriptors];
    
	[arr removeAllObjects];
	[arr addObjectsFromArray:sortedArray];
}


+(void) sort:(NSMutableArray *)arr{
    NSArray * sortedArray = [arr sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	[arr removeAllObjects];
	[arr addObjectsFromArray:sortedArray];
}


+(NSMutableString*) implode:(NSMutableArray*)arr delim:(NSString *)delim{
    NSString *str = [arr componentsJoinedByString:delim];
    return [[NSMutableString alloc] initWithString:str];
    
}

@end
