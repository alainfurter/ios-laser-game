//
//  SettingsViewController.m
//  Blocks
//
//  Created by Alain on 07.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SettingsViewController.h"

#import "UIApplication+AppDimension.h"

#import "SoundManager.h"

#import "UIColor+Lights.h"
#import "UIImage+Lights.h"

#import "Config.h"

#import "SetsSliderView.h"
#import "SliderKnobView.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed: 219.0f/255.0f green: 0 blue: 0 alpha: 1];
    
    CGSize size = self.view.frame.size;
    
    NSLog(@"Settings size: %.1f, %.1f", size.width, size.height);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        size = [UIApplication currentScreenSize];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor whiteColor]];
        UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage cancelButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor whiteColor]];
        [_backButton setImage: backButtonImage forState: UIControlStateNormal];
        [_backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
        _backButton.imageView.contentMode = UIViewContentModeCenter;
        _backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
        _backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _backButton.showsTouchWhenHighlighted = YES;
        [_backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: _backButton];
    } else {
        self.view.frame = CGRectMake(0, 0, IPADHELPWIDTH * IPADHELPSCALEFACTOR, IPADHELPHEIGHT * IPADHELPSCALEFACTOR);
        size = self.view.frame.size;
    }
    
    NSUInteger sliderWidth = 400;
    NSUInteger knobSize = 40;
    NSUInteger sliderY = 150;
    NSUInteger rightMargin = 65;
    NSUInteger sliderX = size.width - sliderWidth - rightMargin;
    NSUInteger sliderHeight = 20;
    NSUInteger sliderInterSpace = 100;
    CGFloat settingsFontSize = 65.0f;
    CGRect settingsFrame = CGRectMake(20, 10, 410, 80);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        settingsFrame = CGRectMake(0, 0, 250, 50);
        settingsFontSize = 40.0f;
        sliderWidth = 280;
        rightMargin = 20;
        sliderY = 120;
        sliderInterSpace = 80;
        sliderX = size.width - sliderWidth - rightMargin;
    }
    
    self.titleLabel = [[UILabel alloc] initWithFrame: settingsFrame];
    _titleLabel.font = [UIFont systemFontOfSize: settingsFontSize];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    _titleLabel.text = NSLocalizedString(@"Settings", @"Settings label text");
    [self.view addSubview: _titleLabel];

    CGRect sliderFrameSound = CGRectMake(size.width - sliderWidth - rightMargin, sliderY, sliderWidth, sliderHeight);
    CGRect sliderFrameFX = CGRectMake(size.width - sliderWidth - rightMargin, sliderY + sliderInterSpace, sliderWidth, sliderHeight);
    
    self.soundLabel = [[UILabel alloc] initWithFrame: CGRectMake(size.width - sliderWidth - rightMargin + 5, sliderY - 40, sliderWidth, 30)];
    _soundLabel.font = [UIFont systemFontOfSize: 26.0];
    _soundLabel.textColor = [UIColor whiteColor];
    _soundLabel.backgroundColor = [UIColor clearColor];
    _soundLabel.textAlignment = NSTextAlignmentLeft;
    _soundLabel.text = NSLocalizedString(@"Music Volume", @"Music volume label text");
    [self.view addSubview: _soundLabel];
    
    self.fxLabel = [[UILabel alloc] initWithFrame: CGRectMake(size.width - sliderWidth - rightMargin + 5, sliderY + sliderInterSpace - 40, sliderWidth, 30)];
    _fxLabel.font = [UIFont systemFontOfSize: 26.0];
    _fxLabel.textColor = [UIColor whiteColor];
    _fxLabel.backgroundColor = [UIColor clearColor];
    _fxLabel.textAlignment = NSTextAlignmentLeft;
    _fxLabel.text = NSLocalizedString(@"Sound Effects Volume", @"Sound FX label text");
    [self.view addSubview: _fxLabel];
        
    SetsSliderView *soundSlider = [[SetsSliderView alloc] initWithFrame:sliderFrameSound];
    [self.view addSubview:soundSlider];
    
    SetsSliderView *fxSlider = [[SetsSliderView alloc] initWithFrame:sliderFrameFX];
    [self.view addSubview:fxSlider];
    
    CGFloat bgsoundlevel = 0.3f;
    CGFloat fxsoundlevel = 0.3f;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    if (soundOn) {
        bgsoundlevel = [prefs doubleForKey: @"bgsoundlevel"];
        fxsoundlevel = [prefs doubleForKey: @"fxsoundlevel"];
    }
    
    //NSLog(@"Sound level: %.2f, %.2f", bgsoundlevel, fxsoundlevel);
        
    CGFloat volumelevelbg = sliderX + bgsoundlevel * (sliderWidth - knobSize);
    CGFloat volumelevelfx = sliderX + fxsoundlevel * (sliderWidth - knobSize);
    
    CGRect sliderFrameKnobSound = CGRectMake(volumelevelbg, sliderY - knobSize / 2 + sliderHeight / 2, knobSize, knobSize);
    CGRect sliderFrameKnobFX = CGRectMake(volumelevelfx, sliderY + sliderInterSpace - knobSize / 2 + sliderHeight / 2, knobSize, knobSize);
    
    SliderKnobView *sliderKnobViewSound = [[SliderKnobView alloc] initWithFrame:sliderFrameKnobSound];
    sliderKnobViewSound.tag = 0;
    [self.view addSubview: sliderKnobViewSound];
    
    UIPanGestureRecognizer *panRecognizerSound = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizerSound setMinimumNumberOfTouches:1];
    [panRecognizerSound setMaximumNumberOfTouches:1];
    [sliderKnobViewSound addGestureRecognizer:panRecognizerSound];
    
    SliderKnobView *sliderKnobViewFX = [[SliderKnobView alloc] initWithFrame:sliderFrameKnobFX];
    sliderKnobViewFX.tag = 1;
    [self.view addSubview: sliderKnobViewFX];
    
    UIPanGestureRecognizer *panRecognizerFX = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizerFX setMinimumNumberOfTouches:1];
    [panRecognizerFX setMaximumNumberOfTouches:1];
    [sliderKnobViewFX addGestureRecognizer:panRecognizerFX];
    
    NSUInteger bottomMargin = 10;
    NSUInteger leftMargin = 20;
    
    #ifdef AdsCodeIsOn
    bottomMargin = 10;
    #endif
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        #ifdef AdsCodeIsOn
        bottomMargin = 60;
        #endif
        
        leftMargin = 25;
    }
    
    UIImage *logoImage =  [UIImage newImageFromMaskImage: [UIImage logoImage] inColor: [UIColor whiteColor]];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    CGRect imageFrame = CGRectMake(leftMargin, size.height - logoImage.size.height - 20 - bottomMargin, logoImage.size.width, logoImage.size.height);
     
    logoImageView.frame = imageFrame;
    [self.view addSubview: logoImageView];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftMargin, size.height - 20 - bottomMargin, 200, 20)];
    copyrightLabel.font = [UIFont systemFontOfSize: 10.0];
    copyrightLabel.textColor = [UIColor whiteColor];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.textAlignment = NSTextAlignmentLeft;
    copyrightLabel.text = NSLocalizedString(@"© 2013 Zone Zero Apps", @"Zone Zero Apps Copyright");
    [self.view addSubview: copyrightLabel];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGSize size = [UIApplication currentScreenSize];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        size = [UIApplication currentScreenSize];
    } else {
        size = self.view.frame.size;
    }
    
    NSLog(@"%.1f, %.1f", size.width, size.height);
    
    NSUInteger sliderWidth = 400;
    NSUInteger rightMargin = 65;
    NSUInteger knobSize = 40;
    NSUInteger sliderX = size.width - sliderWidth - rightMargin;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        sliderWidth = 280;
        rightMargin = 20;
        sliderX = size.width - sliderWidth - rightMargin;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
        
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (recognizer.view.center.x + translation.x >= sliderX + knobSize / 2 && recognizer.view.center.x + translation.x <= sliderX + sliderWidth - knobSize / 2) {
        
        CGFloat volumelevel = (recognizer.view.frame.origin.x + translation.x - sliderX) / (sliderWidth - knobSize);
        if (recognizer.view.tag == 0) {
            [[SoundManager sharedSoundManager] setBackgroundSoundLevel: volumelevel];
        } else {
            [[SoundManager sharedSoundManager] setFXSoundLevel: volumelevel];
        }
        
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y);
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat volumelevel = (recognizer.view.frame.origin.x + translation.x - sliderX) / (sliderWidth - knobSize);
        //NSLog(@"Volume: %d, %.1f", recognizer.view.tag, volumelevel);
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if (recognizer.view.tag == 0) {
            [[SoundManager sharedSoundManager] setBackgroundSoundLevel: volumelevel];
            [prefs setDouble: volumelevel forKey:@"bgsoundlevel"];
            [prefs synchronize];
        } else {
            [[SoundManager sharedSoundManager] setFXSoundLevel: volumelevel];
            [prefs setDouble: volumelevel forKey:@"fxsoundlevel"];
            [prefs synchronize];
            
            [[SoundManager sharedSoundManager] playButton2Sound];
        }        
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
        [_recognizer setNumberOfTapsRequired:1];
        _recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
        [self.view.window addGestureRecognizer: _recognizer];
    }
}

/*
- (void) pushBackController:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(pushSettingsViewController:)]) {
        [self.delegate pushSettingsViewController:self];
    }
}
*/
- (void) pushBackController:(id)sender {
    
    [[SoundManager sharedSoundManager] playButton2Sound];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
         [self dismissViewControllerAnimated: YES completion: ^{}];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushSettingsViewController:)]) {
            [self.delegate pushSettingsViewController:self];
        }
    }
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil];
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            if (_recognizer) {
                [self.view.window removeGestureRecognizer: _recognizer];
                _recognizer = nil;
            }
            
            [self pushBackController: nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
