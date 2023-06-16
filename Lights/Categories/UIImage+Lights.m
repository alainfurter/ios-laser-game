//
//  UIImage+Lights.m
//  Swiss Trains
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "UIImage+Lights.h"
#import "UIApplication+AppDimension.h"

@implementation UIImage (Lights)

+(UIImage *) backButtonImage {
    return [UIImage imageNamed: @"Back.png"];
}

+(UIImage *) cancelButtonImage {
    return [UIImage imageNamed: @"Cancel.png"];
}

+(UIImage *) qaButtonImage {
    return [UIImage imageNamed: @"QA.png"];
}

+(UIImage *) redoButtonImage {
    return [UIImage imageNamed: @"Redo.png"];
}

+(UIImage *) soundonButtonImage {
    return [UIImage imageNamed: @"SoundOn.png"];
}

+(UIImage *) soundoffButtonImage {
    return [UIImage imageNamed: @"SoundOff.png"];
}

+(UIImage *) gameTitleImageGlass {
    return [UIImage imageNamed: @"TitleGlass.png"];
}

+(UIImage *) gameTitleImageGlassRed {
    return [UIImage imageNamed: @"TitleGlassRed.png"];
}

+(UIImage *) settingsButtonImage {
    return [UIImage imageNamed: @"Settings.png"];
}

+(UIImage *) logoImage {
    return [UIImage imageNamed: @"Logo.png"];
}

+(UIImage *) helpHandImage {
    return [UIImage imageNamed: @"HelpHand.png"];
}

+(UIImage *) helpGridImage {
    return [UIImage imageNamed: @"HelpGrid.png"];
}

+(UIImage *) helpStoneImage {
    return [UIImage imageNamed: @"HelpStone.png"];
}

+(UIImage *) gameSceneBackgroundImage {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIApplication IS_IPHONE5_RETINA]) {
            return [UIImage imageNamed: @"BackgroundiPhone5.png"];
            
        } else {
            return [UIImage imageNamed: @"BackgroundiPhone4.png"];
        }
    }    
    return [UIImage imageNamed: @"Background.png"];
}

