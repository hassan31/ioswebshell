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

#import "UIRecordAudio.h"
#import "Constants.h"


@implementation UIRecordAudio

@synthesize btnPlayAudio,btnRecordAudio,audioURL,btnStopAudio,rawData,filePath,audioSpinner,audioState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkAudioPermissions];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    NSString *color = [prefs objectForKey:@"buttonShade"];
    
    if ([color isEqualToString:@"dark"]) {
        [btnPlayAudio setImage:[UIImage imageNamed:@"play-dark.png"] forState:UIControlStateNormal];
        
        [btnRecordAudio setImage:[UIImage imageNamed:@"mic-dark.png"] forState:UIControlStateNormal];
        
        [btnStopAudio setImage:[UIImage imageNamed:@"pause-dark.png"] forState:UIControlStateNormal];
        
        
    }else{
        [btnPlayAudio setImage:[UIImage imageNamed:@"play-light.png"] forState:UIControlStateNormal];
        
        [btnRecordAudio setImage:[UIImage imageNamed:@"mic-light.png"] forState:UIControlStateNormal];
        
        [btnStopAudio setImage:[UIImage imageNamed:@"pause-light.png"] forState:UIControlStateNormal];
    }
    

    self.navBar.topItem.title=@"recordAudio".translate;
    
    self.audioSpinner.autoresizesSubviews=TRUE;
    
    isdark = [UIColor isDarkColor:[prefs objectForKey:@"hexColor"]];
    
    if (isdark) {
        self.audioSpinner.color=[UIColor whiteColor];
    }else{
        self.audioSpinner.color=[UIColor blackColor];
    }
    
    
    [self setupAudioSession];
    
    NSArray *dirPaths;
    
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:FILE_NAME_AUDIO];
    
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    
    
    //kAudioFormatMPEG4AAC
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    
    
    self.audioURL=soundFileURL;
    
    
    self.audioState.text=AUDIO_STATE_NO_RECORDING.translate;
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:soundFileURL settings:recordSettings error:&error];
    
    
    
    if (error){
        //NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
        audioRecorder.delegate=self;

    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.audioSpinner.transform = transform;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)setupAudioSession {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    UInt32 doSetProperty = 1;
    
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
    
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [self setSpeakers];
    
}


-(void) recordAudio{
    if (!audioRecorder.recording){
        audioState.text=AUDIO_STATE_ABOUT_TO_RECORD.translate;
        btnPlayAudio.enabled = NO;
        btnStopAudio.enabled = YES;
        [audioRecorder record];
        audioSpinner.color=[UIColor redColor];
        [audioSpinner startAnimating];
        audioState.text=AUDIO_STATE_RECORDING.translate;
        self.dirty=YES;
    }
}
-(void)stop{
    
    [self setButtonStates];
    
    if (audioRecorder.recording){
        [audioRecorder stop];
        
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    
    [self.audioSpinner stopAnimating];
    [self.audioSpinner setColor:[UIColor blackColor]];
    self.audioState.text=AUDIO_STATE_STOPPED.translate;
    
    
}
-(void) playAudio{
    
    if ([self.audioState.text isEqualToString:AUDIO_STATE_NO_RECORDING.translate]) {
        return;
    }
    
    if (!audioRecorder.recording) {
        
        btnStopAudio.enabled = YES;
        
        btnRecordAudio.enabled = NO;
        
        NSError *error;
        
        self.audioState.text=AUDIO_STATE_ABOUT_TO_PLAY.translate;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
        
        audioPlayer.delegate = self;
        
        
        if (error){
            //NSLog(@"Error: %@", [error localizedDescription]);
            [self.audioSpinner stopAnimating];
            self.audioState.text=[error localizedDescription];
        }
        else{
            [audioPlayer play];
            audioSpinner.color=[UIColor greenColor];
            [audioSpinner startAnimating];
            audioState.text=AUDIO_STATE_PLAYING.translate;
            
        }
    }
}


-(void)setSpeakers{
    OSStatus error;
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    error = AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    if (error) {
        //NSLog(@"Couldn't route audio to speaker");
    }
    
    
    
}


-(void)setButtonStates{
    btnRecordAudio.enabled=TRUE;
    btnPlayAudio.enabled=TRUE;
    btnStopAudio.enabled=FALSE;
}




//audio delegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.audioSpinner stopAnimating];
    self.audioState.text=AUDIO_STATE_STOPPED.translate;
    
    if (isdark) {
        self.audioSpinner.color=[UIColor whiteColor];
    }else{
        self.audioSpinner.color=[UIColor blackColor];
    }
    
    
    
    [self setButtonStates];
    
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self.audioSpinner stopAnimating];
    self.audioState.text=AUDIO_STATE_PLAYING_ERROR.translate;

    if (isdark) {
        self.audioSpinner.color=[UIColor whiteColor];
    }else{
        self.audioSpinner.color=[UIColor blackColor];
    }
    
    
    [self setButtonStates];
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self.audioSpinner stopAnimating];
    self.audioState.text=AUDIO_STATE_FINISHED_RECORDING.translate;

    if (isdark) {
        self.audioSpinner.color=[UIColor whiteColor];
    }else{
        self.audioSpinner.color=[UIColor blackColor];
    }
    
    
    btnRecordAudio.enabled=TRUE;
    btnPlayAudio.enabled=TRUE;
    btnStopAudio.enabled=FALSE;
    
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    [self.audioState setText:AUDIO_STATE_RECORDING_ERROR.translate];
    [self.audioSpinner stopAnimating];
    
    if (isdark) {
        self.audioSpinner.color=[UIColor whiteColor];
    }else{
        self.audioSpinner.color=[UIColor blackColor];
    }
    
}



-(IBAction)save:(id)sender{

    [spinner setMsg:@"uploading".translate];
    [spinner startAnimating];

    NSData *audioData = [FileUtils retrieveFromCache:FILE_NAME_AUDIO];
    
    
    //setup the http utils client
    HTTPUtils *http = [[HTTPUtils alloc] init];
    
    //set the callback owner to the current view controller
    http.callBackOwner=(NSObject*)self;
    
    //set the call back method (will get called after response recieved to update the UI)
    http.callBack=@selector(onResponse:);
    
    
    //this controller requires UPLOAD action, we will ignore what is set in the config from the server
   //NSLog(@"calling url %@", [action getString:@"url"]);
    [http uploadFile:audioData filename:FILE_NAME_AUDIO url:[action getString:@"url"]];


}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [UIHelper centerXView:self.audioSpinner];
    [UIHelper centerYView:self.audioSpinner];
    
}

-(void)checkAudioPermissions{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone is enabled..");
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"microphoneAccessDenied".translate
                                                                message:@"microphoneAccessDeniedText".translate
                                                               delegate:nil
                                                      cancelButtonTitle:@"ok".translate
                                                      otherButtonTitles:nil];
                
                [alert show];
                
                
                
            }
        }];
        
     
    }

}

@end
