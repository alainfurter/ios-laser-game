//
//  GameLightsSceneViewController.m
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "GameLightsSceneViewController.h"

#import "UIApplication+AppDimension.h"

#import "UIImage+Lights.h"
#import "UIColor+Lights.h"

#import "SquareView.h"
#import "BlockView.h"
#import "LaserView.h"
#import "TargetView.h"

#import "SoundManager.h"
#import "ImageManager.h"

#import "Config.h"

#import "CPAnimationSequence.h"
#import "CPAnimationProgram.h"

#import "GameLightsSceneToolbarView.h"

@interface GameLightsSceneViewController ()

@end

@implementation GameLightsSceneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWorldAndLevel:(NSUInteger)world level:(NSUInteger)level
{
    self = [super init];
    if (self) {
        _gameworld = world;
        _gamelevel = level;
    }
    return self;
}

- (void) loadView {
    CGSize size = [UIApplication currentScreenSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[[ImageManager sharedImageManager] getBackgroundImage]];
    //[view addSubview: backgroundView];
    //backgroundView.alpha = 1.0;
    
    //_view.backgroundColor = [UIColor whiteColor];
    view.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage gameSceneBackgroundImage]];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interceptCalculator = [[InterceptCalculator alloc] init];
    
	//self.view.backgroundColor = [UIColor whiteColor];
    CGSize size = [UIApplication currentScreenSize];
    
    CGRect topbarFrame = CGRectMake(0, 0, size.width, 36);
    //UIView *topbar = [[UIView alloc] initWithFrame:topbarFrame];
    GameLightsSceneToolbarView *topbar = [[GameLightsSceneToolbarView alloc] initWithFrame:topbarFrame];
    /*
    topbar.backgroundColor = [UIColor clearColor];
    topbar.layer.masksToBounds = NO;
    topbar.layer.shadowColor = [UIColor blackColor].CGColor;
    topbar.layer.shadowOffset = CGSizeMake(-45.0, 10.0f);
    topbar.layer.shadowOpacity = 0.5f;
    topbar.layer.shadowRadius = 5.0f;
    topbar.layer.shadowPath = [UIBezierPath bezierPathWithRect:topbar.bounds].CGPath;
    */
    [self.view addSubview:topbar];
    
    //GameLightsSceneBackgroundView *backgroundView = [[GameLightsSceneBackgroundView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview: backgroundView];
    //backgroundView.alpha = 1.0;
    
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage greyGradientBackgroundImage:self.view.frame.size]];
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage gameSceneBackgroundImage]];
    //[self.view addSubview: backgroundView];
    //backgroundView.alpha = 1.0;
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    UIImage *backButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage backButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    [_backButton setImage: backButtonImage forState: UIControlStateNormal];
    [_backButton setImage: backButtonImageHighlighted forState: UIControlStateHighlighted];
    _backButton.imageView.contentMode = UIViewContentModeCenter;
    _backButton.frame = CGRectMake(5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    _backButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _backButton.showsTouchWhenHighlighted = YES;
    [_backButton addTarget: self action: @selector(pushBackController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _backButton];
    
    self.redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *redoButtonImage =  [UIImage newImageFromMaskImage: [[UIImage redoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    UIImage *redoButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage redoButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    [_redoButton setImage: redoButtonImage forState: UIControlStateNormal];
    [_redoButton setImage: redoButtonImageHighlighted forState: UIControlStateHighlighted];
    _redoButton.imageView.contentMode = UIViewContentModeCenter;
    _redoButton.frame = CGRectMake(size.width - BUTTONHEIGHT - 5, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    _redoButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _redoButton.showsTouchWhenHighlighted = YES;
    [_redoButton addTarget: self action: @selector(redoBlocks:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _redoButton];
    
    self.soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *soundButtonImage =  [UIImage newImageFromMaskImage: [[UIImage soundonButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    UIImage *soundButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage soundoffButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    [_soundButton setImage: soundButtonImage forState: UIControlStateNormal];
    [_soundButton setImage: soundButtonImageHighlighted forState: UIControlStateHighlighted];
    [_soundButton setImage: soundButtonImageHighlighted forState: UIControlStateSelected];
    _soundButton.imageView.contentMode = UIViewContentModeCenter;
    _soundButton.frame = CGRectMake(size.width - BUTTONHEIGHT * 2 - 5 * 2, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    _soundButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _soundButton.showsTouchWhenHighlighted = YES;
    [_soundButton addTarget: self action: @selector(toggleSound:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _soundButton];
    
    self.helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *helpButtonImage =  [UIImage newImageFromMaskImage: [[UIImage qaButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    UIImage *helpButtonImageHighlighted =  [UIImage newImageFromMaskImage: [[UIImage qaButtonImage] resizedImage: CGSizeMake(BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON, BUTTONHEIGHT * SCALEFACTORTOOLBARBUTTON) interpolationQuality: kCGInterpolationDefault] inColor: [UIColor blockSceneButtonColor]];
    [_helpButton setImage: helpButtonImage forState: UIControlStateNormal];
    [_helpButton setImage: helpButtonImageHighlighted forState: UIControlStateHighlighted];
    [_helpButton setImage: helpButtonImageHighlighted forState: UIControlStateSelected];
    _helpButton.imageView.contentMode = UIViewContentModeCenter;
    _helpButton.frame = CGRectMake(size.width - BUTTONHEIGHT * 3 - 5 * 3, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    _helpButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _helpButton.showsTouchWhenHighlighted = YES;
    [_helpButton addTarget: self action: @selector(showHelp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _helpButton];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    if (!soundOn) {
        [prefs setObject:@"on" forKey:@"sound"];
        [prefs synchronize];
        _soundButton.selected = NO;
    } else {
        if ([soundOn isEqualToString:@"on"]) {
            _soundButton.selected = NO;
        } else {
            _soundButton.selected = YES;
        }
    }
    
    CGRect labelFrame = CGRectMake((size.width - 220)/2, 8, 220, 20);
    
    /*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        labelFrame = CGRectMake((size.width - 220)/2, 60, 220, 20);
    }
    */
    
    UILabel *worldlevelLabel =[[UILabel alloc] initWithFrame: labelFrame];
    worldlevelLabel.font = [UIFont systemFontOfSize:16.0];
    worldlevelLabel.backgroundColor = [UIColor clearColor];
    worldlevelLabel.textColor = [UIColor worldlevelTextColor];
    worldlevelLabel.textAlignment = NSTextAlignmentCenter;
    self.worldlevelLabel = worldlevelLabel;
    [self.view addSubview: _worldlevelLabel];
    
    [self initGameWithWorldAndLevel:_gameworld gamelevel:_gamelevel];
}

- (void) pushBackController:(id)sender {
    if (_delegate && [_delegate respondsToSelector: @selector(pushBackGameLightsSceneViewController:)]) {
        [_delegate pushBackGameLightsSceneViewController:self];
    }
}

- (void) cleanupGame {
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[BlockView class]]) {
            [currentview removeFromSuperview];
        }
        if ([currentview isKindOfClass:[SquareView class]]) {
            [currentview removeFromSuperview];
        }
        if ([currentview isKindOfClass:[LaserView class]]) {
            [currentview removeFromSuperview];
        }
        if ([currentview isKindOfClass:[TargetView class]]) {
            [currentview removeFromSuperview];
        }
        if ([currentview isKindOfClass:[LightView class]]) {
            [currentview removeFromSuperview];
            [_lightView removeLightLines];
            self.lightView = nil;
        }
    }
}

- (void) redoBlocks:(id)sender {
    [[SoundManager sharedSoundManager] playButton1Sound];
    
    [self cleanupGame];
    
    [self initGameWithWorldAndLevel:_gameworld gamelevel: _gamelevel];
}

- (void) toggleSound:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [[SoundManager sharedSoundManager] playButton2Sound];
    
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        button.selected = YES;
        [prefs setObject:@"off" forKey:@"sound"];
        [prefs synchronize];
        [[SoundManager sharedSoundManager] toggleSoundOn: NO];
    } else {
        button.selected = NO;
        [prefs setObject:@"on" forKey:@"sound"];
        [prefs synchronize];
        [[SoundManager sharedSoundManager] toggleSoundOn: YES];
    }
}

- (void) showHelp:(id)sender {
    
    [[SoundManager sharedSoundManager] playButton2Sound];
    
    /*
    GameHelpViewController *gameHelpViewController = [[GameHelpViewController alloc] init];
    gameHelpViewController.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        gameHelpViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        gameHelpViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        gameHelpViewController.wantsFullScreenLayout = NO;
        [self presentViewController: gameHelpViewController animated: YES completion: nil];
        gameHelpViewController.view.superview.bounds = CGRectMake(0, 0, IPADHELPWIDTH * IPADHELPSCALEFACTOR, IPADHELPHEIGHT * IPADHELPSCALEFACTOR);
    } else {
        gameHelpViewController.view.frame = self.view.bounds;
        gameHelpViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        gameHelpViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        gameHelpViewController.wantsFullScreenLayout = YES;
        [self presentViewController: gameHelpViewController animated: YES completion: nil];
    }
    */
}

/*
- (void)helpDidFinish:(GameHelpViewController *)controller {
}
*/

- (void) initGameWithWorldAndLevel:(NSUInteger)gameworld gamelevel:(NSUInteger)gamelevel {
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSString *worldfile = [NSString stringWithFormat:@"GameWorld%d.plist", gameworld + 1];
    NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: worldfile];
    NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
    NSArray *levels = [world objectForKey: @"levels"];
    
    _gamecompleted = NO;
    
    NSLog(@"World: %d, level: %d", gameworld, gamelevel);
    NSLog(@"Game world file: %@", worldpath);
    NSLog(@"Number of levels for world: %d", [levels count]);
    
    NSDictionary *level = [levels objectAtIndex: gamelevel];
    
    self.worldlevelLabel.text = [NSString stringWithFormat:NSLocalizedString(@"World: %@ / Level: %d", @"World level title"), [world objectForKey:@"worldname"], gamelevel + 1];
    
    NSUInteger numberofrectswith = [[level objectForKey: @"gridwidth"] integerValue];
    NSUInteger numberofrectsheight = [[level objectForKey: @"gridheight"] integerValue];
    
    NSUInteger squareSize = SQUARESIZEIPAD;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        squareSize = SQUARESIZEIPHONE;
    }
    
    CGSize size = [UIApplication currentScreenSize];
    
    NSUInteger viewWidth = size.width;
    NSUInteger viewHeight = size.height;
    
    //NSLog(@"View size : %d, %d", viewWidth, viewHeight);
    
    NSUInteger squareStartX = (viewWidth - numberofrectswith * squareSize) / 2;
    NSUInteger squareStartY = (viewHeight - numberofrectsheight * squareSize) / 2;
    
    /*
    SquareFrameView *squareFrameView = [[SquareFrameView alloc] initWithFrame:CGRectMake(squareStartX, squareStartY, squareSize * numberofrectswith, squareSize * numberofrectsheight)];
    [self.view addSubview: squareFrameView];
    */
    
    NSArray *deactivatedSquares = [level objectForKey: @"deactivatedgrids"];
    if (deactivatedSquares && [deactivatedSquares count] > 0) {
        NSMutableArray *deactivatedGrids = [NSMutableArray array];
        for (NSDictionary *deactivatedGrid in deactivatedSquares) {
            NSUInteger deactivatedSquareX = [[deactivatedGrid objectForKey: @"posx"] integerValue];
            NSUInteger deactivatedSquareY = [[deactivatedGrid objectForKey: @"posy"] integerValue];
            NSString *deactivatedSquareCode = [NSString stringWithFormat:@"%d|%d", deactivatedSquareX, deactivatedSquareY];
            //NSLog(@"Deactivated gridcode: %@", deactivatedSquareCode);
            [deactivatedGrids addObject:deactivatedSquareCode];
        }
        self.deactivatedGrids = deactivatedGrids;
    }
    
    for (int i = 0; i < numberofrectswith; i++) {
        for (int y = 0; y < numberofrectsheight; y++) {
            SquareView *squareView = [[SquareView alloc] initWithFrameAndNumber:CGRectMake(squareStartX + i * squareSize, squareStartY + y * squareSize, squareSize, squareSize) squarenumberX:i squarenumberY:y];
            [self.view addSubview: squareView];
            squareView.alpha = 0.6f;
            
            if (_deactivatedGrids && [_deactivatedGrids count] > 0) {
                NSString *deactivatedSquareCode = [NSString stringWithFormat:@"%d|%d", i, y];
                if ([_deactivatedGrids indexOfObject: deactivatedSquareCode] != NSNotFound) {
                    squareView.alpha = 0.0;
                }
            }
        }
    }
    
    _numberofrectswidth = numberofrectswith;
    _numberofrectsheight =  numberofrectsheight;
    _squareSize = squareSize;
    
    _gridMinX = squareStartX;
    _gridMinY = squareStartY;
    _gridMaxX = squareStartX + numberofrectswith * squareSize;
    _gridMaxY = squareStartY + numberofrectsheight * squareSize;
    
    LightView *lightView = [[LightView alloc] initWithFrame:self.view.bounds];
    self.lightView = lightView;
    [self.view addSubview: _lightView];
    
    NSArray *lasers = [level objectForKey:@"lasers"];
    
    for (int i = 0; i < [lasers count]; i++) {
        NSDictionary *laser = [lasers objectAtIndex: i];
        
        NSInteger laserX = [[laser objectForKey:@"posx"] integerValue];
        NSInteger laserY = [[laser objectForKey:@"posy"] integerValue];
        
        CGFloat laserAngle = [[laser objectForKey:@"angle"] integerValue];
        CGFloat laserBorderPosition = [[laser objectForKey:@"borderposition"] doubleValue];
        NSInteger laserColor = [[laser objectForKey:@"color"] integerValue];
        
        NSUInteger laserXCoord = squareStartX + laserX * squareSize;
        NSUInteger laserYCoord = squareStartY + laserY * squareSize;
        
        NSUInteger laserWidth = squareSize;
        NSUInteger laserHeight = squareSize;
        
        CGRect laserFrame = CGRectMake(laserXCoord, laserYCoord, laserWidth, laserHeight);
        
        LaserView *laserView = [[LaserView alloc] initWithFrameAndNumberXAndNumberYAndBorderpositionAndAngle:laserFrame
                                                                                                lasernumberX:laserX
                                                                                                lasernumberY:laserY
                                                                                         laserborderposition:laserBorderPosition
                                                                                                  laserangle:laserAngle
                                                                                                  lasercolor:laserColor];
        
        [self.view addSubview: laserView];
        
        //CGPoint laserpointoriginal = CGPointMake(laserView.laserXCenter, laserView.laserYCenter);
        //CGPoint laserpoint = [self.view convertPoint:laserpointoriginal fromView:laserView];
        //NSLog(@"Laserpoint: %.1f, %.1f", laserpoint.x, laserpoint.y);
        
    }
    
    NSArray *lights = [level objectForKey:@"lights"];
    
    for (int i = 0; i < [lights count]; i++) {
        NSDictionary *light = [lights objectAtIndex: i];
        
        NSInteger lightX = [[light objectForKey:@"posx"] integerValue];
        NSInteger lightY = [[light objectForKey:@"posy"] integerValue];
    
        CGFloat lightBorderPosition = [[light objectForKey:@"borderposition"] doubleValue];
        NSInteger lightColor = [[light objectForKey:@"color"] integerValue];
        
        NSUInteger lightXCoord = squareStartX + lightX * squareSize;
        NSUInteger lightYCoord = squareStartY + lightY * squareSize;
        
        NSUInteger lightWidth = squareSize;
        NSUInteger lightHeight = squareSize;
        
        CGRect lightFrame = CGRectMake(lightXCoord, lightYCoord, lightWidth, lightHeight);
        
        TargetView *targetView = [[TargetView alloc] initWithFrameAndNumberXAndNumberYAndBorderposition:lightFrame
                                                                                          targetnumberX:lightX
                                                                                          targetnumberY:lightY
                                                                                   targetborderposition:lightBorderPosition
                                                                                            targetcolor:lightColor];
        
        [self.view addSubview: targetView];
    }
    
    NSArray *blocks = [level objectForKey:@"blocks"];
    
    NSMutableArray *animations = [NSMutableArray array];
    
    for (int i = 0; i < [blocks count]; i++) {
        NSDictionary *block = [blocks objectAtIndex: i];
        
        NSUInteger blockX = [[block objectForKey:@"posx"] integerValue];
        NSUInteger blockY = [[block objectForKey:@"posy"] integerValue];
        
        NSUInteger blockType = [[block objectForKey:@"blocktype"] integerValue];
        
        NSUInteger blockXCoord = squareStartX + blockX * squareSize;
        NSUInteger blockYCoord = squareStartY + blockY * squareSize;
        
        NSUInteger blockWidth = squareSize;
        NSUInteger blockHeight = squareSize;
        
        //NSLog(@"Grid size: %d", self.gameGrid.gameSquareGrid.count);
        
        BlockView *blockView = [[BlockView alloc] initWithFrameAndTypeAndNumber:CGRectMake(blockXCoord, blockYCoord, blockWidth, blockHeight)
                                                                      blocktype:blockType
                                                                     blocknumer:i];
        
        blockView.blocktype = blockType;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [blockView addGestureRecognizer:panRecognizer];
        
        blockView.alpha = 0.0;
        
        CPAnimationStep *animationStep = [CPAnimationStep after:0.002 * (i + 1) for:0.03 animate:^{
            blockView.alpha = 1.0;
        }];
        [animations addObject: animationStep];
        
        [self.view addSubview: blockView];
    }
    
    CPAnimationSequence* animationSequence = [CPAnimationSequence sequenceWithStepsArray: animations];
    [animationSequence runAnimated:YES];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self calculateLaserLights];
        [self checkIfTargetLightsTouchedWithLight];
        [self checkIfGameSolved];
        
    });
}

- (BOOL) CGRectContainsPointOrPointIsOnBorder:(CGRect)rect point:(CGPoint)point {
    CGPoint topLeft = rect.origin;
    CGPoint rightBottom = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    if ((point.x >= topLeft.x && point.x <= rightBottom.x) && (point.y >= topLeft.y && point.y <= rightBottom.y)) {
        return YES;
    }
    return NO;
}

- (BlockView *) getIntersectingBlockViewForPointAndAngleWithBlockView:(CGPoint)point angle:(CGFloat)angle blockView:(BlockView *)blockView {
    CGPoint laserpoint = point;
    
    double angleradians = angle * M_PI / 180;
    double length = 1.0; // Dummy length
    double endX = cos(angleradians) * length + laserpoint.x;
    double endY = sin(angleradians) * length + laserpoint.y;
    CGPoint laserDirectionPoint = CGPointMake(endX, endY);
    
    //NSLog(@"getIntersectingBlockViewForPointAndAngleWithBlockView: %.1f, %.1f, %.1f, %.1f", blockView.frame.origin.x, blockView.frame.origin.y, blockView.frame.size.width, blockView.frame.size.height);
    //NSLog(@"getIntersectingBlockViewForPointAndAngleWithBlockView: %d / %.1f, %.1f / %.1f / %.1f, %.1f", blockView.blocknumber, laserpoint.x, laserpoint.y, angle, laserDirectionPoint.x, laserDirectionPoint.y);
        
    // Check if blockview has touching neighbor
    BOOL isNeigborBlockView = NO;
    if ([self CGRectContainsPointOrPointIsOnBorder:blockView.frame point:laserpoint]) {
        //NSLog(@"GetNeighboringBlockview: laser point is in frame. May be source block view: %d", blockView.blocknumber);
        //NSLog(@"GetNeighboringBlockview: blockframe: %.1f, %.1f, %.1f, %.1f", blockView.frame.origin.x, blockView.frame.origin.y, blockView.frame.size.width, blockView.frame.size.height);
        if ([self CGRectContainsPointOrPointIsOnBorder:blockView.frame point:laserDirectionPoint]) {
            //NSLog(@"GetNeighboringBlockview: laser direction point is in frame: %d", blockView.blocknumber);
            
            isNeigborBlockView = YES;
        }
        
    }
    
    /*
    if (CGRectContainsPoint(blockView.frame, laserpoint)) {
                
        NSLog(@"GetNeighboringBlockview: laser point is in frame. May be source block view: %d", blockView.blocknumber);
        NSLog(@"GetNeighboringBlockview: blockframe: %.1f, %.1f, %.1f, %.1f", blockView.frame.origin.x, blockView.frame.origin.y, blockView.frame.size.width, blockView.frame.size.height);
        if (CGRectContainsPoint(blockView.frame, laserDirectionPoint)) {
            NSLog(@"GetNeighboringBlockview: laser direction point is in frame: %d", blockView.blocknumber);
            
            isNeigborBlockView = YES;
        }
    }
    */
    
    CGPoint blockTopLeft = CGPointMake(blockView.frame.origin.x, blockView.frame.origin.y);
    CGPoint blockTopRight = CGPointMake(blockView.frame.origin.x + blockView.frame.size.width, blockView.frame.origin.y);
    CGPoint blockBottomLeft = CGPointMake(blockView.frame.origin.x, blockView.frame.origin.y + blockView.frame.size.height);
    CGPoint blockBottomRight = CGPointMake(blockView.frame.origin.x + blockView.frame.size.width, blockView.frame.origin.y + blockView.frame.size.height);
    
    CGPoint intersectionTop = [InterceptCalculator findLineSegmentsIntersection:laserpoint lineAEnd:laserDirectionPoint lineBStart:blockTopLeft lineBEnd:blockTopRight];
    CGPoint intersectionBottom = [InterceptCalculator findLineSegmentsIntersection:laserpoint lineAEnd:laserDirectionPoint lineBStart:blockBottomLeft lineBEnd:blockBottomRight];
    CGPoint intersectionLeft = [InterceptCalculator findLineSegmentsIntersection:laserpoint lineAEnd:laserDirectionPoint lineBStart:blockTopLeft lineBEnd:blockBottomLeft];
    CGPoint intersectionRight = [InterceptCalculator findLineSegmentsIntersection:laserpoint lineAEnd:laserDirectionPoint lineBStart:blockTopRight lineBEnd:blockBottomRight];
    
    if (CGPointEqualToPoint(intersectionTop, CGPointZero) && CGPointEqualToPoint(intersectionBottom, CGPointZero) && CGPointEqualToPoint(intersectionLeft, CGPointZero) && CGPointEqualToPoint(intersectionRight, CGPointZero)) {
        return nil;
    }
    
    CGFloat distanceTop = 99999;
    CGFloat distanceBottom = 99999;
    CGFloat distanceLeft = 99999;
    CGFloat distanceRight = 99999;
    
    if (!CGPointEqualToPoint(intersectionTop, CGPointZero)) {
        distanceTop = [InterceptCalculator findDistanceBetweenPoints:laserpoint endpoint:intersectionTop];
        CGFloat distanceTopDirection = [InterceptCalculator findDistanceBetweenPoints:laserDirectionPoint endpoint:intersectionTop];
        
        //if (isNeigborBlockView) { NSLog(@"Neighbor at top: %.1f, %1.f", distanceTop, distanceTopDirection); }
    
        //BOOL neighborDistance = (distanceTop >= 2.0f && distanceTopDirection >= 2.0f);
        //NSLog(@"Dist top: %d / %.1f, %.1f", neighborDistance, distanceTop, distanceTopDirection);

        if (distanceTop < distanceTopDirection && !isNeigborBlockView) {
        //if (distanceTop < distanceTopDirection) {
            distanceTop = 99999;
            intersectionTop = CGPointZero;
        }
    }
    if (!CGPointEqualToPoint(intersectionBottom, CGPointZero)) {
        distanceBottom = [InterceptCalculator findDistanceBetweenPoints:laserpoint endpoint:intersectionBottom];
        CGFloat distanceBottomDirection = [InterceptCalculator findDistanceBetweenPoints:laserDirectionPoint endpoint:intersectionBottom];
        
        //if (isNeigborBlockView) { NSLog(@"Neighbor at bottom: %.1f, %1.f", distanceBottom, distanceBottomDirection); }
        
        //BOOL neighborDistance = (distanceBottom >= 2.0f && distanceBottomDirection >= 2.0f);
        //NSLog(@"Dist bottom: %d / %.1f, %.1f", neighborDistance, distanceBottom, distanceBottomDirection);
        
        if (distanceBottom < distanceBottomDirection && !isNeigborBlockView) {
        //if (distanceBottom < distanceBottomDirection) {
            distanceBottom = 99999;
            intersectionBottom = CGPointZero;
        }
    }
    if (!CGPointEqualToPoint(intersectionLeft, CGPointZero)) {
        distanceLeft = [InterceptCalculator findDistanceBetweenPoints:laserpoint endpoint:intersectionLeft];
        CGFloat distanceLeftDirection = [InterceptCalculator findDistanceBetweenPoints:laserDirectionPoint endpoint:intersectionLeft];
        
        //if (isNeigborBlockView) { NSLog(@"Neighbor at left: %.1f, %1.f", distanceLeft, distanceLeftDirection); }
        
        //BOOL neighborDistance = (distanceLeft >= 2.0f && distanceLeftDirection >= 2.0f);
        //NSLog(@"Dist left: %d / %.1f, %.1f", neighborDistance, distanceLeft, distanceLeftDirection);
        
        if (distanceLeft < distanceLeftDirection && !isNeigborBlockView) {
        //if (distanceLeft < distanceLeftDirection) {
            distanceLeft = 99999;
            intersectionLeft = CGPointZero;
        }
    }
    if (!CGPointEqualToPoint(intersectionRight, CGPointZero)) {
        distanceRight = [InterceptCalculator findDistanceBetweenPoints:laserpoint endpoint:intersectionRight];
        CGFloat distanceRightDirection = [InterceptCalculator findDistanceBetweenPoints:laserDirectionPoint endpoint:intersectionRight];
        
        //if (isNeigborBlockView) { NSLog(@"Neighbor at right: %.1f, %1.f", distanceRight, distanceRightDirection); }
        
        //BOOL neighborDistance = (distanceRight >= 2.0f && distanceRightDirection >= 2.0f);
        //NSLog(@"Dist right: %d / %.1f, %.1f", neighborDistance, distanceRight, distanceRightDirection);
        
        if (distanceRight < distanceRightDirection && !isNeigborBlockView) {
        //if (distanceRight < distanceRightDirection) {
            distanceRight = 99999;
            intersectionRight = CGPointZero;
        }
    }
    
    //if (isNeigborBlockView) { NSLog(@"Distances: %.1f, %.1f, %.1f, %.1f", distanceTop, distanceBottom, distanceLeft, distanceRight); }
    
    if (distanceTop < distanceBottom && distanceTop < distanceLeft && distanceTop < distanceRight) {
        //if (isNeigborBlockView) { NSLog(@"Neighbor at top first"); }
        blockView.touchingLightPoint = intersectionTop;
        blockView.touchingLightBorder = laserBorderPositionTop;
        blockView.touchingLightAngle = angle;
        blockView.touchingNeighbor = isNeigborBlockView;
        return blockView;
    }
    if (distanceBottom < distanceTop && distanceBottom < distanceLeft && distanceBottom < distanceRight) {
        //if (isNeigborBlockView) { NSLog(@"Neighbor at bottom first"); }
        blockView.touchingLightPoint = intersectionBottom;
        blockView.touchingLightBorder = laserBorderPositionBottom;
        blockView.touchingLightAngle = angle;
        blockView.touchingNeighbor = isNeigborBlockView;
        return blockView;
    }
    if (distanceLeft < distanceTop && distanceLeft < distanceBottom && distanceLeft < distanceRight) {
        //if (isNeigborBlockView) { NSLog(@"Neighbor at left first"); }
        blockView.touchingLightPoint = intersectionLeft;
        blockView.touchingLightBorder = laserBorderPositionLeft;
        blockView.touchingLightAngle = angle;
        blockView.touchingNeighbor = isNeigborBlockView;
        return blockView;
    }
    if (distanceRight < distanceTop && distanceRight < distanceBottom && distanceRight < distanceLeft) {
        //if (isNeigborBlockView) { NSLog(@"Neighbor at right first"); }
        blockView.touchingLightPoint = intersectionRight;
        blockView.touchingLightBorder = laserBorderPositionRight;
        blockView.touchingLightAngle = angle;
        blockView.touchingNeighbor = isNeigborBlockView;
        return blockView;
    }
    return nil;
}

/*
- (BlockView *) getNeighboringBlockViewForPointAndAngleWithBlockView:(CGPoint)point angle:(CGFloat)angle blockView:(BlockView *)blockView {
    
    CGPoint laserpoint = point;
    
    double angleradians = angle * M_PI / 180;
    double length = 1.0; // Dummy length
    double endX = cos(angleradians) * length + laserpoint.x;
    double endY = sin(angleradians) * length + laserpoint.y;
    CGPoint laserDirectionPoint = CGPointMake(endX, endY);
    
    if (CGRectContainsPoint(blockView.frame, laserpoint)) {
        NSLog(@"GetNeighboringBlockview: laser point is in frame. May be source block view");
        if (CGRectContainsPoint(blockView.frame, laserDirectionPoint)) {
            NSLog(@"GetNeighboringBlockview: laser direction point is in frame");
            
            BlockView *neighoringBlockView = [self getIntersectingBlockViewForPointAndAngleWithBlockView:point angle:angle blockView:blockView];
            
            
            return blockView;
        }
    }
    
    return nil;
}
*/

- (BlockView *) getClosestTouchingBlockViewForPointAndAngle:(CGPoint)point angle:(CGFloat)angle {
    CGPoint laserpoint = point;
    
    CGFloat minDistance = 99999;
    BlockView *closestBlockView = nil;
    
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[BlockView class]]) {
            BlockView *blockView = (BlockView *)currentview;
            
            /*
            // Check if blockview has touching neighbor. If yes leave for-each because there will be only one if any
            BlockView *neighboringBlockView = [self getNeighboringBlockViewForPointAndAngleWithBlockView:point angle:angle blockView:blockView];
            if (neighboringBlockView) {
                closestBlockView = neighboringBlockView;
                return closestBlockView;
            }
            */
            
            BlockView *touchingBlockView = [self getIntersectingBlockViewForPointAndAngleWithBlockView:point angle:angle blockView:blockView];
            
            if (touchingBlockView) {
                //NSLog(@"Laser touching block: %d, %.1f, %.1f", blockView.blocknumber, touchingBlockView.touchingLightPoint.x, touchingBlockView.touchingLightPoint.y);
                
                // Check if blockview has touching neighbor. If yes leave for-each because there will be only one if any
                if (touchingBlockView.touchingNeighbor) {                    
                    //NSLog(@"getClosestTouchingBlockViewForPointAndAngle. Is neighbor %d", touchingBlockView.blocknumber);

                    return touchingBlockView;
                }
                
                // No neighboring blockview check if light intersects with blockview further away and mark if closest so far
                CGFloat distance = [InterceptCalculator findDistanceBetweenPoints:laserpoint endpoint:touchingBlockView.touchingLightPoint];
                if (distance < minDistance) {
                    minDistance = distance;
                    closestBlockView = touchingBlockView;
                }
            }
        }
    }
    return closestBlockView;
}

/*
- (CGPoint) getBorderPointForLaserView:(LaserView *)laserView {
    CGPoint laserpointoriginal = CGPointMake(laserView.laserXCenter, laserView.laserYCenter);
    CGPoint laserpoint = [self.view convertPoint:laserpointoriginal fromView:laserView];
    
    double angle = laserView.laserangle * M_PI / 180;
    double length = 1.0; // Dummy length
    double endX = cos(angle) * length + laserpoint.x;
    double endY = sin(angle) * length + laserpoint.y;
    CGPoint laserDirectionPoint = CGPointMake(endX, endY);
    CGPoint borderpoint = [InterceptCalculator findInterceptFromSource:laserpoint andTouch:laserDirectionPoint withinBounds:self.view.bounds];
    return borderpoint;
}
*/

- (CGPoint) getBorderPointForPointAndAngle:(CGPoint)point angle:(CGFloat)angle {
    double angleradians = angle * M_PI / 180;
    double length = 1.0; // Dummy length
    double endX = cos(angleradians) * length + point.x;
    double endY = sin(angleradians) * length + point.y;
    CGPoint laserDirectionPoint = CGPointMake(endX, endY);
    
    //CGRect gameBorder = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOPBARLASERMARGIN - BUTTONHEIGHT);
    CGRect gameBorder = CGRectMake(0, TOPBARLASERMARGIN + BUTTONHEIGHT, self.view.frame.size.width, self.view.frame.size.height);
    
    //NSLog(@"Game border: %.1f, %.1f, %.1f, %.1f", gameBorder.origin.x, gameBorder.origin.y, gameBorder.size.width, gameBorder.size.height);
    //NSLog(@"Frame: %.1f, %.1f", self.view.frame.size.width, self.view.frame.size.height);
    
    CGPoint borderpoint = [InterceptCalculator findInterceptFromSource:point andTouch:laserDirectionPoint withinBounds:gameBorder];
    
    //borderpoint.y += TOPBARLASERMARGIN + BUTTONHEIGHT;
    
    return borderpoint;
}

- (LightLine *)getInitialLightLineForStartPointAndAngleAndColor:(CGPoint)startpoint angle:(CGFloat)angle colorcode:(NSUInteger)colorcode {
    
    CGPoint borderpoint = [self getBorderPointForPointAndAngle:startpoint angle:angle];
    
    BlockView *touchingBlock  = [self getClosestTouchingBlockViewForPointAndAngle:startpoint angle:angle];

    LightLine *lightLine = [[LightLine alloc] init];
    lightLine.startPoint = startpoint;
    lightLine.lightColor = [UIColor getLaserColorForColorCode: colorcode];
    lightLine.lightColorCode = colorcode;
    
    if (touchingBlock) {
        lightLine.endPoint = touchingBlock.touchingLightPoint;
        lightLine.touchesBorder = NO;
        lightLine.touchingBlockview = touchingBlock;
        lightLine.touchesEndBlock = NO;
        
        if (touchingBlock.blocktype == fixedNonReflectingBlock || touchingBlock.blocktype == movableNonReflectingBlock) {
            lightLine.touchesEndBlock = YES;
        }
    } else {
        lightLine.endPoint = borderpoint;
        lightLine.touchesBorder = YES;
        lightLine.touchesEndBlock = NO;
        lightLine.touchingBlockview = nil;
    }
    return lightLine;
}

/*
- (NSArray *)getLightLinesForStartPointAndAngleAndColor:(CGPoint)startpoint angle:(CGFloat)angle colorcode:(NSUInteger)colorcode {
    
    CGPoint borderpoint = [self getBorderPointForPointAndAngle:startpoint angle:angle];
    
    BlockView *touchingBlock  = [self getClosestTouchingBlockViewForPointAndAngle:startpoint angle:angle];
    
    LightLine *lightLine = [[LightLine alloc] init];
    lightLine.startPoint = startpoint;
    lightLine.lightColor = [UIColor getLaserColorForColorCode: colorcode];
    lightLine.lightColorCode = colorcode;
    
    if (touchingBlock) {
        lightLine.endPoint = touchingBlock.touchingLightPoint;
        lightLine.touchesBorder = NO;
        lightLine.touchingBlockview = touchingBlock;
        lightLine.touchesEndBlock = NO;
        
        if (touchingBlock.blocktype == fixedNonReflectingBlock || touchingBlock.blocktype == movableNonReflectingBlock) {
            lightLine.touchesEndBlock = YES;
        }
    } else {
        lightLine.endPoint = borderpoint;
        lightLine.touchesBorder = YES;
        lightLine.touchesEndBlock = NO;
        lightLine.touchingBlockview = nil;
    }
    return [NSArray arrayWithObject: lightLine];
}
*/

- (NSArray *)getLightLinesForTouchingBlockViewAndColor:(BlockView *)blockview colorcode:(NSUInteger)colorcode {
    
    //NSLog(@"getLightLinesForTouchingBlockViewAndColor. Block: %d",blockview.blocknumber);
    
    NSMutableArray *lightLines = [NSMutableArray array];
    
    // Get out point and out angle depending on block type
    BlockView *outBlockView = [self getOutBlockViewWithLightOutAngleAndPointForTouchingBlockView: blockview];
    CGPoint startpoint = outBlockView.outLightPoint;
    CGFloat angle = outBlockView.outLightAngle;
    
    //NSLog(@"getLightLinesForTouchingBlockViewAndColor. Block: %d / %.1f, %.1f / %.1f",blockview.blocknumber, startpoint.x, startpoint.y, angle);
    
    CGPoint borderpoint = [self getBorderPointForPointAndAngle:startpoint angle:angle];
    BlockView *touchingBlock  = [self getClosestTouchingBlockViewForPointAndAngle:startpoint angle:angle];
    
    /*
    if (touchingBlock && touchingBlock.touchingNeighbor) {
        NSLog(@"getLightLinesForTouchingBlockViewAndColor. %d. Start: %.1f, %.1f /%.1f", touchingBlock.blocknumber, startpoint.x, startpoint.y, angle);
        NSLog(@"getLightLinesForTouchingBlockViewAndColor. Neighbor. %d / %.1f, %.1f / %d / %.1f",touchingBlock.blocknumber, touchingBlock.touchingLightPoint.x, touchingBlock.touchingLightPoint.y, touchingBlock.touchingLightBorder, touchingBlock.touchingLightAngle);
    }
    */
    
    LightLine *lightLine = [[LightLine alloc] init];
    lightLine.startPoint = startpoint;
    lightLine.lightColor = [UIColor getLaserColorForColorCode: colorcode];
    lightLine.lightColorCode = colorcode;
    
    if (touchingBlock) {
        lightLine.endPoint = touchingBlock.touchingLightPoint;
        lightLine.touchesBorder = NO;
        lightLine.touchingBlockview = touchingBlock;
        lightLine.touchesEndBlock = NO;
        
        if (touchingBlock.blocktype == fixedNonReflectingBlock || touchingBlock.blocktype == movableNonReflectingBlock) {
            lightLine.touchesEndBlock = YES;
        }
    } else {
        lightLine.endPoint = borderpoint;
        lightLine.touchesBorder = YES;
        lightLine.touchesEndBlock = NO;
        lightLine.touchingBlockview = nil;
    }
    [lightLines addObject: lightLine];
    
    if (blockview.blocktype == movablePassingBlock || blockview.blocktype == fixedPassingBlock) {
        LightLine *lightLinepassing = [[LightLine alloc] init];
        lightLinepassing.startPoint = blockview.touchingLightPoint;
        lightLinepassing.lightColor = [UIColor getLaserColorForColorCode: colorcode];
        lightLinepassing.lightColorCode = colorcode;
        
        lightLinepassing.endPoint = blockview.outLightPoint;
        lightLinepassing.touchesBorder = NO;
        lightLinepassing.touchingBlockview = nil;
        lightLinepassing.touchesEndBlock = NO;
        [lightLines addObject:lightLinepassing];
    }
    
    if (blockview.blocktype == movableSplittingBlock || blockview.blocktype == fixedSplittingBlock) {
        LightLine *lightLinepassing = [[LightLine alloc] init];
        lightLinepassing.startPoint = blockview.touchingLightPoint;
        lightLinepassing.lightColor = [UIColor getLaserColorForColorCode: colorcode];
        lightLinepassing.lightColorCode = colorcode;
        
        lightLinepassing.endPoint = blockview.outLightPointSecondSplittingBlock;
        lightLinepassing.touchesBorder = NO;
        lightLinepassing.touchingBlockview = nil;
        lightLinepassing.touchesEndBlock = NO;
        [lightLines addObject:lightLinepassing];
        
        CGPoint borderpointsecond = [self getBorderPointForPointAndAngle:blockview.outLightPointSecondSplittingBlock angle:blockview.outLightAngleSecondSplittingBlock];
        BlockView *touchingBlocksecond  = [self getClosestTouchingBlockViewForPointAndAngle:blockview.outLightPointSecondSplittingBlock angle:blockview.outLightAngleSecondSplittingBlock];
        
        LightLine *lightLinesecond = [[LightLine alloc] init];
        lightLinesecond.startPoint = blockview.outLightPointSecondSplittingBlock;
        lightLinesecond.lightColor = [UIColor getLaserColorForColorCode: colorcode];
        lightLinesecond.lightColorCode = colorcode;
        
        if (touchingBlocksecond) {
            lightLinesecond.endPoint = touchingBlocksecond.touchingLightPoint;
            lightLinesecond.touchesBorder = NO;
            lightLinesecond.touchingBlockview = touchingBlocksecond;
            lightLinesecond.touchesEndBlock = NO;
            
            if (touchingBlocksecond.blocktype == fixedNonReflectingBlock || touchingBlocksecond.blocktype == movableNonReflectingBlock) {
                lightLinesecond.touchesEndBlock = YES;
            }
        } else {
            lightLinesecond.endPoint = borderpointsecond;
            lightLinesecond.touchesBorder = YES;
            lightLinesecond.touchesEndBlock = NO;
            lightLinesecond.touchingBlockview = nil;
        }
        
        [lightLines addObject: lightLinesecond];
    }

    return lightLines;
}

- (BlockView *)getOutBlockViewWithLightOutAngleAndPointForTouchingBlockView:(BlockView *)blockView {
    
    if (blockView.blocktype == movableNightyDegreeReflectingBlock || blockView.blocktype == fixedNightyDegreeReflectingBlock || blockView.blocktype == movableNonReflectingBlock || blockView.blocktype == fixedNonReflectingBlock) {
        blockView.outLightPoint = blockView.touchingLightPoint;
        blockView.outLightBorder = blockView.touchingLightBorder;
        
        if (blockView.touchingLightBorder == laserBorderPositionTop) {
            if (blockView.touchingLightAngle == 45) {
                blockView.outLightAngle = 315;
            }
            if (blockView.touchingLightAngle == 135) {
                blockView.outLightAngle = 225;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionBottom) {
            if (blockView.touchingLightAngle == 315) {
                blockView.outLightAngle = 45;
            }
            if (blockView.touchingLightAngle == 225) {
                blockView.outLightAngle = 135;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionLeft) {
            if (blockView.touchingLightAngle == 45) {
                blockView.outLightAngle = 135;
            }
            if (blockView.touchingLightAngle == 315) {
                blockView.outLightAngle = 225;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionRight) {
            if (blockView.touchingLightAngle == 135) {
                blockView.outLightAngle = 45;
            }
            if (blockView.touchingLightAngle == 225) {
                blockView.outLightAngle = 315;
            }
        }
    }
    
    if (blockView.blocktype == movablePassingBlock || blockView.blocktype == fixedPassingBlock) {
        blockView.outLightAngle = blockView.touchingLightAngle;
        
        if (blockView.touchingLightBorder == laserBorderPositionTop) {
            blockView.outLightBorder = laserBorderPositionBottom;
            CGPoint outpoint = blockView.touchingLightPoint;
            outpoint.y += blockView.frame.size.height;
            blockView.outLightPoint = outpoint;
        }
        if (blockView.touchingLightBorder == laserBorderPositionBottom) {
            blockView.outLightBorder = laserBorderPositionTop;
            CGPoint outpoint = blockView.touchingLightPoint;
            outpoint.y -= blockView.frame.size.height;
            blockView.outLightPoint = outpoint;
        }
        if (blockView.touchingLightBorder == laserBorderPositionLeft) {
            blockView.outLightBorder = laserBorderPositionRight;
            CGPoint outpoint = blockView.touchingLightPoint;
            outpoint.x += blockView.frame.size.width;
            blockView.outLightPoint = outpoint;
        }
        if (blockView.touchingLightBorder == laserBorderPositionRight) {
            blockView.outLightBorder = laserBorderPositionLeft;
            CGPoint outpoint = blockView.touchingLightPoint;
            outpoint.x -= blockView.frame.size.width;
            blockView.outLightPoint = outpoint;
        }
    }
    
    if (blockView.blocktype == movableSplittingBlock || blockView.blocktype == fixedSplittingBlock) {
        
        blockView.outLightPoint = blockView.touchingLightPoint;
        blockView.outLightAngleSecondSplittingBlock = blockView.touchingLightAngle;
        blockView.outLightBorder = blockView.touchingLightBorder;
        
        if (blockView.touchingLightBorder == laserBorderPositionTop) {
            if (blockView.touchingLightAngle == 45) {
                blockView.outLightAngle = 315;
                 
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x += blockView.frame.size.height/2;
                outpoint.y += blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionRight;
            }
            if (blockView.touchingLightAngle == 135) {
                blockView.outLightAngle = 225;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x -= blockView.frame.size.height/2;
                outpoint.y += blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionLeft;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionBottom) {
            if (blockView.touchingLightAngle == 315) {
                blockView.outLightAngle = 45;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x += blockView.frame.size.height/2;
                outpoint.y -= blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionRight;
            }
            if (blockView.touchingLightAngle == 225) {
                blockView.outLightAngle = 135;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x -= blockView.frame.size.height/2;
                outpoint.y -= blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionLeft;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionLeft) {
            if (blockView.touchingLightAngle == 45) {
                blockView.outLightAngle = 135;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x += blockView.frame.size.height/2;
                outpoint.y += blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionBottom;
            }
            if (blockView.touchingLightAngle == 315) {
                blockView.outLightAngle = 225;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x += blockView.frame.size.height/2;
                outpoint.y -= blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionTop;
            }
        }
        if (blockView.touchingLightBorder == laserBorderPositionRight) {
            if (blockView.touchingLightAngle == 135) {
                blockView.outLightAngle = 45;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x -= blockView.frame.size.height/2;
                outpoint.y += blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionBottom;
            }
            if (blockView.touchingLightAngle == 225) {
                blockView.outLightAngle = 315;
                
                CGPoint outpoint = blockView.touchingLightPoint;
                outpoint.x -= blockView.frame.size.height/2;
                outpoint.y -= blockView.frame.size.height/2;
                blockView.outLightPointSecondSplittingBlock = outpoint;
                
                blockView.outLightBorderSecondSplittingBlock = laserBorderPositionTop;
            }
        }
    }
    
    return blockView;
}

- (void) calculateLaserLights {
    NSLog(@"Calculate laser lights");
    
    [_lightView backupLightLines];
    [_lightView removeLightLines];
    
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[LaserView class]]) {

            LaserView *laserView = (LaserView *)currentview;
            CGPoint laserpointoriginal = CGPointMake(laserView.laserXCenter, laserView.laserYCenter);
            CGPoint laserpoint = [self.view convertPoint:laserpointoriginal fromView:laserView];
            
            LightLine *lightLine = [self getInitialLightLineForStartPointAndAngleAndColor:laserpoint angle:laserView.laserangle colorcode:laserView.lasercolor];
            [_lightView addLightLine:lightLine];
            
            NSUInteger maxSteps = 0;
            //first lightline already ended because it touches a non reflecting block or the border
            BOOL allLightLinesEnded = (lightLine.touchesBorder || lightLine.touchesEndBlock);
                        
            if (!allLightLinesEnded) {
                //NSLog(@"Not all lines ended");
                NSMutableArray *processingLightlines = [NSMutableArray arrayWithObject:lightLine];
                NSMutableArray *lightlinesForFurtherProcessing = [NSMutableArray array];
                
                while (!allLightLinesEnded) {
                    //NSLog(@"While processing: %d", maxSteps);
                    [lightlinesForFurtherProcessing removeAllObjects];
                    for (LightLine *processingLightline in processingLightlines) {
                        //NSLog(@"Processing line: %d", maxSteps);
                        //BlockView *outBlockView = [self getBlockViewWithLightOutAngleAndPointForTouchingBlockView: processingLightline.touchingBlockview];
                        //NSArray *nextLightlines = [self getLightLinesForStartPointAndAngleAndColor:outBlockView.outLightPoint angle:outBlockView.outLightAngle colorcode:laserView.lasercolor];
                        
                        // Process only lightlines outside blockview touching another block or the border but no lightlines passing through a block
                        if (processingLightline.touchingBlockview) {
                            NSArray *nextLightlines = [self getLightLinesForTouchingBlockViewAndColor:processingLightline.touchingBlockview colorcode:laserView.lasercolor];
                            
                            //NSLog(@"Got next light lines: %d", [nextLightlines count]);
                            [_lightView addLightLines:nextLightlines];
                            
                            NSArray *tempLightlinesForFurtherProcessing = [nextLightlines objectsAtIndexes:[nextLightlines indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                LightLine *currentLightlineChecking = (LightLine *)obj;
                                //NSLog(@"Temp checking lightline: border: %d, endblock: %d", currentLightlineChecking.touchesBorder, currentLightlineChecking.touchesEndBlock);
                                BOOL lightlineEnded = (currentLightlineChecking.touchesBorder || currentLightlineChecking.touchesEndBlock);
                                //NSLog(@"Temp checking lightline: %d", lightlineEnded);
                                return !lightlineEnded;
                            }]];
                            //NSLog(@"Temp next lines: %d", [tempLightlinesForFurtherProcessing count]);
                            [lightlinesForFurtherProcessing addObjectsFromArray:tempLightlinesForFurtherProcessing];
                            //NSLog(@"Next lines further: %d", [lightlinesForFurtherProcessing count]);
                        }
                    }
                    
                    if (lightlinesForFurtherProcessing && [lightlinesForFurtherProcessing count] > 0) {
                        //NSLog(@"Replace next lightline for processing");
                        [processingLightlines removeAllObjects];
                        [processingLightlines addObjectsFromArray:lightlinesForFurtherProcessing];
                    } else {
                        //NSLog(@"No next lightlines for processing");
                        allLightLinesEnded = YES;
                    }
                    
                    maxSteps++;
                    
                    if (maxSteps >= MAXLASERSTEPS) {
                        allLightLinesEnded = YES;
                    }
                }
            }
        }
    }
    [_lightView setNeedsDisplay];
    
    if (![_lightView areLightLinesEqualToPreviousLines]) {
        [[SoundManager sharedSoundManager] playLaserSound];
    }
}

- (void) checkIfTargetLightsTouchedWithLight {
    NSLog(@"checkIfTargetLightsTouchedWithLight");
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[TargetView class]]) {
            TargetView *targetView = (TargetView *)currentview;
            //targetView.targetTouched = NO;
            CGPoint targetpointoriginal = CGPointMake(targetView.targetXCenter, targetView.targetYCenter);
            CGPoint targetpoint = [self.view convertPoint:targetpointoriginal fromView:targetView];
            //NSLog(@"Check target with light: %d, %d / %.1f, %.1f", targetView.targetnumberX, targetView.targetnumberY, targetpoint.x, targetpoint.y);
            BOOL currentTargetViewTouched = NO;
            
            for (LightLine *lightline in [_lightView lightLines]) {
                if ([InterceptCalculator isPointOnLineAndBetweenPoints:targetpoint lineStart:lightline.startPoint lineEnd:lightline.endPoint]) {
                    if (targetView.targetcolor == lightline.lightColorCode) {
                        
                        currentTargetViewTouched = YES;
                        
                        /*
                        //targetView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                            //recognizer.view.frame = blockFrame;
                            targetView.alpha = 0.5;
                            //CGAffineTransform t = CGAffineTransformMakeScale(1.2, 1.2);
                            //t = CGAffineTransformTranslate(t, 0.5, 0.5);
                            //targetView.transform = t;
                        } completion:^(BOOL completed){
                            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                //recognizer.view.frame = blockFrame;
                                targetView.alpha = 1.0;
                                //CGAffineTransform t = CGAffineTransformIdentity;
                                //t = CGAffineTransformTranslate(t, 0.5, 0.5);
                                //targetView.transform = t;
                            } completion:^(BOOL completed){
                                [targetView fadeIn];
                            }];
                        }];
                        */
                        
                    }
                }
            }
            
            if (currentTargetViewTouched) {                
                if (!targetView.targetTouched) {
                    NSLog(@"Target touched with light: %d, %d", targetView.targetnumberX, targetView.targetnumberY);
                    
                    [targetView fadeIn];
                    targetView.targetTouched = YES;
                    [[SoundManager sharedSoundManager] playLightSound];
                } else {
                    //NSLog(@"Target already touched with light: %d, %d", targetView.targetnumberX, targetView.targetnumberY);
                }
            } else {
                if (targetView.targetTouched) {
                    //NSLog(@"Target un-touched with light: %d, %d", targetView.targetnumberX, targetView.targetnumberY);
                    [targetView fadeOut];
                    targetView.targetTouched = NO;
                }
            }
        }
    }
}

- (void) checkIfGameSolved {
    BOOL gameSolved = YES;
    NSUInteger numbersOfTargetViews = 0;
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[TargetView class]]) {
            TargetView *targetView = (TargetView *)currentview;
            if (!targetView.targetTouched) {
                gameSolved = NO;
            }
            numbersOfTargetViews++;
        }
    }
    if (gameSolved && numbersOfTargetViews > 0) {
        [self gamesolved];
    }
}

