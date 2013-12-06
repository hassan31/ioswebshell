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

#import "FileUtils.h"

@implementation FileUtils

+(NSString*) documentPath{
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docsDirectory;
}

+(NSString*) cachePath{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cacheDir;
}

+(NSArray*) listDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *filePathsArray = [fileManager subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:filePathsArray.count];
    for(NSString *filename in filePathsArray){
        NSURL *fileurl = [self retrieveUrlFromDocuments:filename];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:[fileurl path] error:nil];
        NSMutableDictionary *atts = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [atts setObject:filename forKey:@"filename"];
        [atts setObject:fileurl forKey:@"fileurl"];
        [arr addObject:atts];
    }
    
    return arr;
}


+(NSArray*) listCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *filePathsArray = [fileManager subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:filePathsArray.count];
    for(NSString *path in filePathsArray){
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
        NSMutableDictionary *atts = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [atts setObject:path forKey:@"filePath"];
        [arr addObject:atts];
    }
    
    return arr;
}

+(NSString*) saveToDocuments:(NSData*)data fileName:(NSString*) fileName{
    NSString *path = [self documentPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

+(NSString*) saveStringToCacheFolder:(NSString*)data fileName:(NSString*) fileName{
    NSString *path = [self cachePath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSError *error;
    [data writeToFile:data atomically:TRUE encoding:NSASCIIStringEncoding error:&error];
    
    return filePath;
    
}

+(NSString*) saveToCacheFolder:(NSData*)data fileName:(NSString*) fileName{
    NSString *path = [self cachePath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSError *error;
    [data writeToFile:filePath options:NSDataWritingFileProtectionComplete error:&error];
    // [data writeToFile:filePath atomically:YES];
    return filePath;
}




+(NSData*) retrieveFromDocuments:(NSString *)fileName{
    NSString *path = [self documentPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSData *fileData=[NSData dataWithContentsOfURL:[fileUrl filePathURL]];
    return fileData;
}

+(NSURL*) retrieveUrlFromDocuments:(NSString *)fileName{
    NSString *path = [self documentPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    return fileUrl;
}


+(NSData*) retrieveFromCache:(NSString *)fileName{
    NSString *path = [self cachePath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSData *fileData=[NSData dataWithContentsOfURL:[fileUrl filePathURL]];
    return fileData;
}


+(NSURL*) retrieveUrlFromCache:(NSString *)fileName{
    NSString *path = [self cachePath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    return fileUrl;
}

+(void)deleteCachedFile:(NSString *)fileName{
    NSString *path = [FileUtils cachePath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath]; // Returns a BOOL    
    
    // Remove the file
    if(fileExists){
        //NSLog(@"cleaning up file %@ ...", filePath);
        [fileManager removeItemAtPath:filePath error:NULL];
    }else{
        fileExists = [fileManager fileExistsAtPath:fileName];
        if(fileExists){
            //NSLog(@"cleaning up file %@ ...", filePath);
            [fileManager removeItemAtPath:fileName error:NULL]; 
        }
    }
}


+(void)deleteDocument:(NSString *)fileName{
    NSString *path = [FileUtils documentPath];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath]; // Returns a BOOL
    
    // Remove the file
    if(fileExists){
        //NSLog(@"cleaning up file %@ ...", filePath);
        [fileManager removeItemAtPath:filePath error:NULL];
    }else{
        fileExists = [fileManager fileExistsAtPath:fileName];
        if(fileExists){
            //NSLog(@"cleaning up file %@ ...", filePath);
            [fileManager removeItemAtPath:fileName error:NULL];
        }
    }
}


+(void) purgeCachedFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [fileManager subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSError *error = nil;
    
    
    for(NSString *myFile in filePathsArray){

            NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:myFile];
            
            //NSLog(@"clean up file %@", finalPath);
            
            [fileManager removeItemAtPath:finalPath error:&error];
            
            if (error!=nil) {
                NSLog(@"Error is %@", [error localizedDescription]);
            } 
          
    }
}


+(void) purgeDocuments{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [fileManager subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSError *error = nil;
    
    
    for(NSString *myFile in filePathsArray){
        

            NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:myFile];
            
            //NSLog(@"clean up file %@", finalPath);
            
            [fileManager removeItemAtPath:finalPath error:&error];
            
            if (error!=nil) {
                NSLog(@"Error is %@", [error localizedDescription]);
            } 
        
    }
}

+(void) purgeTempDecryptedFiles{
    
    //NSLog(@"purgeTempDecryptedFiles");
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [fileManager subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSError *error = nil;
    
    
    for(NSString *myFile in filePathsArray){
        
        if ([myFile hasSuffix:@".db"] || [myFile hasSuffix:@".opengl"] || [myFile hasSuffix:@".data"] || [myFile hasSuffix:@".maps"]) {
            //NSLog(@"system file will not be deleted.");
        }else{
            
            //if any file has an extension we assume its been decrypted and should be deleted.
            NSRange range = [myFile rangeOfString:@"."];
            if (range.location!=NSNotFound) {
                NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:myFile];
                [fileManager removeItemAtPath:finalPath error:&error];
                
                if (error!=nil) {
                    //NSLog(@"Error is %@", [error localizedDescription]);
                }
            }
        }
        
    }
}

@end
