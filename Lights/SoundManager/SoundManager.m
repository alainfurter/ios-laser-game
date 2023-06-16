//
//  SoundManager.m
//  Blocks
//
//  Created by Alain on 30.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+ (SoundManager *)sharedSoundManager
{
    static SoundManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SoundManager alloc] init];
        sharedInstance.soundOn = YES;
    });
    
    return sharedInstance;
}

- (void)initAudio
{    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    CGFloat soundvolume = 0.3f;
    CGFloat fxvolume = 0.3f;
    if (soundOn) {
        soundvolume = [prefs floatForKey:@"bgsoundlevel"];
        fxvolume = [prefs floatForKey:@"fxsoundlevel"];
    }
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void){
    
        NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:@"Ambient1" withExtension:@"caf"];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
        
        if (_audioPlayer != nil){
            [_audioPlayer setNumberOfLoops:-1];
            [_audioPlayer setVolume: soundvolume];
            [_audioPlayer setDelegate: self];
            
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
                [[AVAudioSession sharedInstance] setActive: YES error: nil];
                
                UInt32 doSetProperty = 1;
                AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
                
                if ([_audioPlayer prepareToPlay]) {
                    // successfully created player
                } else {
                    // failed to initiate player
                }
            }
        }
    });
    
    NSError *error;
    
    _engine = [FISoundEngine sharedEngine];
    _bubblesound = [_engine soundNamed:@"Bubble1.caf" maxPolyphony:4 error:&error];
    _blocksound = [_engine soundNamed:@"Block1.caf" maxPolyphony:4 error:&error];
    _successsound = [_engine soundNamed:@"Success1.caf" maxPolyphony:4 error:&error];
    
    _bubblesound.gain = fxvolume;
    
    _button1sound = [_engine soundNamed:@"Button1.caf" maxPolyphony:4 error:&error];
    _button2sound = [_engine soundNamed:@"Button2.caf" maxPolyphony:4 error:&error];
    
    _lasersound = [_engine soundNamed:@"Laser2.caf" maxPolyphony:4 error:&error];
    
    _lightsound = [_engine soundNamed:@"Drip2.caf" maxPolyphony:4 error:&error];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) toggleSoundOn:(BOOL)soundon {
    _soundOn = soundon;
    if (_audioPlayer.playing && !soundon) {
        [self pauseAudio];
    }
    if (!_audioPlayer.playing && soundon) {
        [self playAudio];
    }
}

- (void)playAudio {
    if (_soundOn) {
        [_audioPlayer play];
    }
}

- (void)pauseAudio {
    [_audioPlayer pause];
}

- (void)togglePlayPause {
    if (!_audioPlayer.playing) {
        [self playAudio];
    } else if (_audioPlayer.playing) {
        [self pauseAudio];
    }
}

- (void)playBlockSound {
    if (_soundOn) {        
        [_blocksound play];
    }
}

- (void)playBubbleSound {
    if (_soundOn) {
        [_bubblesound play];
    }
}

- (void)playSuccessSound {
    if (_soundOn) {
        [_successsound play];
    }
}

- (void)playButton1Sound {
    if (_soundOn) {
        [_button1sound play];
    }
}

- (void)playButton2Sound {
    if (_soundOn) {
        [_button2sound play];
    }
}

- (void)playLaserSound {
    if (_soundOn) {
        [_lasersound play];
    }
}

- (void)playLightSound {
    if (_soundOn) {
        [_lightsound play];
    }
}

- (void)setBackgroundSoundLevel:(CGFloat)volume {
    [_audioPlayer setVolume: volume];
}

- (void)setSuccessSoundLevel:(CGFloat)volume {
    _successsound.gain = volume;
}

- (void)setBubbleSoundLevel:(CGFloat)volume {
    _bubblesound.gain = volume;
}

- (void)setBlockSoundLevel:(CGFloat)volume {
    _blocksound.gain = volume;
}

- (void)setButton1SoundLevel:(CGFloat)volume {
    _button1sound.gain = volume;
}

- (void)setButton2SoundLevel:(CGFloat)volume {
    _button2sound.gain = volume;
}

- (void)setLaserSoundLevel:(CGFloat)volume {
    _lasersound.gain = volume;
}

- (void)setLightSoundLevel:(CGFloat)volume {
    _lightsound.gain = volume;
}

- (void)setFXSoundLevel:(CGFloat)volume {
    [self setBlockSoundLevel:volume];
    [self setSuccessSoundLevel:volume];
    [self setBubbleSoundLevel:volume];
    [self setButton1SoundLevel:volume];
    [self setButton2SoundLevel:volume];
    [self setLaserSoundLevel:volume];
    [self setLightSoundLevel:volume];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if (_audioPlayer.playing) {
        [self pauseAudio];
    }
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (!_audioPlayer.playing) {
        [self playAudio];
    }
}

@end
