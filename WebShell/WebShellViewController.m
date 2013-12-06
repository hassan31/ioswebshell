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

#import "WebShellViewController.h"


@implementation WebShellViewController

@synthesize toolBar,webView,actions,selectedAction,spinner,loading;
@synthesize actionSheet,btnActions,btnBackward,currentUrl,history,locationCallBacks;
@synthesize btnForward,btnStop,txtUrl,jsonResponse,menuLoaded,btnSettings,btnRefresh;
@synthesize navBar,btnFullScreen,btnRestore,menuTable,navActions,btnMenu,downloadUrl,bookmarks;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    device = [UIDevice currentDevice];
    
    authed=FALSE;
    
    self.txtUrl.adjustsFontSizeToFitWidth=TRUE;
    
    spinner = [[Spinner alloc] init];
    
    [spinner addToView:self.view];
    
    self.btnMenu.enabled=FALSE;
    
    self.btnActions.enabled=FALSE;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    //lets set the default prefs if they aren't set yet:
    if ([prefs objectForKey:@"setup"]==nil) {
        [self restoreDefaults];
    }
    
    
    validator = [[ActionValidator alloc] init];
    
    self.webView.multipleTouchEnabled=TRUE;
    
    self.webView.userInteractionEnabled=TRUE;
    
    self.webView.scalesPageToFit=YES;
    
    //LocationService *service= [[LocationService getInstance] init];
    // NSLog(@"service isReady %i", [service isReady]);
    
    
    
    
    self.history=[prefs valueForKey:USER_PREFS_HISTORY];
    if (history==nil) {
        self.history=[[NSMutableArray alloc] initWithCapacity:MAX_HISTORY_ALLOWED];//only going to hold recent history.
    }
    
    self.bookmarks=[prefs valueForKey:USER_PREFS_BOOKMARK];
    if (bookmarks==nil) {
        self.bookmarks=[[NSMutableArray alloc] initWithCapacity:MAX_HISTORY_ALLOWED];//only going to hold recent history.
    }
    
    
    self.locationCallBacks=[prefs valueForKey:USER_PREFS_LOCATION_CALLBACKS];
    if (locationCallBacks==nil) {
        self.locationCallBacks=[[NSMutableArray alloc] initWithCapacity:20];//only going to hold recent callbacks.
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleResponse:)
                                                 name:ON_RESPONSE
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNavigation:)
                                                 name:ON_NAVIGATE
                                               object:nil];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLocationChange:)
                                                 name:ON_LOCATION_CHANGE
                                               object:nil];
    
    
    
    defaultWebViewFrame=self.webView.frame;
    
    self.view.autoresizesSubviews=TRUE;
    
    NSString *loadedDefault = [prefs stringForKey:@"loadedDefault"];
    
    if (TEST_MODE) {
        self.txtUrl.text=TEST_URL;
        [self loadUrl:TEST_URL];
        
    }else if(loadedDefault==nil){
        self.txtUrl.text=DEFAULT_URL;
        [self loadUrl:DEFAULT_URL];
        [prefs setObject:@"true" forKey:@"loadedDefault"];
        
    }
    
    //load up the refresh option
    self.navActions=[[NSMutableArray alloc] initWithCapacity:20];
    
    
    settings=[[NSMutableArray alloc] initWithCapacity:2];
    [self loadSettingsData];
    
}



