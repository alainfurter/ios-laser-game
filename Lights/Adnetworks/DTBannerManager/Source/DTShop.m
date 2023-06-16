//
//  DTShop.m
//  IR
//
//  Created by Oliver Drobnik on 2/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DTShop.h"
#import <StoreKit/StoreKit.h>

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"

//#import "IapTransactionsLog.h"

static DTShop * _sharedShop;


#if defined __arm__ || defined __thumb__
#undef TARGET_IPHONE_SIMULATOR
#ifndef TARGET_OS_IPHONE
#define TARGET_OS_IPHONE
#endif
#else
#define TARGET_IPHONE_SIMULATOR 1
#undef TARGET_OS_IPHONE
#endif



@implementation DTShop


+ (DTShop *)sharedShop
{
	if (!_sharedShop)
	{
		_sharedShop = [[DTShop alloc] init];
	}
    
	return _sharedShop;
}

- (void)simulateShopOpening
{
	simulatedOpen = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopNowOpen" object:nil];
}

- (id) init
{
	if ((self = [super init]))
	{
		//// get installed SKUs
		
		//skus = [[NSMutableSet setWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"SKUs"]] retain];
		
		//if (!skus)
		//{
		//	NSLog(@"SKU Alloc");
        
        //skus = [[NSMutableSet alloc] init];
		//}
		
		// prepare shop
        
        shopIsOpenForPurchase = NO;
		
		if ([SKPaymentQueue canMakePayments])
		{
            #ifdef LOGOUTPUTON
            NSLog(@"Init Can make payments");
            #endif
                        
            NSString *path = [[NSBundle mainBundle] pathForResource:kProductsfile ofType:@"plist"];
            
			NSArray *productsArray = [NSArray arrayWithContentsOfFile:path];
			
            #ifdef LOGOUTPUTON
            NSLog(@" Init Products array: %@", productsArray);
            #endif
			
            // cannot autorelease, otherwise no response
			NSSet *possibleProducts = [NSSet setWithArray:productsArray];
            
            #ifdef LOGOUTPUTON
            NSLog(@"Init Possible products: %@", possibleProducts);
            #endif
			
            myProdRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:possibleProducts];
			myProdRequest.delegate = self;
			[myProdRequest start];
			
			[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		}
		
	}
	
	return self;
}

- (void) reinitShop {
    if ([SKPaymentQueue canMakePayments])
    {
        #ifdef LOGOUTPUTON
        NSLog(@"Init Can make payments");
        #endif
        
        NSString *path = [[NSBundle mainBundle] pathForResource:kProductsfile ofType:@"plist"];
        
        NSArray *productsArray = [NSArray arrayWithContentsOfFile:path];
        
        #ifdef LOGOUTPUTON
        NSLog(@" Init Products array: %@", productsArray);
        #endif
        
        // cannot autorelease, otherwise no response
        NSSet *possibleProducts = [NSSet setWithArray:productsArray];
        
        #ifdef LOGOUTPUTON
        NSLog(@"Init Possible products: %@", possibleProducts);
        #endif
        
        myProdRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:possibleProducts];
        myProdRequest.delegate = self;
        [myProdRequest start];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopReinitShopDone" object:nil];
        
    } else {
        shopIsOpenForPurchase = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopCannotOpen" object:nil];
    }
}

- (void) dealloc
{
    #ifdef TARGET_IPHONE_SIMULATOR
	[simulatedPurchaseSKU release];
    #endif
	
	//[skus release];
	[purchasableProducts release];
	[myProdRequest release], myProdRequest = nil;  // instead of autorelease, otherwise no response.
	
	
	[super dealloc];
}

