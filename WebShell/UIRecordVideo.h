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
#import "FileUtils.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface UIRecordVideo : UIParent <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>{
    
    UIImageView *selectedImage;
    
    UIImage *image;
    
    NSDictionary *fileInfo;

    NSURL *movieURL;
    
    UIView *movieView;
    
    MPMoviePlayerViewController *player;

    CGRect playerDefaultFrame;
    
    UIButton *btnPlayMovie;
    
    UIButton *btnRecordVideo;
    
    UIButton *btnVideoPicker;
    
    NSData *rawData;
    
    NSString *filePath;
    

    
}

@property(nonatomic,retain) NSString *filePath;

@property(nonatomic,retain) NSData *rawData;

@property(nonatomic,retain) IBOutlet UIButton *btnPlayMovie;

@property(nonatomic,retain) IBOutlet UIButton *btnRecordVideo;

@property(nonatomic,retain) IBOutlet UIButton *btnVideoPicker;

@property(nonatomic,retain) IBOutlet UIView *movieView;

@property(nonatomic,strong) MPMoviePlayerViewController *player;

@property(nonatomic,retain) NSURL *movieURL;

@property(nonatomic,retain) IBOutlet UIImageView *selectedImage;

@property(nonatomic,retain) NSDictionary *fileInfo;

@property(nonatomic,retain) UIImage *image;

-(IBAction)loadCameraRoll:(id)sender;

-(IBAction)loadCamera:(id)sender;

-(IBAction)playMovie:(id)sender;

-(void)moviePlayBackDidFinish: (NSNotification*)notification;

-(IBAction)close:(id)sender;

@end
