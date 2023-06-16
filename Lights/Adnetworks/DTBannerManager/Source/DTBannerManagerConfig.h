#import "DTBannerManager.h"

// --- Publishers
// Networks without ID setup are disabled
//
// The combination of iAd, MobFox and AdMob is the best because it gets you the highest payout due to 
// strenghts of individual networks in different regions

// priority of networks, order in which they are tried

//#define NETWORK_PRIORITY_ORDER {BannerModeMobFox,BannerModeApple,BannerModeAdMob}

// iAd: does not use a publisher ID and is always enabled
// -- pays well where released

// iAd: amount of time that is waiting max for an iAd, sometimes it takes longer than 10 secs!
#define IAD_RESPONSE_TIMEOUT 15

// MobFox: http://www.mobfox.com/?aid=2
// -- pays very well in D, A, CH countries

//#define MOBFOX_PUBLISHER_ID @"f214da5aa1fda4dfbef2bae8ab8df673"

// AdMob: http://www.admob.com
// -- backfilling for everywhere else

//#define ADMOB_PUBLISHER_ID @"a1512a0b2faa109"


// this displays a purchase button "X" which you can hook into your IAP, e.g. DTShop
#define ADFREE_PURCHASE_ENABLED


