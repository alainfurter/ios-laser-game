//
//  LightLine.h
//  Lights
//
//  Created by Alain on 25.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockView.h"

@interface LightLine : NSObject

@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;

@property (assign) BOOL touchesBorder;
@property (assign) BlockView *touchingBlockview;

@property (assign) BOOL touchesEndBlock;

@property (strong, nonatomic) UIColor *lightColor;
@property (assign) NSUInteger lightColorCode;

@end
