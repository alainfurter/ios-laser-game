//
//  UIColor+Lights.m
//  Swiss Trains
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "UIColor+Lights.h"
#import "Config.h"

@implementation UIColor (Lights)

#define kBoxAlpha 0.95f

+(UIColor *) blockSceneButtonColor {
    return [UIColor grayColor];
    //return [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha];
}

+(UIColor *) blockTitleColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
}

+(UIColor *) squareFrameColor {
    return [UIColor colorWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1];
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 0.3];
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 1];
}

+(UIColor *) squareStrokeColor {
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 0.5];
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 0.3];
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 1];
}

+(UIColor *) laserRedColor {
    return [UIColor colorWithRed: 238.0f/255.0f green: 0.0f/255.0f blue: 0.0f/255.0f alpha: 1];
    return [UIColor redColor];
    return [UIColor colorWithRed: 159.0f/255.0f green: 45.0f/255.0f blue: 35.0f/255.0f alpha: 1];
}

+(UIColor *) laserBlueColor {
    return [UIColor colorWithRed: 40.0f/255.0f green: 223.0f/255.0f blue: 255.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 114.0f/255.0f green: 197.0f/255.0f blue: 255.0f/255.0f alpha: 1];
}

+(UIColor *) laserGreenColor {
    return [UIColor colorWithRed: 0.0f/255.0f green: 255.0f/255.0f blue: 3.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 254.0f/255.0f green: 137.0f/255.0f blue: 0.0f/255.0f alpha: 1];
}

+(UIColor *) laserYellowColor {
    return [UIColor colorWithRed: 244.0f/255.0f green: 206.0f/255.0f blue: 71.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 255.0f/255.0f green: 217.0f/255.0f blue: 5.0f/255.0f alpha: 1];
}

+ (UIColor *)getLaserColorForColorCode:(NSUInteger)colorcode {
    UIColor *laserColor = nil;
    
    switch (colorcode) {
        case laserColorRed:
            laserColor = [self laserRedColor];
            break;
        case laserColorBlue:
            laserColor = [self laserBlueColor];
            break;
        case laserColorGreen:
            laserColor = [self laserGreenColor];
            break;
        case laserColorYellow:
            laserColor = [self laserYellowColor];
            break;
        default:
            laserColor = [self laserRedColor];
            break;
    }
    return laserColor;
}

+ (UIColor *)getBlockColorForColorCode:(NSUInteger)colorcode {
    UIColor *squareStroke = nil;
    
    switch (colorcode) {
        case blockDarkGrayColor:
            squareStroke = [self blockFixColor];
            break;
        case blockGrayColor:
            squareStroke = [self blockNormalColor];
            break;
        case worldMediumColor:
            squareStroke = [self gameWorldMediumColor];
            break;
        case worldAdvancedColor:
            squareStroke = [self gameWorldAdvancedColor];
            break;
        case worldHardColor:
            squareStroke = [self gameWorldHardColor];
            break;
        case worldExpertColor:
            squareStroke = [self gameWorldExpertColor];
            break;
        case worldEasyColor:
            squareStroke = [self gameWorldEasyColor];
            break;
        default:
            squareStroke = [self gameWorldEasyColor];
            break;
    }
    return squareStroke;
}

+(UIColor *) worldlevelTextColor {
    return [UIColor grayColor];
    //return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+(UIColor *) gameSolvedViewBackgroundColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
    //return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+(UIColor *) gameSolvedButtonBackgroundColor {
    return [UIColor colorWithWhite:0.5 alpha:1.0];
    //return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+(UIColor *) gameSolvedButtonTextColor {
    return [UIColor lightGrayColor];
    //return [UIColor colorWithWhite:0.5 alpha:1.0];
}


+(UIColor *) gameSolvedLabelBackgroundColor {
    return [UIColor whiteColor];
    //return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+(UIColor *) blockNormalColor {
    return [UIColor colorWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1];
    return [UIColor colorWithRed: 0.894 green: 0.894 blue: 0.894 alpha: 1];
}

