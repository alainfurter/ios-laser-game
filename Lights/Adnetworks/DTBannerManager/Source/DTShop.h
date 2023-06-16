//
//  DTShop.h
//  IR
//
//  Created by Oliver Drobnik on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

//#import "UIAlertView+Blocks.h"
//#import "NSStringAdditions.h"

#import "DTBannerManager.h"

#import "Config.h"

//#import "UIAlertView+Blocks.h"

//#import "AFHTTPClient.h"
//#import "AFHTTPRequestOperation.h"

#define SHOP [DTShop sharedShop]

@interface DTShop : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
	//NSMutableSet *skus;
	
	SKProductsRequest *myProdRequest;
	
	NSArray *purchasableProducts;
    
    BOOL shopIsOpenForPurchase;
	
#ifdef TARGET_IPHONE_SIMULATOR
	NSString *simulatedPurchaseSKU;
	BOOL simulatedOpen;
#endif
}

+ (DTShop *)sharedShop;

- (BOOL) isProductInstalledWithSKU:(NSString *)sku;
- (void) installProductWithSKU:(NSString *)sku;
- (void) purchaseProductWithSKU:(NSString *)sku;

- (NSString *)localizedPriceForProductWithSKU:(NSString *)sku;

- (BOOL) isReadyForPurchasing;
- (void) restorePurchases:(NSString *)sku;
- (void) restoreAllPurchases;

- (SKProduct *)productForSKU:(NSString *)sku;

//- (BOOL) deductOneCreditFromBalance;
//- (int) checkCreditsBalance;

//- (void) reinitShop;

@end
