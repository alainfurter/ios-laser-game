//
//  LightView.m
//  Lights
//
//  Created by Alain on 25.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "LightView.h"

#import "UIColor+Lights.h"
#import "Config.h"

#define LIGHTLINEWIDTH 1.0f
#define GLOWWIDTH 8.0f

@implementation LightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.lightLines = [NSMutableArray array];
    }
    return self;
}

-(void) backupLightLines {
    [_previouslightLines removeAllObjects];
    self.previouslightLines = nil;
    self.previouslightLines = [NSMutableArray arrayWithArray: [_lightLines copy]];
}

-(BOOL) areLightLinesEqualToPreviousLines {
    if (!_previouslightLines && !_lightLines) {
        //NSLog(@"No previous and current lines");
        return YES;
    }
    if ((_previouslightLines && !_lightLines) || (!_previouslightLines && _lightLines)) {
        NSLog(@"No previous and/or current lines");
        return NO;
    } 
    if ([_previouslightLines count] == 0 && [_lightLines count] == 0) {
        //NSLog(@"0 previous and current lines");
        return YES;
    }
    if ([_previouslightLines count] != [_lightLines count]) {
        //NSLog(@"Previous and current lines not same amount");
        return NO;
    }
    if ([_previouslightLines count] == [_lightLines count]) {
        //NSLog(@"Previous and current same amount of lines");
        BOOL allLinesAreEqual = YES;
        for (int i = 0; i < [_lightLines count]; i++) {
            LightLine *currentLightline = [_lightLines objectAtIndex: i];
            LightLine *previousLightline = [_previouslightLines objectAtIndex: i];
            BOOL linesAreEqual = YES;
            if (!CGPointEqualToPoint(currentLightline.startPoint, previousLightline.startPoint)) {
                linesAreEqual = NO;
            }
            if (!CGPointEqualToPoint(currentLightline.endPoint, previousLightline.endPoint)) {
                linesAreEqual = NO;
            }
            if (currentLightline.lightColorCode != previousLightline.lightColorCode) {
                linesAreEqual = NO;
            }
            if (!linesAreEqual) {
                allLinesAreEqual = NO;
            }
        }
        return allLinesAreEqual;
    }
    return NO;
}


-(void) addLightLine:(LightLine *)lightLine {
    if (lightLine) {
        [_lightLines addObject:lightLine];
    }
}

-(void) addLightLines:(NSArray *)lightLines {
    if (lightLines && [lightLines count] > 0) {
        [_lightLines addObjectsFromArray: lightLines];
    }
}

-(void) removeLightLines {
    [_lightLines removeAllObjects];
}

- (void) drawLightLines {
    if (_lightLines && [_lightLines count] > 0) {
        NSLog(@"Draw light lines");
        
        NSMutableArray *redLightlines = [NSMutableArray array];
        for (LightLine *lightLine in _lightLines) {
            if (lightLine.lightColorCode == laserColorRed) {
                [redLightlines addObject: lightLine];
            }
        }
        
        NSMutableArray *blueLightlines = [NSMutableArray array];
        for (LightLine *lightLine in _lightLines) {
            if (lightLine.lightColorCode == laserColorBlue) {
                [blueLightlines addObject: lightLine];
            }
        }
        
        NSMutableArray *yellowLightlines = [NSMutableArray array];
        for (LightLine *lightLine in _lightLines) {
            if (lightLine.lightColorCode == laserColorYellow) {
                [yellowLightlines addObject: lightLine];
            }
        }
        
        NSMutableArray *greenLightlines = [NSMutableArray array];
        for (LightLine *lightLine in _lightLines) {
            if (lightLine.lightColorCode == laserColorGreen) {
                [greenLightlines addObject: lightLine];
            }
        }
        
        if (redLightlines && [redLightlines count] > 0) {
            [self drawLightLines: redLightlines];
        }
        
        if (blueLightlines && [blueLightlines count] > 0) {
            [self drawLightLines: blueLightlines];
        }
        
        if (yellowLightlines && [yellowLightlines count] > 0) {
            [self drawLightLines: yellowLightlines];
        }
        
        if (greenLightlines && [greenLightlines count] > 0) {
            [self drawLightLines: greenLightlines];
        }
    }
}

