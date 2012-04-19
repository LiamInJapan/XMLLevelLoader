--[[
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
--]]


--[[
		* Need help with the KKStartupConfig settings?
		* ------ http://www.kobold2d.com/x/ygMO ------
--]]


local config =
{
	KKStartupConfig = 
	{
		-- load first scene from a class with this name, or from a Lua script with this name with .lua appended
		FirstSceneClassName = "PrototypeMenu",

		-- set the director type, and the fallback in case the first isn't available
		DirectorType = DirectorType.DisplayLink,
		DirectorTypeFallback = DirectorType.NSTimer,

		MaxFrameRate = 60,
		DisplayFPS = YES,

		EnableUserInteraction = YES,
		EnableMultiTouch = YES,

		-- Render settings
		DefaultTexturePixelFormat = TexturePixelFormat.RGBA8888,
		GLViewColorFormat = GLViewColorFormat.RGB565,
		GLViewDepthFormat = GLViewDepthFormat.DepthNone,
		GLViewMultiSampling = NO,
		GLViewNumberOfSamples = 0,

		Enable2DProjection = NO,
		EnableRetinaDisplaySupport = NO,	-- there are no Retina assets in this template project

		-- Orientation & Autorotation
		DeviceOrientation = DeviceOrientation.LandscapeLeft,
		AutorotationType = Autorotation.CCDirector,
		ShouldAutorotateToLandscapeOrientations = NO,
		ShouldAutorotateToPortraitOrientations = NO,
		AllowAutorotateOnFirstAndSecondGenerationDevices = NO,
	
		-- iAd setup
		-- Note: for iAd to support autorotation you should use: AutorotationType = Autorotation.kAutorotationUIViewController
		EnableAdBanner = NO,
		LoadOnlyPortraitBanners = NO,
		LoadOnlyLandscapeBanners = NO,
		PlaceBannerOnBottom = NO,
	
		-- Mac OS specific settings
		AutoScale = YES,
		AcceptsMouseMovedEvents = NO,
		WindowFrame = RectMake(1024-640, 768-480, 640, 480),		
	},
	
	-- you can create your own config sections using the same mechanism and use KKConfig to access the parameters
	-- or use the KKConfig injectPropertiesFromKeyPath method
	MySettings =
	{
	},
}

return config
