//
//  AppDelegate.m
//  Lights
//
//  Created by Alain on 24.05.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "AppDelegate.h"

#import "Config.h"
#import "DTShop.h"
#import "DTBannerManager.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"
#import "ImageManager.h"

@implementation AppDelegate

#ifdef AdsCodeIsOn
- (void) appLaunchRegisterForFirstTimeUseAndProductsfile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *iapFile = [documentsDirectory stringByAppendingPathComponent: kProductsfilePurchased];
    NSString *regFile = [documentsDirectory stringByAppendingPathComponent: kRegistrationfile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: regFile])
    {
        NSString *deviceID;
        deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSDictionary *products;
        products = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: @"NA", nil] forKeys: [NSArray arrayWithObjects:  kProductFullVersion, nil]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath: iapFile]) {
            [[NSFileManager defaultManager] removeItemAtPath: iapFile error: NULL];
        }
        
        [products writeToFile: iapFile atomically:YES];
        [@"FRD" writeToFile: regFile atomically: YES encoding: NSUTF8StringEncoding error: NULL];
    }
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *documentsdirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: bundleRoot error:NULL];
    for (NSString *filestring in dirContents) {
        if ([filestring hasPrefix:@"GameWorld"] && [filestring hasSuffix:@".plist"]) {
            NSString *worldpath = [bundleRoot stringByAppendingPathComponent: filestring];
            NSString *worlddocpath = [documentsdirectory stringByAppendingPathComponent: filestring];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:worlddocpath]) {
                [[NSFileManager defaultManager] removeItemAtPath:worlddocpath error:NULL];
            }
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:worlddocpath]) {
                [[NSFileManager defaultManager] copyItemAtPath:worldpath toPath:worlddocpath error:NULL];
            }
        }
    }
    
#ifdef AdsCodeIsOn
    [self appLaunchRegisterForFirstTimeUseAndProductsfile];
#endif
    
    //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *soundOn = [prefs stringForKey:@"sound"];
    
    [ImageManager sharedImageManager];
    
    //NSLog(@"Soundon: %@", soundOn);
    
    if (!soundOn) {
        //NSLog(@"Set settings");
        [prefs setObject:@"on" forKey:@"sound"];
        [prefs setDouble: 0.3f forKey:@"bgsoundlevel"];
        [prefs setDouble: 0.3f forKey:@"fxsoundlevel"];
        [prefs setInteger:0 forKey:@"selectedworld"];
        [prefs setInteger:0 forKey:@"selectedlevel"];
        [prefs synchronize];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.gameDirectorViewController = [[GameDirectorViewController alloc] init];
    self.window.rootViewController = self.gameDirectorViewController;
    
    self.gameLevelsViewController = [[GameLevelsViewController alloc] init];
    [self.gameDirectorViewController.view addSubview: self.gameLevelsViewController.view];
    
    //self.gameLightsSceneViewController = [[GameLightsSceneViewController alloc] initWithWorldAndLevel:0 level:0];
    //[self.gameDirectorViewController.view addSubview: self.gameLightsSceneViewController.view];
    
    [self.window makeKeyAndVisible];
    
#ifdef AdsCodeIsOn
    
    _shopOpen = NO;
    
    if (![[DTShop sharedShop] isProductInstalledWithSKU: AppStoreInApp])
    {
        [DTBannerManager sharedManager].delegate = (id)self;
        
        [[DTBannerManager sharedManager] addAdsToViewController: self.topViewController];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopProductPurchased:) name:@"DTShopProductPurchased" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopNowOpen:) name:@"DTShopNowOpen" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopPurchaseCancelled:) name:@"DTShopPurchaseCancelled" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCannotOpen:) name:@"DTShopCannotOpen" object:nil];
        
        [[DTShop sharedShop] isReadyForPurchasing];
    }
    
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#ifdef AdsCodeIsOn

#pragma mark DTShop Notifications
- (void) shopProductPurchased:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSString *sku = [userInfo objectForKey:@"SKU"];
    
    [[DTBannerManager sharedManager].bannerClipView setPurchaseButtonBusy:NO];
	
	if ([sku isEqualToString: AppStoreInApp])
	{
        #ifdef  LOGOUTPUTON
        NSLog(@"Product successfully purchased: Full version");
        #endif
        
		[[DTBannerManager sharedManager] removeAds];
	}
}

- (void) shopPurchaseCancelled:(NSNotification *)notification
{
	[[DTBannerManager sharedManager].bannerClipView setPurchaseButtonBusy:NO];
    
    #ifdef  LOGOUTPUTON
    NSLog(@"Purchase cancelled received");
    #endif
}

- (void) shopNowOpen:(NSNotification *)notification
{
	
    #ifdef  LOGOUTPUTON
    NSLog(@"Shop now open received");
    #endif
    
    if (![[DTShop sharedShop] isProductInstalledWithSKU: AppStoreInApp]) {
        self.shopOpen = YES;
        [[DTBannerManager sharedManager].bannerClipView setPurchaseButtonVisible:YES animated:YES];
    }
}

- (void) shopCannotOpen:(NSNotification *)notification
{
    #ifdef kLoggingIsOn
    NSLog(@"App delegate: Shop cannot open received");
    #endif
    
    self.shopOpen = NO;
    [[DTBannerManager sharedManager].bannerClipView setPurchaseButtonVisible:NO animated:YES];
}

- (void)bannerManagerDidPushPurchaseButton:(DTBannerManager *)bannerManager
{
	[[DTBannerManager sharedManager].bannerClipView setPurchaseButtonBusy:YES];
    [[DTShop sharedShop] purchaseProductWithSKU: AppStoreInApp];
    
}

#endif

@end