- (SquareView *)getClosestSquareViewToBlock:(BlockView *)blockview {
        
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[SquareView class]]) {
            
            SquareView *currentsquareview = (SquareView *)currentview;
            currentsquareview.intersectionSurface = 0;
            
            if(CGRectIntersectsRect(blockview.frame, currentsquareview.frame)) {
                CGRect interRect = CGRectIntersection(blockview.frame, currentsquareview.frame);
                CGFloat surface = CGRectGetHeight(interRect) * CGRectGetWidth(interRect);
                currentsquareview.intersectionSurface = surface;
            }

        }
    }
    
    SquareView *closestSquareView = nil;
    CGFloat maxSurface = 0;
    
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[SquareView class]]) {
            SquareView *currentsquareview = (SquareView *)currentview;
            
            if (currentsquareview.intersectionSurface > 0 && currentsquareview.intersectionSurface > maxSurface) {
                maxSurface = currentsquareview.intersectionSurface;
                closestSquareView = currentsquareview;
            }
        }
    }
    
    return closestSquareView;
}

- (void) calculateLightsAndCheckForGameState {
    [self calculateLaserLights];
    [self checkIfTargetLightsTouchedWithLight];
    [self checkIfGameSolved];
}

- (BOOL) isSquareAlreadyOccupiedForSquareNumberXAndY:(NSUInteger)numberX numberY:(NSUInteger)numberY {
        
    NSUInteger squareSize = SQUARESIZEIPAD;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        squareSize = SQUARESIZEIPHONE;
    }
        
    CGFloat blockXCoord = _gridMinX + numberX * squareSize;
    CGFloat blockYCoord = _gridMinY + numberY * squareSize;
    
    NSLog(@"Check numberXY: %d, %d / %.1f, %.1f", numberX, numberY, blockXCoord, blockYCoord);
    
    BOOL isOccupied = NO;
    
    for (UIView *currentview in self.view.subviews) {
        if ([currentview isKindOfClass:[BlockView class]]) {
            BlockView *currentblockview = (BlockView *)currentview;
            
            NSLog(@"Check block numberXY: %.1f, %.1f", currentblockview.frame.origin.x, currentblockview.frame.origin.y);
            
            if (currentblockview.frame.origin.x == blockXCoord && currentblockview.frame.origin.y == blockYCoord) {
                NSLog(@"Check block occupied");
                isOccupied = YES;
            }
    
        }
    }
    return isOccupied;
}

