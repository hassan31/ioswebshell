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
#import "UIParent.h"
#import "WebShellViewController.h"


@implementation UIParent

@synthesize webShell,navBar,toolBar,lblTitle,action,data,spinner,popover,btnUpload,btnClose;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    prefs=[NSUserDefaults standardUserDefaults];
    
    self.spinner = [[Spinner alloc] init];
    
    [self.spinner addToView:self.view];
    
    [self.spinner setMsg:@"uploading".translate];
    
    [self.spinner stop];
    
    NSString *bgColor = [prefs objectForKey:@"backgroundColor"];
    self.view.backgroundColor=[UIColor colorWithHexString:bgColor];
    
    [UIHelper applyColorsAndFonts:self.view];
    
    self.view.autoresizesSubviews=YES;

    
    self.btnUpload.enabled=FALSE;
    
    
    NSString *color = [prefs objectForKey:@"buttonShade"];

    if ([color isEqualToString:@"dark"]) {
       // NSLog(@"setting image to dark");
        [btnUpload setImage:[UIImage imageNamed:@"upload-dark.png"] forState:UIControlStateNormal];
        [btnClose setImage:[UIImage imageNamed:@"close-dark.png"] forState:UIControlStateNormal];
        
    }else{
        [btnUpload setImage:[UIImage imageNamed:@"upload-light.png"] forState:UIControlStateNormal];
        [btnClose setImage:[UIImage imageNamed:@"close-light.png"] forState:UIControlStateNormal];
    }

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIHelper setNavBarColorScheme:self.navBar];
    [UIHelper setToolBarColorScheme:self.toolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)save:(id)sender{
    NSLog(@"save operation should be called by sub classes.");
    
}

-(IBAction)close:(id)sender{
    
    if (dirty) {
        [self loadDirtyActions];
        return;
    }
    
    [self dismissModalViewControllerAnimated:TRUE];
}

-(void) loadDirtyActions{
    NSString *title = @"saveMessage".translate;
    NSString *yesLabel = @"yes".translate;
    NSString *noLabel = @"no".translate;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"cancel".translate
                                               destructiveButtonTitle:nil otherButtonTitles:yesLabel,noLabel,nil];
    
    
     [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
       // NSLog(@"saving");
        [self save:nil];
        
    }else if(buttonIndex==1){
       // NSLog(@"not saving");
        self.dirty=NO;
        [self close:nil];
    }
    
    
}

-(void)onResponse:(NSData *)jsonData{
    [self.spinner stopAnimating];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_RESPONSE object:json];
    self.dirty=NO;
    [self close:nil];
    
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
   // NSLog(@"touchesBegan");
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint point= [touch locationInView:touch.view];
    touchPoint=point;
}


-(void) setDirty:(BOOL)mydirty{
    dirty=mydirty;
    btnUpload.enabled=dirty;
}

-(BOOL)dirty{
    return dirty;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}




@end
