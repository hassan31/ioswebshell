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
#import "NSData+Base64.h"
#import "JSONUtils.h"
#import "NSMutableDictionary+SafeMethods.h"

@interface HTTPUtils : NSObject {
	
	NSMutableDictionary *customHeaders;
	int statusCode;
    
    NSObject *callBackOwner;
    SEL callBack;

}


@property(nonatomic,retain) NSObject *callBackOwner;

@property(nonatomic,readwrite) SEL callBack;

@property(nonatomic,retain) NSMutableDictionary *customHeaders;

@property(nonatomic,readwrite) int statusCode;

-(int) lastStatusCode;

//-(void) executeMethod:(NSString*)httpMethod url:(NSString *)url params:(NSString*)params  data:(NSData*)data;

-(void) executeAction:(NSMutableDictionary*)action postdata:(NSMutableDictionary*)postdata;

-(void) doPost:(NSString *)url data:(NSData*)data;

-(void) doGet:(NSString *)url params:(NSString*)params;

-(void) doPut:(NSString *)url data:(NSData*)data;

-(void) doDelete:(NSString *)url params:(NSString*)params;

-(NSDictionary *) parseUrl:(NSURL*)url;

-(void)setRequestHeader:(NSMutableURLRequest *)request;

-(void) addCustomHeader:(NSString *)headerName headerValue:(NSString *)headerValue;

- (void)uploadFile:(NSData *)fileData filename:(NSString *)filename url:(NSString*)url;

-(void)onComplete :(NSData*)data;

-(NSData*) buildFailureResponse:(NSError*)err;



@end