- (void) handlePan:(UIPanGestureRecognizer *)recognizer {
    
    BlockView *blockView = (BlockView*)recognizer.view;
    
    BOOL movableBlockType = (blockView.blocktype == movableNightyDegreeReflectingBlock || blockView.blocktype == movableNonReflectingBlock || blockView.blocktype == movablePassingBlock || blockView.blocktype == movableSplittingBlock);
    if (!movableBlockType) {
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
        
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startX = blockView.frame.origin.x;
        _startY = blockView.frame.origin.y;
        //blockView.alpha = 0.5;
        
        //Copy touched blockview for dragging
        self.movingBlockView = [[BlockView alloc] initWithFrameAndTypeAndNumber:blockView.frame blocktype:blockView.blocktype blocknumer:blockView.blocknumber];
        [self.view addSubview: _movingBlockView];
        _movingBlockView.alpha = 0.4f;
    }
    
    //NSInteger originAndTranslationX = recognizer.view.frame.origin.x + translation.x;
    //NSInteger originAndTranslationY = recognizer.view.frame.origin.y + translation.y;
    
    NSInteger originAndTranslationX = _movingBlockView.frame.origin.x + translation.x;
    NSInteger originAndTranslationY = _movingBlockView.frame.origin.y + translation.y;
    
    NSInteger minViewX = self.view.frame.origin.x -  _squareSize / 2;
    NSInteger maxViewX = self.view.frame.origin.x + self.view.frame.size.width + _squareSize / 2;
    
    NSInteger minViewY = self.view.frame.origin.y -  _squareSize / 2;
    NSInteger maxViewY = self.view.frame.origin.y + self.view.frame.size.height + _squareSize / 2;
    
    //BOOL insideGrid = (originAndTranslationX >= _gridMinX && originAndTranslationX + _squareSize <= _gridMaxX) && (originAndTranslationY>= _gridMinY && originAndTranslationY + _squareSize <= _gridMaxY);
    
    BOOL insideScene = (originAndTranslationX >= minViewX && originAndTranslationX + _squareSize <= maxViewX && originAndTranslationY >= minViewY && originAndTranslationY + _squareSize <= maxViewY);
    
    if (insideScene && movableBlockType) {
        //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        _movingBlockView.center = CGPointMake(_movingBlockView.center.x + translation.x, _movingBlockView.center.y + translation.y);
    }
        
    /*
    if (recognizer.view.center.x >= _gridMaxX && !_gamecompleted) {
        _gamecompleted = YES;
        [self gamesolved];
    }
    */
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        //SquareView *closestSquareView = [self getClosestSquareViewToBlock: (BlockView *)recognizer.view];
        SquareView *closestSquareView = [self getClosestSquareViewToBlock: _movingBlockView];
        if (closestSquareView) {
            //NSLog(@"Closestview: %d, %d", closestSquareView.squarenumberX, closestSquareView.squarenumberY);
            
            // Are there any deactivated grid squares?
            if (_deactivatedGrids && [_deactivatedGrids count] > 0) {
                // YES: check if block can be moved to target position (target square must not be deactivated
                NSString *deactivatedSquareCode = [NSString stringWithFormat:@"%d|%d", closestSquareView.squarenumberX, closestSquareView.squarenumberY];
                BOOL targetSquareDeactivated = [_deactivatedGrids indexOfObject: deactivatedSquareCode] != NSNotFound;
                BOOL targetSquareOccupied = [self isSquareAlreadyOccupiedForSquareNumberXAndY:closestSquareView.squarenumberX numberY:closestSquareView.squarenumberY];
                BOOL movableToTargetSquare = targetSquareDeactivated || targetSquareOccupied;
                
                NSLog(@"%d, %d, %d", targetSquareDeactivated, targetSquareOccupied, movableToTargetSquare);
                
                if (movableToTargetSquare) {       //Is target square deactivated ?
                    // Yes: move block back to original position
                    //CGRect blockFrame = CGRectMake(_startX, _startY, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
                    CGRect blockFrame = CGRectMake(_startX, _startY, _movingBlockView.frame.size.width, _movingBlockView.frame.size.height);
                    
                    NSLog(@"Target square deactivated. Move back to original square");
                    //[[SoundManager sharedSoundManager] playBlockSound];
                    [UIView animateWithDuration:BLOCKMOVEANIMATIONTIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        //recognizer.view.frame = blockFrame;
                        _movingBlockView.frame = blockFrame;
                    } completion:^(BOOL completed){
                        blockView.frame = blockFrame;
                        [_movingBlockView removeFromSuperview];
                        self.movingBlockView = nil;
                        [self calculateLightsAndCheckForGameState];
                    }];
                } else {
                    // NO: move block to target grid position
                    CGRect blockFrame = closestSquareView.frame;
                    NSLog(@"Target square not deactivated. Move to target position");
                    [[SoundManager sharedSoundManager] playBlockSound];
                    [UIView animateWithDuration:BLOCKMOVEANIMATIONTIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        //recognizer.view.frame = blockFrame;
                        _movingBlockView.frame = blockFrame;
                    } completion:^(BOOL completed){
                        blockView.frame = blockFrame;
                        [_movingBlockView removeFromSuperview];
                        self.movingBlockView = nil;
                        [self calculateLightsAndCheckForGameState];
                    }];
                }
            } else {
                // NO: move block to target grid position
                CGRect blockFrame = closestSquareView.frame;
                NSLog(@"No deactivated squares. Move to target position");
                [[SoundManager sharedSoundManager] playBlockSound];
                [UIView animateWithDuration:BLOCKMOVEANIMATIONTIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    //recognizer.view.frame = blockFrame;
                    _movingBlockView.frame = blockFrame;
                } completion:^(BOOL completed){
                    blockView.frame = blockFrame;
                    [_movingBlockView removeFromSuperview];
                    self.movingBlockView = nil;
                    [self calculateLightsAndCheckForGameState];
                }];
            }
        } else {
            // No clostest square that intersects with block view. Move back to original position
            //CGRect blockFrame = CGRectMake(_startX, _startY, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
            CGRect blockFrame = CGRectMake(_startX, _startY, _movingBlockView.frame.size.width, _movingBlockView.frame.size.height);
            NSLog(@"No closest square. Move back to original square");
            //[[SoundManager sharedSoundManager] playBlockSound];
            [UIView animateWithDuration:BLOCKMOVEANIMATIONTIME delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //recognizer.view.frame = blockFrame;
                _movingBlockView.frame = blockFrame;
            } completion:^(BOOL completed){
                blockView.frame = blockFrame;
                [_movingBlockView removeFromSuperview];
                self.movingBlockView = nil;
                [self calculateLightsAndCheckForGameState];
            }];
        }
        
        if (recognizer.state == UIGestureRecognizerStateCancelled) {
            CGRect blockFrame = CGRectMake(_startX, _startY, _movingBlockView.frame.size.width, _movingBlockView.frame.size.height);
            blockView.frame = blockFrame;
            [_movingBlockView removeFromSuperview];
            self.movingBlockView = nil;
            [self calculateLightsAndCheckForGameState];
        }
        
        //blockView.alpha = 1.0;
    }
}

