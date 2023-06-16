//
//  GameLevelsViewController.m
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "GameLevelsViewController.h"

#import "UIApplication+AppDimension.h"

#import "SoundManager.h"

#import "UIColor+Lights.h"
#import "UIImage+Lights.h"

#import "Config.h"

#import "LevelButton.h"
#import "WorldView.h"

#import "LaserView.h"

#import "SoundManager.h"

#import "CPAnimationSequence.h"
#import "CPAnimationProgram.h"

@interface GameLevelsViewController ()

@end

@implementation GameLevelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    view.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage gameSceneBackgroundImage]];
    //self.view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SoundManager sharedSoundManager] initAudio];
    
    CGSize size = [UIApplication currentScreenSize];
    //NSLog(@"%.1f, %.1f", size.width, size.height);
    
    NSUInteger bottomMargin = 0;
    
#ifdef AdsCodeIsOn
    bottomMargin = 90;
#endif
    
    NSUInteger buttonWidth = SETTINGSBUTTONIPADW;
    NSUInteger buttonHeight = SETTINGSBUTTONIPADH;
    
    
    CGRect buttomFrame = CGRectMake(-5, size.height - buttonHeight+5 - bottomMargin, buttonWidth, buttonHeight);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        buttonWidth = SETTINGSBUTTONIPHONEW;
        buttonHeight = SETTINGSBUTTONIPHONEH;
        buttomFrame = CGRectMake(-5, size.height - buttonHeight+5 - bottomMargin, buttonWidth, buttonHeight);
    }
        
    self.settingsButtoniPad = [[SettingsButton alloc] initWithFrame:buttomFrame];
    _settingsButtoniPad.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _settingsButtoniPad.showsTouchWhenHighlighted = NO;
    [_settingsButtoniPad addTarget: self action: @selector(pushSettingsController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _settingsButtoniPad];
    
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.settingsButtoniPhone = [UIButton buttonWithType: UIButtonTypeCustom];
        UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage settingsButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
        UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage settingsButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
        [_settingsButtoniPhone setImage: backButtonImage forState: UIControlStateNormal];
        [_settingsButtoniPhone setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
        _settingsButtoniPhone.imageView.contentMode = UIViewContentModeCenter;
        _settingsButtoniPhone.frame = buttomFrame;
        _settingsButtoniPhone.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _settingsButtoniPhone.showsTouchWhenHighlighted = YES;
        [_settingsButtoniPhone addTarget: self action: @selector(pushSettingsController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _settingsButtoniPhone];
    } else {
        self.settingsButtoniPad = [[SettingsButton alloc] initWithFrame:buttomFrame];
        _settingsButtoniPad.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _settingsButtoniPad.showsTouchWhenHighlighted = NO;
        [_settingsButtoniPad addTarget: self action: @selector(pushSettingsController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _settingsButtoniPad];
    }
    */
    
    NSUInteger normallevelbuttonwidth = LEVELBUTTONIPADW;
    NSUInteger normallevelbuttonheight = LEVELBUTTONIPADH;
    NSUInteger nextlevelbuttonwidth = NEXTLEVELBUTTONIPADW;
    NSUInteger nextlevelbuttonheight = NEXTLEVELBUTTONIPADH;
    NSUInteger levelsperline = 10;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIApplication IS_IPHONE5_RETINA]) {
            normallevelbuttonwidth = LEVELBUTTONIPHONE5DW;
            normallevelbuttonheight = LEVELBUTTONIPHONE5DH;
            
        } else {
            normallevelbuttonwidth = LEVELBUTTONIPHONE4DW;
            normallevelbuttonheight = LEVELBUTTONIPHONE4DH;
        }
        nextlevelbuttonwidth = NEXTLEVELBUTTONIPHONEDW;
        nextlevelbuttonheight = NEXTLEVELBUTTONIPHONEDH;
    }
    
    NSUInteger nextbuttonsStartX = size.width - levelsperline * normallevelbuttonwidth - 20 - WORLDBUTTONIPADW - 20;
    NSUInteger nextbuttonsStartY = size.height - NEXTLEVELBUTTONIPADH - 50 - bottomMargin;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nextbuttonsStartY = size.height - NEXTLEVELBUTTONIPHONEDH - 10 - bottomMargin;
        nextbuttonsStartX = size.width - levelsperline * normallevelbuttonwidth - 20 - WORLDBUTTONIPHONEDW - 10 + (levelsperline * normallevelbuttonwidth - nextlevelbuttonwidth)/2;
    }
    
    NSLog(@"NLB %d, %d, %d, %d", nextbuttonsStartX, nextbuttonsStartY, nextlevelbuttonwidth, nextlevelbuttonheight);
    
    CGRect nextLevelButtonFrame = CGRectMake(nextbuttonsStartX, nextbuttonsStartY, nextlevelbuttonwidth, nextlevelbuttonheight);
    self.nextGameLevelButton = [[NextLevelButton alloc] initWithFrame:nextLevelButtonFrame];
    [_nextGameLevelButton addTarget: self action: @selector(jumpToNextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextGameLevelButton];
    
    
    UIImage *gameTitleImage =  [UIImage gameTitleImageGlass];
    UIImage *gameTitleImageRed =  [UIImage gameTitleImageGlassRed];
    UIImageView *gameTitle = [[UIImageView alloc] initWithImage:gameTitleImage];
    __block UIImageView *gameTitleRed = [[UIImageView alloc] initWithImage:gameTitleImageRed];
    CGRect imageFrame = CGRectMake(40, 40, gameTitleImage.size.width, gameTitleImage.size.height);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIApplication IS_IPHONE5_RETINA]) {
            imageFrame = CGRectMake(15, 12, gameTitleImage.size.width / 2, gameTitleImage.size.height / 2);
        } else {
            imageFrame = CGRectMake(15, 12, gameTitleImage.size.width / 3, gameTitleImage.size.height / 3);
        }
    }
    
    gameTitle.frame = imageFrame;
    gameTitleRed.frame = imageFrame;
    
    self.gameTitle = gameTitle;
    self.gameTitleRed = gameTitleRed;
    [self.view addSubview: _gameTitle];
    [self.view addSubview: _gameTitleRed];
    _gameTitleRed.alpha = 0.0;
    
    self.worlds = [NSMutableArray array];
    
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: documentsdirectory error:NULL];
    for (NSString *filestring in dirContents) {
        if ([filestring hasPrefix:@"GameWorld"] && [filestring hasSuffix:@".plist"]) {
            
            NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: filestring];
            NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
            [_worlds addObject: world];
        }
    }
    
    NSUInteger worldbuttonwidth = WORLDBUTTONIPADW;
    NSUInteger worlduttonheight = WORLDBUTTONIPADH;
    NSUInteger buttonsStartX = size.width - worldbuttonwidth - 25;
    NSUInteger buttonsStartY = WORLDBUTTONSTARTYIPAD;
    NSUInteger buttonInterMargin = 20;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        worldbuttonwidth = WORLDBUTTONIPHONEDW;
        worlduttonheight = WORLDBUTTONIPHONEDH;
        buttonsStartX = size.width - worldbuttonwidth - 15;
        buttonsStartY = WORLDBUTTONSTARTYIPHONE;
        buttonInterMargin = 5;
    }
    
    for (int i = 0; i < [_worlds count]; i++) {
        NSDictionary *world = [_worlds objectAtIndex: i];
        //NSUInteger worldcolor = [[world objectForKey: @"worldcolor"] integerValue];
        NSString *worldname = [world objectForKey: @"worldname"];
        
        //NSLog(@"World: %@, %d", worldname, worldcolor);
                
        //UIColor *buttoncolor = [UIColor getBlockColorForColorCode: worldcolor];
        
        WorldView *worldview = [[WorldView alloc] initWithWorld:CGRectMake(buttonsStartX, buttonsStartY + + i * worlduttonheight + i * buttonInterMargin, worldbuttonwidth, worlduttonheight) world:i worldname:worldname];
             
        [self.view addSubview: worldview];
        [_worldbuttons addObject: worldview];
        
        UILabel *worldnamelabel =[[UILabel alloc] initWithFrame: CGRectMake(buttonsStartX, buttonsStartY + + i * worlduttonheight + i * buttonInterMargin, worldbuttonwidth, worlduttonheight)];
        worldnamelabel.font = [UIFont systemFontOfSize:16.0];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            worldnamelabel.font = [UIFont systemFontOfSize: 11];
        }
        worldnamelabel.text = worldname;
        worldnamelabel.backgroundColor = [UIColor clearColor];
        worldnamelabel.textColor = [UIColor whiteColor];
        worldnamelabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview: worldnamelabel];
    }
    
    _selectedWorld = 0;
    _selectedLevel = 0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    if (soundOn) {
        _selectedWorld = [prefs integerForKey: @"selectedworld"];
        _selectedLevel = [prefs integerForKey:  @"selectedlevel"];
    }
    
    /*
    dispatch_queue_t processing_queue = dispatch_queue_create("com.fasoft.lights.processing", 0);
    dispatch_async(processing_queue, ^(void) {
        [self showLevels:YES];
    });
    //dispatch_release(processing_queue);
    */
    [self showLevels:YES];
    
    if (!soundOn) {
        [prefs setObject:@"on" forKey:@"sound"];
        [prefs synchronize];
        [[SoundManager sharedSoundManager] playAudio];
    } else {
        if ([soundOn isEqualToString:@"on"]) {
            [[SoundManager sharedSoundManager] playAudio];
        }
    }
    
    CGRect laserFrame = CGRectMake(0, size.height / 2 - 5, SQUARESIZEIPAD, SQUARESIZEIPAD);
    
    LaserView *laserView = [[LaserView alloc] initWithFrameAndNumberXAndNumberYAndBorderpositionAndAngle: laserFrame lasernumberX:0 lasernumberY:0 laserborderposition:1 laserangle:315 lasercolor:1];
    [self.view addSubview: laserView];
    laserView.alpha = 0.0;
    
    LightLine *lightline = [[LightLine alloc] init];
    lightline.startPoint = CGPointMake(SQUARESIZEIPAD / 2, size.height / 2 - 4);
    lightline.endPoint = CGPointMake(250, 76);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIApplication IS_IPHONE5_RETINA]) {
            lightline.endPoint = CGPointMake(105, 30);
            
        } else {
            lightline.endPoint = CGPointMake(80, 20);
        }
    }
    
    lightline.lightColor = [UIColor redColor];
    lightline.lightColorCode = 1;
    
    LightView *lightView = [[LightView alloc] initWithFrame:CGRectMake(0, 0, size.width / 2, size.height)];
    [self.view addSubview: lightView];
    [lightView addLightLine:lightline];
    [lightView setNeedsDisplay];
    lightView.alpha = 0.0f;
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            laserView.alpha = 1.0f;
        } completion: ^(BOOL completed){
            [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                gameTitleRed.alpha = 1.0;
                lightView.alpha = 1.0f;
                //[[SoundManager sharedSoundManager] playLaserSound];
            } completion: ^(BOOL completed){
                [[SoundManager sharedSoundManager] playLaserSound];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    gameTitleRed.alpha = 0.8;
                } completion:^(BOOL completed){
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        laserView.alpha = 0.0f;
                        lightView.alpha = 0.0f;
                    } completion:nil];
                
                }];
            }];
            
        }];
    });
}

