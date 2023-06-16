//
//  DTBannerManager.m
//
//  Created by Oliver Drobnik on 7/29/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import "DTBannerManager.h"

//#import "MobFox.h"

//#import "DocumentViewController.h"

#define AD_REFRESH_PERIOD 12.5 // display fresh ads every 12.5 seconds

DTBannerManager *_sharedManager = nil;

@implementation DTBannerManager

+ (DTBannerManager *)sharedManager
{
	if (!_sharedManager)
	{
		_sharedManager = [[DTBannerManager alloc] init];
	}
	
	return _sharedManager;
}

- (id)init
{
	if ((self = [super init]))
	{
		// get notified if app becomes active
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[refreshTimer invalidate];
}



- (void)removeAllBannersExceptForMode:(BannerMode)bannerMode
{
	if (bannerMode != BannerModeAdMob)
	{
		[adMobBannerView removeFromSuperview];
		adMobBannerView = nil;
		[refreshTimer invalidate], refreshTimer = nil;
		adMobBannerShowing = NO;	
	}
	
	if (bannerMode != BannerModeApple)
	{
		[iAdBannerView removeFromSuperview];
		iAdBannerView = nil;
		iAdBannerShowing = NO;	
	}
	
	if (bannerMode != BannerModeMobFox)
	{
		[mobfoxBannerView removeFromSuperview];
		mobfoxBannerView = nil;
		mobFoxBannerShowing = NO;	
	}
	
	// causes purchase button to not reappear subsequently	
	//	if (bannerMode == BannerModeNoAds)
	//	{
	//		[bannerClipView setPurchaseButtonVisible:NO animated:YES];
	//	}
}


- (void)setBannerMode:(BannerMode)newMode
{
	if (newMode != _bannerMode)
	{
		_bannerMode = newMode;
		
		switch (_bannerMode) 
		{
			case BannerModeMobFox:
			{
				if ([self mobFoxSupported])
				{
					if (!mobfoxBannerView)
                    {
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            mobfoxBannerView = [[MobFoxBannerView alloc] initWithFrame:CGRectMake(0, 0, 1024, 90)];
                            
                        } else {
                            mobfoxBannerView = [[MobFoxBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                            
                        }

                        mobfoxBannerView.backgroundColor = [UIColor blackColor];
                        mobfoxBannerView.allowDelegateAssigmentToRequestAd = NO;
                        [mobfoxBannerView setDelegate:self];
                        
                        //mobfoxBannerView.refreshAnimation = UIViewAnimationTransitionFlipFromLeft;
                        mobfoxBannerView.requestURL = @"http://my.mobfox.com/request.php";
                        [mobfoxBannerView requestAd];
                    }
				}
				else 
				{
					self.bannerMode = [self nextBannerNetworkAfterCurrent];
					return;
				}
				
				break;
			}
				
			case BannerModeAdMob:
			{
				if ([self adMobSupported])
				{
					if (!adMobBannerView)
                    {
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            adMobBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 1024, 90)];
                            adMobBannerView.adUnitID = ADMOBIDIPAD;
                            
                        } else {
                            adMobBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                            adMobBannerView.adUnitID = ADMOBIDIPHONE;
                            
                        }
                        
                        adMobBannerView.backgroundColor = [UIColor blackColor];
                                                                        
                        adMobBannerView.rootViewController = viewControllerWithBanner;
                        [adMobBannerView setDelegate:self];
                        
                        [adMobBannerView loadRequest:[GADRequest request]];
                    }
				}
				else
				{
					self.bannerMode = [self nextBannerNetworkAfterCurrent];
					return;
				}
				
				break;
			}
				
			case BannerModeApple:
			{
				if ([self iAdsSupported])
				{
					if (!iAdBannerView)
                    {
                        //NSLog(@"iAD alloc view");
                        
                        
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 1024, 66)];
                            
                        } else {
                            iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                            
                        }
                        
                        //NSLog(@"iAD alloc view 2");
                        
                        iAdBannerView.delegate = [DTBannerManager sharedManager];
                        
                        //NSLog(@"iAD alloc view 3");
                        
                        //iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
                        
                        /*
                         // only portrait ads - catch iOS 4.2 iAD identifier change - otherwise crash
                         if (&ADBannerContentSizeIdentifierPortrait != nil) {
                         // NEWER
                         iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
                         //iAdBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
                         } else {
                         // OLDER
                         iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
                         //iAdBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
                         }
                         */
                        
                        //NSLog(@"iAD alloc view 4");
                    }

					
#ifdef IAD_RESPONSE_TIMEOUT					
					// wait max x seconds to receive iAd
					[self performSelector:@selector(cancelAppleAds) withObject:nil afterDelay:IAD_RESPONSE_TIMEOUT];
#endif
				}
				else 
				{
					self.bannerMode = [self nextBannerNetworkAfterCurrent];
					return;
				}
				
				break;
			}
				
			default:
				break;
		}
		
		// remove all we don't need
		[self removeAllBannersExceptForMode:_bannerMode];
		
	}
}

