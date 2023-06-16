//
//  SettingsButton.m
//  Blocks
//
//  Created by Alain on 17.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "SettingsButton.h"

@implementation SettingsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIColor* buttonColorTitleNormal = [UIColor colorWithRed: 184.0f/255.0f green: 184.0f/255.0f blue: 184.0f/255.0f alpha: 1];
        UIColor* buttonColorTitleHighlighted = [UIColor blackColor];
        
        [self setTitleColor:buttonColorTitleNormal forState:UIControlStateNormal];
        [self setTitleColor:buttonColorTitleHighlighted forState:UIControlStateHighlighted];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        } else {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
        }
        
        NSString* textContent = NSLocalizedString(@"Settings", @"Settings label text");
        
        [self setTitle:textContent forState:UIControlStateNormal];
        [self setTitle:textContent forState:UIControlStateHighlighted];
    }
    return self;
}


CGMutablePathRef createOneCornerRoundedRectForRect(CGRect rect, CGFloat radius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    
    //CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    //CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    //CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    //CGPathCloseSubpath(path);
    
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
        buttonCornerRadiusOutside = 25.0;
        buttonCornerRadiusInside = 20.0;
    }
        
    CGMutablePathRef outerPath = createOneCornerRoundedRectForRect(CGRectInset(rect, 3, 3), buttonCornerRadiusOutside);
    CGMutablePathRef innerPath = createOneCornerRoundedRectForRect(CGRectInset(rect, 4, 4), buttonCornerRadiusInside);
    
    if (self.state != UIControlStateHighlighted) {
        CGContextSaveGState(context);
        
        CGContextSetStrokeColorWithColor(context, buttonColor.CGColor);
        CGContextSetLineWidth(context, 4.0f);
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
        CGContextAddPath(context, outerPath);
        CGContextStrokePath(context);
        
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextAddPath(context, innerPath);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    }
    
    CFRelease(outerPath);
    CFRelease(innerPath);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithWhite:0.8 alpha:1];
    UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Abstracted Attributes
    CGRect roundedRectangleRect = CGRectInset(rect, 10, 10);
    CGFloat roundedRectangleCornerRadius = 25;
    NSString* textContent = NSLocalizedString(@"Settings", @"Settings label text");
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: roundedRectangleCornerRadius];
    [fillColor setFill];
    [roundedRectanglePath fill];
    
    //// Text Drawing
    CGRect textRect = CGRectMake(roundedRectangleRect.origin.x, roundedRectangleRect.origin.y + 10, roundedRectangleRect.size.width, roundedRectangleRect.size.height);
    [fillColor2 setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 16] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}
*/

@end