- (void) gamesolved {
    //NSLog(@"Game completed");
    
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *worldfile = [NSString stringWithFormat:@"GameWorld%d.plist", _gameworld + 1];
    NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: worldfile];
    
    CFStringRef errStr = NULL;
    NSMutableDictionary *worlds = nil;
    NSData *data = [NSData dataWithContentsOfFile:worldpath];
    if ( ! data ) {
        NSLog(@"An error occurred: couldn't read from %@", worldpath);
    } else {
        worlds = (__bridge NSMutableDictionary *)CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef) data, kCFPropertyListMutableContainersAndLeaves, &errStr);
        if ( errStr != NULL ) {
            NSLog(@"An error occurred: %@", (__bridge NSString *)errStr);
            // Edited "errstr" to "errStr" for those wishing to copy/paste CFRelease(errStr);
        } else {
            //NSLog(@"Property list loaded succesfully!");
        }
    }
    
    //NSLog(@"friends: %@", worlds);
    
    NSMutableArray *levels = [worlds objectForKey: @"levels"];
    NSMutableDictionary *level = [levels objectAtIndex: _gamelevel];
    [level setValue: [NSNumber numberWithInt: 1] forKey: @"completed"];
    [worlds writeToFile:worldpath atomically: YES];
    
    CGSize size = [UIApplication currentScreenSize];
    
    UIView *transparentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, size.width, size.height)];
    transparentView.backgroundColor = [UIColor clearColor];
    
    UIView *gamesolvedView = [[UIView alloc] initWithFrame: CGRectMake(0, size.height / 2, size.width, 0)];
    gamesolvedView.backgroundColor = [[UIColor gameSolvedViewBackgroundColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview: transparentView];
    [transparentView addSubview: gamesolvedView];
    
    CGRect viewFrame = gamesolvedView.frame;
    viewFrame.origin.y = (size.height - SOLVEDVIEWHEIGHT) / 2;
    viewFrame.size.height = SOLVEDVIEWHEIGHT;
    
    UIButton *nextGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextGameButton.backgroundColor = [UIColor gameSolvedButtonBackgroundColor];
    //nextGameButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    nextGameButton.showsTouchWhenHighlighted = YES;
    nextGameButton.frame = CGRectMake(0, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    [nextGameButton addTarget: self action: @selector(nextGameAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextGameButton setTitle:NSLocalizedString(@"Next", @"Puzzle solved next button title") forState:UIControlStateNormal];
    nextGameButton.titleLabel.textColor = [UIColor gameSolvedButtonTextColor];
    nextGameButton.layer.cornerRadius = 10;
    
    UIButton *listGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listGameButton.backgroundColor = [UIColor gameSolvedButtonBackgroundColor];
    //nextGameButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    listGameButton.showsTouchWhenHighlighted = YES;
    listGameButton.frame = CGRectMake(0, 0, BUTTONHEIGHT, BUTTONHEIGHT);
    [listGameButton addTarget: self action: @selector(listGameAction:) forControlEvents:UIControlEventTouchUpInside];
    [listGameButton setTitle:NSLocalizedString(@"List", @"Puzzle solved list button title") forState:UIControlStateNormal];
    listGameButton.titleLabel.textColor = [UIColor gameSolvedButtonTextColor];
    listGameButton.layer.cornerRadius = 10;
    
    UILabel *solvedLabel =[[UILabel alloc] initWithFrame: CGRectMake((size.width - 320)/2, 22, 320, 25)];
    solvedLabel.font = [UIFont systemFontOfSize:23.0];
    solvedLabel.backgroundColor = [UIColor clearColor];
    solvedLabel.textColor = [UIColor gameSolvedLabelBackgroundColor];
    solvedLabel.textAlignment = NSTextAlignmentCenter;
    solvedLabel.alpha = 0.0;
    solvedLabel.text = NSLocalizedString(@"PUZZLE SOLVED!", @"Puzzle solved label text");
    [gamesolvedView addSubview: solvedLabel];
    
    [[SoundManager sharedSoundManager] playSuccessSound];
    
    [self saveNextGameWorldAndLevel];
    
    [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        gamesolvedView.frame = viewFrame;
    } completion: ^(BOOL completed){
        listGameButton.frame = CGRectMake(-SOLVEDBUTTONWIDTH, (gamesolvedView.frame.size.height - SOLVEDBUTTONHEIGHT)/2 + 20, SOLVEDBUTTONWIDTH, SOLVEDBUTTONHEIGHT);
        [gamesolvedView addSubview: listGameButton];
        
        nextGameButton.frame = CGRectMake(gamesolvedView.frame.size.width, (gamesolvedView.frame.size.height - SOLVEDBUTTONHEIGHT)/2 + 20, SOLVEDBUTTONWIDTH, SOLVEDBUTTONHEIGHT);
        [gamesolvedView addSubview: nextGameButton];
        
        CGRect listFrame = CGRectMake(gamesolvedView.frame.size.width / 2 - SOLVEDBUTTONWIDTH - 40, (gamesolvedView.frame.size.height - SOLVEDBUTTONHEIGHT)/2 + 20, SOLVEDBUTTONWIDTH, SOLVEDBUTTONHEIGHT);
        CGRect nextFrame = CGRectMake(gamesolvedView.frame.size.width / 2 + 40, (gamesolvedView.frame.size.height - SOLVEDBUTTONHEIGHT)/2 + 20, SOLVEDBUTTONWIDTH, SOLVEDBUTTONHEIGHT);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            nextGameButton.frame = nextFrame;
            listGameButton.frame = listFrame;
            solvedLabel.alpha = 1.0;
        } completion:nil];
        
    }];
}