- (void)setDefaultBannerMode
{
    #ifdef LOGOUTPUTON
    NSLog(@"Set default banner mode");
    #endif
    
    self.bannerMode = BannerModeNoAds;
	
	self.bannerMode = [self nextBannerNetworkAfterCurrent];
	/*
	 
	 return;
	 
	 if ([self iAdsSupported])
	 {
	 self.bannerMode = BannerModeApple;
	 }
	 else 
	 {
	 self.bannerMode = BannerModeAdMob;
	 }
	 */
}

- (void)addAdsToViewController:(UIViewController *)viewController
{
	self.viewControllerWithBanner = viewController;
	
	// mount at bottom of this viewcontroller's view
	[viewController.view addSubview:self.bannerClipView];
    
    #ifdef LOGOUTPUTON
    NSLog(@"View controller: %.1f, %.1f", viewController.view.frame.size.width, viewController.view.frame.size.height);
    #endif
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect bannerFrame = CGRectMake(0, 768 - 20 - 90 - 25, 1024, 90 + 25);
        bannerClipView.frame = bannerFrame;
        
    } else {
        
        CGRect bannerFrame = CGRectMake(0, viewController.view.frame.size.height - 50 - 25, 320, 50 + 25);
        bannerClipView.frame = bannerFrame;
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"Banner view frame: %.1f, %.1f, %.1f, %.1f", bannerClipView.frame.origin.x, bannerClipView.frame.origin.y, bannerClipView.frame.size.width, bannerClipView.frame.size.height);
    #endif
    
	[self setDefaultBannerMode];
}

- (void)removeAds
{
	// we release, end of slide out should free them
	iAdBannerShowing = NO;
	iAdBannerView = nil;
	
	adMobBannerShowing = NO;
	adMobBannerView = nil;
	
	mobFoxBannerShowing = NO;
	mobfoxBannerView = nil;
	
	[bannerClipView slideOutSubviews];
}



- (BOOL) isBannerVisible
{
	return iAdBannerShowing || adMobBannerShowing || mobFoxBannerShowing;
}

