//
//  BlockView.m
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "BlockView.h"
#import "Config.h"

#define STOPSIZEWIDTHIPAD           10.0f
#define STOPSIZEMARGINIPAD          30.0f
#define STOPSIZEINTERSPACEIPAD      10.0f

#define STOPSIZEWIDTHIPHONE          5.0f
#define STOPSIZEMARGINIPHONE        10.0f
#define STOPSIZEINTERSPACEIPHONE     5.0f

@implementation BlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrameAndTypeAndNumber:(CGRect)frame blocktype:(NSUInteger)blocktype blocknumer:(NSUInteger)blocknumber {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        _blocknumber = blocknumber;
        _blocktype = blocktype;
        
        // Debug
        #ifdef DEBUGON
        CGRect labelFrame = CGRectMake((frame.size.width - 40)/2, frame.size.height - 25, 40, 20);
        self.blockNumberLabel = [[UILabel alloc] initWithFrame: labelFrame];
        _blockNumberLabel.font = [UIFont systemFontOfSize:10.0];
        _blockNumberLabel.backgroundColor = [UIColor clearColor];
        _blockNumberLabel.textColor = [UIColor whiteColor];
        _blockNumberLabel.textAlignment = NSTextAlignmentCenter;
        _blockNumberLabel.text = [NSString stringWithFormat:@"%d / %d", _blocknumber, _blocktype];
        [self addSubview: _blockNumberLabel];
        #endif
        
        CGFloat radius = 22;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            radius = 12;
        }
        
        UIBezierPath* shadowRectanglePath = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: radius];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.layer.shadowOpacity = 0.8f;
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowPath = shadowRectanglePath.CGPath;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    static CGRect nativeRect = { 0.f, 0.f, 512.f, 512.f };
    
    CGContextSaveGState(context); {
        
        // determine aspect ratio and scale from native resolution to current bounds size
        
        CGSize boundsSize = self.bounds.size;
        CGSize nativeSize = nativeRect.size;
        CGFloat nativeAspect = nativeSize.width / nativeSize.height;
        CGFloat boundsAspect = boundsSize.width / boundsSize.height;
        CGFloat scale = (nativeAspect > boundsAspect ?
                         boundsSize.width / nativeSize.width :
                         boundsSize.height / nativeSize.height);
        
        
        // transform to current bounds
        CGContextTranslateCTM(context,
                              0.5 * (boundsSize.width  - scale * nativeSize.width),
                              0.5 * (boundsSize.height - scale * nativeSize.height));
        CGContextScaleCTM(context, scale, scale);
        
        // circle with shadow
        CGColorSpaceRef colourspace = CGColorSpaceCreateDeviceGray();
        
        
        CGFloat shadowComponents[] = { 0.0, 0.75 };
        CGColorRef shadowColor = CGColorCreate(colourspace, shadowComponents);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 8 * scale), 12 * scale, shadowColor);
        CGContextSetGrayFillColor(context, 0.9, 1.0);
        CGContextFillEllipseInRect(context, nativeRect);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL); // disable shadow
        CGColorRelease(shadowColor);
        CGColorSpaceRelease(colourspace);
        
        
        
        CGContextSaveGState(context); {
            
            // inner circle with gradient
            CGContextAddEllipseInRect(context, nativeRect);
            CGContextClip(context);
            
            colourspace = CGColorSpaceCreateDeviceGray();
            CGFloat components[] = { 1.0, 1.0, 0.82, 1.0 };
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colourspace, components, NULL, 2);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, nativeSize.height), 0);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colourspace);
            
        } CGContextRestoreGState(context);
        
         
        // black center, inset within larger circle
        
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: 45];
        CGPathRef visiblePath = CGPathCreateCopy(rectanglePath.CGPath);
        
        
        CGRect ellipseCenterRect = CGRectInset(nativeRect, 16, 16);
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        //CGContextFillEllipseInRect(context, ellipseCenterRect);
        CGContextAddPath(context, visiblePath);
        CGContextFillPath(context);
        //CGContextAddEllipseInRect(context, ellipseCenterRect);
        CGContextClip(context);
        
        
        // bottom glow gradient
        colourspace = CGColorSpaceCreateDeviceRGB();
        CGFloat bComponents[] = { 0.0, 0.94, 0.82, 1.0,
            0.0, 0.62, 0.56, 1.0,
            0.0, 0.05, 0.35, 1.0,
            0.0, 0.00, 0.00, 1.0 };
        CGFloat bGlocations[] = { 0.0, 0.35, 0.60, 0.7 };
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colourspace, bComponents, bGlocations, 4);
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect) + (CGRectGetHeight(ellipseCenterRect) * 0.1));
        CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
        CGGradientRelease(gradient);

        
        // top glow gradient
        CGFloat tComponents[] = { 0.0, 0.68, 1.00, 0.75,
            0.0, 0.45, 0.62, 0.55,
            0.0, 0.45, 0.62, 0.00 };
        CGFloat tGlocations[] = { 0.0, 0.25, 0.40 };
        gradient = CGGradientCreateWithColorComponents(colourspace, tComponents, tGlocations, 3);
        centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect) - (CGRectGetHeight(ellipseCenterRect) * 0.2));
        CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
        CGGradientRelease(gradient);
        
        // center glow gradient
        CGFloat cComponents[] = { 0.0, 0.90, 0.90, 0.90,
            0.0, 0.49, 1.00, 0.00 };
        CGFloat cGlocations[] = { 0.0, 0.85 };
        gradient = CGGradientCreateWithColorComponents(colourspace, cComponents, cGlocations, 2);
        centerPoint = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect));
        CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(ellipseCenterRect) * 0.8, 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colourspace);
        
        
        CGContextSaveGState(context); {
            // floral shadow
            CGContextSetShadowWithColor(context, CGSizeZero, 12 * scale, [UIColor blackColor].CGColor);
            
            // draw floral heart
            NSString * floralHeart = @"\u2766";
            UIFont * floralHeartFont = [UIFont fontWithName:@"Arial Unicode MS" size:420];
            CGSize textSize = [floralHeart sizeWithFont:floralHeartFont];
            
            CGPoint point = CGPointMake((CGRectGetWidth(ellipseCenterRect) - textSize.width) / 2.0,
                                        (CGRectGetHeight(ellipseCenterRect) - textSize.height) / 2.0);
            
            CGContextSetGrayFillColor(context, 0.9, 1.0);
            [floralHeart drawAtPoint:point withFont:floralHeartFont];
            
        } CGContextRestoreGState(context);
        
        
        
        // gloss arc
        const CGFloat glossInset = 8;
        CGFloat glossRadius = (CGRectGetWidth(ellipseCenterRect) * 0.5) - glossInset;
        double arcFraction = 0.1;
        
        CGPoint topArcCenter = CGPointMake(CGRectGetMidX(ellipseCenterRect), CGRectGetMidY(ellipseCenterRect));
        CGPoint arcStartPoint = CGPointMake(topArcCenter.x + glossRadius * cos((2 * M_PI) - arcFraction),
                                            topArcCenter.y + glossRadius * sin((2 * M_PI) - arcFraction));
        CGContextAddArc(context, topArcCenter.x, topArcCenter.y, glossRadius, (2 * M_PI) - arcFraction, M_PI + arcFraction, 1);
        
        const CGFloat bottomArcBulgeDistance = 70;
        CGContextAddQuadCurveToPoint(context, topArcCenter.x, topArcCenter.y + bottomArcBulgeDistance, arcStartPoint.x, arcStartPoint.y);
        CGContextClip(context);
        
        colourspace = CGColorSpaceCreateDeviceGray();
        CGFloat glossLocations[]  = { 0.0, 0.5, 1.0 };
        CGFloat glossComponents[] = { 1.0, 0.85, 1.0, 0.50, 1.0, 0.05 };
        gradient = CGGradientCreateWithColorComponents(colourspace, glossComponents, glossLocations, 3);
        
        CGRect clippedRect = CGContextGetClipBoundingBox(context);
        CGContextDrawLinearGradient(context,
                                    gradient,
                                    CGPointMake(topArcCenter.x, CGRectGetMinY(clippedRect)),
                                    CGPointMake(topArcCenter.x, CGRectGetMaxY(clippedRect)),
                                    0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colourspace);
        
        
    } CGContextRestoreGState(context);
    
    */
    
    
    // Drawing code
    //// Color Declarations
    UIColor* squareFill = [UIColor darkGrayColor];
    if (_blocktype == movableNightyDegreeReflectingBlock || _blocktype == fixedNightyDegreeReflectingBlock) {
        //squareFill = [UIColor colorWithWhite:0.6 alpha:1.0];
        squareFill = [UIColor colorWithRed: 0.99 green: 0.99 blue: 0.99 alpha: 0.8];
    }
    if (_blocktype == movableNonReflectingBlock || _blocktype == fixedNonReflectingBlock) {
        //squareFill = [UIColor colorWithWhite:0.2 alpha:1.0];
        squareFill = [UIColor colorWithRed: 0.4 green: 0.4 blue: 0.4 alpha: 0.8];
    }
    if (_blocktype == movablePassingBlock || _blocktype == fixedPassingBlock) {
        squareFill = [UIColor colorWithRed: 114.0f/255.0f green: 197.0f/255.0f blue: 255.0f/255.0f alpha: 0.05];
        //squareFill = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    if (_blocktype == movableSplittingBlock || _blocktype == fixedSplittingBlock) {
        squareFill = [UIColor colorWithRed: 255.0f/255.0f green: 217.0f/255.0f blue: 5.0f/255.0f alpha: 0.05];
        //squareFill = [UIColor colorWithWhite:0.2 alpha:0.5];
    }
    
    [self drawBlock:rect color:squareFill isHighlighted:NO];
    
    
    /*
    //// Abstracted Attributes
    CGRect rectangleRect = CGRectInset(rect, 0, 0);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect cornerRadius: 22];
    [squareFill setFill];
    [rectanglePath fill];
    //[squareStroke setStroke];
    //[squareFill setStroke];
    //rectanglePath.lineWidth = 4;
    //[rectanglePath stroke];
    */
    
    /*
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* frameShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
    UIColor* buttonColor = [UIColor colorWithRed: 0.731 green: 0 blue: 0.091 alpha: 1];
    CGFloat buttonColorRGBA[4];
    [buttonColor getRed: &buttonColorRGBA[0] green: &buttonColorRGBA[1] blue: &buttonColorRGBA[2] alpha: &buttonColorRGBA[3]];
    
    UIColor* glossyColorUp = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.2 + 0.8) green: (buttonColorRGBA[1] * 0.2 + 0.8) blue: (buttonColorRGBA[2] * 0.2 + 0.8) alpha: (buttonColorRGBA[3] * 0.2 + 0.8 - 0.6)];
    UIColor* glossyColorBottom = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.6 + 0.4) green: (buttonColorRGBA[1] * 0.6 + 0.4) blue: (buttonColorRGBA[2] * 0.6 + 0.4) alpha: (buttonColorRGBA[3] * 0.6 + 0.4 - 0.6)];
    
    //// Gradient Declarations
    NSArray* glossyGradientColors = [NSArray arrayWithObjects:
                                     (id)glossyColorUp.CGColor,
                                     (id)glossyColorBottom.CGColor, nil];
    CGFloat glossyGradientLocations[] = {0, 1};
    CGGradientRef glossyGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)glossyGradientColors, glossyGradientLocations);
    
    //// Shadow Declarations
    UIColor* frameInnerShadow = frameShadowColor;
    CGSize frameInnerShadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat frameInnerShadowBlurRadius = 3;
    UIColor* buttonInnerShadow = [UIColor blackColor];
    CGSize buttonInnerShadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat buttonInnerShadowBlurRadius = 12;
    
    //// Frames
    //CGRect frame = CGRectMake(50, 34, 162, 47);
    CGRect frame = rect;
    
    
    //// Abstracted Attributes
    //CGRect innerFrameRect = CGRectMake(CGRectGetMinX(frame) + 10.5, CGRectGetMinY(frame) + 9.5, CGRectGetWidth(frame) - 21, CGRectGetHeight(frame) - 20);
    CGRect innerFrameRect = rect;
    CGFloat innerFrameCornerRadius = 22;
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 8, CGRectGetWidth(frame) - 20, 25);
    CGFloat roundedRectangleCornerRadius = 15;
    
    
    //// innerFrame Drawing
    UIBezierPath* innerFramePath = [UIBezierPath bezierPathWithRoundedRect: innerFrameRect cornerRadius: innerFrameCornerRadius];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, frameInnerShadowOffset, frameInnerShadowBlurRadius, frameInnerShadow.CGColor);
    [buttonColor setFill];
    [innerFramePath fill];
    
    ////// innerFrame Inner Shadow
    CGRect innerFrameBorderRect = CGRectInset([innerFramePath bounds], -buttonInnerShadowBlurRadius, -buttonInnerShadowBlurRadius);
    innerFrameBorderRect = CGRectOffset(innerFrameBorderRect, -buttonInnerShadowOffset.width, -buttonInnerShadowOffset.height);
    innerFrameBorderRect = CGRectInset(CGRectUnion(innerFrameBorderRect, [innerFramePath bounds]), -1, -1);
    
    UIBezierPath* innerFrameNegativePath = [UIBezierPath bezierPathWithRect: innerFrameBorderRect];
    [innerFrameNegativePath appendPath: innerFramePath];
    innerFrameNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = buttonInnerShadowOffset.width + round(innerFrameBorderRect.size.width);
        CGFloat yOffset = buttonInnerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    buttonInnerShadowBlurRadius,
                                    buttonInnerShadow.CGColor);
        
        [innerFramePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(innerFrameBorderRect.size.width), 0);
        [innerFrameNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [innerFrameNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    innerFramePath.lineWidth = 1;
    //[innerFramePath stroke];
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: roundedRectangleCornerRadius];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, glossyGradient,
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(glossyGradient);
    CGColorSpaceRelease(colorSpace);
    */
    /*
    
    
    CGFloat _percentValue = 0.8;
    
    UIBezierPath* rectPath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: 45];
    CGPathRef visiblePath = CGPathCreateCopy(rectPath.CGPath);
    
    // Drawing code
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    
    [[UIColor clearColor] setFill];
    CGContextFillRect(currentContext, rect);
    
    CGFloat diameter=MIN(rect.size.height, rect.size.width);
    CGFloat borderWidth=1;
    CGMutablePathRef circle=CGPathCreateMutable();
    CGPathAddArc(circle, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect), (diameter/2.0)-borderWidth, M_PI, -M_PI, NO);
    //percentValue goes from 0 to 1 and defines the circle main color from red (0) to green (1)
    CGColorRef color1=[UIColor colorWithHue:_percentValue*(1.0/3.0) saturation:0.9 brightness:0.8 alpha:1].CGColor;
    CGColorRef color2=[UIColor colorWithHue:_percentValue*(1.0/3.0) saturation:0.7 brightness:0.6 alpha:1].CGColor;
    CGGradientRef gradient;
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)color1, (__bridge id)color2, nil];
    
    gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    //fill the circle with gradient
    CGContextAddPath(currentContext, visiblePath);
    CGContextSaveGState(currentContext);
    CGContextClip(currentContext);
    CGContextDrawLinearGradient(currentContext, gradient, topCenter, midCenter, 0);
    
    //inner shadow to simulate emboss
    CGMutablePathRef innerShadowPath=CGPathCreateMutable();
    //CGMutablePathRef innerShadowPath=CGPathCreateMutableCopy(visiblePath);
    CGPathAddRect(innerShadowPath, NULL, CGRectInset(rect, -100, -100));
    CGPathAddEllipseInRect(innerShadowPath, NULL, CGRectInset(rect, borderWidth-1, borderWidth-1));
    
    CGContextSetShadow(currentContext, CGSizeMake(-4, -4), 3);
    [[UIColor whiteColor] setFill];
    CGContextAddPath(currentContext, innerShadowPath);
    CGContextEOFillPath(currentContext);
    CGPathRelease(innerShadowPath);
    
    // white shine
    //CGMutablePathRef whiteShinePath=CGPathCreateMutable();
    CGMutablePathRef whiteShinePath=CGPathCreateMutableCopy(visiblePath);
    CGPathAddEllipseInRect(whiteShinePath, NULL, CGRectInset(rect, borderWidth+5, borderWidth+5));

    
    CGContextSetShadowWithColor(currentContext, CGSizeMake(-3, -3), 2, [UIColor colorWithWhite:1 alpha:0.4].CGColor);
    
    CGMutablePathRef innerClippingPath=CGPathCreateMutable();
    //CGMutablePathRef innerClippingPath=CGPathCreateMutableCopy(visiblePath);
    CGPathAddRect(innerClippingPath, NULL, CGRectInset(rect, -100, -100));
    CGPathAddEllipseInRect(innerClippingPath, NULL, CGRectInset(rect, borderWidth+4, borderWidth+4));
    
    CGContextAddPath(currentContext, innerClippingPath);
    CGContextEOClip(currentContext);
    
    CGContextAddPath(currentContext, whiteShinePath);
    CGContextFillPath(currentContext);
    CGPathRelease(innerClippingPath);
    CGPathRelease(whiteShinePath);
    
    CGMutablePathRef circleBorder=CGPathCreateMutable();
    CGPathAddArc(circleBorder, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect), (diameter-(borderWidth*2))/2.0, M_PI, -M_PI, NO);
    //CGMutablePathRef circleBorder=CGPathCreateMutableCopy(visiblePath);
    
    [[UIColor colorWithWhite:0.2 alpha:1] setStroke];
    CGContextSetLineWidth(currentContext, borderWidth);
    CGContextAddPath(currentContext, circleBorder);
    CGContextStrokePath(currentContext);
    CGPathRelease(circleBorder);
    CGContextRestoreGState(currentContext);
    
    CGGradientRelease(gradient);
    CFRelease(visiblePath);
    
    
    */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef visiblePath = CGPathCreateCopy(rectanglePath.CGPath);
    CGContextAddPath(context, visiblePath);
    //CGContextAddEllipseInRect(context, ellipseCenterRect);
    CGContextClip(context);
    
    CGColorSpaceRef colourspace = CGColorSpaceCreateDeviceGray();
    colourspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context); {
        
        // inner circle with gradient
        //CGContextAddEllipseInRect(context, nativeRect);
        //CGContextClip(context);
        
        colourspace = CGColorSpaceCreateDeviceGray();
        CGFloat components[] = { 1.0, 1.0, 0.82, 1.0 };
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colourspace, components, NULL, 2);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colourspace);
        
    } CGContextRestoreGState(context);
    
    
    colourspace = CGColorSpaceCreateDeviceRGB();
    CGFloat bComponents[] = { 0.0, 0.94, 0.82, 1.0,
        0.0, 0.62, 0.56, 1.0,
        0.0, 0.05, 0.35, 1.0,
        0.0, 0.00, 0.00, 1.0 };
    CGFloat bGlocations[] = { 0.0, 0.35, 0.60, 0.7 };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colourspace, bComponents, bGlocations, 4);
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect) + (CGRectGetHeight(rect) * 0.1));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(rect) * 1.0, 0);
    CGGradientRelease(gradient);
    
    // top glow gradient
    CGFloat tComponents[] = { 0.0, 0.68, 1.00, 0.75,
        0.0, 0.45, 0.62, 0.55,
        0.0, 0.45, 0.62, 0.00 };
    CGFloat tGlocations[] = { 0.0, 0.25, 0.40 };
    gradient = CGGradientCreateWithColorComponents(colourspace, tComponents, tGlocations, 3);
    centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect) - (CGRectGetHeight(rect) * 0.2));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(rect) * 1.0, 0);
    CGGradientRelease(gradient);
    
    // center glow gradient
    CGFloat cComponents[] = { 0.0, 0.90, 0.90, 0.90,
        0.0, 0.49, 1.00, 0.00 };
    CGFloat cGlocations[] = { 0.0, 0.85 };
    gradient = CGGradientCreateWithColorComponents(colourspace, cComponents, cGlocations, 2);
    centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextDrawRadialGradient(context, gradient, centerPoint, 0.0, centerPoint, CGRectGetHeight(rect) * 1.0, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colourspace);
    */
    
    
    CGFloat STOPSIZEINTERSPACE = STOPSIZEINTERSPACEIPAD;
    CGFloat STOPSIZEWIDTH = STOPSIZEWIDTHIPAD;
    CGFloat STOPSIZEMARGIN = STOPSIZEMARGINIPAD;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        STOPSIZEINTERSPACE = STOPSIZEINTERSPACEIPHONE;
        STOPSIZEWIDTH = STOPSIZEWIDTHIPHONE;
        STOPSIZEMARGIN = STOPSIZEMARGINIPHONE;
    }
    
    if (_blocktype == fixedNonReflectingBlock || _blocktype == fixedNightyDegreeReflectingBlock) {
        CGRect stopFrameLeft = CGRectMake(rect.size.width / 2 - STOPSIZEINTERSPACE / 2 - STOPSIZEWIDTH, STOPSIZEMARGIN, STOPSIZEWIDTH, rect.size.height - STOPSIZEMARGIN * 2);
        CGRect stopFrameRight = CGRectMake(rect.size.width / 2 + STOPSIZEINTERSPACE / 2, STOPSIZEMARGIN, STOPSIZEWIDTH, rect.size.height - STOPSIZEMARGIN * 2);
        
        UIBezierPath* stopFramePathLeft = [UIBezierPath bezierPathWithRoundedRect: stopFrameLeft cornerRadius: 4];
        UIBezierPath* stopFramePathRight = [UIBezierPath bezierPathWithRoundedRect: stopFrameRight cornerRadius: 4];
        
        UIColor* stopFill = [UIColor colorWithWhite:1.0 alpha:1.0];;
        
        [stopFill setFill];
        [stopFramePathLeft fill];
        [stopFramePathRight fill];
        [stopFill setStroke];
        stopFramePathLeft.lineWidth = 1;
        stopFramePathRight.lineWidth = 1;
        [stopFramePathLeft stroke];
        [stopFramePathRight stroke];
    }
    
}

