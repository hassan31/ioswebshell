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

#import "UIHelper.h"

@implementation UIHelper{
    
}

+(void)setNavBarColorScheme:(UINavigationBar *)navBar{

    UIColor *color = [UIHelper themeColor];
    if(color==nil){
        color = NAV_BAR_COLOR;
    }
    
    if ([UIHelper iosVersion] >=7) {
        navBar.barTintColor = color;
        navBar.tintColor=color;
        navBar.translucent=NO;
    }else{
        navBar.tintColor = color;
        navBar.translucent=NO;
    }
    

}

+(void)setToolBarColorScheme:(UIToolbar *)toolBar{
    UIColor *color = [UIHelper themeColor];
    if(color==nil){
        color = NAV_BAR_COLOR;
    }
    if ([UIHelper iosVersion] >=7) {
    	toolBar.barTintColor = color;
        toolBar.translucent=NO;
    }else{
        toolBar.tintColor = color;
        toolBar.translucent=NO;
    }

}


+(void)setSearchBarColorScheme:(UISearchBar *)searchBar{

    UIColor *color = [UIHelper themeColor];
    if(color==nil){
        color = NAV_BAR_COLOR;
    }
    
	searchBar.tintColor = color;
	searchBar.translucent=YES;
}




//search for existence of substring in string;
+(BOOL) contains:(NSString *)_source searchFor:(NSString *)_target{
	BOOL b=TRUE;
	
	if(NSEqualRanges(NSMakeRange(NSNotFound, 0), [_source rangeOfString:_target])){
		b=FALSE;
	}
	
	return b;	
}



+(UIImage*) imageFromStatus:(NSString*) statusCode{
    
    
    /*
     UIImage *img = nil;
     
     if ([statusCode isEqualToString:STATUS_CODE_WESTON]) {
     img = [UIImage imageNamed:@"warehouse.png"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_SHIP_CHANGE]){
     img=[UIImage imageNamed:@"warning.png"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_ONHOLD]){
     img=[UIImage imageNamed:@"warning.png"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_CANCELLED]){
     img = [UIImage imageNamed:@"error.png"];
     
     }else if([statusCode isEqualToString:STATUS_DELIVERY_CONFIRMATION]){
     img = [UIImage imageNamed:@"ok.png"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_VENDOR_SHIPPED]){
     img=[UIImage imageNamed:@"shipped"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_SHIPPED_TO_SHIP]){
     img=[UIImage imageNamed:@"shiptoship.png"];
     
     }else if([statusCode isEqualToString:STATUS_CODE_IMPORTED]){
     img=[UIImage imageNamed:@"Database.png"];
     }
     
     else{
     img = [UIImage imageNamed:@"86-camera.png"];
     }
     */
    
    return nil;
    
}


+(void)adjustWidth:(UIView *)view width:(int)width{
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, width,view.frame.size.height);
}

+(void)adjustHeight:(UIView *)view height:(int)height{
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,height);
}

+(void)adjustHeightAndWidth:(UIView *)view height:(int)height width:(int)width{
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, height,width);
}

+(void)fadeInOnTopMessage:(UIView *)view text:(NSString *)text{
    UIFadeLabel *lbl = [[UIFadeLabel alloc] init];
    lbl.fadeOutSeconds=4;
    lbl.text=text;
    [lbl fadeInTop:view];
}

+(void) fadeInMessage:(UIView*) view text:(NSString*)text{
    UIFadeLabel *lbl = [[UIFadeLabel alloc] init];
    lbl.fadeOutSeconds=4;
    lbl.text=text;
    [lbl fadeIn:view];

}

+(void) fadeInMessage:(UIView*) view text:(NSString*)text backgroundColor:(UIColor*)backgroundColor fontColor:(UIColor*)fontColor{
    UIFadeLabel *lbl = [[UIFadeLabel alloc] init];
    lbl.fadeOutSeconds=4;
    lbl.text=text;
    lbl.backgroundColor=backgroundColor;
    lbl.textColor=fontColor;
    [lbl fadeIn:view];
}

+(void) fadeInValidationMessage:(UIView*) view text:(NSString*)text{
    UIFadeLabel *lbl = [[UIFadeLabel alloc] init];
    lbl.fadeOutSeconds=4;
    lbl.text=text;
    lbl.backgroundColor=[UIColor redColor];
    [lbl fadeIn:view];
}

+(void) fadeInTimedMessage:(UIView*) view text:(NSString*)text seconds:(int)seconds{
    UIFadeLabel *lbl = [[UIFadeLabel alloc] init];
    lbl.fadeOutSeconds=seconds;
    lbl.text=text;
    [lbl fadeIn:view];
}


+(void)hideKeyboard{
    NSArray *arrWindows = [[UIApplication sharedApplication] windows];
    if ([arrWindows count] > 1) {
        UIWindow *keyboardWindow = [arrWindows objectAtIndex:1];
        [keyboardWindow setHidden:YES];
    }
}

+(void)setButtonTitle:(UIButton *)btn title:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateReserved];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateDisabled];
}


+(void)fadeToController:(UIViewController*) source navController:(UIViewController*)target segue:(NSString*) segue{
    [source.view addSubview:target.view];
    [target.view setFrame:source.view.window.frame];
    [target.view setTransform:CGAffineTransformMakeScale(0.5,0.5)];
    [target.view setAlpha:1.0];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [target.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                         [target.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [target.view removeFromSuperview];
                         [source.navigationController pushViewController:target animated:NO];
                     }];
}