+(UIImage *) greyGradientBackgroundImage:(CGSize)imageSize {
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageRect.size.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    //CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35,  // Start color
    //    1.0, 1.0, 1.0, 0.06 }; // End color
    CGFloat components[8] = { 254.0/255.0f, 254.0/255.0f, 254.0/255.0f, 0.5,  // Start color
        173.0/255.0f, 173.0/255.0f, 173.0/255.0f, 0.5 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    //CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(imageRect), CGRectGetMidY(imageRect));
    //CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    CGContextDrawRadialGradient(bitmapContext, glossGradient, midCenter, 200.0f, midCenter, 700.0f, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
}

+(UIImage *)generateRadialTargetGlowImage:(CGSize)imageSize color:(UIColor *)color {
    
    //CGRect frameSize = CGRectMake(_targetXCoord, _targetYCoord, TARGETVIEWSIZE, TARGETVIEWSIZE);
    
    //Define the gradient ----------------------
    CGGradientRef gradient;
    //CGColorSpaceRef colorSpace;
    size_t locations_num = 5;
    CGFloat locations[5] = {0.0,0.4,0.5,0.6,1.0};
    
    CGFloat color_RGBA[4];
    [color getRed: &color_RGBA[0] green: &color_RGBA[1] blue: &color_RGBA[2] alpha: &color_RGBA[3]];
    /*
    CGFloat color2_RGBA[4];
    [color getRed: &color2_RGBA[0] green: &color2_RGBA[1] blue: &color2_RGBA[2] alpha: &color2_RGBA[3]];
    CGFloat color3_RGBA[4];
    [color getRed: &color3_RGBA[0] green: &color3_RGBA[1] blue: &color3_RGBA[2] alpha: &color3_RGBA[3]];
    CGFloat color4_RGBA[4];
    [color getRed: &color4_RGBA[0] green: &color4_RGBA[1] blue: &color4_RGBA[2] alpha: &color4_RGBA[3]];
    CGFloat color5_RGBA[4];
    [color getRed: &color5_RGBA[0] green: &color5_RGBA[1] blue: &color5_RGBA[2] alpha: &color5_RGBA[3]];
    */
    /*
    UIColor* c1 = [UIColor colorWithRed:buttonColorRGBA[0] green:buttonColorRGBA[1] blue:buttonColorRGBA[2] alpha: 1];
    UIColor* c2 = [UIColor colorWithRed:buttonColorRGBA[0] green:buttonColorRGBA[1] blue:buttonColorRGBA[2] alpha: 1];
    UIColor* c3 = [UIColor colorWithRed:buttonColorRGBA[0] green:buttonColorRGBA[1] blue:buttonColorRGBA[2] alpha: 1];
    UIColor* c4 = [UIColor colorWithRed:buttonColorRGBA[0] green:buttonColorRGBA[1] blue:buttonColorRGBA[2] alpha: 1];
    */

    
    
    CGFloat components[20] = {
        color_RGBA[0], color_RGBA[1], color_RGBA[2], 0.2,
        color_RGBA[0], color_RGBA[1], color_RGBA[2], 1,
        color_RGBA[0], color_RGBA[1], color_RGBA[2], 0.8,
        color_RGBA[0], color_RGBA[1], color_RGBA[2], 0.4,
        color_RGBA[0], color_RGBA[1], color_RGBA[2], 0.0
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, locations_num);
    
    
    //Define Gradient Positions ---------------
    
    //We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    //Start point
    startPoint.x = imageSize.width/2;
    startPoint.y = imageSize.height/2;
    
    //End point
    endPoint.x =imageSize.width/2;
    endPoint.y = imageSize.height/2;
    
    //Generate the Image -----------------------
    //Begin an image context
    //UIGraphicsBeginImageContext(self.frame.size);
    
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageSize.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    
    
    
    
    
    
    
    //CGContextRef imageContext = UIGraphicsGetCurrentContext();
    //Use CG to draw the radial gradient into the image context
    CGContextDrawRadialGradient(bitmapContext, gradient, startPoint, 0, endPoint, imageSize.height / 2, 0);
    //Get the image from the context
    //UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
}

+ (UIImage *)normalButtonImage:(CGRect)rect {
    
    CGRect imageRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageRect.size.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    //// Color Declarations
    UIColor* buttonColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Abstracted Attributes
    CGRect roundedRectangleRect = rect;
    CGFloat roundedRectangleCornerRadius = 5;
    CGRect roundedRectangle2Rect = CGRectInset(rect, 5, 5);
    CGFloat roundedRectangle2CornerRadius = 5;
    
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: roundedRectangleCornerRadius];
    
    
    //CGContextSaveGState(bitmapContext);
    
    CGContextAddPath(bitmapContext, roundedRectanglePath.CGPath);
    //CGContextClip(bitmapContext);
    
    CGContextSetLineWidth(bitmapContext, 8.0f);
    CGContextSetStrokeColorWithColor(bitmapContext, buttonColor.CGColor);
    CGContextStrokePath(bitmapContext);
    
    //CGContextRestoreGState(bitmapContext);
    
    
    
    //CGContextSaveGState(bitmapContext);
    
    UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: roundedRectangle2Rect cornerRadius: roundedRectangle2CornerRadius];
    
    CGContextAddPath(bitmapContext, roundedRectangle2Path.CGPath);
    //CGContextClip(bitmapContext);
    
    CGContextSetFillColorWithColor(bitmapContext, buttonColor.CGColor);
    CGContextFillPath(bitmapContext);
    
    //CGContextRestoreGState(bitmapContext);
    
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
}


