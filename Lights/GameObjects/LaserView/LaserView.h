//
//  LaserView.h
//  Lights
//
//  Created by Alain on 25.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaserView : UIView

@property (assign) NSInteger lasernumberX;
@property (assign) NSInteger lasernumberY;

@property (assign) NSUInteger laserborderposition;

@property (assign) CGFloat laserangle;

@property (assign) NSUInteger lasercolor;

@property (assign) NSInteger laserXCoord;
@property (assign) NSInteger laserYCoord;

@property (assign) NSInteger laserXCenter;
@property (assign) NSInteger laserYCenter;

- (id)initWithFrameAndNumberXAndNumberYAndBorderpositionAndAngle:(CGRect)frame lasernumberX:(NSUInteger)lasernumberX lasernumberY:(NSUInteger)lasernumberY laserborderposition:(NSUInteger)laserborderposition laserangle:(CGFloat)laserangle lasercolor:(NSUInteger)lasercolor;

@end
