//
//  GameLightsSceneBackgroundView.m
//  Lights
//
//  Created by Alain on 26.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "GameLightsSceneBackgroundView.h"

@implementation GameLightsSceneBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    //CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
    //    1.0, 1.0, 1.0, 0.06 }; // End color
    CGFloat components[8] = { 254.0/255.0f, 254.0/255.0f, 254.0/255.0f, 0.5,  // Start color
        173.0/255.0f, 173.0/255.0f, 173.0/255.0f, 0.5 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    //CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    //CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    CGContextDrawRadialGradient(currentContext, glossGradient, midCenter, 200.0f, midCenter, 700.0f, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

@end
