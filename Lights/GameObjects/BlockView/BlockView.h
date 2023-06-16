//
//  BlockView.h
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockView : UIView

@property (assign) NSUInteger blocknumber;
@property (assign) NSUInteger blocktype;

@property (assign) CGPoint touchingLightPoint;
@property (assign) NSUInteger touchingLightBorder;
@property (assign) CGFloat touchingLightAngle;
@property (assign) BOOL touchingNeighbor;

@property (assign) CGPoint outLightPoint;
@property (assign) NSUInteger outLightBorder;
@property (assign) CGFloat outLightAngle;

@property (assign) CGPoint outLightPointSecondSplittingBlock;
@property (assign) NSUInteger outLightBorderSecondSplittingBlock;
@property (assign) CGFloat outLightAngleSecondSplittingBlock;

// Debug
@property (strong, nonatomic) UILabel *blockNumberLabel;

- (id)initWithFrameAndTypeAndNumber:(CGRect)frame blocktype:(NSUInteger)blocktype blocknumer:(NSUInteger)blocknumber;

@end