- (void) nextGameAction:(id)sender {
    //NSLog(@"Next game action");
    
    UIButton *button = (UIButton *)sender;
    UIView *sv = button.superview;
    UIView *tv = button.superview.superview;
    
    for (UIView *cv in sv.subviews) {
        [cv removeFromSuperview];
    }
    [sv removeFromSuperview];
    sv = nil;
    [tv removeFromSuperview];
    tv = nil;
    
    [self cleanupGame];
    
    NSUInteger gworld = _gameworld;
    NSUInteger glevel = _gamelevel;
    
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *worldfile = [NSString stringWithFormat:@"GameWorld%d.plist", gworld + 1];
    NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: worldfile];
    NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
    NSArray *levels = [world objectForKey: @"levels"];
    
    if (glevel + 1 > levels.count - 1) {
        //NSLog(@"Init new world and level");
        
        NSMutableArray *worldsarray = [NSMutableArray array];
        NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: documentsdirectory error:NULL];
        for (NSString *filestring in dirContents) {
            if ([filestring hasPrefix:@"GameWorld"] && [filestring hasSuffix:@".plist"]) {
                
                NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: filestring];
                NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
                [worldsarray addObject: world];
            }
        }
        
        if (worldsarray.count > gworld + 1) {
            //NSLog(@"Init new world + 1 and level 0");
            _gameworld = gworld + 1;
            _gamelevel = 0;
            [[SoundManager sharedSoundManager] playButton1Sound];
            [self initGameWithWorldAndLevel:gworld + 1 gamelevel: 0];
        } else {
            //NSLog(@"End of all levels reached. Push back.");
            [self pushBackController: nil];
        }
        
    } else {
        //NSLog(@"Init next level of same world");
        _gameworld = gworld;
        _gamelevel = glevel + 1;
        [[SoundManager sharedSoundManager] playButton1Sound];
        [self initGameWithWorldAndLevel:gworld gamelevel: glevel + 1];
    }
}

