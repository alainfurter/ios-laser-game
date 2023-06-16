//
//  NextLevelButton.m
//  Lights
//
//  Created by Alain on 04.06.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "NextLevelButton.h"

@implementation NextLevelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIColor* buttonColorTitleNormal = [UIColor colorWithRed: 234.0f/255.0f green: 234.0f/255.0f blue: 234.0f/255.0f alpha: 1];
        UIColor* buttonColorTitleHighlighted = [UIColor blackColor];
        
        [self setTitleColor:buttonColorTitleNormal forState:UIControlStateNormal];
        [self setTitleColor:buttonColorTitleHighlighted forState:UIControlStateHighlighted];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        } else {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:36.0f];
        }
        
        NSString* textContent = NSLocalizedString(@"Next Level", @"Next Level label text");
        
        [self setTitle:textContent forState:UIControlStateNormal];
        [self setTitle:textContent forState:UIControlStateHighlighted];
    }
    return self;
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* buttonColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
    CGFloat buttonCornerRadiusOutside = 45.0;
    CGFloat buttonCornerRadiusInside = 40.0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        buttonCornerRadiusOutside = 20.0;
        buttonCornerRadiusInside = 15.0;
    }
    
    CGMutablePathRef outerPath = createRoundedRectForRect(CGRectInset(rect, 4, 4), buttonCornerRadiusOutside);
    CGMutablePathRef innerPath = createRoundedRectForRect(CGRectInset(rect, 10, 10), buttonCornerRadiusInside);
    CGMutablePathRef middlePath = createRoundedRectForRect(CGRectInset(rect, 6, 6), buttonCornerRadiusInside);
    
    if (self.state != UIControlStateHighlighted) {
        CGContextSaveGState(context);
        
        CGContextSetStrokeColorWithColor(context, buttonColor.CGColor);
        CGContextSetLineWidth(context, 3.0f);
        CGContextAddPath(context, outerPath);
        CGContextStrokePath(context);
        
        
        CGContextSetFillColorWithColor(context, buttonColor.CGColor);
        CGContextAddPath(context, innerPath);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    } else {
        CGContextSaveGState(context);
        
        CGContextSetStrokeColorWithColor(context, buttonColor.CGColor);
        CGContextSetLineWidth(context, 4.0f);
        CGContextAddPath(context, middlePath);
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
    }
    
    CFRelease(outerPath);
    CFRelease(innerPath);
    CFRelease(middlePath);
}

// Add the following methods to the bottom
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}


@end
