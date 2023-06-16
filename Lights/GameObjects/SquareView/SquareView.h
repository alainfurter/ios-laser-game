//
//  SquareView.h
//  Blocks
//
//  Created by Alain on 28.04.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareView : UIView

@property (assign) NSUInteger squarenumberX;
@property (assign) NSUInteger squarenumberY;

@property (assign) CGFloat intersectionSurface;

- (id)initWithFrameAndNumber:(CGRect)frame squarenumberX:(NSUInteger)squarenumberX squarenumberY:(NSUInteger)squarenumberY;

@end
