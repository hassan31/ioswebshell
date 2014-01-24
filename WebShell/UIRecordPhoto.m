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

#import "UIRecordPhoto.h"

@implementation UIRecordPhoto

@synthesize selectedImage,fileInfo,movieURL,player,movieView,btnLoadPicture,filePath,btnCamera,btnPictures;

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
    [UIHelper centerXView:self.selectedImage];
    
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    if ([color isEqualToString:@"dark"]) {
       // NSLog(@"setting image to dark");
        [btnLoadPicture setImage:[UIImage imageNamed:@"play-dark.png"] forState:UIControlStateNormal];
        [btnCamera setImage:[UIImage imageNamed:@"camera-dark.png"] forState:UIControlStateNormal];
        [btnPictures setImage:[UIImage imageNamed:@"photos-dark.png"] forState:UIControlStateNormal];
        
    }else{
        [btnLoadPicture setImage:[UIImage imageNamed:@"play-light.png"] forState:UIControlStateNormal];
        [btnCamera setImage:[UIImage imageNamed:@"camera-light.png"] forState:UIControlStateNormal];
        [btnPictures setImage:[UIImage imageNamed:@"photos-light.png"] forState:UIControlStateNormal];
    }
    
    
    self.view.autoresizesSubviews=TRUE;
    
    self.navBar.topItem.title=@"recordPhoto".translate;
    
    selectedImage.layer.cornerRadius=5.0f;
    
     NSString *buttonShade = [prefs objectForKey:@"buttonShade"];
    
    if ([buttonShade isEqualToString:@"light"]) {
        selectedImage.backgroundColor=[UIColor lightGrayColor];
    }else{
        selectedImage.backgroundColor=[UIColor blackColor];
    }
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.selectedImage addGestureRecognizer:singleTap];
    [self.selectedImage setUserInteractionEnabled:YES];
    
    
}


- (void)imageViewTapped:(UIGestureRecognizer *)gestureRecognizer {
    [self loadPicture:nil];
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
    
    NSArray *mediaTypesAllowed = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.mediaTypes=mediaTypesAllowed;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing=NO;
    
    [UIHelper setNavBarColorScheme:imagePicker.navigationBar];
    imagePicker.delegate=self;
    
    
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if(self.popover!=nil && [self.popover isPopoverVisible]){
            [self.popover dismissPopoverAnimated:NO];
        }
        
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        CGRect r=((UIButton*)sender).frame;
        CGRect tRect=[((UIButton*)sender) convertRect:((UIButton*)sender).frame toView:self.view];
        tRect.origin.x=r.origin.x;
        
        [pop presentPopoverFromRect:tRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.popover=pop;
        
        
    } else {
        [self presentModalViewController:imagePicker animated:YES];
    }
}


-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

//image picker methods
-(IBAction)loadCameraRoll:(id)sender{
    
    NSArray *mediaTypesAllowed = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.mediaTypes=mediaTypesAllowed;
    imagePicker.allowsEditing=NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [UIHelper setNavBarColorScheme:imagePicker.navigationBar];
    imagePicker.delegate=self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if(self.popover!=nil && [self.popover isPopoverVisible]){
            [self.popover dismissPopoverAnimated:YES];
            return;
        }
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        CGRect r=((UIButton*)sender).frame;
        CGRect tRect=[((UIButton*)sender) convertRect:((UIButton*)sender).frame toView:self.view];
        tRect.origin.x=r.origin.x;
        [pop presentPopoverFromRect:tRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        self.popover=pop;
    } else {
        [self presentModalViewController:imagePicker animated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
    
    //close the picker which will make the image available.
    [picker dismissModalViewControllerAnimated:YES];
    

    
    
    
    UIImage *image = nil;
    
    //so we can test in sim
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:MEDIA_TYPE_PHOTO]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //NSLog(@"using camera");
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }else{
            //NSLog(@"using camera roll");
            image= [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        
        if(image==nil){
            //NSLog(@"Image is nil!!!");
            return;
        }
        
        
        /*
        if(imgData.length > 500000){
            image= [image scaleToHalfSize];
        }
         */

        
        //NSData *imgData = UIImageJPEGRepresentation(image, 0);
        
        selectedImage.image=image;
        selectedImage.hidden=FALSE;
        self.movieView.hidden=TRUE;
        self.btnLoadPicture.hidden=TRUE;
        
        NSData *imageData= UIImagePNGRepresentation(selectedImage.image);
        
        
       // NSLog(@"after percent reduce %i", imageData.length);
        
        [FileUtils saveToCacheFolder:imageData fileName:FILE_NAME_PHOTO];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please only select photos from this view." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;
        
    }
    
    //get the file info.
    self.fileInfo=info;
    
    self.dirty=YES;
    
    //NSLog(@"fileInfo is %@", [fileInfo description]);
    
}



-(IBAction)loadPicture:(id)sender{
    
    if (self.selectedImage.image==nil) {
        return;
    }
    
    NSURL *url = [FileUtils retrieveUrlFromCache:FILE_NAME_PHOTO]; //[NSURL fileURLWithPath:self.filePath];
    
    UIStoryboard *storyboard = [UIHelper storyboard];
    
    UIAttachmentViewer *viewer = [storyboard instantiateViewControllerWithIdentifier:@"renderAttachment"];
    
    viewer.url=url;
    
    viewer.photo=TRUE;
    
    [self presentModalViewController:viewer animated:TRUE];
}

-(void)loadPortrait{
    UIImage * landscape = self.selectedImage.image;
    UIImage * portrait = [[UIImage alloc] initWithCGImage: landscape.CGImage
                                                    scale: 1.0
                                              orientation: UIImageOrientationUp];
    
    self.selectedImage.image=portrait;
}

-(void)loadLandscape{
    UIImage * portrait = self.selectedImage.image;
    UIImage * landscape = [[UIImage alloc] initWithCGImage: portrait.CGImage
                                                     scale: 1.0
                                               orientation: UIImageOrientationLeft];
    
    self.selectedImage.image=landscape;
}



-(IBAction)save:(id)sender{
    
    [spinner setMsg:@"uploading".translate];
    [spinner startAnimating];
    
    NSURL *url = [FileUtils retrieveUrlFromCache:FILE_NAME_PHOTO];
    
    NSData *filedata = [NSData dataWithContentsOfURL:url];
    NSLog(@"filedata.length is %i", filedata.length);
    
    
    
    NSDictionary *props = (NSDictionary*)[action getObjectSafely:@"properties"];
    NSNumber *scaledown =(NSNumber*) [props getObjectSafely:@"scaleDown"];
    
    if(scaledown!=nil && scaledown.intValue > 0){
        UIImage *image = [UIImage imageWithData:filedata];
        image = [image scaleDownBy:scaledown.doubleValue];
        filedata = UIImagePNGRepresentation(image);
        NSLog(@"filedata length is %i", filedata.length);
        
    }
    
    
    //setup the http utils client
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    //set the callback owner to the current view controller
    http.callBackOwner=(NSObject*)self;
    
    //set the call back method (will get called after response recieved to update the UI)
    http.callBack=@selector(onResponse:);
    
    
    //this controller requires UPLOAD action, we will ignore what is set in the config from the server
    //NSLog(@"calling url %@", [action getString:@"url"]);
    [http uploadFile:url.path url:[action getString:@"url"]];
    
    
}



@end
