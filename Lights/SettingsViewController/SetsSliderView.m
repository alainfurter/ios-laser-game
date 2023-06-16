//
//  SetsSliderView.m
//  Blocks
//
//  Created by Alain on 07.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SetsSliderView.h"

@implementation SetsSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect viewFrame = CGRectInset(rect, 5, 5);
    UIColor* fillColor = [UIColor colorWithRed: 170.0f/255.0f green: 0 blue: 0 alpha: 1];
    
    //// Abstracted Attributes
    CGRect roundedRectangleRect = viewFrame;
    CGFloat roundedRectangleCornerRadius = 3;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: roundedRectangleCornerRadius];
    [fillColor setFill];
    [roundedRectanglePath fill];
    [fillColor setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
}


@end
