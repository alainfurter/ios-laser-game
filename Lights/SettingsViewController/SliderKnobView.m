//
//  SliderKnobView.m
//  Blocks
//
//  Created by Alain on 07.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SliderKnobView.h"

@implementation SliderKnobView

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
    // Drawing code
    CGRect viewFrame = CGRectInset(rect, 5, 5);
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 255.0f/255.0f green: 255.0f/255.0f blue: 255.0f/255.0f alpha: 1];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: viewFrame];
    [fillColor setFill];
    [ovalPath fill];
    [fillColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
}

@end
