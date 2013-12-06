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
#import "HTTPUtils.h"
#import "NSData+Base64.h"
#import "NSMutableDictionary+SafeMethods.h"
#import "Constants.h"
#import "UIHelper.h"
#import "Spinner.h"
#import "NSString+Translate.h"

@class WebShellViewController;

@interface UIParent : UIViewController <UIActionSheetDelegate>{
    NSMutableDictionary *action;

    UIButton *btnClose;
    UIButton *btnUpload;
    
    UINavigationBar *navBar;
    UILabel *lblTitle;
    UIToolbar *toolBar;
    BOOL dirty;
    WebShellViewController *webShell;
    NSData *data;
    Spinner *spinner;
    NSUserDefaults *prefs;
    BOOL isdark;
    UIPopoverController *popover;
    CGPoint touchPoint;
}
@property(nonatomic,retain) IBOutlet UIButton *btnClose;

@property(nonatomic,retain) IBOutlet UIButton *btnUpload;

@property(nonatomic,retain) UIPopoverController *popover;

@property(nonatomic,retain) Spinner *spinner;

@property(nonatomic,retain) WebShellViewController *webShell;

@property(nonatomic,retain) NSMutableDictionary *action;

@property(readwrite) BOOL dirty;

@property(nonatomic,retain) IBOutlet UILabel *lblTitle;

@property(nonatomic,retain) IBOutlet UINavigationBar *navBar;

@property(nonatomic,retain) IBOutlet UIToolbar *toolBar;

@property(nonatomic,retain) NSData *data;//final data to push back to server via REST.

-(IBAction)close:(id)sender;

-(IBAction)save:(id)sender;

-(void) loadDirtyActions;

-(void)onResponse:(NSData *)jsonData;

@end