/*
- (BOOL) deductOneCreditFromBalance {
    
    #ifdef LOGOUTPUTON
    NSLog(@"Deduct one credit: enter");
    #endif
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prodFilePath = [documentsDirectory stringByAppendingPathComponent: kProductsfile];
    
    NSString *deviceID;
    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: prodFilePath]) {
        #ifdef LOGOUTPUTON
        NSLog(@"Products file not found");
        #endif
        
        return NO;
    }
    
    NSDictionary *prodArray = [[NSDictionary alloc] initWithContentsOfFile: prodFilePath];
    if ([prodArray count] != 2) return NO;
    
    #ifdef LOGOUTPUTON
    NSLog(@"Deduct one credit: products file loaded");
    NSLog(@"Products file content before: %@2", prodArray);
    #endif
    
    //NSDictionary *products;
    NSString *productkey;
    NSString *creditString;
    
    NSArray *prArray = [[prodArray objectForKey: kProductTrainlineCredits] componentsSeparatedByString: @"|"];
    int credits = [[prArray objectAtIndex: 0] intValue];
    
    #ifdef LOGOUTPUTON
    NSLog(@"Deduct one credit: credits: %d", credits);
    #endif
    
    if (credits <=0) return NO;
    
    if (credits == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DTOpenStore" object:nil];
    }
    
    credits-=1;
    
    creditString = [NSString stringWithFormat: @"%d", credits];
    NSArray *newPrArray = [NSArray arrayWithObjects: creditString, deviceID, nil];
    productkey = [[creditString stringByAppendingString: @"|"] stringByAppendingString: [[newPrArray componentsJoinedByString: @""] stringFromMD5]];
    
    #ifdef LOGOUTPUTON
    NSLog(@"Deduct one credit: productkey: %@", productkey);
    #endif
    
    [prodArray setValue:productkey forKey:kProductTrainlineCredits];
    [prodArray writeToFile:prodFilePath atomically:YES];
    
    #ifdef LOGOUTPUTON
    NSLog(@"Deduct one credit: out");
    NSLog(@"Products file content after: %@2", prodArray);
    #endif
    
    return YES;
    
}

- (int) checkCreditsBalance {
    
    #ifdef LOGOUTPUTON
    NSLog(@"Check credit balance: enter");
    #endif
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prodFilePath = [documentsDirectory stringByAppendingPathComponent: kProductsfile];
    
    NSString *deviceID;
    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: prodFilePath]) {
        #ifdef LOGOUTPUTON
        NSLog(@"Products file not found");
        #endif
        
        return NO;
    }
    
    NSDictionary *prodArray = [[NSDictionary alloc] initWithContentsOfFile: prodFilePath];
    if ([prodArray count] != 2) return NO;
    
    NSArray *prArray = [[prodArray objectForKey: kProductTrainlineCredits] componentsSeparatedByString: @"|"];
    int credits = [[prArray objectAtIndex: 0] intValue];
    
    NSString *productkey;
    
    NSString *creditString = [NSString stringWithFormat: @"%d", credits];
    NSArray *newPrArray = [NSArray arrayWithObjects: creditString, deviceID, nil];
    productkey = [[creditString stringByAppendingString: @"|"] stringByAppendingString: [[newPrArray componentsJoinedByString: @""] stringFromMD5]];
    if (!([[prodArray objectForKey: kProductTrainlineCredits] isEqualToString: productkey])) {
        
        #ifdef LOGOUTPUTON
        NSLog(@"Check credit balance: invalid product key. 0 credits");
        #endif
        
        return 0;
    }
    
    #ifdef LOGOUTPUTON
    NSLog(@"Check credit balance: credits: %d", credits);
    #endif
    
    return credits;
}
*/

- (BOOL) isProductInstalledWithSKU:(NSString *)sku
{
    #ifdef LOGOUTPUTON
    NSLog(@"Is product install with sku: %@", sku);
    #endif
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prodFilePath = [documentsDirectory stringByAppendingPathComponent: kProductsfilePurchased];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: prodFilePath]) return NO;
    
    NSDictionary *prodArray = [[NSDictionary alloc] initWithContentsOfFile: prodFilePath];
        
    if ([prodArray count] != 2) return NO;
    
    NSString *deviceID;

    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *productkey;
    if ([sku isEqualToString: AppStoreInApp]) {
        if (![[prodArray allKeys] containsObject:kProductFullVersion]) return NO;
        
        productkey = [[deviceID stringByAppendingString: sku] stringFromMD5];
        if (![[prodArray objectForKey:kProductFullVersion] isEqualToString: productkey]) return NO;
        
        #ifdef LOGOUTPUTON
        NSLog(@"Full version ipad is installed");
        #endif
        
        return YES;
    } else if ([sku isEqualToString: AppStoreInApp]) {
        if (![[prodArray allKeys] containsObject:kProductFullVersion]) return NO;
        
        productkey = [[deviceID stringByAppendingString: sku] stringFromMD5];
        if (![[prodArray objectForKey:kProductFullVersion] isEqualToString: productkey]) return NO;
        
        #ifdef LOGOUTPUTON
        NSLog(@"Full version iphone is installed");
        #endif
        
        return YES;
    }
    return NO;
}

