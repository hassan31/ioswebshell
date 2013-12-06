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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#import "NSString+Translate.h"
#import "UIHelper.h"
#import "UIParent.h"
#import "NSMutableDictionary+SafeMethods.h"
#import "JSONUtils.h"
#import "UIMapPoint.h"
#import "LocationUtils.h"


@interface UIRenderLocation : UIParent<MKMapViewDelegate,UIActionSheetDelegate> {
	MKMapView *mapView;
	NSMutableString *tmp;
	NSMutableArray *results;
	double spanLat;
	double spanLon;
	UIActionSheet *actions;
	UIBarButtonItem *btnLoadActions;
		

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;


-(void)loadLocationData;
-(void)onLocationData:(NSData *)jsonData;

-(void)showClosestLocation;
-(void)showAllLocations;
-(void)showTopRated;
-(void) loadActions;
-(void) sortByAttribute:(NSString *)attribute ascending:(BOOL)asc;
-(void)loadDirections;
@property (nonatomic, retain) NSMutableArray *results;
@end
