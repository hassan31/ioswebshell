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

#import "UIFadeLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIFadeLabel

@synthesize fadeOutSeconds;


-(id)init{
	self = [super init];
	if (!self) return nil;
    self.textColor=[UIColor whiteColor];
    self.fadeOutSeconds=2;
    self.font=[UIFont fontWithName:@"TrebuchetMS" size:12];
    self.autoresizingMask=TRUE;
    self.textAlignment=UITextAlignmentCenter;
    self.adjustsFontSizeToFitWidth = YES;
    self.numberOfLines=2;

    
    //set the gradient
    self.backgroundColor=BLUE_COLOR;    
    return self;
}

-(void)fadeInTop:(UIView*)view{
    
    CGRect frame = CGRectMake(0, 0, view.frame.size.width, 50);
    self.frame=frame;
    self.alpha=0.0f;
    [view addSubview:self];
    
    //now lets animate the addition
    [UIView transitionWithView:self duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        
                        self.alpha=1.0f;
                        [NSTimer scheduledTimerWithTimeInterval:fadeOutSeconds
                                                         target:self
                                                       selector:@selector(fadeOut)
                                                       userInfo:nil
                                                        repeats:NO];
                        
                        
                        
                    } completion:NULL];
    
}


-(void)fadeIn:(UIView*)view{
    
    CGRect frame = CGRectMake(0, (view.frame.size.height -50), view.frame.size.width, 50);
    self.frame=frame;
    self.alpha=0.0f;
    [view addSubview:self]; 
    
    //now lets animate the addition
    [UIView transitionWithView:self duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        

                        self.alpha=1.0f;
                        [NSTimer scheduledTimerWithTimeInterval:fadeOutSeconds
                                                         target:self
                                                       selector:@selector(fadeOut)
                                                       userInfo:nil
                                                        repeats:NO];
                        
                        
                        
                    } completion:NULL]; 
    
}



-(void) fadeOut{
    [UIView transitionWithView:self duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        self.alpha=0.0f;
                        
                        
                    } completion:^(BOOL completion){
                        [self removeFromSuperview];
                    }];

}






@end
