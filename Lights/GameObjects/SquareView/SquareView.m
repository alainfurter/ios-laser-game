//
//  SquareView.m
//  Blocks
//
//  Created by Alain on 28.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SquareView.h"

#import "UIColor+Lights.h"

@implementation SquareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrameAndNumber:(CGRect)frame squarenumberX:(NSUInteger)squarenumberX squarenumberY:(NSUInteger)squarenumberY {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        _squarenumberX = squarenumberX;
        _squarenumberY = squarenumberY;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    
    CGFloat radius = 22;
    CGRect rectangleRect = CGRectInset(rect, 6, 6);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        radius = 12;
        rectangleRect = CGRectInset(rect, 2, 2);
    }
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect cornerRadius: radius];
    CGPathRef visiblePath = CGPathCreateCopy(rectanglePath.CGPath);
    
    // Fill this path
    //UIColor *aColor = [UIColor redColor];
    UIColor* squareStroke = [[UIColor squareStrokeColor] colorWithAlphaComponent:0.2];
    [squareStroke setFill];
    CGContextAddPath(context, visiblePath);
    CGContextFillPath(context);
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(CGPathGetPathBoundingBox(visiblePath), -5, -5));
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);
    
    // Now setup the shadow properties on the context
    squareStroke = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f];;
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 7.0f, [squareStroke CGColor]);
    
    // Now fill the rectangle, so the shadow gets drawn
    [squareStroke setFill];
    CGContextSaveGState(context);   
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    // Release the paths
    CGPathRelease(path);    
    CGPathRelease(visiblePath);
}


@end
