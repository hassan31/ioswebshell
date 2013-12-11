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

#import "HTTPUtils.h"

@implementation HTTPUtils

@synthesize customHeaders,statusCode,callBack,callBackOwner;

-(void) addCustomHeader:(NSString *)headerName headerValue:(NSString *)headerValue{	

	[self.customHeaders setValue:headerValue forKey:headerName];
	
}
-(int) lastStatusCode{
	return self.statusCode;
}

-(void) executeAction:(NSMutableDictionary*)action postdata:(NSMutableDictionary*)postdata{
    
    NSString *httpMethod = [action getString:@"httpMethod"];
    NSString *url = [action getString:@"url"];
    NSData *data = [JSONUtils convertDictionaryToJSON:postdata];

    
    if([httpMethod isEqualToString:@"POST"]){
        [self doPost:url data:data];
        
        
    }else if([httpMethod isEqualToString:@"PUT"]){
        [self doPut:url data:data];
        
        
    }else if([httpMethod isEqualToString:@"DELETE"]){
        NSMutableString *params = [[NSMutableString alloc] initWithString:@"json="];
        [params appendString:[JSONUtils urlEncodeJson:data]];
        [self doDelete:url params:params];
        
        
    }else if([httpMethod isEqualToString:@"GET"]){
        NSMutableString *params = [[NSMutableString alloc] initWithString:@"json="];
        [params appendString:[JSONUtils urlEncodeJson:data]];
        [self doGet:url params:params];
        
        
    }
    
    /*
     don't think i use upload this way, need to check
     
    else if([httpMethod isEqualToString:@"UPLOAD"]){
        [self uploadFile:data filename:params url:url];
        
    }
     */
}

-(void) executeMethod:(NSString*)httpMethod url:(NSString *)url params:(NSString*)params  data:(NSData*)data{
    if([httpMethod isEqualToString:@"POST"]){
        [self doPost:url data:data];
        
        
    }else if([httpMethod isEqualToString:@"PUT"]){
        [self doPut:url data:data];
        
        
    }else if([httpMethod isEqualToString:@"DELETE"]){
        [self doDelete:url params:params];
        
        
    }else if([httpMethod isEqualToString:@"GET"]){
        [self doGet:url params:params];
        
        
    }else if([httpMethod isEqualToString:@"UPLOAD"]){
        [self uploadFile:params url:url];
        
    }
    
}


-(void) doPost:(NSString *)url data:(NSData*)data{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[self setRequestHeader:request];//setup the custom headers.
	
	[request setURL:[NSURL URLWithString:url]];
	
	[request setHTTPMethod:@"POST"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:data];
	
	[request setTimeoutInterval:20.0];
    
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"webshell.queue"];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:[self buildFailureResponse:error]];
            });
            return;
        }
        
        // Decode the data
        NSError *myErr;

        // If there was an error decoding the JSON
        if (myErr) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:data];
            });
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSHTTPURLResponse *res= (NSHTTPURLResponse*) response;
            self.statusCode=res.statusCode;
            [self onComplete:data];
        });
    }];
}

-(void) doDelete:(NSString *)url params:(NSString*)params{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[self setRequestHeader:request];//setup the custom headers.
	
	[request setURL:[NSURL URLWithString:url]];
	
	[request setHTTPMethod:@"DELETE"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

	[request setTimeoutInterval:20.0];
    
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"webshell.queue"];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:[self buildFailureResponse:error]];
            });
            return;
        }
        
        // Decode the data
        NSError *myErr;

        // If there was an error decoding the JSON
        if (myErr) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:data];
            });
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSHTTPURLResponse *res= (NSHTTPURLResponse*) response;
            self.statusCode=res.statusCode;
            [self onComplete:data];
        });
    }];
	
}

-(void) doPut:(NSString *)url data:(NSData*)data{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"putting json %@", jsonString);
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[self setRequestHeader:request];//setup the custom headers.
	
	[request setURL:[NSURL URLWithString:url]];
	
	[request setHTTPMethod:@"PUT"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:data];
	
	[request setTimeoutInterval:20.0];
    
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"webshell.queue"];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:[self buildFailureResponse:error]];
            });
            return;
        }
        
        // Decode the data
        NSError *myErr;
        //NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        //NSString *responseDataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        // If there was an error decoding the JSON
        if (myErr) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:data];
            });
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSHTTPURLResponse *res= (NSHTTPURLResponse*) response;
            self.statusCode=res.statusCode;
            [self onComplete:data];
        });
    }];
	
}



