//
//  DTBannerClipView.m
//  GeoCorder
//
//  Created by Oliver Drobnik on 7/29/10.
//  Copyright 2010 Drobnik.com. All rights reserved.
//

#import "DTBannerClipView.h"
#import "DTBannerManagerConfig.h"

@implementation DTBannerClipView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
	{
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		
		self.userInteractionEnabled = NO;
    }
    return self;
}

// have all taps "go through" this view unless it's a subview
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView *view = [super hitTest:point withEvent:event];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (CGRectContainsPoint(CGRectMake(0, 0, 984, 25), point))
        {
            return nil;
        }
    } else {
        //if (CGRectContainsPoint(CGRectMake(0, 0, 320, 25), point))
        if (CGRectContainsPoint(CGRectMake(0, 0, 280, 25), point))
        {
            return nil;
        }
    }

	if (view!=self)
	{
		return view;
	}
	
	return nil;
}

- (void)addSubviewAtBottom:(UIView *)view
{
	view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height - view.bounds.size.height,
							view.bounds.size.width, view.bounds.size.height);
	[self addSubview:view];
	
#ifdef ADFREE_PURCHASE_ENABLED
    
    //NSLog(@"Ad free purchase is enabled. View:  %.1f, %.1f, %.1f, %.1f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    //NSLog(@"Ad free purchase is enabled. View:  %.1f, %.1f, %.1f, %.1f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    //NSLog(@"Ad free purchase is enabled. View:  %.1f, %.1f, %.1f, %.1f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
	self.purchaseButton.frame = CGRectMake(0, self.bounds.size.height - view.bounds.size.height-24, self.bounds.size.width, view.bounds.size.height + 24);
	self.backgroundView.frame = CGRectInset(view.frame, 1, 1);
	
	if (!_slidingView)
	{
		_slidingView = [[UIView alloc] initWithFrame:self.bounds];
        //_slidingView.backgroundColor = [UIColor blueColor];
	}
    
    //UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - view.bounds.size.height-24, self.bounds.size.width, view.bounds.size.height + 24)];
    //UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0, -24, 30, 24)];
    
    //testview.backgroundColor = [UIColor blueColor];
	//[_slidingView addSubview: testview];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        if (view.frame.size.height == 66) {
            //NSLog(@"Is iAd ad, set activitindicator");
            self.activityIndicator.center = CGPointMake(1008, 15 + 15);
        } else {
            //NSLog(@"Is Mobfox / Admob ad, set activitindicator");
            self.activityIndicator.center = CGPointMake(1008, 15);
        }        
    } else {
        self.activityIndicator.center = CGPointMake(304, 15);
        
    }
	
	[_slidingView addSubview:_backgroundView];
	[_slidingView addSubview:purchaseButton];
	[_slidingView addSubview:_activityIndicator];

	[self insertSubview:_slidingView atIndex:0];
	
	// show or hide based on current setting
	if (purchaseButtonVisible)
	{
		self.purchaseButton.alpha = 1;
		self.backgroundView.alpha = 1;
	}
	else 
	{
		self.purchaseButton.alpha = 0;
		self.backgroundView.alpha = 0;
	}
    
    //NSLog(@"Sliding View:  %.1f, %.1f, %.1f, %.1f", _slidingView.frame.origin.x, _slidingView.frame.origin.y, _slidingView.frame.size.width, _slidingView.frame.size.height);
	
	_slidingView.transform = CGAffineTransformIdentity;
    
    //NSLog(@"Sliding View:  %.1f, %.1f, %.1f, %.1f", _slidingView.frame.origin.x, _slidingView.frame.origin.y, _slidingView.frame.size.width, _slidingView.frame.size.height);
#endif
}

- (void)addSubviewOutsideAtBottom:(UIView *)view
{
	[self addSubviewAtBottom:view];
	
	// set transform to make it be outside
	view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
	_slidingView.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
}

- (void) slideInDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	self.userInteractionEnabled = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerDidSlideIn" object:nil];
}

/*
- (void) slideOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(id)context
{
	NSLog(@"1");
    self.userInteractionEnabled = NO;
    NSLog(@"2");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerDidSlideOut" object:nil];
    NSLog(@"3");
	for (UIView *oneView in self.subviews)
	{
		NSLog(@"4");
        if (context == oneView || !context)
		{
			NSLog(@"5");
            if (oneView != purchaseButton && oneView != _backgroundView)
			{
				NSLog(@"6");
                [oneView removeFromSuperview];
			}
		}
	}	
}
*/
 
- (void)slideInSubview:(UIView *)subview
{
	
    #ifdef LOGOUTPUTON
    NSLog(@"Slide in subview");
    #endif
    
    [self addSubviewOutsideAtBottom:subview];
	
	[UIView beginAnimations:nil context:(__bridge void *)subview];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideInDidStop:finished:context:)];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideIn" object:nil];
	
	subview.transform = CGAffineTransformIdentity;
	
	_slidingView.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)slideOutSubview:(UIView *)subview
{
	#ifdef LOGOUTPUTON
    NSLog(@"Slide out subview");
    #endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideOut" object:nil];
    
    [self setPurchaseButtonVisible: NO];
    
    [UIView animateWithDuration:0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         subview.transform = CGAffineTransformMakeTranslation(0, subview.bounds.size.height);
                         _slidingView.transform = CGAffineTransformMakeTranslation(0, subview.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         self.userInteractionEnabled = NO;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerDidSlideOut" object:nil];
                         for (UIView *oneView in self.subviews)
                         {
                             if (oneView != purchaseButton && oneView != _backgroundView)
                             {
                                 [oneView removeFromSuperview];
                             }
                         }
                         
                         
                     }];
    
    /*
    [UIView beginAnimations:nil context:(__bridge void *)subview];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideOutDidStop:finished:context:)];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideOut" object:nil];
	
	subview.transform = CGAffineTransformMakeTranslation(0, subview.bounds.size.height);
	_slidingView.transform = CGAffineTransformMakeTranslation(0, subview.bounds.size.height);
	
	
	[UIView commitAnimations];
     */
}

