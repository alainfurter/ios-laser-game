//
//  Config.h
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#ifndef Lights_Config_h
#define Lights_Config_h

// ---------------------------------------------------------------------------------
// App settings

#define AppIdentifier                   @"ch.fasoft.lights"
#define AppIdentifierFree               @"ch.fasoft.lightsfree"

//#define DEBUGON                        1

// ---------------------------------------------------------------------------------
// Ad settings

//#define AdsCodeIsOn                    1

#define iAdIsOn                        1
#define AdmobIsOn                      1
#define MobfoxIsOn                     1

#define ADMOBIDIPAD                     @"a1518806407ef4f"
#define ADMOBIDIPHONE                   @"a15188071b9dbb7"

#define MOBFOXID                        @"8d4bcb3e30e9a9e17a5d8a38e9a9a87f"

// ---------------------------------------------------------------------------------
// Store settings

#define kProductsfile                   @"iap_products"
#define AppStoreInApp                   @"2013050601"
#define kProductFullVersion             @"FV"
#define kProductsfilePurchased          @"prodinf.plist"
#define kRegistrationfile               @"reg.plist"

// ---------------------------------------------------------------------------------
// Levels

#define BLOBANIMATIONDURATION           0.18f

#define WORLDBUTTONIPADW               100.0f
#define WORLDBUTTONIPADH               80.0f

#define WORLDBUTTONIPHONEDW            60.0f
#define WORLDBUTTONIPHONEDH            40.0f

#define WORLDBUTTONSTARTYIPAD          40.0f
#define WORLDBUTTONSTARTYIPHONE        10.0f

#define LEVELBUTTONIPADRADIUS          8.0f
#define LEVELBUTTONIPADW               40.0f
#define LEVELBUTTONIPADH               40.0f
#define LEVELBUTTONIPADSMALLW          35.0f
#define LEVELBUTTONIPADSMALLH          35.0f

#define LEVELBUTTONIPHONERADIUS        4.0f
#define LEVELBUTTONIPHONE5DW            25.0f
#define LEVELBUTTONIPHONE5DH            20.0f
#define LEVELBUTTONIPHONE4DW            23.0f
#define LEVELBUTTONIPHONE4DH            20.0f
#define LEVELBUTTONIPHONESMALLW        15.0f
#define LEVELBUTTONIPHONESMALLH        15.0f

#define LEVELBUTTONSTARTYIPAD         120.0f
#define LEVELBUTTONSTARTYIPHONE       130.0f

#define LEVELBUTTONMARGIN               0.0f

#define NEXTLEVELBUTTONIPHONEDW       150.0f
#define NEXTLEVELBUTTONIPHONEDH        50.0f

#define NEXTLEVELBUTTONIPADW          400.0f
#define NEXTLEVELBUTTONIPADH          100.0f

// ---------------------------------------------------------------------------------
// Game Scene Lights

#define BUTTONHEIGHT                   36.0
#define SCALEFACTORTOOLBARBUTTON        1.0

#define SQUARESIZEIPAD                100.0f
#define SQUARESIZEIPHONE               40.0f

#define SOLVEDVIEWHEIGHT              150.0f
#define SOLVEDBUTTONHEIGHT             50.0f
#define SOLVEDBUTTONWIDTH             100.0f

#define TOPBARLASERMARGIN               2.0

// ---------------------------------------------------------------------------------
// Settings / Help 

#define IPADHELPWIDTH                480.0
#define IPADHELPHEIGHT               360.0
#define IPADHELPSCALEFACTOR            1.1


#define IPHONEHELPWIDTH              480.0
#define IPHONEHELPHEIGHT             300.0
#define IPHONEHELPSCALEFACTOR          1.0

#define SETTINGSBUTTONIPADW          200.0
#define SETTINGSBUTTONIPADH           50.0
#define SETTINGSBUTTONIPADRADIUS       4.0

#define SETTINGSBUTTONIPHONEW        120.0
#define SETTINGSBUTTONIPHONEH         30.0
#define SETTINGSBUTTONIPHONERADIUS     4.0

// ---------------------------------------------------------------------------------
// Enums

enum laserBorderPositionCodes {
    laserBorderPositionTop = 1,
    laserBorderPositionBottom = 2,
    laserBorderPositionLeft = 3,
    laserBorderPositionRight = 4
};

enum laserColorCodes {
    laserColorRed = 1,
    laserColorBlue = 2,
    laserColorGreen = 3,
    laserColorYellow = 4
};

enum blockTypeCodes {
    movableNonReflectingBlock = 1,
    fixedNonReflectingBlock = 2,
    movableNightyDegreeReflectingBlock = 3,
    fixedNightyDegreeReflectingBlock = 4,
    movablePassingBlock = 5,
    fixedPassingBlock = 6,
    movableSplittingBlock = 7,
    fixedSplittingBlock = 8
};

// ---------------------------------------------------------------------------------
// Game Scene Functions / Calculations

#define MAXLASERSTEPS                 20
#define BLOCKMOVEANIMATIONTIME         0.1f

#endif
