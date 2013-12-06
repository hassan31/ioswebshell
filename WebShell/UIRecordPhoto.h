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
#import "UIParent.h"
#import "NSData+Base64.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+Scale.h"
#import "FileUtils.h"
#import "UIAttachmentViewer.h"


@interface UIRecordPhoto : UIParent <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>{
    
    UIImageView *selectedImage;

    NSDictionary *fileInfo;

    NSURL *movieURL;

    UIView *movieView;
    
    MPMoviePlayerController *player;
    
    CGRect playerDefaultFrame;
    
    UIButton *btnLoadPicture;

    UIButton *btnCamera;
    
    UIButton *btnPictures;
    
    NSString *filePath;
    
    CGRect vertFrame;
    
    CGRect horizFrame;
    
}


@property(nonatomic,retain) IBOutlet UIButton *btnCamera;
@property(nonatomic,retain) IBOutlet UIButton *btnPictures;
@property(nonatomic,retain) IBOutlet UIButton *btnLoadPicture;
@property(nonatomic,retain) NSString *filePath;
@property(nonatomic,retain) IBOutlet UIView *movieView;
@property(nonatomic,strong) MPMoviePlayerController *player;
@property(nonatomic,retain) NSURL *movieURL;
@property(nonatomic,retain) IBOutlet UIImageView *selectedImage;
@property(nonatomic,retain) NSDictionary *fileInfo;


-(IBAction)loadCameraRoll:(id)sender;
-(IBAction)loadCamera:(id)sender;
-(IBAction)loadPicture:(id)sender;
-(void)loadLandscape;
-(void)loadPortrait;
-(void)imageViewTapped:(UIGestureRecognizer *)gestureRecognizer;

@end