/*
- (void)slideInSubviews
{
	NSLog(@"Slide in subviews");
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideInDidStop:finished:context:)];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideIn" object:nil];
	
	for (UIView *subview in self.subviews)
	{
		subview.transform = CGAffineTransformIdentity;
	}
	
	_slidingView.transform = CGAffineTransformIdentity;
	
	
	[UIView commitAnimations];
	
}
*/

- (void)slideOutSubviews
{
	#ifdef LOGOUTPUTON
    NSLog(@"Slide out subviews");
    #endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideOut" object:nil];
    
    [self setPurchaseButtonVisible: NO];
    
    [UIView animateWithDuration:0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for (UIView *subview in self.subviews)
                         {
                             subview.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
                         }
                         
                         _slidingView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         self.userInteractionEnabled = NO;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerDidSlideOut" object:nil];
                         for (UIView *oneView in self.subviews)
                         {
                             if (oneView != purchaseButton && oneView != _backgroundView)
                             {
                                 [oneView removeFromSuperview];
                             }
                         }
                         
                         
                     }];
    
    /*
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideOutDidStop:finished:context:)];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BannerWillSlideOut" object:nil];
	
	for (UIView *subview in self.subviews)
	{
		subview.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
	}
	
	_slidingView.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
	
	[UIView commitAnimations];
     */
}



#pragma mark Properties
- (void)setPurchaseButtonBusy:(BOOL)isBusy
{
	#ifdef LOGOUTPUTON
    NSLog(@"Make purchase button busy. Check");
    #endif
    
    if (purchaseButtonBusy != isBusy)
	{
		#ifdef LOGOUTPUTON
        NSLog(@"Make purchase button busy.");
        #endif
        
        purchaseButtonBusy = isBusy;
		
		
		if (isBusy)
		{
			purchaseButton.enabled = NO;
			[_activityIndicator startAnimating];
		}
		else 
		{
			purchaseButton.enabled = YES;
			[_activityIndicator stopAnimating];
		}
	}
}

- (void)setPurchaseButtonVisible:(BOOL)visible animated:(BOOL)animated
{
	#ifdef LOGOUTPUTON
    NSLog(@"Make purchase button visible. Check.");
    #endif
    
    if (visible != purchaseButtonVisible)
	{
		#ifdef LOGOUTPUTON
        NSLog(@"Make purchase button visible");
        #endif
        
        purchaseButtonVisible = visible;
		
		if (animated)
		{
			[UIView beginAnimations:@"PurchaseFade" context:nil];
			//[UIView setAnimationDuration:1];
		}
		
		if (visible)
		{
			#ifdef LOGOUTPUTON
            NSLog(@"Make purchase button visible: Y");
            #endif
            
            self.purchaseButton.alpha = 1;
			self.backgroundView.alpha = 1;
		}
		else 
		{
			#ifdef LOGOUTPUTON
            NSLog(@"Make purchase button visible: N");
            #endif
            
            self.purchaseButton.alpha = 0;
			self.backgroundView.alpha = 0;
		}
		
		if (animated)
		{
			[UIView commitAnimations];
		}
	}
}

- (void)setPurchaseButtonVisible:(BOOL)visible
{
	#ifdef LOGOUTPUTON
    NSLog(@"Make purchase button visible. Init.");
    #endif
    
    [self setPurchaseButtonVisible:visible animated:NO];
}

- (UIButton *)purchaseButton
{
	if (!purchaseButton)
	{
		purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		UIImage *unpressed = [UIImage imageNamed:@"xBatch_border_x_stretchable.png"];
		UIImage *stretchableUnpressed = [unpressed stretchableImageWithLeftCapWidth:4 topCapHeight:30];
		
		UIImage *pressed = [UIImage imageNamed:@"xBatch_border_x_stretchable_pressed.png"];
		UIImage *stretchablePressed = [pressed stretchableImageWithLeftCapWidth:4 topCapHeight:30];
        
		UIImage *disabled = [UIImage imageNamed:@"xBatch_border_stretchable.png"];
		UIImage *stretchableDisabled = [disabled stretchableImageWithLeftCapWidth:4 topCapHeight:30];

		purchaseButton.adjustsImageWhenHighlighted = NO;
		
		[purchaseButton setBackgroundImage:stretchableUnpressed forState:UIControlStateNormal];
		[purchaseButton setBackgroundImage:stretchablePressed forState:UIControlStateHighlighted];
		[purchaseButton setBackgroundImage:stretchableDisabled forState:UIControlStateDisabled];
	}
	
	return purchaseButton;
}

- (UIView *)backgroundView
{
	if (!_backgroundView)
	{
		_backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		_backgroundView.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.5];
	}
	
	return _backgroundView;
}

- (UIActivityIndicatorView *)activityIndicator
{
	if (!_activityIndicator)
	{
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	}
	
	return _activityIndicator;
}




@synthesize backgroundView = _backgroundView;
@synthesize purchaseButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize purchaseButtonVisible;
@synthesize purchaseButtonBusy;

@end
