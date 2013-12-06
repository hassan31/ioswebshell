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
#import "Spinner.h"
#import "FileUtils.h"
#import "UIParent.h"
#import "ArrayUtils.h"

@interface UIDownloadHistory : UIParent <NSURLConnectionDataDelegate, UITableViewDelegate>{
    NSMutableData *fileData;
    NSURL *url;
    UILabel *state;
    NSNumber *fileSize;
    NSString *fileSizeDesc;
    NSURLConnection *conn;
    UIButton *btnEdit;
    UITableView *tableView;
    NSMutableArray *files;
    int cntr;

}

@property(nonatomic,retain) NSMutableArray *files;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSURLConnection *conn;
@property(nonatomic,retain) IBOutlet UILabel *state;
@property(nonatomic,retain) NSMutableData *fileData;
@property(nonatomic,retain) NSURL *url;
@property(nonatomic,retain) IBOutlet UIButton *btnEdit;

-(void)loadDocuments;
-(IBAction)editTable:(id)sender;
-(IBAction)upload:(id)sender;

@end
