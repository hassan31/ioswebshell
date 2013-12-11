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

@interface FileUtils : NSObject{

}

+(NSString*) documentPath;
+(NSString*) cachePath;
+(NSArray*) listCache;
+(NSArray*) listDocuments;
+(NSString*) saveToDocuments:(NSData*)data fileName:(NSString*) fileName;
+(NSString*) saveToCacheFolder:(NSData*)data fileName:(NSString*) fileName;
+(NSString*) saveStringToCacheFolder:(NSString*)data fileName:(NSString*) fileName;
+(NSInputStream*) retrieveStreamFromDocuments:(NSString *)fileName;
+(NSURL*) retrieveUrlFromDocuments:(NSString *)fileName;
+(NSURL*) retrieveUrlFromCache:(NSString *)fileName;
+(NSData*) retrieveFromCache:(NSString*) fileName;
+(NSData*) retrieveFromDocuments:(NSString*) fileName;
+(void) deleteCachedFile:(NSString*) fileName;
+(void)deleteDocument:(NSString *)fileName;


+(void) purgeCachedFiles;
+(void)purgeDocuments;
+(void) purgeTempDecryptedFiles;




@end