- (DTBannerClipView *)bannerClipView
{
	if (!bannerClipView)
	{
		CGRect bannerFrame;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            bannerFrame = CGRectMake(0, 768 - 20 - 90 - 25, 1024, 90 + 25);
            bannerClipView.frame = bannerFrame;
            
        } else {
            
            bannerFrame = CGRectMake(0, self.viewControllerWithBanner.view.frame.size.height - 50 - 25, 320, 50 + 25);
            bannerClipView.frame = bannerFrame;
        }
		
		// create clipping frame
		bannerClipView = [[DTBannerClipView alloc] initWithFrame:bannerFrame];
		
		[bannerClipView.purchaseButton addTarget:self action:@selector(purchaseButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return bannerClipView;
}

#pragma mark MobFox

/*
- (MobFoxBannerView *)mobfoxBannerView
{
	if (!mobfoxBannerView)
	{        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            mobfoxBannerView = [[MobFoxBannerView alloc] initWithFrame:CGRectMake(0, 0, 1024, 90)];
            
        } else {
            mobfoxBannerView = [[MobFoxBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];

        }
    
		mobfoxBannerView.backgroundColor = [UIColor blackColor];
		[mobfoxBannerView setDelegate:self];
        
        [mobfoxBannerView setRequestURL: @"http://my.mobfox.com/request.php"];
	}
	
	return mobfoxBannerView;
}
*/

- (BOOL)mobFoxSupported
{
#ifdef MobfoxIsOn
    return YES;
#else
    return NO;
#endif
}

- (NSString *)publisherIdForMobFoxBannerView:(MobFoxBannerView *)banner
{
	return MOBFOXID;
}

- (void)mobfoxBannerViewDidLoadMobFoxAd:(MobFoxBannerView *)banner
{
	#ifdef LOGOUTPUTON
    NSLog(@"MobFox: Did receive ad");
    #endif
	
	mobFoxBannerShowing = YES;
	
	[self.bannerClipView slideInSubview:banner];
}

- (void)mobfoxBannerView:(MobFoxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	#ifdef LOGOUTPUTON
    NSLog(@"MobFox: Did fail to receive ad, %@", [error localizedDescription]);
    #endif
    
	mobFoxBannerShowing = NO;
    
	[self.bannerClipView slideOutSubviews];
	
	self.bannerMode = [self nextBannerNetworkAfterCurrent];
}

- (BOOL)mobfoxBannerViewActionShouldBegin:(MobFoxBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	if ([_delegate respondsToSelector:@selector(bannerManagerWillExecuteBannerAction:willLeaveApplication:)])
	{
		[_delegate bannerManagerWillExecuteBannerAction:self willLeaveApplication:willLeave];	
	}
	
	return YES;
}

- (void)mobfoxBannerViewActionDidFinish:(MobFoxBannerView *)banner
{
	if ([_delegate respondsToSelector:@selector(bannerManagerDidFinishBannerAction:)])
	{
		[_delegate bannerManagerDidFinishBannerAction:self];	
	}
}

#pragma mark iAds

/*
- (ADBannerView *)iAdBannerView
{
	if (!iAdBannerView)
	{        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 1024, 90)];
            
        } else {
            iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            
        }
        
		iAdBannerView.delegate = [DTBannerManager sharedManager];
		
        //iAdBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
		// only portrait ads
		//iAdBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
	}
	
	return iAdBannerView;
}
*/

- (BOOL)iAdsSupported
{
#ifdef iAdIsOn
    if (NSClassFromString(@"ADBannerView"))
	{
		return YES;
	}
#endif
	return NO;
}

- (void)cancelAppleAds
{
	#ifdef LOGOUTPUTON
    NSLog(@"iAd: request cancelled");
    #endif
	
	self.bannerMode = [self nextBannerNetworkAfterCurrent];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
    #ifdef LOGOUTPUTON
	NSLog(@"iAd: Did receive ad");
    #endif
	
	if (!iAdBannerShowing)
	{
		iAdBannerShowing = YES;
		[self.bannerClipView slideInSubview:banner];
	}
	
	// TEST: [self performSelector:@selector(hideAdBanner) withObject:nil afterDelay:5];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
    #ifdef LOGOUTPUTON
	NSLog(@"iAd: Did fail to receive ad, %@", [error localizedDescription]);
    #endif
    
	iAdBannerShowing = NO;
	
	[self.bannerClipView slideOutSubview:banner];
	self.bannerMode = [self nextBannerNetworkAfterCurrent];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	if ([_delegate respondsToSelector:@selector(bannerManagerWillExecuteBannerAction:willLeaveApplication:)])
	{
		[_delegate bannerManagerWillExecuteBannerAction:self willLeaveApplication:willLeave];	
	}
	
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	if ([_delegate respondsToSelector:@selector(bannerManagerDidFinishBannerAction:)])
	{
		[_delegate bannerManagerDidFinishBannerAction:self];	
	}
}


#pragma mark AdMob

/*
- (GADBannerView *)adMobBannerView
{
	if (!adMobBannerView)
	{

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            adMobBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 90.0)];
            
        } else {
            adMobBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 50.0)];
            
        }

		adMobBannerView.rootViewController = self.viewControllerWithBanner;
		adMobBannerView.adUnitID = ADMOB_PUBLISHER_ID;
		adMobBannerView.delegate = self;
		
		// start a new ad request
		
		[adMobBannerView loadRequest:[GADRequest request]];
	}
	
	return adMobBannerView;
}
*/

- (BOOL)adMobSupported
{
#ifdef AdmobIsOn
        return YES;
#else
        return NO;
#endif
}

// Request a new ad. If a new ad is successfully loaded, it will be animated into location.
- (void)refreshAd:(NSTimer *)timer {
	[adMobBannerView loadRequest:[GADRequest request]];
}

- (NSString *)publisherIdForAd:(GADBannerView *)adView 
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return ADMOBIDIPAD;
        
    } else {
        return ADMOBIDIPHONE;
        
    }
}

- (UIViewController *)currentViewControllerForAd:(GADBannerView *)adView {
	return viewControllerWithBanner;
}

