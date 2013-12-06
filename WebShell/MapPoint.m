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

#import "MapPoint.h"
#import "LocationUtils.h"
#import "LocationService.h"


@implementation MapPoint

@synthesize coordinate;

@synthesize url;

@synthesize title;

@synthesize distance;





//pass in an array of ProxAlertResults and create a map point for each
+(NSMutableArray *)createMapPointsByResults:(NSArray*)arr{
	NSMutableArray *points = [[NSMutableArray alloc] init];
	int cntr=0;
	//int i=0;
	for(int i=0;i<arr.count;i++){
		NSMutableDictionary *dict=[arr objectAtIndex:i];
		MapPoint *point=[self createMapPoint:dict];
		[points addObject:point];
		cntr++;
	}

	
	return points;
}


+(MapPoint *)createMapPoint:(NSMutableDictionary*)dict{
	MapPoint *point=[[MapPoint alloc] init];
	LocationService *locService=[LocationService getInstance];
	CLLocationCoordinate2D target;
	
    NSNumber *lat =(NSNumber*) [dict getObjectSafely:@"latitude"];
    
    NSNumber *lon =(NSNumber*) [dict getObjectSafely:@"longitude"];
	
	target.latitude=lat.floatValue;
    
	target.longitude=lon.floatValue;

    CLLocation *pointLoc= [[CLLocation alloc] initWithLatitude:target.latitude longitude:target.longitude];
    
    CLLocation *current = locService.currentLocation;
    
    double dist = [LocationUtils distanceInMeters:pointLoc current:current];
    
    point.distance=[NSNumber numberWithDouble:dist];
    
	point.coordinate=target;
    
	point.title=[dict getString:@"title"];
    
    point.url=[dict getString:@"url"];
    
    return point;
}


+(MapPoint *)createMapPointFromCurrentLocation{
	MapPoint *point=[[MapPoint alloc] init];
	CLLocationCoordinate2D target = [[LocationService getInstance] getCoordinate];
	NSString *locTitle=NSLocalizedString(@"currentLocation","Current Location");
	point.coordinate=target;
	point.title=locTitle;
	return point;
}





@end
