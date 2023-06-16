//
//  LightView.h
//  Lights
//
//  Created by Alain on 25.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LightLine.h"

@interface LightView : UIView

@property (strong, nonatomic) NSMutableArray *lightLines;
@property (strong, nonatomic) NSMutableArray *previouslightLines;

-(void) addLightLine:(LightLine *)lightLine;
-(void) addLightLines:(NSArray *)lightLines;
-(void) removeLightLines;
-(void) drawLightLines;

-(void) backupLightLines;
-(BOOL) areLightLinesEqualToPreviousLines;

@end
