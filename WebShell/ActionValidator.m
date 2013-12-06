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

#import "ActionValidator.h"

@implementation ActionValidator

@synthesize error;

static NSMutableArray* params;

-(NSMutableArray*)getParams{
    if (!params){
        params= [[NSMutableArray alloc] initWithObjects:@"action",@"url",@"label",@"callback",@"httpMethod",@"imageUrl", nil];
    }
    
    return params;
}



static NSMutableArray* validActions;

-(NSMutableArray*)getValidActions{
    if (!validActions){
        validActions= [[NSMutableArray alloc] initWithObjects:@"scanBarcode",@"recordAudio",@"recordSignature",@"recordPhoto",@"recordVideo",@"recordLocation",@"cancelActions", nil];
    }
    
    return validActions;
}


static NSMutableArray* httpMethods;

-(NSMutableArray*)getHttpMethods{
    if (!httpMethods){
        httpMethods= [[NSMutableArray alloc] initWithObjects:@"GET",@"PUT",@"POST",@"DELETE",@"UPLOAD", nil];
    }
    
    return httpMethods;
}


-(BOOL) isValid:(NSDictionary *)action{
    BOOL b = YES;
    
    NSMutableString *err =[[NSMutableString alloc] initWithString:@""];
    
    
    
    for (id param in [self getParams]){
        
        NSString *value =[action getString:param];
        
        if([param isEqualToString:@"url"]){
            b = [self isValidUrl:[action getString:param]];
            if (!b) {
                [err appendString:@", invalid action url"];
                [err appendString:@"\n"];
                [err appendString:value];
                [err appendString:@"\n"];
            }
        }
        
        if([param isEqualToString:@"imageUrl"] && ![value isEqualToString:@""]){
            b = [self isValidUrl:[action getString:param]];
            if (!b) {
                [err appendString:[action getString:@"action"]];
                [err appendString:@", invalid image url"];
                [err appendString:@"\n"];
            }
        }

        
        if([param isEqualToString:@"action"]){
            if (![[self getValidActions] containsString:value]) {
                b=NO;
                [err appendString:[action getString:@"action"]];
                [err appendString:@", unsupported / invalid action "];
                [err appendString:value];
                [err appendString:@"\n"];
            }
            
        }
        
        if([param isEqualToString:@"httpMethod"]){
            if (![[self getHttpMethods] containsString:value]) {
                b=NO;
                [err appendString:[action getString:@"action"]];
                [err appendString:@", invalid httpMethod "];
                [err appendString:value];
                [err appendString:@". Only GET,POST,PUT,DELETE are supported.\n"];
            }
        }
        
        if([param isEqualToString:@"label"]){
            if ([value isEqualToString:@""]) {
                b=NO;
                [err appendString:[action getString:@"action"]];
                [err appendString:@", action label is required"];
                [err appendString:@"\n"];
            }
        }
        
    }
    
    if (b==FALSE) {
        self.error=err;
    }
    
    return b;
}

- (BOOL)isValidUrl:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [NSURLConnection canHandleRequest:request];
}




@end