- (void) pushSettingsController:(id)sender {
    
    [[SoundManager sharedSoundManager] playButton2Sound];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        settingsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        settingsViewController.wantsFullScreenLayout = NO;
        [self presentViewController: settingsViewController animated: YES completion: nil];
        settingsViewController.view.superview.bounds = CGRectMake(0, 0, IPADHELPWIDTH * IPADHELPSCALEFACTOR, IPADHELPHEIGHT * IPADHELPSCALEFACTOR);
    } else {

        self.settingsViewController = nil;
        self.settingsViewController = [[SettingsViewController alloc] init];
        _settingsViewController.delegate = self;
        
        CGRect buttonFrame = [_settingsButtoniPad frame];
        buttonFrame = CGRectInset(buttonFrame, LEVELBUTTONMARGIN, LEVELBUTTONMARGIN);
                
        UIView *animview = [[UIView alloc] initWithFrame:buttonFrame];
        animview.backgroundColor = [UIColor blackColor];
        [self.view addSubview: animview];
        
        __block CGRect viewFrame = animview.frame;
        CGSize size = [UIApplication currentScreenSize];
        viewFrame.origin.x = 0;
        viewFrame.size.width = size.width;
        
        [[SoundManager sharedSoundManager] playBubbleSound];
        
        [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animview.frame = viewFrame;
        } completion: ^(BOOL completed){
            viewFrame.origin.y = 0;
            viewFrame.size.height = size.height;
            [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                animview.frame = viewFrame;
            } completion:^(BOOL completed){
                [self.view insertSubview:_settingsViewController.view atIndex: self.view.subviews.count - 1];
                [animview removeFromSuperview];
            }];
            
        }];
        
        animview = nil;
        
        /*
        settingsViewController.view.frame = self.view.bounds;
        settingsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        settingsViewController.wantsFullScreenLayout = YES;
        [self presentViewController: settingsViewController animated: YES completion: nil];
        */ 
    }
}

