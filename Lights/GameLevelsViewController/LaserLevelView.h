//
//  LaserLevelView.h
//  Lights
//
//  Created by Alain on 30.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LightLine.h"

@interface LaserLevelView : UIView

@property (strong, nonatomic) NSMutableArray *lightLines;

-(void) addLightLine:(LightLine *)lightLine;
-(void) addLightLines:(NSArray *)lightLines;
-(void) removeLightLines;
-(void) drawLightLines;

@end
