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

#import "UIRecordSignature.h"
#import "Constants.h"
#import "UIImage+Scale.h"

@implementation UIRecordSignature

@synthesize viewTitle,drawImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizesSubviews=TRUE;
    
    self.navBar.topItem.title=@"recordSignature".translate;
    
    self.drawImage.backgroundColor=[UIColor lightGrayColor];
    
    
    /*
     MWA: if we want to pull from the cache, uncomment this.
     
    NSData *imgData = [FileUtils retrieveFromCache:FILE_NAME_SIGNATURE];
    
    UIImage *img = [UIImage imageWithData:imgData];
    
   self.drawImage.image=img;
    */
    
	mouseMoved = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIHelper fadeInTimedMessage:self.view text:@"signatureDoubleTap".translate seconds:2];
    
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
    if (touch.view==self.drawImage) {
        if ([touch tapCount] == 2) {
            drawImage.image = nil;
            self.dirty=FALSE;
            return;
        }
        self.dirty=YES;
        lastPoint = [touch locationInView:self.drawImage];
        lastPoint.y -= 20;
    }
    

    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];
    
    if(touch.view==self.drawImage){
        CGPoint currentPoint = [touch locationInView:self.drawImage];
        currentPoint.y -= 20;
        
        
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        [drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
        
      
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
        
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
        
        mouseMoved++;
        
        if (mouseMoved == 10) {
            mouseMoved = 0;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
    
    
    if(touch.view==self.drawImage){
        
        if ([touch tapCount] == 2) {
            drawImage.image = nil;
            return;
        }
        
        
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(self.drawImage.frame.size);
            [drawImage.image drawInRect:CGRectMake(0, 0, self.drawImage.frame.size.width, self.drawImage.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(IBAction)save:(id)sender{
    
    [spinner startAnimating];
    
    [spinner setMsg:@"uploading".translate];
    
    UIImage *img = [UIImage capture:self.drawImage];
    
    NSData *imgData = UIImagePNGRepresentation(img);
    
    [FileUtils saveToCacheFolder:imgData fileName:FILE_NAME_SIGNATURE];
    
    
    //setup the http utils client
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    //set the callback owner to the current view controller
    http.callBackOwner=(NSObject*)self;
    
    //set the call back method (will get called after response recieved to update the UI)
    http.callBack=@selector(onResponse:);
    
    
    //this controller requires UPLOAD action, we will ignore what is set in the config from the server
    //and just use the file upload
    //NSLog(@"upload file to url %@",[action getString:@"url"]);
    [http uploadFile:FILE_NAME_SIGNATURE url:[action getString:@"url"]];

}



@end
