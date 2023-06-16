//
//  SettingsViewController.h
//  Blocks
//
//  Created by Alain on 07.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>
- (void)pushSettingsViewController:(SettingsViewController *)controller;
@end


@interface SettingsViewController : UIViewController

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UITapGestureRecognizer *recognizer;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *soundLabel;
@property (strong, nonatomic) UILabel *fxLabel;

@property (weak) id <SettingsViewControllerDelegate> delegate;

@end
