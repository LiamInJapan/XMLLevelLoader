/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"

@implementation AppDelegate

// Note: only override the UI/NSApplicationDelegate methods that you absolutely must handle yourself.
// In most cases you will still want to call the [super ..] implementation,
// unless you want to override the KKAppDelegate behavior entirely.

// Called when Cocos2D is fully setup and you are able to run the first scene
-(void) initializationComplete
{
	// If iAd is enabled and you want to supply your own AdBannerViewDelegate, use this code:
	//[[KKAdBanner sharedAdBanner].adBannerView setDelegate:yourAdBannerViewDelegate];
	

	// Note: if you specify FirstSceneClassName in startup-config.lua you do not need to call runWithScene at all!
	// If you have to, you can still call runWithScene here, for example to add some logic to select one of many scenes to run first
	//[[CCDirector sharedDirector] runWithScene:[test test]];
}

@end