- (void)pushSettingsViewController:(SettingsViewController *)controller {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [_settingsViewController.view removeFromSuperview];
        self.settingsViewController = nil;
        
        [[SoundManager sharedSoundManager] playButton2Sound];
    } else {        
        CGSize size = [UIApplication currentScreenSize];
    
        UIView *animview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        animview.backgroundColor = [UIColor blackColor];
        [self.view addSubview: animview];
        
        [_settingsViewController.view removeFromSuperview];
        self.settingsViewController = nil;
        
        __block CGRect viewFrame = animview.frame;
        viewFrame.origin.y = _settingsButtoniPad.frame.origin.y;
        viewFrame.size.height = _settingsButtoniPad.frame.size.height;
        
        [[SoundManager sharedSoundManager] playBubbleSound];
        
        [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animview.frame = viewFrame;
        } completion: ^(BOOL completed){
            viewFrame.origin.x = _settingsButtoniPad.frame.origin.x;
            viewFrame.size.width = _settingsButtoniPad.frame.size.width;
            [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                animview.frame = viewFrame;
            } completion:^(BOOL completed){
                [animview removeFromSuperview];
                //[self showLevels: NO];
            }];
            
        }];
        
        animview = nil;
    }
}

- (void) showLevels:(BOOL)animated {
    
    //NSLog(@"Show levels");
    
    for (UIView *cv in self.view.subviews) {
        if ([cv isKindOfClass:[LevelButton class]]) {
            [cv removeFromSuperview];
        }
    }
    
    [_levelbuttons removeAllObjects];
    [_worlds removeAllObjects];
    
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: documentsdirectory error:NULL];
    for (NSString *filestring in dirContents) {
        if ([filestring hasPrefix:@"GameWorld"] && [filestring hasSuffix:@".plist"]) {
            
            NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: filestring];
            NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
            [_worlds addObject: world];
        }
    }
    
    NSUInteger levelbuttonwidth = LEVELBUTTONIPADW;
    NSUInteger leveluttonheight = LEVELBUTTONIPADH;
    NSUInteger levelsperline = 10;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIApplication IS_IPHONE5_RETINA]) {
            levelbuttonwidth = LEVELBUTTONIPHONE5DW;
            leveluttonheight = LEVELBUTTONIPHONE5DH;
            
        } else {
            levelbuttonwidth = LEVELBUTTONIPHONE4DW;
            leveluttonheight = LEVELBUTTONIPHONE4DH;
        }
    }
    
    CGSize size = [UIApplication currentScreenSize];
    //CGSize size = self.view.frame.size;
    //NSLog(@"%.1f, %.1f", size.width, size.height);
    
    NSUInteger buttonsStartX = size.width - levelsperline * levelbuttonwidth - 20 - WORLDBUTTONIPADW - 20;
    NSUInteger buttonsStartY = WORLDBUTTONSTARTYIPAD;
    NSUInteger buttonInterMargin = 20;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        buttonsStartY = WORLDBUTTONSTARTYIPHONE;
        buttonsStartX = size.width - levelsperline * levelbuttonwidth - 20 - WORLDBUTTONIPHONEDW - 10;
        buttonInterMargin = 5;
    }
    
    BOOL lastUncompletedLevel = YES;
    //NSUInteger levelstate = 1;
    
    NSUInteger worldStartY = buttonsStartY;
    
    for (int w = 0; w < [_worlds count]; w++) {
        NSDictionary *world = [_worlds objectAtIndex:w];
        worldStartY = buttonsStartY + w * leveluttonheight * 2 + w * buttonInterMargin;
        //NSUInteger worldcolor = [[world objectForKey: @"worldcolor"] integerValue];
        NSArray *levels = [world objectForKey: @"levels"];
                
        for (int i = 0;  i < [levels count];  i++) {
            NSUInteger posYMulti = i / levelsperline;
            NSUInteger posXMulti = i - posYMulti * levelsperline;
            CGRect buttonFrame = CGRectMake(buttonsStartX + posXMulti * levelbuttonwidth, worldStartY + posYMulti * leveluttonheight, levelbuttonwidth, leveluttonheight);
            
            NSDictionary *level = [levels objectAtIndex: i];
            NSUInteger levelstate = [[level objectForKey: @"completed"] integerValue];
            //NSUInteger levelColor = worldcolor;
            NSUInteger buttonstate = stateNotCompleted;
            if (levelstate != 0) {
                if (lastUncompletedLevel) {
                    buttonstate = stateCompleted;
                } else {
                    buttonstate = stateCompleted;
                }
            }
            
            LevelButton *levelbutton = [[LevelButton alloc] initWithStateWorldAndLevel:buttonFrame state:buttonstate world:w level:i color:w];
            levelbutton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            [levelbutton setTitle: [NSString stringWithFormat: @"%d", i+1] forState:UIControlStateNormal];
            
            levelbutton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            //worldbutton.showsTouchWhenHighlighted = YES;
            [levelbutton addTarget: self action: @selector(chooselevel:) forControlEvents:UIControlEventTouchUpInside];
            
            if (animated) {
                levelbutton.alpha = 0.0;
            }
            
            [self.view addSubview: levelbutton];
            
            [_levelbuttons addObject: levelbutton];
            
            if (animated) {
                NSMutableArray *animations = [NSMutableArray array];
                CGFloat counter = 1;
                for (UIView *cv in self.view.subviews) {
                    if ([cv isKindOfClass: [LevelButton class]]) {
                        CPAnimationStep *animationStep = [CPAnimationStep after:0.001 * counter for:0.05 animate:^{ cv.alpha = 1.0; }];
                        [animations addObject: animationStep];
                        counter++;
                    }
                }
                CPAnimationSequence* animationSequence = [CPAnimationSequence sequenceWithStepsArray: animations];
                [animationSequence runAnimated:YES];
            }
        }
    }
}

