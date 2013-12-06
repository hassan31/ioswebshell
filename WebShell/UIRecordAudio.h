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
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FileUtils.h"
#import "UIColor+HexString.h"

@interface UIRecordAudio : UIParent <AVAudioPlayerDelegate,AVAudioRecorderDelegate>{
    
    
    UIButton *btnPlayAudio;
    
    UIButton *btnRecordAudio;
    
    UIButton *btnStopAudio;
    
    AVAudioRecorder *audioRecorder;
    
    AVAudioPlayer *audioPlayer;
    
    NSURL *audioURL;
    
    NSData *rawData;
    
    NSString *filePath;
    
    UIActivityIndicatorView *audioSpinner;
    
    UILabel *audioState;

}


@property(nonatomic,retain) NSString *filePath;

@property(nonatomic,retain) NSData *rawData;

@property(nonatomic,retain) NSURL *audioURL;

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *audioSpinner;

@property(nonatomic,retain) IBOutlet UILabel *audioState;

@property(nonatomic,retain) IBOutlet UIButton *btnPlayAudio;

@property(nonatomic,retain) IBOutlet UIButton *btnRecordAudio;

@property(nonatomic,retain) IBOutlet UIButton *btnStopAudio;

-(void)setupAudioSession;

-(IBAction) recordAudio;

-(IBAction) playAudio;

-(IBAction) stop;

-(void)setSpeakers;

-(void)setButtonStates;

-(void) checkAudioPermissions;

@end
