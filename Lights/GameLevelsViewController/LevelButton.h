//
//  LevelView.h
//  Blocks
//
//  Created by Alain on 30.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelButton : UIButton

@property (assign) NSUInteger buttonstate;
@property (assign) NSUInteger buttonworld;
@property (assign) NSUInteger buttonlevel;
@property (assign) NSUInteger buttoncolor;

- (id)initWithStateWorldAndLevel:(CGRect)frame state:(NSUInteger)state world:(NSUInteger)world level:(NSUInteger)level color:(NSUInteger)color;
- (UIColor *)getWorldColor;

@end