- (void)drawBlock:(CGRect)rect color:(UIColor *)color isHighlighted:(BOOL)isHighlighted
{
    // The following code was generated by PaintCode.
    // References to "isHighlighted" variable were added by hand afterwards.
    
    //// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
    
    UIColor* baseColor = color;
    //CGRect buttonrect = CGRectInset(rect, 3, 3);
    //buttonrect.origin.y -=3;
    CGRect buttonrect = rect;
    
	UIColor* iconShadow = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
	//UIColor* baseColor = [UIColor colorWithRed: 0.198 green: 0.451 blue: 0.742 alpha: 1];
    //UIColor* baseColor = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1];
	CGFloat baseColorRGBA[4];
	[baseColor getRed: &baseColorRGBA[0] green: &baseColorRGBA[1] blue: &baseColorRGBA[2] alpha: &baseColorRGBA[3]];
	
	
    UIColor* baseGradientTopColor = [UIColor colorWithRed: (baseColorRGBA[0] * 1.1) green: (baseColorRGBA[1] * 1.1) blue: (baseColorRGBA[2] * 1.1) alpha: (baseColorRGBA[3])];
    UIColor* baseGradientBottomColor = [UIColor colorWithRed: (baseColorRGBA[0] * 0.6) green: (baseColorRGBA[1] * 0.6) blue: (baseColorRGBA[2] * 0.6) alpha: (baseColorRGBA[3])];
	//UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.23];
    
    baseGradientTopColor = [baseGradientTopColor colorWithAlphaComponent: 1.0];
    baseGradientBottomColor = [baseGradientBottomColor colorWithAlphaComponent: 1.0];
    
    
    //UIColor* upperShine = [UIColor colorWithRed: (baseColorRGBA[0] * 1.1) green: (baseColorRGBA[1] * 1.1) blue: (baseColorRGBA[2] * 1.1) alpha: (baseColorRGBA[3])];
    UIColor* upperShine = baseColor;
    
	//UIColor* upperShine = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
	UIColor* bottomShine = [upperShine colorWithAlphaComponent: 0.1];
    UIColor* mediumShine = [upperShine colorWithAlphaComponent: 0.3];
	UIColor* topShine = [upperShine colorWithAlphaComponent: 0.4];
	
	//// Gradient Declarations
	NSArray* shineGradientColors = [NSArray arrayWithObjects:
									(id)topShine.CGColor,
									(id)mediumShine.CGColor,
									(id)bottomShine.CGColor, nil];
	CGFloat shineGradientLocations[] = {0, 0.42, 1};
	CGGradientRef shineGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)shineGradientColors, shineGradientLocations);
	NSArray* baseGradientColors = [NSArray arrayWithObjects:
								   (id)baseGradientTopColor.CGColor,
								   (id)baseGradientBottomColor.CGColor, nil];
	CGFloat baseGradientLocations[] = {0, 1};
	CGGradientRef baseGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)baseGradientColors, baseGradientLocations);
	
	
	//// Shadow Declarations
	UIColor* iconBottomShadow = iconShadow;
	CGSize iconBottomShadowOffset = CGSizeMake(0.1, 2.1);
	if (!isHighlighted)
		iconBottomShadowOffset = CGSizeMake(0.1, 1);
    
	CGFloat iconBottomShadowBlurRadius = 4;
	UIColor* upperShineShadow = upperShine;
	CGSize upperShineShadowOffset = CGSizeMake(0.1, 1.1);
	
	
	
	CGFloat upperShineShadowBlurRadius = 1;
	
    
	//// ShadowGroup
	{
		
		CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, iconBottomShadowOffset, iconBottomShadowBlurRadius, iconBottomShadow.CGColor);
		
		CGContextSetBlendMode(context, kCGBlendModeMultiply);
		CGContextBeginTransparencyLayer(context, NULL);
		
		
		//// shadowRectangle Drawing
		//UIBezierPath* shadowRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(6, 3, 57, 57) cornerRadius: 11];
        //UIBezierPath* shadowRectanglePath = [UIBezierPath bezierPathWithRoundedRect: buttonrect cornerRadius: 22];
		//[baseColor setFill];
		//[shadowRectanglePath fill];
		
		
		CGContextEndTransparencyLayer(context);
		CGContextRestoreGState(context);
	}
    
	//// Button
	{
		CGContextSaveGState(context);
		
		if (!isHighlighted)
			CGContextSetAlpha(context, 0.75);
		else
			CGContextSetAlpha(context, 1);
		
		CGContextBeginTransparencyLayer(context, NULL);
        
        CGFloat radius = 22;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            radius = 12;
        }
        
		//// ButtonRectangle Drawing
		UIBezierPath* buttonRectanglePath = [UIBezierPath bezierPathWithRoundedRect: buttonrect cornerRadius: radius];
        
		CGContextSaveGState(context);
		[buttonRectanglePath addClip];
		CGContextDrawLinearGradient(context, baseGradient, CGPointMake(CGRectGetMidX(buttonrect), buttonrect.origin.y), CGPointMake(CGRectGetMidY(buttonrect), buttonrect.size.height + 10), 0);
		CGContextRestoreGState(context);
		
		////// ButtonRectangle Inner Shadow
		CGRect buttonRectangleBorderRect = CGRectInset([buttonRectanglePath bounds], -upperShineShadowBlurRadius, -upperShineShadowBlurRadius);
		buttonRectangleBorderRect = CGRectOffset(buttonRectangleBorderRect, -upperShineShadowOffset.width, -upperShineShadowOffset.height);
		buttonRectangleBorderRect = CGRectInset(CGRectUnion(buttonRectangleBorderRect, [buttonRectanglePath bounds]), -1, -1);
		
		UIBezierPath* buttonRectangleNegativePath = [UIBezierPath bezierPathWithRect: buttonRectangleBorderRect];
		[buttonRectangleNegativePath appendPath: buttonRectanglePath];
		buttonRectangleNegativePath.usesEvenOddFillRule = YES;
		
        
		CGContextSaveGState(context);
		{
			CGFloat xOffset = upperShineShadowOffset.width + round(buttonRectangleBorderRect.size.width);
			CGFloat yOffset = upperShineShadowOffset.height;
			
            CGContextSetShadowWithColor(context,
										CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
										upperShineShadowBlurRadius,
										upperShineShadow.CGColor);
			
			[buttonRectanglePath addClip];
			CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(buttonRectangleBorderRect.size.width), 0);
			[buttonRectangleNegativePath applyTransform: transform];
			//[[UIColor grayColor] setFill];
			[buttonRectangleNegativePath fill];
		}
		CGContextRestoreGState(context);
        
        
        /*
		[strokeColor setStroke];
        //[baseColor setStroke];
		buttonRectanglePath.lineWidth = 1;
		[buttonRectanglePath stroke];
		*/
		//// SymbolGroup
		//[self drawSymbol];
        
        
        
        UIColor* buttonInnerShadow = [UIColor blackColor];
        CGSize buttonInnerShadowOffset = CGSizeMake(0.1, -0.1);
        CGFloat buttonInnerShadowBlurRadius = 3;
        
        UIBezierPath* innerFrameNegativePath = [UIBezierPath bezierPathWithRect: buttonrect];
        UIBezierPath* innerFrame = [UIBezierPath bezierPathWithRect: buttonrect];
        [innerFrameNegativePath appendPath: innerFrame];
        innerFrameNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = buttonInnerShadowOffset.width + round(buttonrect.size.width);
            CGFloat yOffset = buttonInnerShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        buttonInnerShadowBlurRadius,
                                        buttonInnerShadow.CGColor);
            
            [innerFrame addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(buttonrect.size.width), 0);
            [innerFrameNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [innerFrameNegativePath fill];
        }
        CGContextRestoreGState(context);
        
         
        /*
        //// Rounded Rectangle Drawing
        UIColor* buttonColor = [UIColor colorWithRed: 0.731 green: 0 blue: 0.091 alpha: 1];
        CGFloat buttonColorRGBA[4];
        [buttonColor getRed: &buttonColorRGBA[0] green: &buttonColorRGBA[1] blue: &buttonColorRGBA[2] alpha: &buttonColorRGBA[3]];
        
        UIColor* glossyColorUp = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.2 + 0.8) green: (buttonColorRGBA[1] * 0.2 + 0.8) blue: (buttonColorRGBA[2] * 0.2 + 0.8) alpha: (buttonColorRGBA[3] * 0.2 + 0.8 - 0.6)];
        UIColor* glossyColorBottom = [UIColor colorWithRed: (buttonColorRGBA[0] * 0.6 + 0.4) green: (buttonColorRGBA[1] * 0.6 + 0.4) blue: (buttonColorRGBA[2] * 0.6 + 0.4) alpha: (buttonColorRGBA[3] * 0.6 + 0.4 - 0.6)];
        
        //// Gradient Declarations
        NSArray* glossyGradientColors = [NSArray arrayWithObjects:
                                         (id)glossyColorUp.CGColor,
                                         (id)glossyColorBottom.CGColor, nil];
        CGFloat glossyGradientLocations[] = {0, 1};
        CGGradientRef glossyGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)glossyGradientColors, glossyGradientLocations);
        
        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(buttonrect) + 10, CGRectGetMinY(buttonrect) + 8, CGRectGetWidth(buttonrect) - 40, 25);
        
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 22];
        CGContextSaveGState(context);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, glossyGradient,
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                    0);
        CGContextRestoreGState(context);
        */
        
        
		//// UpperShinner
		{
			CGContextSaveGState(context);
			CGContextSetBlendMode(context, kCGBlendModeHardLight);
			CGContextBeginTransparencyLayer(context, NULL);

            NSInteger shineHeightAdjustment = -8;
            NSInteger topBorderAdjustment = 0;
            
            CGFloat radiusShine = 40;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                radiusShine = 30;
            }
            
            CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(buttonrect) + 0.0, CGRectGetMinY(buttonrect) + 0.0, CGRectGetWidth(buttonrect)-0, radiusShine);
        
            UIBezierPath* upperShinnyPartPath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: radius];
            
            CGContextSaveGState(context);
			[upperShinnyPartPath addClip];
			CGContextDrawLinearGradient(context, shineGradient, CGPointMake(CGRectGetMidX(buttonrect), buttonrect.origin.y + topBorderAdjustment), CGPointMake(CGRectGetMidX(buttonrect), CGRectGetMidY(buttonrect)+shineHeightAdjustment), 0);
			CGContextRestoreGState(context);
			
			////// UpperShinnyPart Inner Shadow
			CGRect upperShinnyPartBorderRect = CGRectInset([upperShinnyPartPath bounds], -upperShineShadowBlurRadius, -upperShineShadowBlurRadius);
			upperShinnyPartBorderRect = CGRectOffset(upperShinnyPartBorderRect, -upperShineShadowOffset.width, -upperShineShadowOffset.height);
			upperShinnyPartBorderRect = CGRectInset(CGRectUnion(upperShinnyPartBorderRect, [upperShinnyPartPath bounds]), -1, -1);
			
			UIBezierPath* upperShinnyPartNegativePath = [UIBezierPath bezierPathWithRect: upperShinnyPartBorderRect];
			[upperShinnyPartNegativePath appendPath: upperShinnyPartPath];
			upperShinnyPartNegativePath.usesEvenOddFillRule = YES;
			
            
			CGContextSaveGState(context);
			{
				CGFloat xOffset = upperShineShadowOffset.width + round(upperShinnyPartBorderRect.size.width);
				CGFloat yOffset = upperShineShadowOffset.height;
				CGContextSetShadowWithColor(context,
											CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
											upperShineShadowBlurRadius,
											upperShineShadow.CGColor);
				
                [upperShinnyPartPath addClip];
                
				CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(upperShinnyPartBorderRect.size.width), 0);
				[upperShinnyPartNegativePath applyTransform: transform];
				[[UIColor grayColor] setFill];
				[upperShinnyPartNegativePath fill];
			}
			CGContextRestoreGState(context);
         
            
			CGContextEndTransparencyLayer(context);
			CGContextRestoreGState(context);
         
		}
        
        
        /*
        CGContextBeginPath(context);
        CGContextAddPath(context, buttonRectanglePath.CGPath);
        CGContextClosePath(context);
        CGContextClip(context);
        */
        
		CGContextEndTransparencyLayer(context);
		CGContextRestoreGState(context);
	}

    
	//// Cleanup
	CGGradientRelease(shineGradient);
	CGGradientRelease(baseGradient);
	CGColorSpaceRelease(colorSpace);
	
	
    
}

@end