- (void) installProductWithSKU:(NSString *)sku
{    
    #ifdef LOGOUTPUTON
    NSLog(@"Install product with sku: %@", sku);
    #endif
	
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:sku forKey:@"SKU"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopProductPurchased" object:nil userInfo:userInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *prodFilePath = [documentsDirectory stringByAppendingPathComponent: kProductsfilePurchased];
    
    NSString *deviceID;
    
    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDictionary *products;
    if (![[NSFileManager defaultManager] fileExistsAtPath: prodFilePath]) {
        products = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: @"NA", nil] forKeys: [NSArray arrayWithObjects: kProductFullVersion, nil]];
        [products writeToFile: prodFilePath atomically:YES];
    } else {
        products = [NSDictionary dictionaryWithContentsOfFile:prodFilePath];
    }
    
    NSString *productkey;
    if ([sku isEqualToString: AppStoreInApp]) {
        productkey = [[deviceID stringByAppendingString: sku] stringFromMD5];
        [products setValue:productkey forKey:kProductFullVersion];
        [products writeToFile:prodFilePath atomically:YES];
    } 
    
    #ifdef LOGOUTPUTON
    NSLog(@"Install product with sku. write new values: %@", products);
    #endif
        
    #ifdef TARGET_IPHONE_SIMULATOR
	[simulatedPurchaseSKU release], simulatedPurchaseSKU = nil;
    #endif
    
    //Test
    //[self resetProductsFile];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopInvalidReceipt" object:nil];
}

- (void) simulateCancelPurchase:(NSString *)sku
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopPurchaseCancelled" object:nil];
	[simulatedPurchaseSKU release], simulatedPurchaseSKU = nil;
}


- (void) purchaseProductWithSKU:(NSString *)sku
{
#ifdef TARGET_IPHONE_SIMULATOR
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Simulated Purchase" message:@"On Simulator you can simulate a cancel or ok." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
	
	simulatedPurchaseSKU = [sku retain];
	
#else
    
    #ifdef LOGOUTPUTON
    NSLog(@"Purchase product: %@", sku);
    #endif
	
    if ([self productForSKU:sku])
	{
		//SKPayment *payment = [SKPayment paymentWithProductIdentifier:sku];
        SKPayment *payment = [SKPayment paymentWithProduct: [self productForSKU:sku]];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
        
        //[IapTransactionsLog sendIapTransactionsLogInfo:sku status: @"0" transactionId: @"Init"];
	}
	else
	{
        #ifdef LOGOUTPUTON
        NSLog(@"Invalid Product ID%@", sku);
        #endif
	}
	
#endif
}

- (void) restorePurchases:(NSString *)sku
{
#ifdef TARGET_IPHONE_SIMULATOR
	[self performSelector:@selector(simulateCancelPurchase:) withObject:nil afterDelay:3.0];
	return;
#else
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    //[IapTransactionsLog sendIapTransactionsLogInfo:sku status: @"1" transactionId: @"Init"];
#endif
}

- (void) restoreAllPurchases
{
#ifdef TARGET_IPHONE_SIMULATOR
	[self performSelector:@selector(simulateCancelPurchase:) withObject:nil afterDelay:3.0];
	return;
#else
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
#endif
}

- (SKProduct *)productForSKU:(NSString *)sku
{
    #ifdef LOGOUTPUTON
    NSLog(@"Product for SKU %@", sku);
    NSLog(@"Purchasable product %@", purchasableProducts);
    #endif
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productIdentifier = %@", sku];
	NSArray *found = [purchasableProducts filteredArrayUsingPredicate:predicate];
	
    #ifdef LOGOUTPUTON
    NSLog(@"Array found: %@", found);
    #endif
    
	if ([found count]==1)
	{
		return [found lastObject];
	}
	
	return nil;
}