-(void) doGet:(NSString *)url params:(NSString*)params{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSMutableString *paramUrl=[[NSMutableString alloc] initWithString:url];
	
	if(params!=nil){
		[paramUrl appendString:@"?"];
		[paramUrl appendString:params];
	}
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[self setRequestHeader:request];//setup custom headers.
    
   // NSLog(@"paramUrl is %@", paramUrl);
	
	[request setURL:[NSURL URLWithString:paramUrl]];
	
	[request setHTTPMethod:@"GET"];
	
	[request setTimeoutInterval:20.0];
    
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    
	
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"webshell.queue"];
    
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        
        // If there was an error getting the data
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:[self buildFailureResponse:error]];
            });
            return;
        }
        
        // Decode the data
        NSError *myErr;

        
        // If there was an error decoding the JSON
        if (myErr) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self onComplete:data];
            });
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSHTTPURLResponse *res= (NSHTTPURLResponse*) response;
            self.statusCode=res.statusCode;
            [self onComplete:data];
        });
    }];
	
	
}



+ (NSString *)urlEncodeValue:(NSString *)str{
	NSString *result = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	return result;
}

-(void)setAuthorizationHeader:(NSMutableURLRequest*)request{
    
    /*
    //get handle on user preferences/password.
    NSString *deviceId = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [[prefs stringForKey:@"userId"] AES128DecryptWithKey:deviceId];
    NSString *password= [[prefs stringForKey:@"password"] AES128DecryptWithKey:deviceId];
    
    //NSLog(@"userId & password are %@ and %@ hmmm",username,password);
    
    //set the authorization/authentication header...
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
     */
}

-(void)setRequestHeader:(NSMutableURLRequest *)request{
	
	UIDevice *device = [UIDevice currentDevice];
	
	NSString *osName = [device systemName];
	
	NSString *osVersion=[device systemVersion];

	NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    
    //NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    //NSLog(@"language is %@", language);
	
	if (self.customHeaders==nil) {
		//NSLog(@"Custom Headers nil");
	}
	
	if (self.customHeaders!=nil) {
		for( NSString *aKey in self.customHeaders ){
			NSString *value = [self.customHeaders valueForKey:aKey];
			[request addValue:value forHTTPHeaderField:aKey];
		}
	}
    
    //set the authorization header
    [self setAuthorizationHeader:request];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *version    = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];

	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	
	//[request addValue:language forHTTPHeaderField:@"Accept-Language"]; //set the language
	
	[request addValue:countryCode forHTTPHeaderField:@"country-code"];//set the custom country header
	
	[request addValue:@"iOS" forHTTPHeaderField:@"device-type"];//device type for the mgt system.
	
	[request addValue:osVersion forHTTPHeaderField:@"operating-system-version"]; //os-version for the mgt system.
	
	[request addValue:osName forHTTPHeaderField:@"operating-system-name"]; //os name for the mgt system.
    
    [request addValue:bundleName forHTTPHeaderField:@"bundle-name"];
    
    [request addValue:version forHTTPHeaderField:@"bundle-version"];
    
}


-(NSDictionary *) parseUrl:(NSURL*)url{
	NSString * q = [url query];
	NSArray * pairs = [q componentsSeparatedByString:@"&"];
	NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
	for (NSString * pair in pairs) {
		NSArray * bits = [pair componentsSeparatedByString:@"="];
		NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		[kvPairs setObject:value forKey:key];
	}
	
	return kvPairs;
	
}



- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}


- (void)uploadFile:(NSString *)filename url:(NSString*)url{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    HTTPUploader *uploader = [[HTTPUploader alloc] init];
    uploader.httputils=self;
    [uploader startSend:filename url:url];
}


-(NSData*) buildFailureResponse:(NSError*)err{
    
    NSString *key = [NSString stringWithFormat:@"%i",err.code];
    NSString *promptMessage=NSLocalizedString(key,@"");
    
    //build the json string for the failure.
    NSMutableString *fail = [[NSMutableString alloc] initWithString:@"{"];
    
    [fail appendString:@"\"promptTitle\":"];
    [fail appendString:@"\"EXCEPTION\",\n"];
    
    [fail appendString:@"\"promptMessage\":"];
    [fail appendString:@"\""];
    
    if (promptMessage==nil || [promptMessage isEqualToString:@""]) {
        promptMessage=[err localizedDescription];
    }
    
    [fail appendString:promptMessage];
    [fail appendString:@"\",\n"];
    
    [fail appendString:@"\"errorCode\":"];
    [fail appendString:@"\""];
    
    [fail appendString:[NSString stringWithFormat:@"%i",[err code]]];
    [fail appendString:@"\"\n"];
    
    [fail appendString:@"}"];

    return [fail dataUsingEncoding:NSUTF8StringEncoding];
}



-(void)onComplete:(NSData *)data{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [callBackOwner performSelector:callBack withObject:data];
}





@end
