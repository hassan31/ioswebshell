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

#import "UITableViewCell+ImageLoader.h"

@implementation UITableViewCell (ImageLoader)

-(void)loadImage:(NSString *)myImageUrl{
    HTTPUtils *http = [[HTTPUtils alloc] init];
    http.callBackOwner=self;
    http.callBack=@selector(onResponse:);
    
   // NSLog(@"myImageUrl is %@", myImageUrl);
    [http doGet:myImageUrl params:nil];
}

-(void)onResponse:(NSData*)data{
  //  NSLog(@"title %@",self.textLabel.text);
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image=image;
    [self setNeedsLayout];
}

@end 