- (void) drawLightLines:(NSArray *)lightLines {

    LightLine *lightLine = [lightLines objectAtIndex:0];
    
    CGMutablePathRef path = NULL;
    path = CGPathCreateMutable();
    
    //CGPathMoveToPoint(path, NULL, firstLine.startPoint.x, firstLine.startPoint.y);
    //CGPathAddLineToPoint(path, NULL, firstLine.endPoint.x, firstLine.endPoint.y);
    
    for (int i = 0; i < [lightLines count]; i++) {
        LightLine *lightLine = [lightLines objectAtIndex:i];
        CGPathMoveToPoint(path, NULL, lightLine.startPoint.x, lightLine.startPoint.y);
        CGPathAddLineToPoint(path, NULL, lightLine.endPoint.x, lightLine.endPoint.y);
    }
    
    //NSLog(@"Drawline: %.1f, %.1f / %.1f, %.1f", lightLine.startPoint.x, lightLine.startPoint.y, lightLine.endPoint.x, lightLine.endPoint.y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawPath:path inContext:context withColor: [lightLine lightColor]];
    
    CGPathRelease(path);
    //CGContextRelease(context);
}

/*
- (void) drawLightLine:(LightLine *)lightLine {
    CGMutablePathRef path = NULL;
    path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, lightLine.startPoint.x, lightLine.startPoint.y);
    CGPathAddLineToPoint(path, NULL, lightLine.endPoint.x, lightLine.endPoint.y);
    
    //NSLog(@"Drawline: %.1f, %.1f / %.1f, %.1f", lightLine.startPoint.x, lightLine.startPoint.y, lightLine.endPoint.x, lightLine.endPoint.y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    [self drawPath:path inContext:context withColor: [lightLine lightColor]];
    
    CGPathRelease(path);
}
*/

- (UIImage *)maskWithPaths:(NSArray *)paths bounds:(CGRect)bounds
{
    // Get the scale for good results on Retina screens.
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize scaledSize = CGSizeMake(bounds.size.width * scale, bounds.size.height * scale);
    
    // Create the bitmap with just an alpha channel.
    // When created, it has value 0 at every pixel.
    CGContextRef gc = CGBitmapContextCreate(NULL, scaledSize.width, scaledSize.height, 8, scaledSize.width, NULL, kCGImageAlphaOnly);
    
    // Adjust the current transform matrix for the screen scale.
    CGContextScaleCTM(gc, scale, scale);
    // Adjust the CTM in case the bounds origin isn't zero.
    CGContextTranslateCTM(gc, -bounds.origin.x, -bounds.origin.y);
    
    // whiteColor has all components 1, including alpha.
    CGContextSetFillColorWithColor(gc, [UIColor whiteColor].CGColor);
    
    // Fill each path into the mask.
    for (UIBezierPath *path in paths) {
        CGContextBeginPath(gc);
        CGContextAddPath(gc, path.CGPath);
        CGContextFillPath(gc);
    }
    
    // Turn the bitmap context into a UIImage.
    CGImageRef cgImage = CGBitmapContextCreateImage(gc);
    CGContextRelease(gc);
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    return image;
}