- (void) chooselevel:(id)sender {
    LevelButton *button = (LevelButton *)sender;
    CGRect buttonFrame = [button frame];
    buttonFrame = CGRectInset(buttonFrame, LEVELBUTTONMARGIN, LEVELBUTTONMARGIN);
    
    [self pushWorldLevel:button.buttonworld level:button.buttonlevel addview: NO];
    
    UIView *animview = [[UIView alloc] initWithFrame:buttonFrame];
    animview.backgroundColor = [button getWorldColor];
    [self.view addSubview: animview];
    
    __block CGRect viewFrame = animview.frame;
    CGSize size = [UIApplication currentScreenSize];
    viewFrame.origin.x = 0;
    viewFrame.size.width = size.width;
    
    [[SoundManager sharedSoundManager] playBubbleSound];
    
    [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        animview.frame = viewFrame;
    } completion: ^(BOOL completed){
        viewFrame.origin.y = 0;
        viewFrame.size.height = size.height;
        [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animview.frame = viewFrame;
        } completion:^(BOOL completed){
            [self.view insertSubview:_gameLightsSceneViewController.view atIndex: self.view.subviews.count - 1];
            [animview removeFromSuperview];
        }];
        
    }];
    
    animview = nil;
    
  /*
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
       
       
        
   */
}