-(void) viewWillAppear:(BOOL)animated{
    [self becomeFirstResponder];
    [super viewWillAppear:animated];
    [self applyTheme];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self processJsonResponse];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void) applyTheme{
    [UIHelper applyColorsAndFonts:self.view];
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    
    
    //NSLog(@"buttonShade is %@",color);
    
    if ([color isEqualToString:@"dark"]) {
        //  NSLog(@"setting image to dark");
        
        [btnActions setImage:[UIImage imageNamed:@"actions-dark.png"] forState:UIControlStateNormal];
        [btnBackward setImage:[UIImage imageNamed:@"back-dark.png"] forState:UIControlStateNormal];
        [btnForward setImage:[UIImage imageNamed:@"forward-dark.png"] forState:UIControlStateNormal];
        [btnMenu setImage:[UIImage imageNamed:@"menu-dark.png"] forState:UIControlStateNormal];
        
        [btnFullScreen setImage:[UIImage imageNamed:@"fullscreen-dark.png"] forState:UIControlStateNormal];
        [btnRefresh setImage:[UIImage imageNamed:@"refresh-dark.png"] forState:UIControlStateNormal];
        [btnSettings setImage:[UIImage imageNamed:@"gear-dark.png"] forState:UIControlStateNormal];
        
    }else{
        [btnActions setImage:[UIImage imageNamed:@"actions-light.png"] forState:UIControlStateNormal];
        [btnBackward setImage:[UIImage imageNamed:@"back-light.png"] forState:UIControlStateNormal];
        [btnForward setImage:[UIImage imageNamed:@"forward-light.png"] forState:UIControlStateNormal];
        [btnMenu setImage:[UIImage imageNamed:@"menu-light.png"] forState:UIControlStateNormal];
        
        [btnFullScreen setImage:[UIImage imageNamed:@"fullscreen-light.png"] forState:UIControlStateNormal];
        [btnRefresh setImage:[UIImage imageNamed:@"refresh-light.png"] forState:UIControlStateNormal];
        [btnSettings setImage:[UIImage imageNamed:@"gear-light.png"] forState:UIControlStateNormal];
    }
    //self.txtUrl.textColor=[UIColor blackColor];//must always be black font.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)canBecomeFirstResponder { return YES; }

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self toggleFullScreen:nil];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.menuTable.view removeFromSuperview];
}


//textfield delegate to close the keyboard when return is selected
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSMutableString *strUrl = [[NSMutableString alloc] initWithString:@"http://"];
    if([txtUrl.text rangeOfString:@"http"].location==NSNotFound){
        [strUrl appendString:txtUrl.text];
        self.txtUrl.text=strUrl;
        [self loadUrl:strUrl];
        
    }else{
        [self loadUrl:txtUrl.text];
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self.menuTable.view removeFromSuperview];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    //update the default frame based on the device orientation (for fullScreen toggle)
    
    defaultWebViewFrame=self.webView.frame;
    
    
}




- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [loading startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [loading stopAnimating];
    
    [self setButtonStates];
    
    NSURL *url = self.webView.request.URL;
    
    // NSLog(@"url absolutestring is %@", [url absoluteString]);
    
    txtUrl.text =   [url absoluteString];
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    //handle the whitespace taps.
    NSString *script = @"window.ontouchstart=function(){ document.location.href = 'http://webshelltouch'; }";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    
    
    pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    
    //get the json data from the tag
    NSString *json = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('webshell-bottom-actions').innerHTML"];
    
    //webshell props (currently only color is defined here)
    NSString *jsonProps = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('webshell-properties').innerHTML"];
    
    //webshell navigation actions (data for the menu);
    NSString *jsonMenu = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('webshell-top-actions').innerHTML"];
    

    NSMutableString *fixedMenu = [[NSMutableString alloc] initWithString:jsonMenu];
    jsonMenu = [StringUtils replaceSubstring:fixedMenu replace:@"&amp;" replaceWith:@"&"];
    
    
    fixedMenu = json.mutableCopy;
    json = [StringUtils replaceSubstring:fixedMenu replace:@"&amp;" replaceWith:@"&"];
    
  
    
    [navActions removeAllObjects];
    
    
    if(![jsonMenu isEqualToString:@""]){
        NSData* data = [jsonMenu dataUsingEncoding:NSUTF8StringEncoding];
        NSObject *tempArr = [JSONUtils convertJSONToObject:data];
        
        [self.navActions addObjectsFromArray:(NSArray*)tempArr];
        self.btnMenu.enabled=TRUE;
        //NSLog(@"navActions.cout is %i", navActions.count);

        
    }else{
        self.btnMenu.enabled=FALSE;
        
    }
    
    
    if(![jsonProps isEqualToString:@""]){
        NSData* data = [jsonProps dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *props = [JSONUtils convertJSONToDictionary:data];
        
        //now lets write the props to the user defaults
        
        [prefs setValuesForKeysWithDictionary:props];
        [prefs setValue:@"true" forKey:@"setup"];
        
    
        
        [prefs synchronize];
        
        
        
        //apply full screen if requested.
        if ([[props getString:@"fullScreen"] isEqualToString:@"true"] && !fullScreen) {
            [self toggleFullScreen:nil];
        }
        
        if ([[props getString:@"translation"] isEqualToString:@""]==FALSE) {
            [self loadTranslation:[props getString:@"translation"]];
        }else{
            //NSLog(@"removing translation from cache");
            [[CacheManager appCache] removeObjectForKey:@"translation"];
            [self loadSettingsData];
        }
        
        
        //execute the custom javascript if it exists in the selectedAction
        
        
        if(self.selectedAction!=nil){
            NSString *scriptfunction = [selectedAction getString:@"scriptfunction"];
            //NSLog(@"scriptfunction %@", scriptfunction);
            if(![scriptfunction isEqualToString:@""]){
                NSString *customdata = [selectedAction getString:@"customdata"];
                NSMutableString *function = [[NSMutableString alloc] initWithString:scriptfunction];
                [function appendString:@"('"];
                [function appendString:customdata];
                [function appendString:@"');"];
                // NSLog(@"final function is %@", function);
                [self.webView stringByEvaluatingJavaScriptFromString:function];
            }
        }
        
        //apply the color theme.
        [self applyTheme];
        
    }
    
    
    //convert the json string to NSData
    if(![json isEqualToString:@""]){
        
        NSString *jsonClean = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *trimmedString = [jsonClean stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"jsonClean is %@" , json);
        if(![trimmedString hasPrefix:@"["]){
            [UIHelper fadeInMessage:self.view text:@"invalidJsonActions".translate];
            return;
        }
        
        
        NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //now convert data to an array of NSDictionary objects.
        self.actions = [JSONUtils convertJSONToArray:data];
        
        
        if (actions!=nil && actions.count > 0) {
            self.btnActions.enabled=TRUE;
            [actions addObject:actionsCanceled];//add the cancel button.
        }
    }else{
        self.btnActions.enabled=FALSE;
    }
    
    //time to validate the actions and the navactions
    for (id action in self.actions){
        if(![validator isValid:action]){
            [UIHelper fadeInValidationMessage:self.view text:validator.error];
            return;
        }
    }
    
    
    
    
    [self addURLHistory:self.txtUrl.text title:pageTitle];
    
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([error code] == NSURLErrorCancelled || [error code] == 204) return; // Ignore this error

    
    NSLog(@"error is %@, %i", [error description], [error code]);
    
    NSString *err = [error localizedDescription];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error".translate message:err delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK".translate, nil];
    [alert show];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [self.menuTable.view removeFromSuperview];
    self.menuLoaded=NO;
    
    if ([request.URL.host isEqualToString:@"webshelltouch"]){
        return NO;
    }
    
    
    
    
    NSMutableURLRequest *editRequest = (NSMutableURLRequest*) request;
    
    [[[HTTPUtils alloc] init] setRequestHeader:editRequest];//apply the standard headers.
    
    
    // NSLog(@"request url is %@", [request.URL absoluteString]);
    
    
    
    if (!authed) {
        authed = NO;
        NSURLConnection *conn =[[NSURLConnection alloc] initWithRequest:editRequest delegate:self];
        NSLog(@"conn is %@", [conn description]);
        return NO;
    }
    
    
    
    
    NSURL *url = [request URL];
    
    //scan for a file name
    if(![[url absoluteString] hasPrefix:@"file://"]){
        NSArray *fileTypes = [StringUtils toArray:DOWLOAD_FILES delim:@","];
        for(NSString *type in fileTypes){
            NSString *pathComponent = [url lastPathComponent];
            if([StringUtils contains:pathComponent searchFor:type] && pathComponent!=nil){
                
                //load up the downloader controller
                [self.webView stopLoading];
                NSMutableDictionary *fileaction = [[NSMutableDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",url,@"url",self.title,@"title",[NSDate date],@"date",@"GET",@"httpMethod" ,nil];
                
                UIStoryboard *storyboard = [UIHelper storyboard];
                UIParent *controller = [storyboard instantiateViewControllerWithIdentifier:@"downloadHistory"];
                controller.action = fileaction;
                [self presentModalViewController:controller animated:TRUE];
                return NO;
            }
        }
    }
    
    
    
    txtUrl.text =   [url absoluteString];
    self.btnActions.enabled=FALSE;
    self.btnMenu.enabled=FALSE;
    
    return YES;
}

-(IBAction)toggleFullScreen:(id)sender{
    
    if (fullScreen) {
        //NSLog(@"restore to default");
        
        self.navBar.alpha=0.0;
        self.toolBar.alpha=0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.navBar.hidden=NO;
            self.toolBar.hidden=NO;
            self.navBar.alpha=1;
            self.toolBar.alpha = 1;
            self.webView.frame=defaultWebViewFrame;
        }];
        
        fullScreen=FALSE;
        
    }else{
        //NSLog(@"enable full screen");
        self.webView.frame=CGRectInset(self.view.bounds, 0.0f, 0.0f); //self.view.frame;
        
        fullScreen=TRUE;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.navBar.alpha = 0;
            self.toolBar.alpha=0;
            
        } completion: ^(BOOL finished) {
            self.navBar.hidden=TRUE;
            self.toolBar.hidden=TRUE;
        }];
        
        [UIHelper fadeInMessage:self.webView text:@"restoreView".translate];
        
    }
    
    
    
}

