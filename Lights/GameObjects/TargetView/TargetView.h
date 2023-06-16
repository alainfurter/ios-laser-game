//
//  TargetView.h
//  Lights
//
//  Created by Alain on 26.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TargetView : UIView

@property (assign) NSInteger targetnumberX;
@property (assign) NSInteger targetnumberY;

@property (assign) NSUInteger targetborderposition;

@property (assign) NSUInteger targetcolor;

@property (assign) NSInteger targetXCoord;
@property (assign) NSInteger targetYCoord;

@property (assign) NSInteger targetXCenter;
@property (assign) NSInteger targetYCenter;

@property (assign) BOOL targetTouched;

@property (nonatomic,strong)CIFilter *filter;

@property (nonatomic,strong) UIImageView *touchedImageView;

- (id)initWithFrameAndNumberXAndNumberYAndBorderposition:(CGRect)frame targetnumberX:(NSUInteger)targetnumberX targetnumberY:(NSUInteger)targetnumberY targetborderposition:(NSUInteger)targetborderposition targetcolor:(NSUInteger)targetcolor;

- (void)fadeOut;
- (void)fadeIn;

@end
