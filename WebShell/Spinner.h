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
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "UIHelper.h"
#import "NSString+Translate.h"

@interface Spinner : UIView{
    
    UIActivityIndicatorView *spinner;
    UILabel *lblMsg;
}

@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UILabel *lblMsg;

-(void) setMsg:(NSString *)message;
-(void) addToView:(UIView*)view;
-(void) start;
-(void) stop;

-(void) startAnimating;
-(void) stopAnimating;


@end
