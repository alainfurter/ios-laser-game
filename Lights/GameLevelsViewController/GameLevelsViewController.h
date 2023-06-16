//
//  GameLevelsViewController.h
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "GameLightsSceneViewController.h"
#import "SettingsViewController.h"
#import "SettingsButton.h"
#import "NextLevelButton.h"

@interface GameLevelsViewController : UIViewController <GameLightsSceneViewControllerDelegate, SettingsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *worlds;
@property (nonatomic, strong) NSMutableArray *worldbuttons;
@property (nonatomic, strong) NSMutableArray *levelbuttons;

@property (nonatomic, strong) UIImageView *gameTitle;
@property (nonatomic, strong) UIImageView *gameTitleRed;

@property (strong, nonatomic) SettingsButton *settingsButtoniPad;
@property (strong, nonatomic) UIButton *settingsButtoniPhone;

@property (strong, nonatomic) NextLevelButton *nextGameLevelButton;

@property (assign) NSUInteger selectedWorld;
@property (assign) NSUInteger selectedLevel;

@property (strong, nonatomic) GameLightsSceneViewController *gameLightsSceneViewController;
@property (strong, nonatomic) SettingsViewController *settingsViewController;

@end
