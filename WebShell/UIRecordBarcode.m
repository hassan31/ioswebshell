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

#import "UIRecordBarcode.h"

@interface UIRecordBarcode ()

@end

@implementation UIRecordBarcode

@synthesize readerView,resultText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.topItem.title=@"scanBarcode".translate;
    
    resultText.enabled=FALSE;
        
    //readerView = [ZBarReaderView new];
    ZBarImageScanner * scanner = [ZBarImageScanner new];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    self.readerView= [readerView initWithImageScanner:scanner];
    readerView.readerDelegate = self;
    readerView.tracksSymbols = YES;
    [readerView setNeedsLayout];
    readerView.frame = portrait;
    readerView.torchMode = 0;
  
    [self relocateReaderPopover:[self interfaceOrientation]];
    

    readerView.autoresizingMask=ZBarOrientationMaskAll;
    
    [readerView start];
    
    readerView.frame = CGRectMake(10, 50, 300, 340);
    

    
   
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        [UIHelper fadeInMessage:self.view text:@"noCameraFound".translate];
        readerView.hidden=TRUE;
        return;
    }
}


-(void)relocateReaderPopover:(UIInterfaceOrientation)toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        readerView.previewTransform = CGAffineTransformMakeRotation(M_PI_2);
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        readerView.previewTransform = CGAffineTransformMakeRotation(-M_PI_2);
    } else if (toInterfaceOrientation== UIInterfaceOrientationPortraitUpsideDown) {
        readerView.previewTransform = CGAffineTransformMakeRotation(M_PI);
    } else {
        readerView.previewTransform = CGAffineTransformIdentity;
    }
}




- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [readerView willRotateToInterfaceOrientation:orientation duration:duration];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}



- (void) readerView: (ZBarReaderView*) view didReadSymbols: (ZBarSymbolSet*) syms  fromImage: (UIImage*) img{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        resultText.text = sym.data;
        self.dirty=YES;
        
        NSDictionary *props =(NSDictionary*) [action getObjectSafely:@"properties"];
        if(props!=nil && [[props getString:@"autopost"] isEqualToString:@"1"]){
            [self save:nil];
        }
        
        break;
    }
}


-(IBAction)save:(id)sender{
    
    //setup the http utils client
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    //set the callback owner to the current view controller
    http.callBackOwner=(NSObject*)self;
    
    //set the call back method (will get called after response recieved to update the UI)
    http.callBack=@selector(onResponse:);
    
    //build a single request param
    NSMutableString *param = [[NSMutableString alloc] initWithString:@"barcode="];
    [param appendString:self.resultText.text];
    
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithCapacity:1];
    [postdata setObjectSafely:resultText.text forKey:@"barcode"];
    
    [http executeAction:self.action postdata:postdata];
    
}


@end
