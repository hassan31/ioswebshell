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

#import "UIRenderLocation.h"
#import "MapPoint.h"
#import "LocationService.h"


@implementation UIRenderLocation

@synthesize mapView;
@synthesize results;



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.topItem.title=@"renderLocation".translate;
    
	[UIHelper applyColorsAndFonts:self.view];
	
	mapView.delegate=self;
	
	mapView.mapType=MKMapTypeStandard;
	
	mapView.scrollEnabled=YES;
	
	mapView.zoomEnabled=TRUE;
    
	[self.navigationItem setRightBarButtonItem:btnLoadActions];
	
	LocationService *locService=[LocationService getInstance];
    
    [locService start];
	
	mapView.scrollEnabled = YES;
	
	mapView.zoomEnabled = YES;
    
    BOOL mapSetup = FALSE;
    
    //default to current location.
    if([locService currentLocation]!=nil){
        mapView.region = MKCoordinateRegionMake([[locService currentLocation] coordinate],MKCoordinateSpanMake(0.15,0.15));
        mapSetup = TRUE;
    }
    
    
    //change if we have coordinates.
    NSDictionary *properties =(NSDictionary*) [action getObjectSafely:@"properties"];
    
    
    NSString *lat = [properties getString:@"latitude"];
    NSString *lon = [properties getString:@"longitude"];
    //NSLog(@"properties for action are %@", [properties description]);
   // NSLog(@"lat is %@", lat);
    
    if(![StringUtils isEmpty:lat] && ![StringUtils isEmpty:lon]){
        //NSLog(@"setting region to relative coordinates");
        NSString *radius = [properties getString:@"radius"];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat.doubleValue, lon.doubleValue);
        if(![radius isEqualToString:@""]){
            mapView.region = [LocationUtils calcRegion:coord miles:radius.doubleValue];
        }else{
            mapView.region = [LocationUtils calcRegion:coord miles:5.0];
        }
        
        mapSetup=TRUE;
        
    }
	
    
    if(mapSetup==FALSE){
        //NSLog(@"using tampa's coordinates");
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(27.9472, -82.4586);
        mapView.region=[LocationUtils calcRegion:coord miles:5.0];
    }
	
    
   // NSLog(@"currentLocation is %@", [locService.currentLocation description]);
    
    [self loadLocationData];
	
	
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([[LocationService getInstance] isReady]==NO){
       // NSLog(@"rendering error %@", @"locationServicesOff".translate);
        [UIHelper fadeInMessage:self.mapView text:@"locationServicesOff".translate backgroundColor:[UIColor yellowColor] fontColor:[UIColor blackColor]];
        
    }
}


-(void)loadLocationData{
    [self.spinner setMsg:@"gettingLocations".translate];
    [self.spinner startAnimating];
    
    LocationService *service = [LocationService getInstance];
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    if([service isReady]){
        [postdata setObjectSafely:[service getLat].stringValue forKey:@"latitude"];
        [postdata setObjectSafely:[service getLon].stringValue forKey:@"longitude"];
    }
    
    HTTPUtils *http = [[HTTPUtils alloc] init];
    http.callBack=@selector(onLocationData:);
    http.callBackOwner=self;
    [http executeAction:self.action postdata:postdata];
    
}


-(void)onLocationData:(NSData *)jsonData{
    self.results = [JSONUtils convertJSONToArray:jsonData];
    [self.spinner stopAnimating];
    
    [self showAllLocations];
    
    //NSLog(@"results are %@", [results description]);
}


//map delegate methods:
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)showClosestLocation{
	[mapView removeAnnotations:[mapView annotations]];
	[self sortByAttribute:@"distance" ascending:TRUE]; //sort the array of results by distance.
	NSMutableDictionary *result = [results objectAtIndex:0];
	MapPoint *point = [MapPoint createMapPoint:result];
	[mapView addAnnotation:point];
	
	MapPoint *relativeLocation=[MapPoint createMapPointFromCurrentLocation];
	[mapView addAnnotation:relativeLocation];
	
}


