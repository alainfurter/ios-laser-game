//
//  UIColor+Lights.h
//  Swiss Trains
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

enum worldColorCodes {
    worldEasyColor = 2,
    worldMediumColor = 3,
    worldAdvancedColor = 4,
    worldHardColor = 5,
    worldExpertColor = 6
};

enum blockColorCodes {
    blockDarkGrayColor = 0,
    blockGrayColor = 1
};

enum stateColorCodes {
    stateCompleted = 1,
    stateNotCompleted = 2
};

@interface UIColor (Lights)

+ (UIColor *)getLaserColorForColorCode:(NSUInteger)colorcode;

+(UIColor *) blockSceneButtonColor;
+(UIColor *) blockTitleColor;

+(UIColor *) squareFrameColor;

+(UIColor *) squareStrokeColor;

+ (UIColor *)getBlockColorForColorCode:(NSUInteger)colorcode;

+(UIColor *) worldlevelTextColor;

+(UIColor *) gameSolvedViewBackgroundColor;
+(UIColor *) gameSolvedButtonBackgroundColor;
+(UIColor *) gameSolvedButtonTextColor;
+(UIColor *) gameSolvedLabelBackgroundColor;

+(UIColor *) blockNormalColor;
+(UIColor *) blockFixColor;

+(UIColor *) gameWorldEasyColor;
+(UIColor *) gameWorldMediumColor;
+(UIColor *) gameWorldAdvancedColor;
+(UIColor *) gameWorldHardColor;
+(UIColor *) gameWorldExpertColor;

// -------------------------------------------------------------------------------------

+ (UIColor *) darkenedColor:(UIColor *)color difference:(CGFloat) difference;

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

- (BOOL)isEqualToColor:(UIColor *)otherColor;

@end
