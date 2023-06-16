//
//  ImageManager.m
//  Lights
//
//  Created by Alain on 29.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "ImageManager.h"
#import "UIImage+Lights.h"

@implementation ImageManager

+ (ImageManager *)sharedImageManager
{
    static ImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageManager alloc] init];
        sharedInstance.backgroundImage = [UIImage gameSceneBackgroundImage];
    });
    
    return sharedInstance;
}

- (UIImage *)getBackgroundImage {
    return _backgroundImage;
}

@end
