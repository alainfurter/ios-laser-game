//
//  DTBannerClipView.h
//  GeoCorder
//
//  Created by Oliver Drobnik on 7/29/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTBannerClipView : UIView 
{
	UIButton *purchaseButton;
	UIView *_backgroundView;
	
	BOOL purchaseButtonVisible;
	BOOL purchaseButtonBusy;
	
	
	UIView *_slidingView;
	UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIButton *purchaseButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;



@property (nonatomic, assign) BOOL purchaseButtonVisible;
@property (nonatomic, assign) BOOL purchaseButtonBusy;

- (void)addSubviewAtBottom:(UIView *)view;
- (void)addSubviewOutsideAtBottom:(UIView *)view;

//- (void)slideInSubviews;
- (void)slideOutSubviews;

- (void)slideInSubview:(UIView *)subview;
- (void)slideOutSubview:(UIView *)subview;


- (void)setPurchaseButtonVisible:(BOOL)visible animated:(BOOL)animated;


@end
