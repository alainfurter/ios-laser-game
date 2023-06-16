//
//  LevelView.m
//  Blocks
//
//  Created by Alain on 30.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "LevelButton.h"

#import "Config.h"

#import "UIColor+Lights.h"

@implementation LevelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStateWorldAndLevel:(CGRect)frame state:(NSUInteger)state world:(NSUInteger)world level:(NSUInteger)level color:(NSUInteger)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _buttonstate = state;
        _buttonworld = world;
        _buttonlevel = level;
        _buttoncolor = color;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// Abstracted Attributes
    //CGRect rectangleRect = CGRectInset(rect, LEVELBUTTONMARGIN, LEVELBUTTONMARGIN);

    NSUInteger widthadjustment = (LEVELBUTTONIPADW - LEVELBUTTONIPADSMALLW)/2;
    NSUInteger heightadjustment = (LEVELBUTTONIPADH - LEVELBUTTONIPADSMALLH)/2;
    
    //NSLog(@"W/UH: %d, %d", widthadjustment, heightadjustment);
    
    CGRect rectangleRect = CGRectInset(rect, widthadjustment, heightadjustment);
    
    //UIColor *squareStroke = [UIColor getBlockColorForColorCode:_buttoncolor];
    
    UIColor *worldbuttonColor = [UIColor colorWithRed:193.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *squareStroke = [UIColor darkenedColor:worldbuttonColor difference:0.1 * _buttonworld];
    
    if (_buttonstate == stateCompleted) {
        CGFloat red, green, blue, alpha;
        [squareStroke getRed: &red
                       green: &green
                        blue: &blue
                       alpha: &alpha];
        
        squareStroke = [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
    }
    
    CGFloat radius = LEVELBUTTONIPADRADIUS;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        radius = LEVELBUTTONIPHONERADIUS;
    }
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rectangleRect cornerRadius:radius];
    [squareStroke setFill];
    [rectanglePath fill];
    //[squareStroke setStroke];
    //rectanglePath.lineWidth = 8;
    //[rectanglePath stroke];
}

- (UIColor *)getWorldColor {
    //UIColor *squareStroke = [UIColor getBlockColorForColorCode:_buttoncolor];
    UIColor *worldbuttonColor = [UIColor colorWithRed:193.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *squareStroke = [UIColor darkenedColor:worldbuttonColor difference:0.1 * _buttonworld];
    return squareStroke;
}

@end
