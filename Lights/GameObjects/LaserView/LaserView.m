//
//  LaserView.m
//  Lights
//
//  Created by Alain on 25.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "LaserView.h"
#import "Config.h"

#import "UIColor+Lights.h"

#define LASERVIEWSIZE 10.0f
#define MARGIN 2.0f

@implementation LaserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/*
- (id)initWithFrameAndNumberXAndNumberYAndBorderpositionAndAngle:(CGRect)frame lasernumberX:(NSUInteger)lasernumberX lasernumberY:(NSUInteger)lasernumberY laserborderposition:(NSUInteger)laserborderposition laserangle:(CGFloat)laserangle lasercolor:(NSUInteger)lasercolor {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        _lasernumberX = lasernumberX;
        _lasernumberY = lasernumberY;
        _laserborderposition = laserborderposition;
        _laserangle = laserangle;
        _lasercolor = lasercolor;
        
        switch (_laserborderposition) {
            case laserBorderPositionTop:
                _laserXCoord = (frame.size.width - LASERVIEWSIZE)/2;
                _laserYCoord = -LASERVIEWSIZE/2;
                _laserXCenter = frame.size.width/2;
                _laserYCenter = 0;
                break;
            case laserBorderPositionBottom:
                _laserXCoord = (frame.size.width - LASERVIEWSIZE)/2;
                _laserYCoord = frame.size.height - LASERVIEWSIZE/2;
                _laserXCenter = frame.size.width/2;
                _laserYCenter = frame.size.height;
                break;
            case laserBorderPositionLeft:
                _laserXCoord = -LASERVIEWSIZE/2;
                _laserYCoord = (frame.size.height - LASERVIEWSIZE)/2;
                _laserXCenter = 0;
                _laserYCenter = frame.size.height/2;
                break;
            case laserBorderPositionRight:
                _laserXCoord = frame.size.width - LASERVIEWSIZE/2;
                _laserYCoord = (frame.size.height - LASERVIEWSIZE)/2;
                _laserXCenter = frame.size.width;
                _laserYCenter = frame.size.height/2;
                break;
            default:
                _laserXCoord = -LASERVIEWSIZE/2;
                _laserYCoord = (frame.size.height - LASERVIEWSIZE)/2;
                _laserXCenter = 0;
                _laserYCenter = frame.size.height/2;
        }
    }
    return self;
}

*/
- (id)initWithFrameAndNumberXAndNumberYAndBorderpositionAndAngle:(CGRect)frame lasernumberX:(NSUInteger)lasernumberX lasernumberY:(NSUInteger)lasernumberY laserborderposition:(NSUInteger)laserborderposition laserangle:(CGFloat)laserangle lasercolor:(NSUInteger)lasercolor {
    //NSLog(@"LV: %.1f, %.1f, %.1f, %.1f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    CGRect laserViewFrame = CGRectInset(frame, -LASERVIEWSIZE/2 - MARGIN, -LASERVIEWSIZE/2 - MARGIN);
    //laserViewFrame.origin.x -= LASERVIEWSIZE/2;
    //laserViewFrame.origin.y -= LASERVIEWSIZE/2;
    //NSLog(@"Laserframe = %.1f, %.1f %.1f, %.1f", laserViewFrame.origin.x, laserViewFrame.origin.y, laserViewFrame.size.width, laserViewFrame.size.height);
    self = [super initWithFrame:laserViewFrame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        _lasernumberX = lasernumberX;
        _lasernumberY = lasernumberY;
        _laserborderposition = laserborderposition;
        _laserangle = laserangle;
        _lasercolor = lasercolor;
        
        switch (_laserborderposition) {
            case laserBorderPositionTop:
                _laserXCoord = (laserViewFrame.size.width - LASERVIEWSIZE)/2;
                _laserYCoord = MARGIN;
                _laserXCenter = laserViewFrame.size.width/2;
                _laserYCenter = LASERVIEWSIZE/2 + MARGIN;
                break;
            case laserBorderPositionBottom:
                _laserXCoord = (laserViewFrame.size.width - LASERVIEWSIZE)/2;
                _laserYCoord = laserViewFrame.size.height - LASERVIEWSIZE - MARGIN;
                _laserXCenter = laserViewFrame.size.width/2;
                _laserYCenter = laserViewFrame.size.height - LASERVIEWSIZE/2 - MARGIN;
                break;
            case laserBorderPositionLeft:
                _laserXCoord = MARGIN;
                _laserYCoord = (laserViewFrame.size.height - LASERVIEWSIZE)/2;
                _laserXCenter = LASERVIEWSIZE/2 + MARGIN;
                _laserYCenter = laserViewFrame.size.height/2;
                break;
            case laserBorderPositionRight:
                _laserXCoord = laserViewFrame.size.width - LASERVIEWSIZE - MARGIN;
                _laserYCoord = (laserViewFrame.size.height - LASERVIEWSIZE)/2;
                _laserXCenter = laserViewFrame.size.width - LASERVIEWSIZE/2 - MARGIN;
                _laserYCenter = laserViewFrame.size.height/2;
                break;
            default:
                _laserXCoord = (laserViewFrame.size.width - LASERVIEWSIZE)/2;
                _laserYCoord = MARGIN;
                _laserXCenter = laserViewFrame.size.width/2;
                _laserYCenter = LASERVIEWSIZE/2 + MARGIN;
        }
        //NSLog(@"LaserCoord: %d, %d, %d, %d", _laserXCoord, _laserYCoord, _laserXCenter, _laserYCenter);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Drawing code
    //// Color Declarations
    //UIColor* fillColor = [UIColor redColor];
    //UIColor* strokeColor = [UIColor redColor];
    
    UIColor* fillColor = [UIColor getLaserColorForColorCode: _lasercolor];
    UIColor* strokeColor = [UIColor getLaserColorForColorCode: _lasercolor];
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_laserXCoord, _laserYCoord, LASERVIEWSIZE, LASERVIEWSIZE)];
    
    [fillColor setFill];
    [ovalPath fill];
    [strokeColor setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
}


@end