- (void) jumpToNextLevel:(id)sender {
    NSLog(@"Jump to next level");
    
    NSUInteger gworld = 0;
    NSUInteger glevel = 0;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    if (soundOn) {
        gworld = [prefs integerForKey:@"selectedworld"];
        glevel = [prefs integerForKey:@"selectedlevel"];
    }
    
    CGRect buttonFrame = [_nextGameLevelButton frame];
    //buttonFrame = CGRectInset(buttonFrame, LEVELBUTTONMARGIN, LEVELBUTTONMARGIN);
    
    [self pushWorldLevel:gworld level:glevel addview: NO];
    
    UIView *animview = [[UIView alloc] initWithFrame:buttonFrame];
    animview.backgroundColor = [UIColor blackColor];
    [self.view addSubview: animview];
    
    __block CGRect viewFrame = animview.frame;
    CGSize size = [UIApplication currentScreenSize];
    viewFrame.origin.x = 0;
    viewFrame.size.width = size.width;
    
    [[SoundManager sharedSoundManager] playBubbleSound];
    
    [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        animview.frame = viewFrame;
    } completion: ^(BOOL completed){
        viewFrame.origin.y = 0;
        viewFrame.size.height = size.height;
        [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animview.frame = viewFrame;
        } completion:^(BOOL completed){
            [self.view insertSubview:_gameLightsSceneViewController.view atIndex: self.view.subviews.count - 1];
            [animview removeFromSuperview];
        }];
        
    }];
    
    animview = nil;
}

