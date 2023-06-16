//
//  GameLightsSceneViewController.h
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LightView.h"
#import "LightLine.h"

#import "GameLightsSceneBackgroundView.h"

#import "InterceptCalculator.h"

@class GameLightsSceneViewController;

@protocol GameLightsSceneViewControllerDelegate <NSObject>
- (void)pushBackGameLightsSceneViewController:(GameLightsSceneViewController *)controller;
@end

@interface GameLightsSceneViewController : UIViewController

@property (strong, nonatomic) LightView *lightView;

@property (strong, nonatomic) BlockView *movingBlockView;

@property (strong, nonatomic) InterceptCalculator *interceptCalculator;

@property (strong, nonatomic) NSArray *deactivatedGrids;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *redoButton;
@property (strong, nonatomic) UIButton *soundButton;
@property (strong, nonatomic) UIButton *helpButton;

@property (strong, nonatomic) UILabel *worldlevelLabel;

@property (assign) NSUInteger gameworld;
@property (assign) NSUInteger gamelevel;

@property (assign) BOOL gamecompleted;

@property (assign) NSUInteger squareSize;
@property (assign) NSUInteger numberofrectswidth;
@property (assign) NSUInteger numberofrectsheight;

@property (assign) NSUInteger gridMinX;
@property (assign) NSUInteger gridMinY;
@property (assign) NSUInteger gridMaxX;
@property (assign) NSUInteger gridMaxY;

@property (assign) NSUInteger maxLeft;
@property (assign) NSUInteger maxRight;
@property (assign) NSUInteger maxUp;
@property (assign) NSUInteger maxDown;

@property (assign) NSUInteger startX;
@property (assign) NSUInteger startY;

@property (weak) id <GameLightsSceneViewControllerDelegate> delegate;

- (id)initWithWorldAndLevel:(NSUInteger)world level:(NSUInteger)level;

@end