-(void)showAllLocations{
	[mapView removeAnnotations:mapView.annotations];
    for(NSMutableDictionary *dict in results){
        MapPoint *point = [MapPoint createMapPoint:dict];
        [self.mapView addAnnotation:point];
    }
}

-(void)showTopRated{
    
	
}


-(void) loadActions{
	
    
    /*
     NSString *showClosest=NSLocalizedString(@"ShowClosestLocation", @"Show Closest");
     NSString *showTopRated=NSLocalizedString(@"ShowTopRatedLocation", @"Show Top Rated");
     NSString *showAll=NSLocalizedString(@"ShowAllLocations", @"Show All");
     NSString *actionsMenu=NSLocalizedString(@"actionsMenu","Actions Menu");
     NSString *cancel=NSLocalizedString(@"cancel","Cancel");
     
     actions = [[UIActionSheet alloc] initWithTitle:actionsMenu delegate:self
     cancelButtonTitle:cancel
     destructiveButtonTitle:nil
     otherButtonTitles:showClosest,showTopRated,showAll,nil];
     
     actions.actionSheetStyle=UIActionSheetStyleBlackOpaque;
     [actions showInView: self.view];
     */
    
}

//alert view protocol (another interface implementation)
-(void)actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if(actionSheet==actions){
		
		
		switch (buttonIndex) {
			case 0:
				[self showClosestLocation];
				break;
				
			case 1:
				[self showTopRated];
				break;
				
			case 2:
				[self showAllLocations];
				break;
				
			default:
				
				break;
		}
	}
    
}




-(void) sortByAttribute:(NSString *) attribute ascending:(BOOL)asc{
	NSSortDescriptor *myDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:asc];
	NSArray *sortDescriptors = [NSArray arrayWithObject:myDescriptor];
	NSArray *sortedArray = [self.results sortedArrayUsingDescriptors:sortDescriptors];
    
	results=[[NSMutableArray alloc] initWithArray:sortedArray];
	
	[self.results removeAllObjects];
	[self.results addObjectsFromArray:sortedArray];
	
	
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKPinAnnotationView *startPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
    
    startPin.animatesDrop = YES;
    
    startPin.pinColor = MKPinAnnotationColorGreen;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    btnRight.tag=98;
    
    startPin.rightCalloutAccessoryView=btnRight;
    
    startPin.canShowCallout = YES;
    
    startPin.enabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"location.png"];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    
    UIButton *btnDirections = [[UIButton alloc] initWithFrame:imgView.frame];
    
    [btnDirections setImage:image forState:UIControlStateNormal];
    
    btnDirections.tag=99;
    
    
    startPin.leftCalloutAccessoryView = btnDirections;
    
	return startPin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    
    if(control.tag==98){
        NSObject *point =[[self.mapView selectedAnnotations]objectAtIndex:0];
        
        
        if ([point isKindOfClass:[MapPoint class]]) {
            MapPoint *myPoint = (MapPoint*) point;
            //build an action and post.
            NSDictionary *navaction = [[NSDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",@"navigate".translate,@"label",myPoint.url,@"url",@"refresh-dark.png",@"imageUrl",@"GET",@"httpMethod", nil];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ON_NAVIGATE object:navaction];
            
            [self close:nil];
        }
        
    }else if(control.tag==99){
        [self loadDirections];
    }
    
    
    
    
    
}




-(void)loadDirections{
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass     respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MapPoint *mapPoint = [mapView.annotations objectAtIndex:0];
        
        // Create an MKMapItem to pass to the Maps app
        
       // NSLog(@"mapPoint.coordinate is %f,%f",mapPoint.coordinate.latitude, mapPoint.coordinate.longitude);
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:mapPoint.coordinate addressDictionary:nil];
        
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        
        // Set the directions mode to "Driving"
        // Can use MKLaunchOptionsDirectionsModeWalking instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey :   MKLaunchOptionsDirectionsModeDriving };
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}



@end
