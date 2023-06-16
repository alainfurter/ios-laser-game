//
//  ImageManager.h
//  Lights
//
//  Created by Alain on 29.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+ (ImageManager *)sharedImageManager;

@property (nonatomic, strong) UIImage *backgroundImage;

- (UIImage *)getBackgroundImage;

@end