-(IBAction)backward:(id)sender{
    
    if(self.webView.canGoBack){
        [self.webView goBack];
        NSURL *url = self.webView.request.URL;
        txtUrl.text =   [url absoluteString];
    }
    
}

-(IBAction)forward:(id)sender{
    
    if(self.webView.canGoForward){
        [self.webView goForward];
        NSURL *url = self.webView.request.URL;
        txtUrl.text =   [url absoluteString];
    }
    
}

-(IBAction)stop:(id)sender{
    [self.webView stopLoading];
}


-(IBAction)loadActionSheet:(id)sender{
    
    
    if(self.actions!=nil && self.actions.count > 0){
        
        NSString *title = NSLocalizedString(@"actions", "actions");
        
        self.actionSheet=[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        
        for(id obj in self.actions) {
            NSDictionary *dict = obj;
            NSString *label =(NSString*)[dict getObjectSafely:@"label"];
            [self.actionSheet addButtonWithTitle:label];
        }
        
        actionSheet.cancelButtonIndex=actions.count -1;
        [actionSheet showInView:self.view];
    }
    
}

-(IBAction)refreshPage:(id)sender{
    if([self.txtUrl.text length] > 4){
        [self loadUrl:self.txtUrl.text];
    }
}


-(void)actionSheet:(UIActionSheet*) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //get handle on selected action dictionary object
    self.selectedAction = [actions objectAtIndex:buttonIndex];
    [self executeAction:selectedAction];
}