- (NSString *)localizedPriceForProductWithSKU:(NSString *)sku
{
#ifdef TARGET_IPHONE_SIMULATOR
	return @"CHF 2.00";
#else
	SKProduct *product = [self productForSKU:sku];
	
    #ifdef LOGOUTPUTON
    NSLog(@"Price check product %@", product);
    #endif
    
	if (product)
	{
		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		
		return [numberFormatter stringFromNumber:product.price];
	}
	else
	{
        #ifdef LOGOUTPUTON
        NSLog(@"Invalid Product ID 2 %@", sku);
        #endif
        
        return nil;
	}
#endif
}

- (NSString *)localizedNameForProductWithSKU:(NSString *)sku
{
#ifdef TARGET_IPHONE_SIMULATOR
	return [NSString stringWithFormat:@"Localized '%@'", sku];;
#else
	SKProduct *product = [self productForSKU:sku];
	
    #ifdef LOGOUTPUTON
    NSLog(@"Product received: %@", product);
    #endif
    
	if (product)
	{
		return [product localizedTitle];
	}
	else
	{
        #ifdef LOGOUTPUTON
        NSLog(@"Invalid Product ID 3 %@", sku);
        #endif
        
        return nil;
	}
#endif
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
        NSLog(@"In app failed transaction: %d, %@", transaction.error.code, transaction.error.description);
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopPurchaseCancelled" object:nil];
}

- (BOOL) isReadyForPurchasing
{
#ifdef TARGET_IPHONE_SIMULATOR
	if (!simulatedOpen)
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(simulateShopOpening) withObject:nil afterDelay:5.0];
	}
	
	return simulatedOpen;
#else
	return [SKPaymentQueue canMakePayments] && purchasableProducts!=nil && shopIsOpenForPurchase;
#endif
}


#pragma mark Product Request Delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    #ifdef LOGOUTPUTON
    NSLog(@"Product request response: %@", response);
    NSLog(@"Products: %@", [response products]);
    NSLog(@"Invalid identifier: %@", [response invalidProductIdentifiers]);
    #endif
    
    purchasableProducts = [[response products] retain];
	[request autorelease];
    
    if ([purchasableProducts count] == 0) {
        #ifdef LOGOUTPUTON
        NSLog(@"No purchasable product returned. Will not open shop!");
        #endif
        
        shopIsOpenForPurchase = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopCannotOpen" object:nil];
        
        return;
    }
	
    shopIsOpenForPurchase = YES;
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopNowOpen" object:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopPurchaseCancelled" object:nil];
}

/*
- (void) resetProductsFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *iapFile = [documentsDirectory stringByAppendingPathComponent: kProductsfile];
    
    NSString *deviceID;
    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSDictionary *products;
    
    NSString *productkey;
    NSString *creditString;
    creditString = [NSString stringWithFormat: @"%d", 0];
    
    NSArray *newPrArray = [NSArray arrayWithObjects: creditString, deviceID, nil];
    productkey = [[creditString stringByAppendingString: @"|"] stringByAppendingString: [[newPrArray componentsJoinedByString: @""] stringFromMD5]];
    
    products = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: productkey, @"NA", nil] forKeys: [NSArray arrayWithObjects: kProductTrainlineCredits, kProductFullVersion, nil]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath: iapFile]) {
        [[NSFileManager defaultManager] removeItemAtPath: iapFile error: NULL];
    }
    
    [products writeToFile: iapFile atomically:YES];
}
*/
/*
- (void) informUserAboutInvalidReceipt {
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel: NSLocalizedString(@"Cancel", @"Share connection cancel block action sheet title")];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid receipt", @"Invalid receipt alert view title") message:NSLocalizedString(@"The receipt for this purchase transaction is invalid. Either the transaction is not valid or a severe unknown error occurred. You may report this to the support", @"Invalid receipt alert view message") cancelButtonItem:cancelButton otherButtonItems:nil, nil];
    
    //[alert showInView: self.view];
    [alert show];
    [alert release];
}
*/

