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

#import "UIWebViewTouch.h"
#import "WebShellViewController.h"

@implementation UIWebViewTouch

@synthesize webshell;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (void)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
   // NSLog(@"hitTest");
    WebShellViewController *w = (WebShellViewController*) self.webshell;
    [w.menuTable.view removeFromSuperview];
    w.menuLoaded=FALSE;
    
    [w.view endEditing:TRUE];
    
    // call the super
    [super hitTest:point withEvent:event];
}
 */

@end