-(void) executeAction:(NSMutableDictionary *)action{
    
    
    UIStoryboard *storyboard = [UIHelper storyboard];
    
    UIParent *target=nil;
    
    //get handle on the action name
    NSString *strAction = [action getString:@"action"];
    
    LocationService *service = [LocationService getInstance];
    
    //use action name to determine the controller to load.
    if([CMD_RECORD_AUDIO isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"recordAudio"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
        
    }else if([CMD_EMAIL_LINK isEqualToString:strAction]){
        [self sendLink];
    
    }else if([CMD_DOWNLOAD_HISTORY isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"downloadHistory"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
    }else if([CMD_UPLOAD_FILE isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"downloadHistory"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
        
    } else if([CMD_RECORD_SIGNATURE isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"recordSignature"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
        
    }else if([CMD_RECORD_PUSH_TOKEN isEqualToString:strAction]){
        //cache the reference to the current action and this view controller for the app delegate to use.
        [[CacheManager appCache] setObject:action forKey:CACHE_CURRENT_ACTION];
        [[CacheManager appCache] setObject:self forKey:CACHE_WEB_SHELL_VIEW_CONTROLLER];
        
        //kick off the push process.
        [self registerForPush];
        
        
    }else if([CMD_RECORD_VIDEO isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"recordVideo"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
        
    }else if([CMD_RECORD_PHOTO isEqualToString:strAction]){
        target  = [storyboard instantiateViewControllerWithIdentifier:@"recordPhoto"];
        target.action=action;
        [self presentModalViewController:target animated:TRUE];
        
        
    }else if([CMD_HISTORY isEqualToString:strAction]){
        UIHistory *historyController  = [storyboard instantiateViewControllerWithIdentifier:@"history"];
        historyController.data=self.history;
        historyController.navBar.topItem.title=@"history".translate;
        historyController.bookMark=FALSE;
        [self presentModalViewController:historyController animated:TRUE];
        
        
    }else if([CMD_CLEAR_HISTORY isEqualToString:strAction]){
        [self clearURLHistory];
        [UIHelper fadeInMessage:self.view text:@"historyCleared".translate];
        
    }else if([CMD_BOOKMARK_LIST isEqualToString:strAction]){
        // NSLog(@"rendering bookmark list");
        UIHistory *historyController  = [storyboard instantiateViewControllerWithIdentifier:@"history"];
        historyController.data=self.bookmarks;
        historyController.navBar.topItem.title=@"bookMark".translate;
        historyController.bookMark=TRUE;
        [self presentModalViewController:historyController animated:TRUE];
        
        
    }else if([CMD_BOOKMARK isEqualToString:strAction]){
        [self addURLBookmark:self.txtUrl.text title:pageTitle];
        
    }else if([CMD_RESTORE_DEFAULTS isEqualToString:strAction]){
        [self restoreDefaults];
        
    }else if([CMD_CANCEL_ACTIONS isEqualToString:strAction]){
        //do nothing.
        
    }else if([CMD_NAVIGATE isEqualToString:strAction]){
        //NSLog(@"navigating to page %@", [action getString:@"url"]);
        self.txtUrl.text=[action getString:@"url"];
        [self loadUrl:self.txtUrl.text];
        
    }else if([CMD_RECORD_LOCATION isEqualToString:strAction]){
        
        if(![service isReady]){
            //NSLog(@"starting service");
            [prefs setObject:@"true" forKey:CMD_RECORD_LOCATION];
        }
        [self addLocationCallBack:action title:pageTitle];
        [UIHelper fadeInMessage:self.view text:@"gpsMessage".translate];
        
        
    }else if([CMD_SEND_LOCATION isEqualToString:strAction]){
        
        HTTPUtils *http = [[HTTPUtils alloc] init];
        NSNumber *lat = [service getLat];
        NSNumber *lon = [service getLon];
        
        
        NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithCapacity:4];
        [postdata setObjectSafely:lat.stringValue forKey:@"latitude"];
        [postdata setObjectSafely:lon.stringValue forKey:@"longitude"];
        [postdata setObjectSafely:service.direction forKey:@"direction"];
        [http executeAction:action postdata:postdata];
        
        
    }else if([CMD_SCAN_BARCODE isEqualToString:strAction]){
        UIParent *scanner  = [storyboard instantiateViewControllerWithIdentifier:@"scanBarcode"];
        scanner.action=action;
        [self presentModalViewController:scanner animated:TRUE];
        
    }else if([CMD_RENDER_LOCATION isEqualToString:strAction]){
        UIParent *renderLocation  = [storyboard instantiateViewControllerWithIdentifier:@"renderLocation"];
        renderLocation.action=action;
        [self presentModalViewController:renderLocation animated:TRUE];
    }
}

-(void)setButtonStates{
    //set button states based on webview.
    btnStop.enabled=self.webView.loading;
    btnForward.enabled=self.webView.canGoForward;
    btnBackward.enabled=self.webView.canGoBack;
}

-(void) loadUrl:(NSString *)url{
    
    // NSLog(@"loadUrl %@", url);
    
    self.txtUrl.text=url;
    
    [self.webView stopLoading];
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    [webView loadRequest:request];
    
}

-(void)simpleMethod{
    //NSLog(@"simpleMethod");
}

-(void)processJsonResponse{
    
    if(jsonResponse!=nil){
        NSMutableString *callbackScript = [[NSMutableString alloc] initWithString:[selectedAction getString:@"callback"]];
        [callbackScript appendString:@"('"];
        [callbackScript appendString:jsonResponse];
        [callbackScript appendString:@"')"];
        //NSLog(@"callbackScript is %@" , callbackScript);
        [webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackScript waitUntilDone:NO];
        self.jsonResponse=nil;
    }
}



-(void)handleLocationChange:(NSNotification *)notification{
    //LocationService *service = [notification object];
    //NSLog(@"latitude is %@", [[service getLat] description]);
    //NSLog(@"longitude is %@", [[service getLon] description]);
    //NSLog(@"direction is %@", service.direction);
    
    for (id action in self.locationCallBacks){
        [self executeAction:action];
    }
    
    
}


-(void)handleResponse:(NSNotification *)notification {
    //NSLog(@"executeCallback called %@", [notification.object description]);
    self.jsonResponse = [notification object];
    [self processJsonResponse];
    
    
}

-(void)handleNavigation:(NSNotification *)notification{
    NSMutableDictionary *action = [notification object];
    
    menuLoaded=FALSE;
    
    if([[action getString:@"action"] isEqualToString:@"refresh"]){
        [self loadUrl:self.txtUrl.text];
        return;
    }
    
    self.selectedAction=action;
    [self executeAction:action];
    
}


-(void)registerForPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound |
      UIRemoteNotificationTypeAlert)];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    restoring=FALSE;
}





- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //NSLog(@"got auth challange");
    
    if ([challenge previousFailureCount] == 0) {
        //NSLog(@"here!!");
        //authed = YES;
        
        authChallenge=challenge;//globalize it..
        
        /* SET YOUR credentials, i'm just hard coding them in, tweak as necessary */
        //[[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"webshell" password:@"starbucks" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
        
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"login"
                                  message:@"enter credentials"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Login", nil];
        
        [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        alertView.delegate=self;
        
        [alertView show];
        
        
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    //NSLog(@"buttonIndex is %i",buttonIndex);
    if(buttonIndex==0) return; //user canceled;
    
    UITextField *username = [alertView textFieldAtIndex:0];
    UITextField *password = [alertView textFieldAtIndex:1];
    [[authChallenge sender] useCredential:[NSURLCredential credentialWithUser:username.text password:password.text persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:authChallenge];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //int code = [httpResponse statusCode];
    authed=TRUE;
    [self loadUrl:self.txtUrl.text];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //NSLog(@"connection error is %@", [error description]);
    
    if([error code]==-1012){
        //lets try it again.
        [self loadUrl:self.txtUrl.text];
        
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *err = [error localizedDescription];
        
        if([error code]==-1001){
            return;
        }
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error".translate message:err delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK".translate, nil];
        [alert show];
        
    }
    
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    return NO;
}


-(void)loadMenu:(id)sender{
    
    
    BOOL rightMenu = [[prefs objectForKey:@"menuPosition"] isEqualToString:@"right"];
    
    if(menuLoaded){
        
        [UIView animateWithDuration:1.0
                         animations:^{menuTable.view.alpha = 0;}
                         completion:^(BOOL finished){
                             [menuTable.view removeFromSuperview];
                             menuLoaded=FALSE;
                         }];
        
    }else{
        int width=200;
        int height=300;
        
        CGRect menuFrame = CGRectMake(5, self.navBar.frame.size.height, width, height);
        
        if (rightMenu) {
            menuFrame=CGRectMake(self.view.bounds.size.width -205, self.navBar.frame.size.height, width, height);
        }
        
        
        self.menuTable = [[UIMenuTable alloc] initWithStyle:UITableViewStylePlain];
        self.menuTable.data=navActions;
        self.menuTable.view.frame=menuFrame;
        
        self.menuTable.view.backgroundColor=[UIColor whiteColor];
        self.menuTable.view.layer.cornerRadius=4.0f;
        self.menuTable.view.layer.borderWidth=1.0f;
        self.menuTable.view.alpha=0.0;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view addSubview:self.menuTable.view];
            self.menuTable.view.alpha=1.0;
            
        }];
        menuLoaded=TRUE;
        
        
    }
    
}


