//
//  TargetView.m
//  Lights
//
//  Created by Alain on 26.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "TargetView.h"
#import "Config.h"

#import "UIColor+Lights.h"
#import "UIImage+Lights.h"

#define TARGETVIEWSIZEIPAD 26.0f
#define TARGETVIEWSIZEIPHONE 23.0f
#define MARGIN 4.0f

@implementation TargetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrameAndNumberXAndNumberYAndBorderposition:(CGRect)frame targetnumberX:(NSUInteger)targetnumberX targetnumberY:(NSUInteger)targetnumberY targetborderposition:(NSUInteger)targetborderposition targetcolor:(NSUInteger)targetcolor {
    //NSLog(@"LV: %.1f, %.1f, %.1f, %.1f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    CGFloat TARGETVIEWSIZE = TARGETVIEWSIZEIPAD;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        TARGETVIEWSIZE = TARGETVIEWSIZEIPHONE;
    }
    
    CGRect targetViewFrame = CGRectInset(frame, -TARGETVIEWSIZE/2 - MARGIN, -TARGETVIEWSIZE/2 - MARGIN);
    //laserViewFrame.origin.x -= LASERVIEWSIZE/2;
    //laserViewFrame.origin.y -= LASERVIEWSIZE/2;
    //NSLog(@"Targetframe = %.1f, %.1f %.1f, %.1f", targetViewFrame.origin.x, targetViewFrame.origin.y, targetViewFrame.size.width, targetViewFrame.size.height);
    self = [super initWithFrame:targetViewFrame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        _targetnumberX = targetnumberX;
        _targetnumberY = targetnumberY;
        _targetborderposition = targetborderposition;
        _targetcolor = targetcolor;
        
        switch (_targetborderposition) {
            case laserBorderPositionTop:
                _targetXCoord = (targetViewFrame.size.width - TARGETVIEWSIZE)/2;
                _targetYCoord = MARGIN;
                _targetXCenter = targetViewFrame.size.width/2;
                _targetYCenter = TARGETVIEWSIZE/2 + MARGIN;
                break;
            case laserBorderPositionBottom:
                _targetXCoord = (targetViewFrame.size.width - TARGETVIEWSIZE)/2;
                _targetYCoord = targetViewFrame.size.height - TARGETVIEWSIZE - MARGIN;
                _targetXCenter = targetViewFrame.size.width/2;
                _targetYCenter = targetViewFrame.size.height - TARGETVIEWSIZE/2 - MARGIN;
                break;
            case laserBorderPositionLeft:
                _targetXCoord = MARGIN;
                _targetYCoord = (targetViewFrame.size.height - TARGETVIEWSIZE)/2;
                _targetXCenter = TARGETVIEWSIZE/2 + MARGIN;
                _targetYCenter = targetViewFrame.size.height/2;
                break;
            case laserBorderPositionRight:
                _targetXCoord = targetViewFrame.size.width - TARGETVIEWSIZE - MARGIN;
                _targetYCoord = (targetViewFrame.size.height - TARGETVIEWSIZE)/2;
                _targetXCenter = targetViewFrame.size.width - TARGETVIEWSIZE/2 - MARGIN;
                _targetYCenter = targetViewFrame.size.height/2;
                break;
            default:
                _targetXCoord = (targetViewFrame.size.width - TARGETVIEWSIZE)/2;
                _targetYCoord = MARGIN;
                _targetXCenter = targetViewFrame.size.width/2;
                _targetYCenter = TARGETVIEWSIZE/2 + MARGIN;
        }
        //NSLog(@"TargetCoord: %d, %d, %d, %d", _targetXCoord, _targetYCoord, _targetXCenter, _targetYCenter);
        
        self.touchedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_targetXCoord, _targetYCoord, TARGETVIEWSIZE, TARGETVIEWSIZE)];
        [self addSubview: _touchedImageView];
        _touchedImageView.alpha = 0.0f;
        
        [_touchedImageView setImage:[UIImage generateRadialTargetGlowImage:CGSizeMake(TARGETVIEWSIZE, TARGETVIEWSIZE)  color:[UIColor getLaserColorForColorCode: _targetcolor]]];
    
        //self.layer.contents = (__bridge id)([[self generateRadial]CGImage]);
    }
    return self;
}

