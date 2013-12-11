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
 *
 * Code based on LocateMe sample from Apple (https://developer.apple.com/library/ios/samplecode/LocateMe/Introduction/Intro.html)
 */

#import "LocationService.h"
#import "Constants.h"


@implementation LocationService

@synthesize locationManager,direction,currentLocation,priorLocation;

static LocationService *currentService=nil;

+ (LocationService *)getInstance{
	@synchronized(self)
    {
		if (currentService == NULL){
			currentService = [[self alloc] init];
		}
    }
	return currentService;
}


-(id) init{
    self = [super init];
    if (self) {
        // Initialization code
        CLLocationManager *locMgr=[[CLLocationManager alloc] init];
        self.locationManager=locMgr;
        [locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        [locationManager setDistanceFilter:LOCATION_DISTANCE_FILTER];
    }

    return self;
}

-(void)start{
	//NSLog(@"startUpdatingLocation");
	[self.locationManager startUpdatingLocation];
}

-(void)stop{
	//NSLog(@"stopUpdatingLocation");
	[self.locationManager stopUpdatingLocation];
}

-(BOOL)isAccessDenied{
	return accessDenied;
}

-(void) monitorSignificantLocationChanges{
	[self.locationManager startMonitoringSignificantLocationChanges];
}


-(void) monitorMoreDetailedLocationChanges{
    self.locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}





//two delegate methods to be used by core location framework to aggregate data points.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    self.priorLocation=oldLocation;
    self.currentLocation=newLocation;
    
    //lets get the direction if we can.
    self.direction=[self getDirection];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:ON_LOCATION_CHANGE object:self userInfo:nil];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([error code]==kCLErrorDenied){
		accessDenied=TRUE;
	}else{
		accessDenied=FALSE;
	}
}

-(BOOL)isReady{
	CLLocation *location=locationManager.location;
	if(!location){
		return FALSE;
	}
	accessDenied=FALSE;
	return TRUE;
}


-(NSNumber *) getLat{
	CLLocation *location=locationManager.location;
	if(!location){
       // NSLog(@"Location still initializing...");
		return 0;
	}
	CLLocationCoordinate2D coordinate = [location coordinate];
	NSNumber *nbr=[NSNumber numberWithDouble:coordinate.latitude];
	return nbr;
}

-(NSNumber *) getLon{
	CLLocation *location=locationManager.location;
	if(!location){
		//NSLog(@"Location still initializing...");
		return 0;
	}
	// Create and configure a new instance of the Event entity
	
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	NSNumber *nbr=[NSNumber numberWithDouble:coordinate.longitude];
	return nbr;
}

-(CLLocationCoordinate2D) getCoordinate{
	CLLocation *location=locationManager.location;
	return location.coordinate;
}



- (void)startSignificantChangeUpdates{
	//NSLog(@"startSignificantChangeUpdates");
	[self.locationManager setDelegate:self];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

-(NSString*) getDirection{
    
    CLLocationDirection degrees = locationManager.location.course;
    NSArray *bearings = [[NSArray alloc] initWithObjects:@"NE", @"E", @"SE", @"S", @"SW", @"W", @"NW", @"N",nil];
    
    int index = degrees - 22.5;
    if (index < 0){
        index += 360;
    }
    
    NSNumber *nbr = [[NSNumber alloc] initWithDouble:index / 45];
    return(bearings[nbr.integerValue]);
    
}



-(void) dealloc{
	[locationManager stopUpdatingLocation];
}





@end
