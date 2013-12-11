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
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface LocationUtils : NSObject {

}


+(double) distanceInMeters:(CLLocation*)prior current:(CLLocation*)current;

+(double) distanceInKilometers:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2;

+(double) distanceInMiles:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2;

+(double) toRadians:(double)point1 point2:(double)point2;

+(double) kilometersToMile:(double)kilometers;

+(double) milesToKilometers:(double) miles;

+(double) round:(double)value digits:(int)digits;

+(NSString*) uiKilometersToMile:(double)kilometers;

+(NSString*) uiKilometers:(double)kilometers;

+(NSString *) uiRound:(double)value;

+(MKCoordinateRegion) calcRegion:(CLLocationCoordinate2D)coordinate miles:(double)miles;



@end