-(UIImage*)generateRadial{
    
    //CGRect frameSize = CGRectMake(_targetXCoord, _targetYCoord, TARGETVIEWSIZE, TARGETVIEWSIZE);
    
    //Define the gradient ----------------------
    CGGradientRef gradient;
    //CGColorSpaceRef colorSpace;
    size_t locations_num = 5;
    CGFloat locations[5] = {0.0,0.4,0.5,0.6,1.0};
    CGFloat components[20] = {  1.0, 0.0, 0.0, 0.2,
        1.0, 0.0, 0.0, 1,
        1.0, 0.0, 0.0, 0.8,
        1.0, 0.0, 0.0, 0.4,
        1.0, 0.0, 0.0, 0.0
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, locations_num);
    
    
    //Define Gradient Positions ---------------
    
    //We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    CGFloat TARGETVIEWSIZE = TARGETVIEWSIZEIPAD;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        TARGETVIEWSIZE = TARGETVIEWSIZEIPHONE;
    }
    
    //Start point
    startPoint.x = TARGETVIEWSIZE/2;
    startPoint.y = TARGETVIEWSIZE/2;
    
    //End point
    endPoint.x = TARGETVIEWSIZE/2;
    endPoint.y = TARGETVIEWSIZE/2;
    
    //Generate the Image -----------------------
    //Begin an image context
    //UIGraphicsBeginImageContext(self.frame.size);
    
    CGRect imageRect = CGRectMake(0, 0, TARGETVIEWSIZE, TARGETVIEWSIZE);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageRect.size.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    
    
    
    
    
    
    
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    //Use CG to draw the radial gradient into the image context
    CGContextDrawRadialGradient(imageContext, gradient, startPoint, 0, endPoint, TARGETVIEWSIZE/2, 0);
    //Get the image from the context
    //UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
}

//Create the Fadein animation and assign it to the layer
-(void)fadeIn{
    
    CABasicAnimation *fadein = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadein.delegate = self;
    fadein.fromValue = [NSNumber numberWithInt:0];
    fadein.toValue = [NSNumber numberWithInt:1];
    fadein.duration = 0.3;
    fadein.fillMode = kCAFillModeForwards;
    fadein.removedOnCompletion = NO;
    
    //[self.layer addAnimation:fadein forKey:@"fade"];
    [_touchedImageView.layer addAnimation:fadein forKey:@"fade"];
}

//Create the Fadeout animation assign it to the layer
-(void)fadeOut{
    
    CABasicAnimation *fadeout = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeout.delegate = self;
    fadeout.fromValue = [NSNumber numberWithInt:1.0];
    fadeout.toValue = [NSNumber numberWithInt:0];
    fadeout.duration = 0.2;
    fadeout.fillMode = kCAFillModeForwards;
    fadeout.removedOnCompletion = NO;
    
    /*
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            [self.imageView removeFromSuperview];
        }];
        [_touchedImageView.layer addAnimation:fadeout forKey:@"fade"];
    } [CATransaction commit];
    */
    
    //[self.layer addAnimation:fadeout forKey:@"fade"];
    [_touchedImageView.layer addAnimation:fadeout forKey:@"fade"];
}

/*
- (id)initWithFrameAndNumberXAndNumberYAndBorderposition:(CGRect)frame targetnumberX:(NSUInteger)targetnumberX targetnumberY:(NSUInteger)targetnumberY targetborderposition:(NSUInteger)targetborderposition targetcolor:(NSUInteger)targetcolor {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        _targetnumberX = targetnumberX;
        _targetnumberY = targetnumberY;
        _targetborderposition = targetborderposition;
        _targetcolor = targetcolor;
        
        switch (_targetborderposition) {
            case laserBorderPositionTop:
                _targetXCoord = (frame.size.width - TARGETVIEWSIZE)/2;
                _targetYCoord = -TARGETVIEWSIZE/2;
                _targetXCenter = frame.size.width/2;
                _targetYCenter = 0;
                break;
            case laserBorderPositionBottom:
                _targetXCoord = (frame.size.width - TARGETVIEWSIZE)/2;
                _targetYCoord = frame.size.height - TARGETVIEWSIZE/2;
                _targetXCenter = frame.size.width/2;
                _targetYCenter = frame.size.height;
                break;
            case laserBorderPositionLeft:
                _targetXCoord = -TARGETVIEWSIZE/2;
                _targetYCoord = (frame.size.height - TARGETVIEWSIZE)/2;
                _targetXCenter = 0;
                _targetYCenter = frame.size.height/2;
                break;
            case laserBorderPositionRight:
                _targetXCoord = frame.size.width - TARGETVIEWSIZE/2;
                _targetYCoord = (frame.size.height - TARGETVIEWSIZE)/2;
                _targetXCenter = frame.size.width;
                _targetYCenter = frame.size.height/2;
                break;
            default:
                _targetXCoord = -TARGETVIEWSIZE/2;
                _targetYCoord = (frame.size.height - TARGETVIEWSIZE)/2;
                _targetXCenter = 0;
                _targetYCenter = frame.size.height/2;
        }
    }
    return self;
}
*/