/*
- (void)verifyReceipt:(SKPaymentTransaction *)transaction {
    NSString *deviceID;
    deviceID = [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *appid = AppIDIPHONE;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        #ifdef AdsCodeIsOn
            appid = AppIDFREEIPAD;
        #else
            appid = AppIDIPAD;
        #endif
        
    } else {
        
        #ifdef AdsCodeIsOn
            appid = AppIDFREEIPHONE;
        #else
            appid = AppIDIPHONE;
        #endif
        
    }
    
    NSString *receiptB64 = [[NSString base64StringFromData: transaction.transactionReceipt length:[transaction.transactionReceipt length]] stringByEscapingURL];
    
    #ifdef kVERIFYRECEIPTISSANDBOX
    NSString *serverEnvironment = @"1";
    #else
    NSString *serverEnvironment = @"0";
    #endif
    
    NSURL *baseURL = [NSURL URLWithString: @"http://www.zonezeroapps.com/"];
        
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:baseURL] autorelease];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            appid, @"appId",
                            deviceID, @"deviceId",
                            transaction.transactionIdentifier, @"transactionId",
                            serverEnvironment, @"sandbox",
                            receiptB64, @"receipt",
                            nil];
    
    
    #ifdef  LOGOUTPUTON
    NSLog(@"Verify receipt with device id, receipt and identifier: %@, %@, %@",deviceID, transaction.transactionIdentifier, serverEnvironment);
    #endif
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path: @"servers/verifyreceiptserver/verifyreceiptswisstransit.php" parameters:params];
    
    [request setTimeoutInterval: 120];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString = [operation responseString];
        
        #ifdef  LOGOUTPUTON
        NSLog(@"Verify receipt success response: %@", responseString);
        #endif
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
        
        if ([responseString isEqualToString: @"CRAIMM"]) {
            abort();
        }
                
        if ([responseString isEqualToString: @"RESPRO"]) {
            [self resetProductsFile];
        }
        
        if ([responseString isEqualToString: @"RPRINV"]) {
            [self resetProductsFile];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopInvalidReceipt" object:nil];
        }
        
        if ([responseString isEqualToString: @"IAPINV"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DTShopInvalidReceipt" object:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Request failed: %@", error);
        
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
        
        NSString *responseString = [operation responseString];
        if (responseString) {
            NSLog(@"Request failed response: %@", responseString);
        }
    }];
    
    [operation start];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}
*/

#pragma mark Payment Queue Delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
				[self installProductWithSKU:transaction.payment.productIdentifier];
				[queue finishTransaction:transaction];
                //[IapTransactionsLog sendIapTransactionsLogInfo:transaction.payment.productIdentifier status: @"2" transactionId:transaction.transactionIdentifier];
                
                //[self verifyReceipt: transaction];
                
                break;
            case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
                if (transaction.error.code != SKErrorPaymentCancelled)
                {
                    //[IapTransactionsLog sendIapTransactionsLogInfo:transaction.payment.productIdentifier status: @"4" transactionId:transaction.transactionIdentifier];
                    
                } else {
                    //[IapTransactionsLog sendIapTransactionsLogInfo:transaction.payment.productIdentifier status: @"3" transactionId:transaction.transactionIdentifier];
                }
                break;
            case SKPaymentTransactionStateRestored:
				[self installProductWithSKU:transaction.payment.productIdentifier];
				[queue finishTransaction:transaction];
                //[IapTransactionsLog sendIapTransactionsLogInfo:transaction.payment.productIdentifier status: @"2" transactionId:transaction.transactionIdentifier];
                
                //[self verifyReceipt: transaction];
                
                break;
			case SKPaymentTransactionStatePurchasing:
                #ifdef LOGOUTPUTON
                NSLog(@"Purchasing Transaction");
                #endif
                
                break;
            default:
                #ifdef LOGOUTPUTON
                NSLog(@"Transaction State: %d", transaction.transactionState);
                #endif
                
                break;
        }
    }
}



#ifdef TARGET_IPHONE_SIMULATOR
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0) // cancel
	{
		[self performSelector:@selector(simulateCancelPurchase:) withObject:simulatedPurchaseSKU afterDelay:1.0];
	}
	else // purchase made
	{
		[self performSelector:@selector(installProductWithSKU:) withObject:simulatedPurchaseSKU afterDelay:1.0];
	}
}
#endif

@end
