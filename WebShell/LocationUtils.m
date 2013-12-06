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

#import "LocationUtils.h"


@implementation LocationUtils

+(double) distanceInKilometers:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2{
	double nRadius = 6371; // Earth's radius in Kilometers
    double latRadians = [self toRadians:lat1 point2:lat2];
    double lonRadians = [self toRadians:lon1 point2:lon2];
    double nA =	pow ( sin(latRadians/2), 2 ) + cos(lat1) * cos(lat2) * pow ( sin(lonRadians/2), 2 );
	double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
	double dist = nRadius * nC;
	return dist; // Return our calculated distance
}



+(double) distanceInMiles:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2{
	
	double kilos=[self distanceInKilometers:lat1 lon1:lon1 lat2:lat2 lon2:lon2];
	
	return [LocationUtils kilometersToMile:kilos];
}

+(double) toRadians:(double)point1 point2:(double)point2{
	double nVal = point1 - point2;
	return nVal * (M_PI/180);
}

+(double) milesToKilometers:(double) miles{
	double kilometers=miles * 1.614;
	return kilometers;
}

+(double) kilometersToMile:(double)kilometers{
	double miles = kilometers * 0.621;
	NSString *strValue= [LocationUtils uiRound:miles];
	double d= [strValue doubleValue];
	return d;
}

+(NSString*) uiKilometersToMile:(double)kilometers{
	double miles = kilometers * 0.621;
	NSString *strValue= [LocationUtils uiRound:miles];
	return strValue;
}

+(NSString*) uiKilometers:(double)kilometers{
	NSString *strValue= [LocationUtils uiRound:kilometers];
	return strValue;
}

+(double) convertToKilomtersPerHour:(int)milesPerHour{
	return 1.61 * milesPerHour;
}

+(double) convertToMilesPerHour:(double)kilometersPerHour{
	return kilometersPerHour * 0.621;
}

+(double) round:(double)value digits:(int)digits{
	
	NSNumber *objDbl = [[NSNumber alloc] initWithDouble:value];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMaximumIntegerDigits:5];
	[formatter setMaximumFractionDigits:3];
	[formatter setMinimumFractionDigits:0];
	NSString *returnNbr = [formatter stringFromNumber:objDbl];
	double d = [returnNbr doubleValue];
	return d;
}

+(NSString *) uiRound:(double)value{
	
	NSNumber *objDbl = [[NSNumber alloc] initWithDouble:value];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMaximumIntegerDigits:5];
	[formatter setMaximumFractionDigits:3];
	[formatter setMinimumFractionDigits:0];
	NSString *returnNbr = [formatter stringFromNumber:objDbl];
	return returnNbr;
	
}

+(double) distanceInMeters:(CLLocation*)prior current:(CLLocation*)current{
    CLLocationDistance meters = [prior distanceFromLocation:current];
    return meters;
}

+(MKCoordinateRegion) calcRegion:(CLLocationCoordinate2D)coordinate miles:(double)miles{
    double scalingFactor = ABS( (cos(2 * M_PI * coordinate.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = coordinate;
    
    return region;
}



@end
