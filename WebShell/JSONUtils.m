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

#import "JSONUtils.h"

@implementation JSONUtils

+(NSObject*) convertJSONToObject:(NSData*) data{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithCapacity:1];
    NSObject *object = nil;
    
    NSError *jsonError;
    
    if(data!=nil && [data length] > 0){
        
        object= [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        
        // If there was an error decoding the JSON
        if (jsonError) {
            [dict setValue:[jsonError description] forKey:@"ERROR"];
            object = dict;
        }
    }else{
        [dict setValue:@"No data in response." forKey:@"ERROR"];
        object = dict;
    }
    
    return object;
}


+(NSMutableArray*) convertJSONToArray:(NSData*) data{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:1];
    NSError *jsonError;
    
    if(data!=nil){
        
        [arr addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]];
        
        // If there was an error decoding the JSON
        if (jsonError) {
            //add the error here for the responseDictionary...
            NSMutableDictionary *error = [[NSMutableDictionary alloc] initWithCapacity:1];
            [error setValue:[jsonError description] forKey:@"ERROR"];
            [arr addObject:error];
        }
    }else{
        //add the error here for the responseDictionary...
        NSMutableDictionary *error = [[NSMutableDictionary alloc] initWithCapacity:1];
        [error setValue:@"No data in response." forKey:@"ERROR"];
        [arr addObject:error];
    }
    
    return arr;
}

+(NSMutableDictionary*) convertJSONToDictionary:(NSData*) data{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithCapacity:1];
    
    NSError *jsonError;
    
    if(data!=nil && [data length] > 0){
        
        dict= [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        
        // If there was an error decoding the JSON
        if (jsonError) {
            [dict setValue:[jsonError description] forKey:@"ERROR"];
        }
    }else{
        [dict setValue:@"No data in response." forKey:@"ERROR"];
    }
    
    return dict;
}


+(NSData*) convertDictionaryToJSON:(NSMutableDictionary*) dict{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}


+(NSData*) convertArrayToJSON:(NSMutableArray*) arr{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}


+(BOOL)isSetup{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"userId"];
    NSString *password = [prefs stringForKey:@"password"];
    NSString *email = [prefs stringForKey:@"email"];
    NSString *setup = [prefs stringForKey:@"setup"];
    
    //NSLog(@"%@,%@,%@,%@", username,password,email,setup);
    
    if(username==nil || password==nil || email==nil || setup==nil || [setup isEqualToString:@"false"]){
        return FALSE;
    }else{
        return TRUE;
    }
    
    
}

+(BOOL)isPopulated{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"userId"];
    NSString *password = [prefs stringForKey:@"password"];
    NSString *email = [prefs stringForKey:@"email"];
    
    if(username==nil || password==nil || email==nil){
        return FALSE;
    }else{
        return TRUE;
    }
}



+(NSString*)urlEncodeJson:(NSData *)jsondata{
    NSString *rawjson = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSString *encodedjson = [rawjson stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    return encodedjson;
}







@end