-(IBAction)loadSettings:(id)sender{
    //NSLog(@"loading settings");
    
    if(menuLoaded){
        
        //NSLog(@"trying to fadeout");
        
        [UIView animateWithDuration:0.5
                         animations:^{menuTable.view.alpha = 0;}
                         completion:^(BOOL finished){
                             [menuTable.view removeFromSuperview];
                             menuLoaded=FALSE;
                         }];
        
    }else{
        
        int height=350;
        if(self.interfaceOrientation!=UIInterfaceOrientationPortrait){
            if([UIHelper iphone]){
                height=250;
            }
        }
        
        UIButton *btn = sender;
        int yaxis = self.toolBar.frame.origin.y -height;
        int xaxis =0;
        if (UIUserInterfaceIdiomPad==device.userInterfaceIdiom) {
            xaxis = btn.frame.origin.x  -70;
        }else{
            xaxis =btn.frame.origin.x / 2;
        }
        
        
        
        CGRect menuFrame = CGRectMake(xaxis, yaxis, 200, height);
        
        
        self.menuTable = [[UIMenuTable alloc] initWithStyle:UITableViewStylePlain];
        self.menuTable.data=settings;
        self.menuTable.view.frame=menuFrame;
        
        self.menuTable.view.backgroundColor=[UIColor whiteColor];
        self.menuTable.view.layer.cornerRadius=4.0f;
        self.menuTable.view.layer.borderWidth=1.0f;
        
        self.menuTable.view.alpha=0.0;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view addSubview:self.menuTable.view];
            self.menuTable.view.alpha=1.0;
            
        }];
        
        menuLoaded=TRUE;
    }
    
}