- (void) drawTargetViewUntouched:(CGRect)rect {
    //UIColor* fillColor = [UIColor orangeColor];
    //UIColor* strokeColor = [UIColor orangeColor];
    UIColor* strokeColor = [UIColor getLaserColorForColorCode: _targetcolor];
    
    NSUInteger CircleMargin = 5.0f;
    
    CGFloat TARGETVIEWSIZE = TARGETVIEWSIZEIPAD;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        TARGETVIEWSIZE = TARGETVIEWSIZEIPHONE;
    }
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord + CircleMargin, _targetYCoord + CircleMargin, TARGETVIEWSIZE - 2 * CircleMargin, TARGETVIEWSIZE - 2 * CircleMargin)];
    UIBezierPath* ovalPath2 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord + CircleMargin + 3, _targetYCoord + CircleMargin + 3, TARGETVIEWSIZE - 3*2 - 2 * CircleMargin, TARGETVIEWSIZE - 3*2 - 2 * CircleMargin)];
    UIBezierPath* ovalPath3 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord + CircleMargin + 6, _targetYCoord + CircleMargin + 6, TARGETVIEWSIZE - 6*2 - 2 * CircleMargin, TARGETVIEWSIZE - 6*2 - 2 * CircleMargin)];
    
    //[fillColor setFill];
    //[ovalPath fill];
    [strokeColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    ovalPath2.lineWidth = 1;
    [ovalPath2 stroke];
    
    ovalPath3.lineWidth = 1;
    [ovalPath3 stroke];
}

- (void) drawTargetViewTouched:(CGRect)rect {
    //UIColor* fillColor = [UIColor orangeColor];
    //UIColor* strokeColor = [UIColor orangeColor];
    UIColor* strokeColor = [UIColor getLaserColorForColorCode: _targetcolor];
    
    /*
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord, _targetYCoord, TARGETVIEWSIZE, TARGETVIEWSIZE)];
    UIBezierPath* ovalPath2 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord + 3, _targetYCoord + 3, TARGETVIEWSIZE - 3*2, TARGETVIEWSIZE - 3*2)];
    UIBezierPath* ovalPath3 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord + 6, _targetYCoord + 6, TARGETVIEWSIZE - 6*2, TARGETVIEWSIZE - 6*2)];
    
    //[fillColor setFill];
    //[ovalPath fill];
    [strokeColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    ovalPath2.lineWidth = 1;
    [ovalPath2 stroke];
    
    ovalPath3.lineWidth = 1;
    [ovalPath3 stroke];
    */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat TARGETVIEWSIZE = TARGETVIEWSIZEIPAD;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        TARGETVIEWSIZE = TARGETVIEWSIZEIPHONE;
    }
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_targetXCoord, _targetYCoord, TARGETVIEWSIZE, TARGETVIEWSIZE)];
    
    //CGMutablePathRef path = CGPathCreateMutable();
    
    //int padding = 20;
    //CGPathMoveToPoint(path, NULL, padding, padding);
    //CGPathAddLineToPoint(path, NULL, rect.size.width - padding, rect.size.height / 2);
    //CGPathAddLineToPoint(path, NULL, padding, rect.size.height - padding);
    
    CGContextSetShadowWithColor(context, CGSizeZero, 10, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    
    CGContextAddPath(context, ovalPath.CGPath);
    CGContextFillPath(context);
    // CGContextAddPath(context, path);
    // CGContextFillPath(context);
    
    //CGPathRelease(path);
}
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// Color Declarations
    [super drawRect:rect];
        
    [self drawTargetViewUntouched:rect];
    
    //[self drawTargetViewTouched:rect];
}

@end
