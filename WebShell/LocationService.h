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
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface LocationService : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	BOOL accessDenied;
	NSDate *lastRun;
	NSString *direction;
    CLLocation *currentLocation;
    CLLocation *priorLocation;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic,retain) NSString *direction;
@property(nonatomic,retain) CLLocation *currentLocation;
@property(nonatomic,retain) CLLocation *priorLocation;

+(LocationService *) getInstance;
-(NSNumber *)getLat;
-(NSNumber *)getLon;
-(CLLocationCoordinate2D) getCoordinate;

-(BOOL) isReady;
-(BOOL) isAccessDenied;
-(void) monitorSignificantLocationChanges;
-(void) monitorMoreDetailedLocationChanges;
-(void)stop;
-(void)start;
-(NSString*) getDirection;//North South East West NW, NE, SW, SE

@end