- (void) pushWorldLevel:(NSUInteger)world level:(NSUInteger)level addview:(BOOL)addview {
    
    self.gameLightsSceneViewController = nil;
    self.gameLightsSceneViewController = [[GameLightsSceneViewController alloc] initWithWorldAndLevel:world level:level];
    _gameLightsSceneViewController.delegate = self;
    
    if (addview) {
        [self.view addSubview:_gameLightsSceneViewController.view];
    }
}

- (void)pushBackGameLightsSceneViewController:(GameLightsSceneViewController *)controller {
        
    NSUInteger gamelevel = controller.gamelevel;
    NSUInteger gameworld = controller.gameworld;
    _selectedWorld = gameworld;
    _selectedLevel = gamelevel;
    
    NSLog(@"Push back scene: %d, %d,", gameworld, gamelevel);
    
    [self showLevels: NO];
    
    CGSize size = [UIApplication currentScreenSize];
    
    NSUInteger levelbuttonwidth = LEVELBUTTONIPADW;
    NSUInteger leveluttonheight = LEVELBUTTONIPADH;
    NSUInteger levelsperline = 10;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ([UIApplication IS_IPHONE5_RETINA]) {
            levelbuttonwidth = LEVELBUTTONIPHONE5DW;
            leveluttonheight = LEVELBUTTONIPHONE5DH;
            
        } else {
            levelbuttonwidth = LEVELBUTTONIPHONE4DW;
            leveluttonheight = LEVELBUTTONIPHONE4DH;
        }
    }
        
    NSUInteger buttonsStartX = size.width - levelsperline * levelbuttonwidth - 20 - WORLDBUTTONIPADW - 20;
    NSUInteger buttonsStartY = WORLDBUTTONSTARTYIPAD;
    NSUInteger buttonInterMargin = 20;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        buttonsStartY = WORLDBUTTONSTARTYIPHONE;
        buttonsStartX = size.width - levelsperline * levelbuttonwidth - 20 - WORLDBUTTONIPHONEDW - 10;
        //buttonsStartX = (size.width - levelsperline * levelbuttonwidth)/2;
        buttonInterMargin = 5;
    }
    
    NSUInteger posYMulti = gamelevel / levelsperline;
    NSUInteger posXMulti = gamelevel - posYMulti * levelsperline;
    
    NSUInteger worldStartY = buttonsStartY + gameworld * leveluttonheight * 2 + gameworld * buttonInterMargin;

    UIView *animview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIColor *worldbuttonColor = [UIColor colorWithRed:193.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *squareStroke = [UIColor darkenedColor:worldbuttonColor difference:0.1 * gameworld];
    animview.backgroundColor = squareStroke;
    [self.view addSubview: animview];
    
    [_gameLightsSceneViewController.view removeFromSuperview];
    self.gameLightsSceneViewController = nil;
    
    __block CGRect viewFrame = animview.frame;
    viewFrame.origin.y = worldStartY + posYMulti * leveluttonheight + LEVELBUTTONMARGIN;
    viewFrame.size.height = leveluttonheight - LEVELBUTTONMARGIN * 2;
    
    [[SoundManager sharedSoundManager] playBubbleSound];
    
    [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        animview.frame = viewFrame;
    } completion: ^(BOOL completed){
        viewFrame.origin.x = buttonsStartX + posXMulti * levelbuttonwidth + LEVELBUTTONMARGIN;
        viewFrame.size.width = levelbuttonwidth - LEVELBUTTONMARGIN * 2;
        [UIView animateWithDuration:BLOBANIMATIONDURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animview.frame = viewFrame;
        } completion:^(BOOL completed){
            [animview removeFromSuperview];
            //[self showLevels: NO];
        }];
        
    }];
    
    animview = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