-(void)addURLBookmark:(NSString*) url title:(NSString*)title{
    NSDictionary *entry = [[NSDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",url,@"url",title,@"title",[NSDate date],@"date",@"GET",@"httpMethod" ,nil];
    
    // NSLog(@"bookmark entry is %@", [entry description]);
    
    int index = -1;
    int cntr = 0;
    
    for (id object in bookmarks){
        NSDictionary *storedEntry = object;
        if([[storedEntry getString:@"url"] isEqualToString:[entry getString:@"url"]]){
            index = cntr;
        }
        cntr ++;
    }
    
    if(index > -1){
        [bookmarks removeObjectAtIndex:index];
    }
    
    [bookmarks insertObject:entry atIndex:0];
    
    // NSLog(@"storing bookmarks");
    [prefs setObject:bookmarks forKey:USER_PREFS_BOOKMARK];
}


-(void)addURLHistory:(NSString*) url title:(NSString *)title{
    NSDictionary *entry = [[NSDictionary alloc] initWithObjectsAndKeys:CMD_NAVIGATE,@"action",url,@"url",title,@"title",[NSDate date],@"date",@"GET",@"httpMethod" ,nil];
    
    int index = -1;
    int cntr = 0;
    
    for (id object in history){
        NSDictionary *storedEntry = object;
        if([[storedEntry getString:@"url"] isEqualToString:[entry getString:@"url"]]){
            index = cntr;
        }
        cntr ++;
    }
    
    if(index > -1){
        [history removeObjectAtIndex:index];
    }
    
    
    [history insertObject:entry atIndex:0];
    if (history.count >=MAX_HISTORY_ALLOWED) {
        [history removeLastObject];
    }
    
    //NSLog(@"history.count is %i", history.count);
    
    [prefs setObject:history forKey:USER_PREFS_HISTORY];
}

-(void)addLocationCallBack:(NSDictionary*)action title:(NSString*)title{
    
    NSString *url = [action getString:@"url"];
    
    NSString *httpMethod =[action getString:@"httpMethod"];
    
    NSString *distanceFilter = [action getString:@"distanceFilter"];
    NSMutableDictionary *entry = [[NSMutableDictionary alloc] initWithObjectsAndKeys:CMD_SEND_LOCATION,@"action",url,@"url",title,@"title",[NSDate date],@"date",httpMethod,@"httpMethod" ,distanceFilter, @"distanceFilter",nil];
    
    int index = -1;
    int cntr = 0;
    
    for (id object in locationCallBacks){
        NSMutableDictionary *storedEntry = object;
        if([[storedEntry getString:@"url"] isEqualToString:[entry getString:@"url"]]){
            index = cntr;
        }
        cntr ++;
    }
    
    if(index > -1){
        [locationCallBacks removeObjectAtIndex:index];
    }
    
    
    [locationCallBacks insertObject:entry atIndex:0];
    if (locationCallBacks.count >=MAX_HISTORY_ALLOWED) {
        [locationCallBacks removeLastObject];
    }
    
    //NSLog(@"locationCallBacks.count is %i", locationCallBacks.count);
    
    [prefs setObject:locationCallBacks forKey:USER_PREFS_LOCATION_CALLBACKS];
}

-(void)clearURLHistory{
    [history removeAllObjects];
    [prefs removeObjectForKey:@"history"];
    [prefs synchronize];
}

-(void)clearCache{
    //clear all the browser cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //clear all the files in the cache folder
    [FileUtils purgeCachedFiles];
    
    //clear out docs.
    [FileUtils purgeDocuments];
}


-(void)loadTranslation:(NSString*)url{
    
    // [spinner setMsg:@"translating..."];
    // [spinner startAnimating];
    
    HTTPUtils *http = [[HTTPUtils alloc] init];
    http.callBack=@selector(onTranslationResponse:);
    http.callBackOwner=self;
    [http doGet:url params:nil];
    
}

-(void)onTranslationResponse:(NSData*)jsondata{
    NSDictionary *translation = [JSONUtils convertJSONToDictionary:jsondata];
    if(translation!=nil){
        [[CacheManager appCache] setObject:translation forKey:@"translation"];
    }
    [self loadSettingsData];//refresh the settings.
    
}

-(void)loadSettingsData{
    
    [settings removeAllObjects];
    
    NSDictionary *historySetting = [[NSDictionary alloc] initWithObjectsAndKeys:@"history",@"action",@"history".translate,@"label",@"",@"url",@"history.png",@"imageUrl",@"GET",@"httpMethod" ,nil];
    
    
    NSDictionary *bookMark = [[NSDictionary alloc] initWithObjectsAndKeys:CMD_BOOKMARK,@"action",@"bookmark".translate,@"label",@"",@"url",@"bookmark.png",@"imageUrl",@"GET",@"httpMethod" ,nil];
    
    
    NSDictionary *bookMarkList = [[NSDictionary alloc] initWithObjectsAndKeys:CMD_BOOKMARK_LIST,@"action",@"bookMarkList".translate,@"label",@"",@"url",@"bookmarks.png",@"imageUrl",@"GET",@"httpMethod" ,nil];
    
    
    NSDictionary *refreshSetting = [[NSDictionary alloc] initWithObjectsAndKeys:@"refresh",@"action",@"refresh".translate,@"label",@"",@"url",@"refresh-dark.png",@"imageUrl",@"GET",@"httpMethod",@"true",@"isSetting", nil];
    
    
    NSDictionary *downloads = [[NSDictionary alloc] initWithObjectsAndKeys:@"downloadHistory",@"action",@"downloadHistory".translate,@"label",@"",@"url",@"downloads.png",@"imageUrl",@"GET",@"httpMethod",@"true",@"isSetting", nil];
    
    NSDictionary *clearHistory = [[NSDictionary alloc] initWithObjectsAndKeys:@"clearHistory",@"action",@"clearHistory".translate,@"label",@"",@"url",@"remove.png",@"imageUrl",@"GET",@"httpMethod",@"true",@"destructive",@"true",@"isSetting", nil];
    
    //build up the actionsCanceled.
    actionsCanceled = [[NSDictionary alloc] initWithObjectsAndKeys:@"actionsCanceled",@"action",@"actionsCanceled".translate,@"label",@"http://apple.com",@"url",@"",@"imageUrl",@"GET",@"httpMethod",@"false",@"destructive",@"true",@"isSetting", nil];
    
    //build up the actionsCanceled.
    NSDictionary *restoreDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:@"restoreDefaults",@"action",@"restoreDefaults".translate,@"label",@"http://apple.com",@"url",@"ok.png",@"imageUrl",@"GET",@"httpMethod",@"false",@"destructive",@"true",@"isSetting", nil];
    
    
    //email link to someone
        NSDictionary *emailLink = [[NSDictionary alloc] initWithObjectsAndKeys:@"emailLink",@"action",@"emailLink".translate,@"label",@"",@"url",@"mail.png",@"imageUrl",@"GET",@"httpMethod",@"true",@"isSetting", nil];
    
    
    [settings addObject:clearHistory];
    [settings addObject:restoreDefaults];
    [settings addObject:refreshSetting];
    [settings addObject:historySetting];
    [settings addObject:downloads];
    [settings addObject:bookMarkList];
    [settings addObject:bookMark];
    [settings addObject:emailLink];
    
}

-(void)restoreDefaults{
    [prefs setValue:@"#CCCCCC" forKey:@"hexColor"];
    [prefs setValue:@"false" forKey:@"fullScreen"];
    [prefs setValue:@"Courier" forKey:@"font"];
    [prefs setValue:@"13" forKey:@"fontSize"];
    [prefs setValue:@"#000000" forKey:@"fontColor"];
    [prefs setValue:@"dark" forKey:@"buttonShade"];
    [prefs setValue:@"#FFFFFF" forKey:@"backgroundColor"];
    [prefs setValue:@"right" forKey:@"menuPosition"];
    [prefs synchronize];
    [self applyTheme];
}


// From within your active view controller

-(void)sendLink{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setMessageBody:self.txtUrl.text isHTML:NO];
        [self presentModalViewController:mailCont animated:YES];
    }else{
        [UIHelper fadeInMessage:self.view text:@"emailNotSetup".translate];
    }
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}


-(void) validateApiKey:(NSString*)apikey{
    HTTPUtils *http = [[HTTPUtils alloc] init];
    http.callBackOwner=self;
    http.callBack=@selector(onLicenseValidation:);
    NSMutableString *params = [[NSMutableString alloc] initWithString:@"apikey="];
    [params appendString:apikey];
    
}

@end
