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

#import "Spinner.h"

@implementation Spinner

@synthesize lblMsg,spinner;


-(id)init{
    self = [super init];
	if (!self) return nil;
    
    
    self.frame=CGRectMake(0, 0, 110, 100);
    
    self.backgroundColor=[UIColor blackColor];
    
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center=self.center;
    
    [UIHelper centerXView:self];
    
    [self.spinner startAnimating];
    
    [self addSubview:self.spinner];
    
    self.lblMsg = [ [UILabel alloc ] initWithFrame:CGRectMake(0.0, 80, 110.0, 15.0) ];
    lblMsg.textAlignment =  UITextAlignmentCenter;
    lblMsg.textColor = [UIColor whiteColor];
    lblMsg.backgroundColor = [UIColor clearColor];
    lblMsg.font = APP_FONT;
    [self addSubview:lblMsg];
    lblMsg.text = @"...";
    self.layer.cornerRadius=10.0f;
    return self;
}

-(void) setMsg:(NSString *)message{

    lblMsg.text=message;
}

-(void) addToView:(UIView*)view{
    self.center=view.center;
    [view addSubview:self];
    self.hidden=TRUE;
    
}

-(void)start{
    [UIHelper centerView:self];
    self.hidden=FALSE;
}

-(void)stop{
    self.hidden=TRUE;
    self.lblMsg.text=@"...";
}

-(void) startAnimating{
    
    [self start];
}
-(void) stopAnimating{
    [self stop];
    
}

@end