- (UIColor *)adBackgroundColorForAd:(GADBannerView *)adView {
	return [UIColor colorWithRed:0.208 green:0.435 blue:0.659 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)primaryTextColorForAd:(GADBannerView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColorForAd:(GADBannerView *)adView {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    
    #ifdef LOGOUTPUTON
	NSLog(@"AdMob: Did receive ad");
    #endif
	
	if (!adMobBannerShowing)
	{
		adMobBannerShowing = YES;
		[self.bannerClipView slideInSubview:adView];
		
		[refreshTimer invalidate];
		refreshTimer = [NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:self selector:@selector(refreshAd:) userInfo:nil repeats:YES];
	}
}

// Sent when an ad request failed to load an ad
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    #ifdef LOGOUTPUTON
	NSLog(@"AdMob: Did fail to receive ad: %@", [error localizedDescription]);
    #endif
    
    [self.bannerClipView slideOutSubview:adView];
    
	adMobBannerShowing = NO;
	
	adMobBannerView.delegate = nil;
	
	//[adMobBannerView removeFromSuperview];  // Not necessary since never added to a view, but doesn't hurt and is good practice
	//adMobBannerView = nil;
	// we could start a new ad request here, but in the interests of the user's battery life, let's not
    
	self.bannerMode = [self nextBannerNetworkAfterCurrent];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
	if ([_delegate respondsToSelector:@selector(bannerManagerWillExecuteBannerAction:willLeaveApplication:)])
	{
		[_delegate bannerManagerWillExecuteBannerAction:self willLeaveApplication:NO];	
	}
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
	if ([_delegate respondsToSelector:@selector(bannerManagerDidFinishBannerAction:)])
	{
		[_delegate bannerManagerDidFinishBannerAction:self];	
	}
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
	if ([_delegate respondsToSelector:@selector(bannerManagerWillExecuteBannerAction:willLeaveApplication:)])
	{
		[_delegate bannerManagerWillExecuteBannerAction:self willLeaveApplication:YES];	
	}
}

#pragma mark Notifications
- (void) appDidBecomeActive:(NSNotification *)notification
{
	// reactivate 
	if (self.bannerMode == BannerModeAllFailed)
	{
		[self setDefaultBannerMode];
	}
}


#pragma mark Custom Prioritization
- (BannerMode)nextBannerNetworkAfterCurrent
{
	// Failed stays failed
	if (_bannerMode == BannerModeAllFailed)
	{
		return BannerModeAllFailed;
	}
	
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    //NSLog(@"Country code: %@", countryCode);
    
    //int test_networks[5] = NETWORK_PRIORITY_ORDER;
    //NSLog(@"Test networks: %@", test_networks);
    
    //for (int x = 0; x<5; x++) {
    //NSLog(@"Numer: %d", test_networks[x]);
    //}
    
    
    int networks[5];
    
    if ([countryCode isEqualToString: @"US"] || [countryCode isEqualToString: @"GB"] || [countryCode isEqualToString: @"FR"] || [countryCode isEqualToString: @"DE"] || [countryCode isEqualToString: @"IT"] || [countryCode isEqualToString: @"ES"]) {
        networks[0] = BannerModeApple;
        networks[1] = BannerModeMobFox;
        networks[2] = BannerModeAdMob;
        networks[3] = BannerModeNoAds;
        networks[4] = BannerModeNoAds;
        
    } else {
        networks[0] = BannerModeMobFox;
        networks[1] = BannerModeAdMob;
        networks[2] = BannerModeApple;
        networks[3] = BannerModeNoAds;
        networks[4] = BannerModeNoAds;
    }
    
    
	//int networks[5] = NETWORK_PRIORITY_ORDER;
    //for (int x = 0; x<5; x++) {
    //    NSLog(@"Numer: %d", networks[x]);
    //}
	
	// default network is first in priority order
	if (_bannerMode == BannerModeNoAds)
	{
		return networks[0];
	}
	
	// find next in line
	int currentIndex;
	for (currentIndex=0; (currentIndex<5); currentIndex++)
	{
		if (networks[currentIndex]==_bannerMode) break;
	}
	currentIndex++;
	
	BannerMode retMode = networks[currentIndex];
	
	if (!retMode)
	{
		retMode = BannerModeAllFailed;
	}
	
	return retMode;}

#pragma mark Purchasing
- (void)purchaseButtonPushed:(UIButton *)button
{
	if ([_delegate respondsToSelector:@selector(bannerManagerDidPushPurchaseButton:)])
	{
		[_delegate bannerManagerDidPushPurchaseButton:self];
	}
}


@synthesize bannerClipView;
@synthesize iAdBannerView;
@synthesize adMobBannerView;
@synthesize mobfoxBannerView;

@synthesize viewControllerWithBanner;
@synthesize bannerMode = _bannerMode;
@synthesize delegate = _delegate;


@end

