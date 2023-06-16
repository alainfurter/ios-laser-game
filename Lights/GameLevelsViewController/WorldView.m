//
//  WorldView.m
//  Lights
//
//  Created by Alain on 30.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "WorldView.h"

#import "Config.h"

#import "UIColor+Lights.h"

@implementation WorldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithWorld:(CGRect)frame world:(NSUInteger)world worldname:(NSString *)worldname
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _buttonworld = world;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Drawing code
    //// Abstracted Attributes
    //CGRect rectangleRect = CGRectInset(rect, LEVELBUTTONMARGIN, LEVELBUTTONMARGIN);
        
    //UIColor *squareStroke = [UIColor getBlockColorForColorCode:_buttoncolor];
    
    UIColor *worldbuttonColor = [UIColor colorWithRed:193.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *squareStroke = [UIColor darkenedColor:worldbuttonColor difference:0.1 * _buttonworld];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10.0];
    [squareStroke setFill];
    [rectanglePath fill];
    //[squareStroke setStroke];
    //rectanglePath.lineWidth = 8;
    //[rectanglePath stroke];
}

@end