+(void)applyTheme:(NSString*)hexColor font:(NSString*)font{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:hexColor forKey:@"hexColor"];
    [prefs setObject:font forKey:@"font"];
    [prefs synchronize];
}

+(UIColor*) themeColor{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *hexColor= [prefs objectForKey:@"hexColor"];
    UIColor *color = NAV_BAR_COLOR;
    if(hexColor!=nil && ![hexColor isEqualToString:@""]){
        
        if (![hexColor hasPrefix:@"#"]) {
            color = BLUE_COLOR;
        }else{
            color = [UIColor colorWithHexString:hexColor];
        }
        
        
    }
    
    return color;
    
}

+(UIFont*) themeFont{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *font= [prefs objectForKey:@"font"];   
    UIFont *uiFont = APP_FONT;
    if (font!=nil  && ![@"" isEqualToString:font]) {
        NSString *fontSize = [prefs objectForKey:@"fontSize"];
        uiFont = [UIFont fontWithName:font size:[fontSize intValue]];
    }
    return uiFont;
}


+(void) centerXView:(UIView *)view{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = view.frame;
                         UIView *parentView = view.superview;
                         r.origin = parentView.bounds.origin;
                         r.origin.x = parentView.bounds.size.width / 2  - r.size.width / 2;
                         r.origin.y = view.frame.origin.y;
                         //view.frame = r;
                         [view setFrame:CGRectIntegral(r)];
                     }
                     completion:^(BOOL finished){
                         
                     }];

}

+(void) centerYView:(UIView *)view{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect r = view.frame;
                         UIView *parentView = view.superview;
                         r.origin = parentView.bounds.origin;
                         r.origin.y = parentView.bounds.size.height / 2  - r.size.height / 2;
                         r.origin.x = view.frame.origin.x;
                         //view.frame = r;
                         [view setFrame:CGRectIntegral(r)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

+(CGFloat)screenWidth{
    CGRect frame = [[UIScreen mainScreen] bounds];
    return frame.size.width;
}


+(CGFloat)screenHeight{
    CGRect frame = [[UIScreen mainScreen] bounds];
    return frame.size.height;
}



+(void)applyColorsAndFonts:(UIView*)view{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *fontColor = [prefs objectForKey:@"fontColor"];
    
    
    if ([view isKindOfClass:[Spinner class]]) {
        return;//we dn't want this modified.
    }
    
    for(UIView *v in [view subviews]) {
        if([v isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField*)v;
           field.font=[UIHelper themeFont];
            field.textColor=[UIColor blackColor];

            
            
        }else if([v isKindOfClass:[UILabel class]]){
            if (![[v superview] isKindOfClass:[UITextField class]]) {
                UILabel *label = (UILabel*)v;
                label.font=[UIHelper themeFont];
                label.textColor=[UIColor colorWithHexString:fontColor];
            }

            
        }else if([v isKindOfClass:[UINavigationBar class]]){
            [UIHelper setNavBarColorScheme:(UINavigationBar*)v];
            
            
        }else if([v isKindOfClass:[UIToolbar class]]){
            [UIHelper setToolBarColorScheme:(UIToolbar*)v];
            
        }
        
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                    UITextAttributeTextColor: [UIColor colorWithHexString:fontColor],
                             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                         UITextAttributeFont: [UIHelper themeFont],
         }];
        
        
        [UIHelper applyColorsAndFonts:v];
    }
    
}

+(UIView*)findFirstInstance:(UIView*)view cls:(Class)cls{
    UIView *target = nil;
    for(UIView *v in [view subviews]) {
        //NSLog(@"class is %@",[[v class] description]);
        if([v isKindOfClass:cls]){
           // NSLog(@"found class!!!");
            target = v;
            break;
            
        }else{
            target = [UIHelper findFirstInstance:v cls:cls];
        }
    }
    
    return target;
}


+(UIView*)findByTag:(UIView*)view tag:(NSInteger)tag{
    UIView *target = nil;
    for(UIView *v in [view subviews]) {
        if(v.tag==tag){
            target = v;
            break;
            
        }else{
            target = [UIHelper findByTag:v tag:tag];
        }
    }
    
    return target;
}


+(void)findAllInstances:(UIView*)view cls:(Class)cls arr:(NSMutableArray*)arr{
    for(UIView *v in [view subviews]) {
       // NSLog(@"class is %@",[[v class] description]);
        if([v isKindOfClass:cls]){
            [arr addObject:v];
        }else{
            [UIHelper findAllInstances:v cls:cls arr:arr];
        }
    }
}

+(void)centerView:(UIView *)view{
    UIView *parent = [view superview];
    view.center = [parent convertPoint:parent.center fromView:parent.superview];
}

+(UIStoryboard*) storyboard{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIDevice *device = [UIDevice currentDevice];
    
    if (UIUserInterfaceIdiomPad==device.userInterfaceIdiom) {
        storyboard=[UIStoryboard storyboardWithName:@"iPadStoryBoard" bundle:nil];
    }
    
    return storyboard;
}


+(BOOL) ipad{
    UIDevice *device = [UIDevice currentDevice];
    return (UIUserInterfaceIdiomPad==device.userInterfaceIdiom);
}

+(BOOL) iphone{
    UIDevice *device = [UIDevice currentDevice];
    return (UIUserInterfaceIdiomPhone==device.userInterfaceIdiom);
}


+(float) iosVersion{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    return sysVer;
}

@end