+(UIColor *) blockFixColor {
    return [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
}

+(UIColor *) gameWorldEasyColor {
    //return [UIColor colorWithRed: 91.0f/255.0f green: 175.0f/255.0f blue: 126.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 114.0f/255.0f green: 197.0f/255.0f blue: 255.0f/255.0f alpha: 1];
}

+(UIColor *) gameWorldMediumColor {
    //return [UIColor colorWithRed: 212.0f/255.0f green: 156.0f/255.0f blue: 67.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 255.0f/255.0f green: 217.0f/255.0f blue: 5.0f/255.0f alpha: 1];
}

+(UIColor *) gameWorldAdvancedColor {
    //return [UIColor colorWithRed: 22.0f/255.0f green: 150.0f/255.0f blue: 163.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 254.0f/255.0f green: 137.0f/255.0f blue: 0.0f/255.0f alpha: 1];
}

+(UIColor *) gameWorldHardColor {
    //return [UIColor colorWithRed: 95.0f/255.0f green: 91.0f/255.0f blue: 150.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 222.0f/255.0f green: 87.0f/255.0f blue: 33.0f/255.0f alpha: 1];
}

+(UIColor *) gameWorldExpertColor {
    //return [UIColor colorWithRed: 139.0f/255.0f green: 56.0f/255.0f blue: 138.0f/255.0f alpha: 1];
    return [UIColor colorWithRed: 159.0f/255.0f green: 45.0f/255.0f blue: 35.0f/255.0f alpha: 1];
}

// -------------------------------------------------------------------------------------

+ (UIColor *) darkenedColor:(UIColor *)color difference:(CGFloat) difference {
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(color.CGColor);
    NSUInteger numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
    
    if (numberOfComponents != 3) {
        return color;
    }
    
    CGFloat alpha = CGColorGetAlpha(color.CGColor);
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    const CGFloat r = components[0];
    const CGFloat g = components[1];
    const CGFloat b = components[2];
    
    return [UIColor colorWithRed:MAX(0, r - difference)
                           green:MAX(0, g - difference)
                            blue:MAX(0, b - difference)
                           alpha:alpha];
}

//static NSMutableDictionary *colorNameCache = nil;

- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return @"Not a valid color space";
	}
}

- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
    
	CGFloat r,g,b,a;
    
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
    
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
    
	return YES;
}

- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (UInt32)rgbHex {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
    
	return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}

- (NSString *)stringFromColor {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
	NSString *result;
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
			break;
		case kCGColorSpaceModelMonochrome:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
			break;
		default:
			result = nil;
	}
	return result;
}

- (NSString *)hexStringFromColor {
	return [NSString stringWithFormat:@"%0.6lX", self.rgbHex];
    //return [NSString stringWithFormat:@"%0.6X", self.rgbHex];
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	if (![scanner scanString:@"{" intoString:NULL]) return nil;
	const NSUInteger kMaxComponents = 4;
	CGFloat c[kMaxComponents];
	NSUInteger i = 0;
	if (![scanner scanFloat:&c[i++]]) return nil;
	while (1) {
		if ([scanner scanString:@"}" intoString:NULL]) break;
		if (i >= kMaxComponents) return nil;
		if ([scanner scanString:@"," intoString:NULL]) {
			if (![scanner scanFloat:&c[i++]]) return nil;
		} else {
			// either we're at the end of there's an unexpected character here
			// both cases are error conditions
			return nil;
		}
	}
	if (![scanner isAtEnd]) return nil;
	UIColor *color;
	switch (i) {
		case 2: // monochrome
			color = [UIColor colorWithWhite:c[0] alpha:c[1]];
			break;
		case 4: // RGB
			color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
			break;
		default:
			color = nil;
	}
	return color;
}

#pragma mark Class methods

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

// -------------------------------------------------------------------------------------

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            return [UIColor colorWithCGColor:CGColorCreate(colorSpaceRGB, components)];
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

@end
