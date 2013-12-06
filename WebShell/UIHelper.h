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
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "NSMutableDictionary+SafeMethods.h"
#import "Cache.h"
#import "UIFadeLabel.h"
#import "UIColor+HexString.h"
#import "CacheManager.h"
#import "Spinner.h"
#import "StringUtils.h"


@interface UIHelper : NSObject{
    
}

+(void)applyColorsAndFonts:(UIView*)view;

+(void)setNavBarColorScheme:(UINavigationBar *)navBar;

+(void)setToolBarColorScheme:(UIToolbar *)toolBar;

+(void)setSearchBarColorScheme:(UISearchBar *)searchBar;

+(BOOL) contains:(NSString *)_source searchFor:(NSString *)_target;

+(UIImage*) imageFromStatus:(NSString*) statusCode;

+(void) adjustWidth:(UIView*) view width:(int)width;

+(void) adjustHeight:(UIView*) view height:(int)height;

+(void) adjustHeightAndWidth:(UIView*) view height:(int)height width:(int)width;

+(void) fadeInOnTopMessage:(UIView*) view text:(NSString*)text;

+(void) fadeInMessage:(UIView*) view text:(NSString*)text;

+(void) fadeInMessage:(UIView*) view text:(NSString*)text backgroundColor:(UIColor*)backgroundColor fontColor:(UIColor*)fontColor;

+(void) fadeInValidationMessage:(UIView*) view text:(NSString*)text;

+(void) fadeInTimedMessage:(UIView*) view text:(NSString*)text seconds:(int)seconds;

+(void)hideKeyboard;

+(void)setButtonTitle:(UIButton*)btn title:(NSString*)title;

+(void)applyTheme:(NSString*)hexColor font:(NSString*)font;

+(UIView*)findFirstInstance:(UIView*)view cls:(Class)cls;

+(UIView*)findByTag:(UIView*)view tag:(NSInteger)tag;

+(void)findAllInstances:(UIView*)view cls:(Class)cls arr:(NSMutableArray*)arr;

+(UIColor*) themeColor;

+(UIFont*) themeFont;

+(void) centerXView:(UIView*)view;

+(void) centerYView:(UIView *)view;

+(void) centerView:(UIView*)view;

+(CGFloat) screenWidth;

+(CGFloat) screenHeight;

+(UIStoryboard*) storyboard;

+(BOOL)ipad;

+(BOOL) iphone;

+(float) iosVersion;

@end
