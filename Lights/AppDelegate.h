//
//  AppDelegate.h
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameDirectorViewController.h"
#import "GameLevelsViewController.h"
#import "GameLightsSceneViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GameDirectorViewController *gameDirectorViewController;
@property (strong, nonatomic) GameLevelsViewController *gameLevelsViewController;

@property (strong, nonatomic) GameLightsSceneViewController *gameLightsSceneViewController;

@property (assign) BOOL shopOpen;
@property (assign) BOOL shopIsReinitializing;

@end
