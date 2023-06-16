//
//  UIImage+Lights.h
//  Swiss Trains
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Lights)

+(UIImage *) backButtonImage;
+(UIImage *) cancelButtonImage;
+(UIImage *) qaButtonImage;
+(UIImage *) redoButtonImage;
+(UIImage *) soundonButtonImage;
+(UIImage *) soundoffButtonImage;

+(UIImage *) gameTitleImageGlass;
+(UIImage *) gameTitleImageGlassRed;

+(UIImage *) settingsButtonImage;

+(UIImage *) logoImage;

+(UIImage *) helpHandImage;
+(UIImage *) helpGridImage;
+(UIImage *) helpStoneImage;
+(UIImage *) gameSceneBackgroundImage;

+(UIImage *) greyGradientBackgroundImage:(CGSize)imageSize;
+(UIImage *)generateRadialTargetGlowImage:(CGSize)imageSize color:(UIColor *)color;


+ (UIImage *)normalButtonImage:(CGRect)rect;

//+(UIImage *) renderCircleButtonImage:(UIImage *)inputimage backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor;
//+(UIImage *) newCircleImageWithMaskImage:(UIImage *)mask backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor size:(CGSize)imageSize;
+(UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

//- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness;
//- (UIImage *)imageWithTransparentLeftRight:(NSUInteger)thickness;
//- (UIImage *)transparentBorderLeftRightImage:(NSUInteger)thickness;

//- (UIImage *)blueTabBarItemFilter;
//- (UIImage *)grayTabBarItemFilter;

@end