// --------------------------------------------
/*
+ (UIImage *) renderCircleButtonImage:(UIImage *)inputimage backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize imageSize = CGSizeMake(30, 30);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width * scaleFactor, imageSize.height * scaleFactor,
                                             8, imageSize.width * scaleFactor * 4, colorSpace,
                                             kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGContextScaleCTM(ctx, scaleFactor, scaleFactor);
    
    CGSize typeImageSize = CGSizeMake(imageSize.width * scaleFactor, imageSize.height * scaleFactor);
    ;
    UIImage *transportTypeImageResized = [inputimage resizedImage: typeImageSize interpolationQuality: kCGInterpolationDefault];
    UIImage *transportTypeImageColored = [UIImage newImageFromMaskImage: transportTypeImageResized inColor: imageColor];
    
    CGContextSaveGState(ctx);
    
    CGRect circleRect = CGRectMake(0, 0,
                                   imageSize.width,
                                   imageSize.height);
    
    
    
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    CGContextFillEllipseInRect(ctx, circleRect);
    
    CGPoint imageStartingPoint = CGPointMake(5, 5);
    
    CGContextDrawImage(ctx, CGRectMake(imageStartingPoint.x, imageStartingPoint.y, imageSize.width - 10, imageSize.height - 10), [transportTypeImageColored CGImage]);

    CGImageRef image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    UIImage *retImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
	return retImage;
}

+(UIImage *) newCircleImageWithMaskImage:(UIImage *)mask backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor size:(CGSize)imageSize {
    float imageDistance = 20.0;
    CGRect imageRect = CGRectMake(0, 0, mask.size.width + imageDistance * 2, mask.size.height + imageDistance * 2);
    
    float scaleFactor = [[UIScreen mainScreen] scale];
        
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       imageRect.size.width * scaleFactor, imageRect.size.height * scaleFactor,
                                                       8, imageRect.size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    float radius = imageRect.size.width;
    CGContextSetFillColorWithColor(bitmapContext, backgroundColor.CGColor);
    CGContextFillEllipseInRect(bitmapContext, CGRectMake(0, 0, radius, radius));
    
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(imageDistance, imageDistance, width,height);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    
    CGRect boundsFill = CGRectMake(imageDistance, imageDistance, width, height);
    CGContextSetFillColorWithColor(bitmapContext, imageColor.CGColor);
    CGContextFillRect(bitmapContext, boundsFill);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale:scaleFactor orientation: UIImageOrientationUp];
    
    return result;
}
*/

