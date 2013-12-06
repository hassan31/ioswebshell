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
#import "JSONUtils.h"
#import "NSMutableDictionary+SafeMethods.h"
#import "Constants.h"
#import "UIParent.h"
#import "CacheManager.h"
#import "UIHelper.h"
#import "UIMenuTable.h"
#import <QuartzCore/QuartzCore.h>
#import "FileUtils.h"
#import "NSMutableArray+Utils.h"
#import "UIHistory.h"
#import "LocationService.h"
#import "StringUtils.h"
#import "ActionValidator.h"
#import "Spinner.h"
#import "LocationUtils.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface WebShellViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate, UIScrollViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
    UITextField *txtUrl;
    NSString *currentUrl;
    UINavigationBar *navBar;
    UIWebView *webView;
    UIToolbar *toolBar;
    NSMutableArray *navActions;
    NSMutableArray *actions;
    NSMutableDictionary *selectedAction;
    UIActionSheet *actionSheet;
    UIButton *btnRestore;
    UIButton *btnActions;
    UIButton *btnForward;
    UIButton *btnBackward;
    UIButton *btnRefresh;
    UIButton *btnSettings;
    UIButton *btnStop;
    UIButton *btnToggleFullScreen;
    UIButton *btnMenu;
    CGRect defaultWebViewFrame;
    NSString *jsonResponse;//json response from modal view controllers.
    BOOL fullScreen;
    BOOL restoring;
    BOOL authed;
    BOOL menuLoaded;
    NSURLAuthenticationChallenge *authChallenge;
    UIMenuTable *menuTable;
    NSMutableArray *bookmarks;//no cap on this one.
    NSMutableArray *history; //only recent history (about 100 pages maintained)
    NSMutableArray *locationCallBacks; //only recent history (about 100 pages maintained)
    NSUserDefaults *prefs;
    NSMutableArray *settings;
    NSString *pageTitle;
    ActionValidator *validator;
    NSDictionary *actionsCanceled;
    Spinner *spinner;
    UIDevice *device;
    NSString *downloadUrl;
    UIActivityIndicatorView *loading;
    
}

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *loading;

@property(nonatomic,retain) NSString *downloadUrl;

@property(nonatomic,retain) Spinner *spinner;

@property(nonatomic,readwrite) BOOL menuLoaded;

@property(nonatomic,retain) UIMenuTable *menuTable;

@property(nonatomic,retain) IBOutlet UINavigationBar *navBar;

@property(nonatomic,retain) IBOutlet UITextField *txtUrl;

@property(nonatomic,retain) IBOutlet UIWebView *webView;

@property(nonatomic,retain) IBOutlet UIToolbar *toolBar;

@property(nonatomic,retain) IBOutlet UIButton *btnRestore;

@property(nonatomic,retain) IBOutlet UIButton *btnMenu;

@property(nonatomic,retain) IBOutlet UIButton *btnFullScreen;

@property(nonatomic,retain) IBOutlet UIButton *btnActions;

@property(nonatomic,retain) IBOutlet UIButton *btnForward;

@property(nonatomic,retain) IBOutlet UIButton *btnRefresh;

@property(nonatomic,retain) IBOutlet UIButton *btnSettings;

@property(nonatomic,retain) IBOutlet UIButton *btnBackward;

@property(nonatomic,retain) IBOutlet UIButton *btnStop;

@property(nonatomic,retain) UIActionSheet *actionSheet;

@property(nonatomic,retain) NSString *jsonResponse;

@property(nonatomic,retain) NSString *currentUrl;

@property(nonatomic,retain) NSMutableArray *history;//array of dictionary objects.

@property(nonatomic,retain) NSMutableArray *bookmarks;//array of dictionary objects.

@property(nonatomic,retain) NSMutableArray *locationCallBacks;//array of dictionary objects.

@property(nonatomic,retain) NSMutableArray *actions;//array of dictionary objects.

@property(nonatomic,retain) NSMutableArray *navActions;//array of dictionary objects.

@property(nonatomic,retain) NSMutableDictionary *selectedAction;//action selected from the action sheet.

-(IBAction)loadMenu:(id)sender;//loads the menu of segmented controls.

-(IBAction)refreshPage:(id)sender;//called by btnRefresh (refreshes/reloads the current page)

-(IBAction)toggleFullScreen:(id)sender;//toggles fullscreen mode.

-(IBAction)loadActionSheet:(id)sender;//loads the action sheet

-(IBAction)backward:(id)sender;//loads the action sheet

-(IBAction)forward:(id)sender;//loads the action sheet

-(IBAction)stop:(id)sender;//loads the action sheet

-(void) setButtonStates;

-(void) loadUrl:(NSString*) url;

-(void)handleResponse:(NSNotification *)notification;

-(void)handleNavigation:(NSNotification *)notification;

-(void)handleLocationChange:(NSNotification *)notification;

-(void)executeAction:(NSMutableDictionary*) action;

-(void)registerForPush;

-(void) applyTheme;

-(void)simpleMethod;

-(void) processJsonResponse;

-(void)addURLHistory:(NSString*) url title:(NSString*)title;

-(void)addURLBookmark:(NSString*) url title:(NSString*)title;

-(void)addLocationCallBack:(NSDictionary*)action title:(NSString*)title;

-(void)clearURLHistory;

-(IBAction)loadSettings:(id)sender;

-(void)loadTranslation:(NSString*)url;

-(void)onTranslationResponse:(NSString*)json;

-(void)loadSettingsData;

-(void) restoreDefaults;

-(void) sendLink;


@end
