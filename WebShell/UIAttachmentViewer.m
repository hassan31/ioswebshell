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

#import "UIAttachmentViewer.h"
#import "UIImage+Scale.h"

@implementation UIAttachmentViewer

@synthesize webView,url,spinner,navBar,lblTitle,btnClose,photo,btnRotate,toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.spinner=[[Spinner alloc]init];
    [self.spinner addToView:self.view];
    [self.spinner setMsg:@"..."];
    
    buttonPosition=btnClose.frame;
    
    [UIHelper setNavBarColorScheme:self.navBar];
    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.webView.scalesPageToFit=TRUE;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    if(self.photo){
        self.btnRotate.hidden=FALSE;
    }else{
        self.btnRotate.hidden=TRUE;
    }
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    btnClose.frame=CGRectMake(0, 0, btnClose.frame.size.width, btnClose.frame.size.height);

    return YES;
}

-(IBAction)close:(id)sender{
    [self dismissModalViewControllerAnimated:TRUE];
}

-(IBAction)rotate:(id)sender{
    UIImage *img = [UIImage imageWithContentsOfFile:[url path]];
    
    img=[img rotateByDegrees:90.0];
    
    NSData *data = UIImagePNGRepresentation(img);
    
    [data writeToURL:self.url atomically:YES];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [spinner setMsg:@"rotating..."];
    
    [spinner startAnimating];
    
}

//webviewdelegate methods
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [spinner stopAnimating];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.spinner startAnimating];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidScrollToTop");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewWillBeginDragging");
}


@end
