//
//  SoundManager.h
//  Blocks
//
//  Created by Alain on 30.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "FISoundEngine.h"

@interface SoundManager : NSObject <AVAudioPlayerDelegate>

+ (SoundManager *)sharedSoundManager;

@property (nonatomic, strong) FISoundEngine *engine;
@property (nonatomic, strong) FISound *bubblesound;
@property (nonatomic, strong) FISound *blocksound;
@property (nonatomic, strong) FISound *successsound;
@property (nonatomic, strong) FISound *button1sound;
@property (nonatomic, strong) FISound *button2sound;
@property (nonatomic, strong) FISound *lasersound;
@property (nonatomic, strong) FISound *lightsound;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (assign) BOOL soundOn;

- (void)initAudio;

- (void)playAudio;
- (void)pauseAudio;
- (void)togglePlayPause;

- (void)playBlockSound;
- (void)playBubbleSound;
- (void)playSuccessSound;
- (void)playButton1Sound;
- (void)playButton2Sound;
- (void)playLaserSound;
- (void)playLightSound;

- (void) toggleSoundOn:(BOOL)soundon;

- (void)setBackgroundSoundLevel:(CGFloat)volume;
- (void)setSuccessSoundLevel:(CGFloat)volume;
- (void)setBubbleSoundLevel:(CGFloat)volume;
- (void)setBlockSoundLevel:(CGFloat)volume;
- (void)setLaserSoundLevel:(CGFloat)volume;
- (void)setLightSoundLevel:(CGFloat)volume;
- (void)setFXSoundLevel:(CGFloat)volume;

@end
