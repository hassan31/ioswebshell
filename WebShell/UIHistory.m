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

#import "UIHistory.h"


@implementation UIHistory

@synthesize data,tableView,navBar,toolBar,lblTitle,btnEdit,bookMark,btnClose;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIHelper applyColorsAndFonts:self.view];
    prefs = [NSUserDefaults standardUserDefaults];
    
    
    
    if (bookMark) {
        self.navBar.topItem.title=@"bookmark".translate;
    }else{
        self.navBar.topItem.title=@"history".translate;
    }
    
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    if ([color isEqualToString:@"dark"]) {
        //NSLog(@"setting image to dark");
        [btnEdit setImage:[UIImage imageNamed:@"trash-dark.png"] forState:UIControlStateNormal];
        [btnClose setImage:[UIImage imageNamed:@"close-dark.png"] forState:UIControlStateNormal];
        
    }else{
        [btnEdit setImage:[UIImage imageNamed:@"trash-light.png"] forState:UIControlStateNormal];
        [btnClose setImage:[UIImage imageNamed:@"close-light.png"] forState:UIControlStateNormal];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//**** start of table view delegate methods *****

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIFont *themeFont = [UIHelper themeFont];
    
    cell.textLabel.font = [UIFont fontWithName:themeFont.fontName size:13];
    cell.detailTextLabel.font = [UIFont fontWithName:themeFont.fontName size:10];
    
    //cell.textLabel.adjustsFontSizeToFitWidth=YES;
    //cell.detailTextLabel.adjustsFontSizeToFitWidth=NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"historyTableId";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    //NSLog(@"building cells...");
    NSDictionary *row = [data objectAtIndex:indexPath.row];
    
    NSDate *date = (NSDate*)[row getObjectSafely:@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *strdate =[formatter stringFromDate:date];
    
    NSMutableString *title = [[NSMutableString alloc] init];
    
    if(!bookMark){
        [title appendString:strdate];
        [title appendString:@" "];
    }
    
    [title appendString:[row getString:@"title"]];

    
    
    cell.textLabel.text =title;
    cell.detailTextLabel.text=[row getString:@"url"];
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *action = [data objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_NAVIGATE object:action];
    [self close:nil];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		// Delete the managed object at the given index path.
		NSDictionary *entry = [self.data objectAtIndex:indexPath.row];
        
        [self.data removeObject:entry];
        
        if (bookMark) {
            [prefs setObject:self.data forKey:USER_PREFS_BOOKMARK];
        }else{
            [prefs setObject:self.data forKey:USER_PREFS_HISTORY];
        }
        
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
    }
}

-(IBAction)close:(id)sender{
    [prefs synchronize];
    [self dismissModalViewControllerAnimated:TRUE];
    
}

-(IBAction)clearHistory:(id)sender{
    
}

-(IBAction)editTable:(id)sender{
    self.tableView.editing=!self.tableView.editing;
}

@end