+(UIImage *) newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color {
    CGImageRef maskImage = mask.CGImage;
    CGFloat width = mask.size.width;
    CGFloat height = mask.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(width, height);
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       size.width * scaleFactor, size.height * scaleFactor,
                                                       8, size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale: scaleFactor orientation: UIImageOrientationUp];
    
    
    return result;
}
/*
+ (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}
*/

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // In iOS 5 the image is already correctly rotated. See Eran Sandler's
    // addition here: http://eran.sandler.co.il/2011/11/07/uiimage-in-ios-5-orientation-and-resize/
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 )
    {
        drawTransposed = NO;
    }
    else
    {
        switch ( self.imageOrientation )
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                drawTransposed = YES;
                break;
            default:
                drawTransposed = NO;
        }
        
        transform = [self transformForOrientation:newSize];
    }
    
    CGFloat scaleFactor = [[UIScreen mainScreen] scale];
    
    CGSize newImageSize = CGSizeMake(newSize.width * scaleFactor, newSize.height * scaleFactor);
    
    UIImage *resizedImage = [self resizedImage:newImageSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
    
    NSData *imageData = [[NSData alloc] initWithData: UIImagePNGRepresentation(resizedImage)];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGDataProviderRelease(dataProvider);
    CGImageRelease(imageRef);
    
    return image;
    //return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}


// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap =CGBitmapContextCreate( NULL,
                                               newRect.size.width,
                                               newRect.size.height,
                                               8,
                                               0,
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

/*
static CGImageRef CreateMask(CGSize size, NSUInteger thickness)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       size.width,
                                                       size.height,
                                                       8,
                                                       size.width * 32,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    if (bitmapContext == NULL)
    {
        NSLog(@"create mask bitmap context failed");
		return nil;
    }
    
    // fill the black color in whole size, anything in black area will be transparent.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
    CGContextFillRect(bitmapContext, CGRectMake(0, 0, size.width, size.height));
    
    // fill the white color in whole size, anything in white area will keep.
    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmapContext, CGRectMake(thickness, thickness, size.width - thickness * 2, size.height - thickness * 2));
    
    // acquire the mask
    CGImageRef maskImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // clean up
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness
{
    size_t newWidth = self.size.width + 2 * thickness;
    size_t newHeight = self.size.height + 2 * thickness;
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = bitsPerPixel * newWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL)
    {
		NSLog(@"create color space failed");
		return nil;
	}
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       newWidth,
                                                       newHeight,
                                                       bitsPerComponent,
                                                       bytesPerRow,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if (bitmapContext == NULL)
    {
        NSLog(@"create bitmap context failed");
		return nil;
    }
    
    // acquire image with opaque border
    CGRect imageRect = CGRectMake(thickness, thickness, self.size.width, self.size.height);
    CGContextDrawImage(bitmapContext, imageRect, self.CGImage);
    CGImageRef opaqueBorderImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // acquire image with transparent border
    CGImageRef maskImageRef = CreateMask(CGSizeMake(newWidth, newHeight), thickness);
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(opaqueBorderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(opaqueBorderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (UIImage *)imageWithTransparentLeftRight:(NSUInteger)thickness
{
    size_t newWidth = self.size.width + 2 * thickness;
    size_t newHeight = self.size.height;
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = bitsPerPixel * newWidth;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if(colorSpace == NULL)
    {
		NSLog(@"create color space failed");
		return nil;
	}
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       newWidth,
                                                       newHeight,
                                                       bitsPerComponent,
                                                       bytesPerRow,
                                                       colorSpace,
                                                       kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if (bitmapContext == NULL)
    {
        NSLog(@"create bitmap context failed");
		return nil;
    }
    
    // acquire image with opaque border
    CGRect imageRect = CGRectMake(thickness, thickness, self.size.width, self.size.height);
    CGContextDrawImage(bitmapContext, imageRect, self.CGImage);
    CGImageRef opaqueBorderImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    // acquire image with transparent border
    CGImageRef maskImageRef = CreateMask(CGSizeMake(newWidth, newHeight), thickness);
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(opaqueBorderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    CGImageRelease(opaqueBorderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

- (UIImage *)transparentBorderLeftRightImage:(NSUInteger)thickness
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    
    //NSLog(@"Current image size: %.1f, %.1f", size.width, size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       (size.width + thickness * 2) * scaleFactor, size.height * scaleFactor,
                                                       8, (size.width + thickness * 2) * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(bitmapContext, scaleFactor, scaleFactor);
    
    CGContextDrawImage(bitmapContext, CGRectMake(thickness, 0, size.width, size.height), self.CGImage);
    
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    
    UIImage *result = [UIImage imageWithCGImage: mainViewContentBitmapContext scale: scaleFactor orientation: UIImageOrientationUp];
    
    //NSLog(@"New image size: %.1f, %.1f", result.size.width, result.size.height);
    
    return result;
}
*/
// iPad Tabbar coloring
/*
- (UIImage *)grayTabBarItemFilter {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);

    UIImage *result = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return result;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                       size.width * scaleFactor, size.height * scaleFactor,
                                                       8, size.width * scaleFactor * 4, colorSpace,
                                                       kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
        
    CGFloat colors[8] = {80/255.0,80/255.0,80/255.0,1, 175/255.0,175/255.0,175/255.0,1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,-(32-size.height)/2.0), CGPointMake(0,size.height+(32-size.height)/2.0), 0);
    CGGradientRelease(gradient);
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, CGRectMake(0,0,size.width,size.height), self.CGImage);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    if (newImage != NULL) {
        result = [UIImage imageWithCGImage:newImage];
        CGImageRelease(newImage);
    }
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

struct RGBA {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
};

#define BLUE_ALPHA_THRESHOLD 128
#define BLUE_BRIGHTNESS_ADJUST 30

- (UIImage *)blueTabBarItemFilter {
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    
    UIImage *result = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        return result;
    }

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width * scaleFactor, size.height * scaleFactor,
                                                 8, size.width * scaleFactor * 4, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    
    
    UIImage *gradient = [UIImage imageNamed:@"selection_gradient.png"];
    CGContextDrawImage(context, CGRectMake(-(gradient.size.width - size.width) / 2.0, -(gradient.size.height - size.height) / 2.0, gradient.size.width, gradient.size.height), gradient.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, CGRectMake(0,0,size.width,size.height), self.CGImage);
    struct RGBA *pixels = CGBitmapContextGetData(context);
    if (pixels != NULL) {
        for (int y = 0; y < size.height; y++) {
            for (int x = 0; x < size.width; x++) {
                int offset = x+y*size.width;
                if (pixels[offset].alpha >= BLUE_ALPHA_THRESHOLD &&
                    ((x == 0 || x == size.width-1 || y == 0 || y == size.height-1) ||
                     (pixels[x+(y-1)*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x+1+y*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x+(y+1)*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD) ||
                     (pixels[x-1+y*(int)size.width].alpha < BLUE_ALPHA_THRESHOLD))) {
                        pixels[offset].red = MIN(pixels[offset].red + BLUE_BRIGHTNESS_ADJUST,255);
                        pixels[offset].green = MIN(pixels[offset].green + BLUE_BRIGHTNESS_ADJUST,255);
                        pixels[offset].blue = MIN(pixels[offset].blue + BLUE_BRIGHTNESS_ADJUST,255);
                    }
            }
        }
        CGImageRef image = CGBitmapContextCreateImage(context);
        if (image != NULL) {
            result = [UIImage imageWithCGImage:image];
            CGImageRelease(image);
        }
    }
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}
*/
@end
