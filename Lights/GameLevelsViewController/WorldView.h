//
//  WorldView.h
//  Lights
//
//  Created by Alain on 30.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorldView : UIView

@property (assign) NSUInteger buttonworld;

- (id)initWithWorld:(CGRect)frame world:(NSUInteger)world worldname:(NSString *)worldname;

@end
