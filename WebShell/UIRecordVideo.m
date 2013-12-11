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

#import "UIRecordVideo.h"

@implementation UIRecordVideo

@synthesize selectedImage,fileInfo,image,movieURL,player,movieView,btnPlayMovie,rawData,filePath,btnVideoPicker,btnRecordVideo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
 
    [super viewDidLoad];
    
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    if ([color isEqualToString:@"dark"]) {
       // NSLog(@"setting image to dark");
        [btnPlayMovie setImage:[UIImage imageNamed:@"play-dark.png"] forState:UIControlStateNormal];
        [btnRecordVideo setImage:[UIImage imageNamed:@"video-dark.png"] forState:UIControlStateNormal];
        [btnVideoPicker setImage:[UIImage imageNamed:@"photos-dark.png"] forState:UIControlStateNormal];
        
    }else{
        [btnPlayMovie setImage:[UIImage imageNamed:@"play-light.png"] forState:UIControlStateNormal];
        [btnRecordVideo setImage:[UIImage imageNamed:@"video-light.png"] forState:UIControlStateNormal];
        [btnVideoPicker setImage:[UIImage imageNamed:@"photos-light.png"] forState:UIControlStateNormal];
    }
    
    
    self.view.autoresizesSubviews=TRUE;
    
    selectedImage.layer.cornerRadius=5.0f;


    self.navBar.topItem.title=@"recordVideo".translate;
    
     NSString *buttonShade = [prefs objectForKey:@"buttonShade"];
    
    if ([buttonShade isEqualToString:@"light"]) {
        selectedImage.backgroundColor=[UIColor lightGrayColor];
    }else{
        selectedImage.backgroundColor=[UIColor blackColor];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(IBAction)loadCamera:(id)sender{
    
    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        [UIHelper fadeInMessage:self.view text:@"noCameraFound".translate];
        return;
    }
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypesAllowed = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];

        UIImagePickerController * moviePicker = [[UIImagePickerController alloc] init];
        
        moviePicker.mediaTypes=mediaTypesAllowed;
        
        moviePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        moviePicker.allowsEditing=NO;
        
        [UIHelper setNavBarColorScheme:moviePicker.navigationBar];
        
        moviePicker.delegate=self;
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            if(self.popover!=nil && [self.popover isPopoverVisible]){
                [self.popover dismissPopoverAnimated:YES];
                return;
            }
            
            UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:moviePicker];
            [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:YES animated:YES];
            self.popover=pop;
            
        }else{
            [self presentModalViewController:moviePicker animated:YES];
        }
        
        
        
        
    }else{
        [UIHelper fadeInValidationMessage:self.view text:@"noCameraFound".translate];
    }

    
}


//image picker methods
-(IBAction)loadCameraRoll:(id)sender{
    NSArray *mediaTypesAllowed = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
    
    UIImagePickerController * moviePicker = [[UIImagePickerController alloc] init];
    
    moviePicker.mediaTypes=mediaTypesAllowed;
    
    moviePicker.allowsEditing=NO;
    
    moviePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [UIHelper setNavBarColorScheme:moviePicker.navigationBar];
    
    moviePicker.delegate=self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if(self.popover!=nil && [self.popover isPopoverVisible]){
            [self.popover dismissPopoverAnimated:YES];
            return;
        }
        
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:moviePicker];
        [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:YES animated:YES];
        self.popover=pop;
        
    }else{
        [self presentModalViewController:moviePicker animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    //close the picker which will make the image available.
    [picker dismissModalViewControllerAnimated:YES];
    
    
    //so we can test in sim
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:MEDIA_TYPE_MOVIE]){
        
        self.movieURL =  [info objectForKey:UIImagePickerControllerMediaURL];
        
        self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        
        self.player.view.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.movieView addSubview:player.view];
        
        UIImage *singleFrameImage = [player.moviePlayer thumbnailImageAtTime:1 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        self.selectedImage.image=singleFrameImage;
        
        [player.moviePlayer stop];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please only select videos with this type of message." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        
        return;
    }
    
    //get the file info.
    self.fileInfo=info;
    self.dirty=YES;
}


-(IBAction)save:(id)sender{
    
    
    [spinner startAnimating];
    
    //NSData *movieData = [NSData dataWithContentsOfURL:self.movieURL];
    
    
    //setup the http utils client
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    //set the callback owner to the current view controller
    http.callBackOwner=(NSObject*)self;
    
    //set the call back method (will get called after response recieved to update the UI)
    http.callBack=@selector(onResponse:);
    
    
    //this controller requires UPLOAD action, we will ignore what is set in the config from the server
    //NSLog(@"calling url %@", [action getString:@"url"]);
    [http uploadFile:FILE_NAME_VIDEO url:[action getString:@"url"]];
    
    
}



-(IBAction)playMovie:(id)sender{
    
    if (self.movieURL==nil) {
        return;
    }
    
    self.player.moviePlayer.contentURL=self.movieURL;
     [self.player.moviePlayer prepareToPlay];
    
    [self presentModalViewController:self.player animated:TRUE];
}


//movie listener
-(void)moviePlayBackDidFinish: (NSNotification*)notification{ 
    //NSLog(@"moviePlayBackDidFinish");
    MPMoviePlayerController *theMovie = [notification object];
    [theMovie pause];
    [theMovie stop];
    
    
}


-(IBAction)close:(id)sender{
    //NSLog(@"closing from video controller");
    if (self.player!=nil) {
        //NSLog(@"Attempting to terminate movie.");
        [self.player.moviePlayer pause];
        [self.player.moviePlayer stop];
        self.player=nil;
        
    }
    [super close:nil];
}





@end