- (void) saveNextGameWorldAndLevel {
    NSUInteger gworld = _gameworld;
    NSUInteger glevel = _gamelevel;
    
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *worldfile = [NSString stringWithFormat:@"GameWorld%d.plist", gworld + 1];
    NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: worldfile];
    NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
    NSArray *levels = [world objectForKey: @"levels"];
    
    if (glevel + 1 > levels.count - 1) {        
        NSMutableArray *worldsarray = [NSMutableArray array];
        NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: documentsdirectory error:NULL];
        for (NSString *filestring in dirContents) {
            if ([filestring hasPrefix:@"GameWorld"] && [filestring hasSuffix:@".plist"]) {
                
                NSString *worldpath = [documentsdirectory stringByAppendingPathComponent: filestring];
                NSDictionary *world = [NSDictionary dictionaryWithContentsOfFile: worldpath];
                [worldsarray addObject: world];
            }
        }
        
        if (worldsarray.count > gworld + 1) {
            gworld += 1;
            glevel = 0;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *soundOn = [prefs stringForKey:@"sound"];
            if (soundOn) {
                [prefs setInteger:gworld forKey:@"selectedworld"];
                [prefs setInteger:glevel forKey:@"selectedlevel"];
                [prefs synchronize];
            }
        } else {
            gworld = 0;
            glevel = 0;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *soundOn = [prefs stringForKey:@"sound"];
            if (soundOn) {
                [prefs setInteger:gworld forKey:@"selectedworld"];
                [prefs setInteger:glevel forKey:@"selectedlevel"];
                [prefs synchronize];
            }
        }
        
    } else {        
        glevel += 1;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *soundOn = [prefs stringForKey:@"sound"];
        if (soundOn) {
            [prefs setInteger:gworld forKey:@"selectedworld"];
            [prefs setInteger:glevel forKey:@"selectedlevel"];
            [prefs synchronize];
        }
    }
}

- (void) listGameAction:(id)sender {
    //NSLog(@"List game action");
    
    UIButton *button = (UIButton *)sender;
    UIView *sv = button.superview;
    UIView *tv = button.superview.superview;
    
    for (UIView *cv in sv.subviews) {
        [cv removeFromSuperview];
    }
    [sv removeFromSuperview];
    sv = nil;
    [tv removeFromSuperview];
    tv = nil;
    
    [self pushBackController: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
