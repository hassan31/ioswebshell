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
#import "Constants.h"
#import "NSMutableDictionary+SafeMethods.h"
#import "UIHelper.h"
#import "NSString+Translate.h"

@interface UIHistory : UIViewController <UITableViewDelegate>{
    UITableView *tableView;
    NSMutableArray *data;
    UINavigationBar *navBar;
    UIToolbar *toolBar;
    UILabel *lblTitle;
    UIButton *btnEdit;
    UIButton *btnClose;
    NSUserDefaults *prefs;
    BOOL bookMark;
    
}
@property(nonatomic, readwrite) BOOL bookMark;
@property(nonatomic,retain) IBOutlet UIButton *btnEdit;
@property(nonatomic,retain) IBOutlet UIButton *btnClose;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) IBOutlet UINavigationBar *navBar;
@property(nonatomic,retain) IBOutlet UIToolbar *toolBar;
@property(nonatomic,retain) IBOutlet UILabel *lblTitle;
@property(nonatomic,retain) NSMutableArray *data;

-(IBAction)close:(id)sender;
-(IBAction)clearHistory:(id)sender;
-(IBAction)editTable:(id)sender;


@end
