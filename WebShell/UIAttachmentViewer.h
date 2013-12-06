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
#import "UIHelper.h"
#import "Spinner.h"

@interface UIAttachmentViewer : UIViewController<UIWebViewDelegate, UIGestureRecognizerDelegate>{
    UIWebView *webView;
    NSURL *url;
    UILabel *lblTitle;
    UINavigationBar *navBar;
    UIToolbar *toolBar;
    UIButton *btnClose;
    UIButton *btnRotate;
    
    Spinner *spinner;
    
    CGRect buttonPosition;
    
    BOOL photo;
    
}
@property(nonatomic,readwrite) BOOL photo;
@property(nonatomic,retain) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain) IBOutlet UINavigationBar *navBar;
@property(nonatomic,retain) IBOutlet UIToolbar *toolBar;
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) IBOutlet UIButton *btnClose;
@property(nonatomic,retain) IBOutlet UIButton *btnRotate;
@property(nonatomic,retain) NSURL *url;
@property(nonatomic,retain) Spinner *spinner;
-(IBAction)close:(id)sender;
-(IBAction)rotate:(id)sender;



@end