- (UIImage *)invertedImageWithMask:(UIImage *)mask color:(UIColor *)color
{
    CGRect rect = { CGPointZero, mask.size };
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, mask.scale); {
        // Fill the entire image with color.
        [color setFill];
        UIRectFill(rect);
        // Now erase the masked part.
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawInnerGlowWithPaths:(NSArray *)paths bounds:(CGRect)bounds color:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur
{
    UIImage *mask = [self maskWithPaths:paths bounds:bounds];
    UIImage *invertedImage = [self invertedImageWithMask:mask color:color];
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    // Save the graphics state so I can restore the clip and
    // shadow attributes after drawing.
    CGContextSaveGState(gc); {
        CGContextClipToMask(gc, bounds, mask.CGImage);
        CGContextSetShadowWithColor(gc, offset, blur, color.CGColor);
        [invertedImage drawInRect:bounds];
    } CGContextRestoreGState(gc);
}

- (void)drawPath:(CGPathRef)path inContext:(CGContextRef)context withColor:(UIColor *)lightColor {
    
    UIColor *baseColor = lightColor;
    //CGFloat shadowAlpha = 0.2f;
    //CGFloat secondNormalPathAlpha = 0.7f;
    CGFloat lineWidth = LIGHTLINEWIDTH;
    
    /*
    // draw non-active routes less intense
    if (!activeRoute) {
        baseColor = [baseColor colorWithAlphaComponent:0.65f];
        lineWidth = LIGHTLINEWIDTH * 0.75f;
        shadowAlpha = 0.15f;
        secondNormalPathAlpha = 0.45f;
    }
    */
        
    //CGFloat darkPathLineWidth = lineWidth;
    //CGFloat darkPathLineWidthOther = lineWidth * 10;
    
    //CGFloat normalPathLineWidth = roundf(darkPathLineWidth * 0.8f);
    //CGFloat innerGlowPathLineWidth = roundf(darkPathLineWidth * 0.9f);
    
    // Setup graphics context
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //UIColor *darkenedColor = darkenedColor(baseColor, 0.1f);
    //UIColor *darkenedColor = [UIColor darkenedColor: baseColor difference: 0.1f];
    
    /*
    // Draw dark path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, darkPathLineWidth);
    CGContextSetFillColorWithColor(context, baseColor.CGColor);
    CGContextSetStrokeColorWithColor(context, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(0.f, darkPathLineWidthOther/10.f), darkPathLineWidthOther/10.f, [UIColor colorWithWhite:0.f alpha:shadowAlpha].CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(2.0f, 2.0f), 3.0f, baseColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(-2.0f, -2.0f), 3.0f, baseColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(2.0f, -2.0f), 3.0f, baseColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(-2.0f, 2.0f), 3.0f, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(2.0f, 0.0f), 3.0f, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 2.0f), 3.0f, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(-2.0f, 0.0f), 3.0f, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(0.0f, -2.0f), 3.0f, baseColor.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(darkPathLineWidthOther/10.f, darkPathLineWidthOther/10.f), darkPathLineWidthOther/10.f, baseColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    */
    
    /*
    //Outer glow path
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextSetLineWidth(context, lineWidth * 2);
    CGContextSetStrokeColorWithColor(context, [baseColor colorWithAlphaComponent:shadowAlpha].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    
    // Draw normal path
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextSetLineWidth(context, normalPathLineWidth);
    CGContextSetStrokeColorWithColor(context, [baseColor colorWithAlphaComponent:0.7f].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    */
    
    UIColor *glowColor = [UIColor darkenedColor: baseColor difference: 0.1f];
    UIColor *laserColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    CGContextSaveGState(context);
    CGFloat glowIterator = GLOWWIDTH - LIGHTLINEWIDTH;
    CGFloat glowStep = 1.0f / glowIterator / 2;
    CGFloat glowAlpha = glowStep;
    for (CGFloat i = glowIterator; i >=0 ; i--) {
        //NSLog(@"Width: %.1f, %.1f", i, glowAlpha);
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        CGContextSetLineWidth(context, i);
        CGContextSetStrokeColorWithColor(context, [glowColor colorWithAlphaComponent:glowAlpha].CGColor);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        
        glowAlpha += glowStep;
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeLighten);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, laserColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    //UIBezierPath *bezierpath = [UIBezierPath bezierPathWithCGPath:path];
    
    //[self drawInnerGlowWithPaths:[NSArray arrayWithObject:bezierpath] bounds:self.bounds color:baseColor offset:CGSizeMake(5, 5) blur:0.3f];
    
    /*
    // Draw inner glow path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, innerGlowPathLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.f alpha:0.1f].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    */
    
    /*
    // Draw normal path again
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    normalPathLineWidth = roundf(lineWidth * 0.6f);
    CGContextSetLineWidth(context, normalPathLineWidth);
    CGContextSetStrokeColorWithColor(context, [darkenedColor colorWithAlphaComponent:secondNormalPathAlpha].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    */ 
}

/*
- (void)drawPath:(CGPathRef)path inContext:(CGContextRef)context withColor:(UIColor *)lightColor {
    
    UIColor *baseColor = lightColor;
    CGFloat shadowAlpha = 0.4f;
    CGFloat secondNormalPathAlpha = 0.7f;
    CGFloat lineWidth = LIGHTLINEWIDTH;
        
    CGFloat darkPathLineWidth = lineWidth;
    CGFloat darkPathLineWidthOther = lineWidth;
    
    CGFloat normalPathLineWidth = roundf(darkPathLineWidth * 0.8f);
    CGFloat innerGlowPathLineWidth = roundf(darkPathLineWidth * 0.9f);
    
    // Setup graphics context
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //UIColor *darkenedColor = darkenedColor(baseColor, 0.1f);
    UIColor *darkenedColor = [UIColor darkenedColor: baseColor difference: 0.1f];
    
    // Draw dark path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, darkPathLineWidth);
    CGContextSetFillColorWithColor(context, darkenedColor.CGColor);
    CGContextSetStrokeColorWithColor(context, darkenedColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.f, darkPathLineWidthOther/10.f), darkPathLineWidthOther/10.f, [UIColor colorWithWhite:0.f alpha:shadowAlpha].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // Draw normal path
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextSetLineWidth(context, normalPathLineWidth);
    CGContextSetStrokeColorWithColor(context, baseColor.CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // Draw inner glow path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, innerGlowPathLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.f alpha:0.1f].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    // Draw normal path again
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    normalPathLineWidth = roundf(lineWidth * 0.6f);
    CGContextSetLineWidth(context, normalPathLineWidth);
    CGContextSetStrokeColorWithColor(context, [baseColor colorWithAlphaComponent:secondNormalPathAlpha].CGColor);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawLightLines];
}


@end
