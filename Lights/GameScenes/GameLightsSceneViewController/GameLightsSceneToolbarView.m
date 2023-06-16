//
//  GameLightsSceneToolbarView.m
//  Lights
//
//  Created by Alain on 04.06.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "GameLightsSceneToolbarView.h"

#define SHADOW_HEIGHT 5.0f
#define SHADOW_INSET  20.0f
#define SHADOW_ARC_INSET  50.0f

#define LINE_INSET    20.0f
#define LINE_SPACE    0.0f

#define bottom_line_color               [UIColor lightGrayColor]

typedef enum {
    LinePositionTop = 0,
    LinePositionBottom,
} LinePosition;

@implementation GameLightsSceneToolbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) drawLineAtPosition:(LinePosition)position rect:(CGRect)rect color:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    float y = 0;
    switch (position) {
        case LinePositionTop:
            y = CGRectGetMinY(rect) + LINE_SPACE;
            break;
        case LinePositionBottom:
            y = CGRectGetMaxY(rect) - LINE_SPACE;
        default:
            break;
    }
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect) + LINE_INSET, y);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) - LINE_INSET, y);
    
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void) drawBottomLine:(CGRect)rect {
    [self drawLineAtPosition:LinePositionBottom rect:rect color:bottom_line_color];
}

- (UIBezierPath *)createArrowShadowPath:(CGRect)rect {
	CGFloat edgeInset = SHADOW_INSET;
	CGFloat shadowDepth = SHADOW_HEIGHT;
    CGFloat shadowArcInset = SHADOW_ARC_INSET;
        
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(CGRectGetMinX(rect) + edgeInset, CGRectGetMinY(rect) + edgeInset)];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - edgeInset, CGRectGetMinY(rect) + edgeInset)];
	[path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - edgeInset, CGRectGetMaxY(rect))];
	[path addCurveToPoint:CGPointMake(CGRectGetMinX(rect) + edgeInset, CGRectGetMaxY(rect))
			controlPoint1:CGPointMake(CGRectGetMaxX(rect) - edgeInset - shadowArcInset, CGRectGetMaxY(rect) + shadowDepth)
			controlPoint2:CGPointMake(CGRectGetMinX(rect) + edgeInset + shadowArcInset, CGRectGetMaxY(rect) + shadowDepth)];

	return path;
}

- (void) setArrowShadowWithOpacity:(float)shadowOpacity {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowRadius = 1.0f;
    self.layer.masksToBounds = NO;
    UIBezierPath *shadowPath = [self createArrowShadowPath:self.frame];
    self.layer.shadowPath = shadowPath.CGPath;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 
 [super drawRect:rect];
 [self drawBottomLine: self.frame];
 //[self setArrowShadowWithOpacity: 0.0f];
}

@end
