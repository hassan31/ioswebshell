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

#import "UIMenuTable.h"


@implementation UIMenuTable

@synthesize data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [UIHelper applyColorsAndFonts:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"number of rows in section is %i",data.count);
    return data.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //NSLog(@"will display cell");
    cell.textLabel.font = [UIHelper themeFont];
    cell.detailTextLabel.font = [UIHelper themeFont];
    
    cell.textLabel.adjustsFontSizeToFitWidth=TRUE;
    cell.detailTextLabel.adjustsFontSizeToFitWidth=TRUE;
    
    
     NSDictionary *row = [data objectAtIndex:indexPath.row];
    
    //NSLog(@"row %@", [row description]);
    
    if([[row getString:@"destructive"] isEqualToString:@"true"]){
        //NSLog(@"is destructive");
        cell.backgroundColor=[UIColor redColor];
        cell.textLabel.textColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray]; 
    }
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"tableId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *row = [data objectAtIndex:indexPath.row];
    cell.textLabel.text =[row getString:@"label"];
    

    NSString *strurl = [row getString:@"imageUrl"];
    
    if([strurl hasPrefix:@"http"]){
        [cell loadImage:strurl];
    }else{
        cell.imageView.image=[UIImage imageNamed:strurl];
    }
    


    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *action = [data objectAtIndex:indexPath.row];    
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_NAVIGATE object:action];
    [self.view removeFromSuperview];
}

@end
