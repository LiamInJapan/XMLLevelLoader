/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "PhysicsLayer.h"

#if KK_PLATFORM_MAC
#import <Carbon/Carbon.h>
#endif

enum 
{
	kTagBatchNode = 1,
	kCollisionTypeCircle = 2,
};

const float kFilterFactor = 0.05;

const int TILESIZE = 32;
const int TILESET_COLUMNS = 9;
const int TILESET_ROWS = 19;

// this controls how quickly the velocity decelerates (lower = quicker to change direction)
const float deceleration = 0.4f;
// this determines how sensitive the accelerometer reacts (higher = more sensitive)
const float sensitivity = 6.0f;
// how fast the velocity can be at most
const float maxVelocity = 10000.0f;
// constant keyboard acceleration value for Mac version
const float keyAcceleration = 0.16f;

@interface PhysicsLayer (PrivateMethods)
-(BOOL) boxCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
-(void) addSomeJoinedBodies:(CGPoint)pos;
-(void) addNewSpriteAt:(CGPoint)pos;
@end

@implementation PhysicsLayer

-(BOOL) boxCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arbiter space:(cpSpace*)space
{
	BOOL processCollision = YES;

	if (moment == COLLISION_BEGIN || moment == COLLISION_SEPARATE)
	{
		cpShape* shapeA;
		cpShape* shapeB;
		cpArbiterGetShapes(arbiter, &shapeA, &shapeB);

		cpCCSprite* spriteA = (cpCCSprite*)shapeA->data;
		cpCCSprite* spriteB = (cpCCSprite*)shapeB->data;
		if (spriteA != nil && spriteB != nil)
		{
			if (moment == COLLISION_BEGIN)
			{
				//spriteA.color = ccMAGENTA;
				//spriteB.color = ccMAGENTA;
			}
			else
			{
				spriteA.color = ccWHITE;
				spriteB.color = ccWHITE;
			}
		}
	}
	
	return processCollision;
}

-(cpCCSprite*) addRandomSpriteAt:(CGPoint)pos shape:(cpShape*)shape
{
	CCSpriteBatchNode* batch = (CCSpriteBatchNode*)[self getChildByTag:kTagBatchNode];

	int idx = CCRANDOM_0_1() * TILESET_COLUMNS;
	int idy = CCRANDOM_0_1() * TILESET_ROWS;
	CGRect tileRect = CGRectMake(TILESIZE * idx, TILESIZE * idy, TILESIZE, TILESIZE);
	
	cpCCSprite* sprite = [cpCCSprite spriteWithTexture:batch.texture rect:tileRect];
	sprite.shape = shape;
	sprite.position = pos;
	[batch addChild:sprite];
	
	return sprite;
}

-(void) addSomeJoinedBodies:(CGPoint)pos
{
	const float mass = 1.0f;
	const float posOffset = 1.4f;
	
	cpShape* staticBox = [spaceManager addRectAt:pos mass:STATIC_MASS width:TILESIZE height:TILESIZE rotation:0];
	staticBox->collision_type = kCollisionTypeCircle;
	cpCCSprite* sprite = [self addRandomSpriteAt:pos shape:staticBox];
	sprite.opacity = 100;
	staticBox->data = sprite;

	pos.x += TILESIZE * posOffset;
	cpShape* boxA = [spaceManager addRectAt:pos mass:mass width:TILESIZE height:TILESIZE rotation:0];
	boxA->collision_type = kCollisionTypeCircle;
	boxA->data = [self addRandomSpriteAt:pos shape:boxA];

	pos.x += TILESIZE * posOffset;
	cpShape* boxB = [spaceManager addRectAt:pos mass:mass width:TILESIZE height:TILESIZE rotation:0];
	boxB->collision_type = kCollisionTypeCircle;
	boxB->data = [self addRandomSpriteAt:pos shape:boxB];

	pos.x += TILESIZE * posOffset;
	cpShape* boxC = [spaceManager addRectAt:pos mass:mass width:TILESIZE height:TILESIZE rotation:0];
	boxC->collision_type = kCollisionTypeCircle;
	boxC->data = [self addRandomSpriteAt:pos shape:boxC];
	
	[spaceManager addPivotToBody:staticBox->body fromBody:boxA->body worldAnchor:staticBox->body->p];
	[spaceManager addPivotToBody:boxA->body fromBody:boxB->body worldAnchor:boxA->body->p];
	[spaceManager addPivotToBody:boxB->body fromBody:boxC->body worldAnchor:boxB->body->p];
}

-(void) addNewPlayerAt:(CGPoint)pos
{
	const float elasticity = 0.0f;
	const float friction = 0.7f;

    player = [cpCCSprite spriteWithFile:@"ball.png"];
    [self addChild:player z:0 tag:1];
    
    cpShape* circle = [spaceManager addCircleAt:pos 
                                           mass:0.5f 
                                         radius:([player texture].contentSize.width)/2];
                       
                       
	/*cpShape* box = [spaceManager addRectAt:pos 
                                      mass:0.5f 
                                     width:[player texture].contentSize.width
                                    height:[player texture].contentSize.height
                                  rotation:0];*/
	circle->e = elasticity;
	circle->u = friction;
	circle->collision_type = kCollisionTypeCircle;
    
    player.position = pos;
    
    //CGRect tileRect = CGRectMake([, TILESIZE * idy, TILESIZE, TILESIZE);
	
	player.shape = circle;
    
	circle->data = player;
}

-(void) update:(ccTime)delta
{
	CGPoint pos = player.position;
	pos.x += playerVelocity.x;
	
	// The Player should also be stopped from going outside the screen
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	float imageWidthHalved = [player texture].contentSize.width * 0.5f;
	float leftBorderLimit = imageWidthHalved;
	float rightBorderLimit = screenSize.width - imageWidthHalved;
    
	// the left/right border check is performed against half the player image's size so that the sides of the actual
	// sprite are blocked from going outside the screen because the player sprite's position is at the center of the image
	if (pos.x < leftBorderLimit)
	{
		pos.x = leftBorderLimit;
        
        NSLog(@"player velocity zeroed");
		// also set velocity to zero because the player is still accelerating towards the border
		playerVelocity = CGPointZero;
	}
	else if (pos.x > rightBorderLimit)
	{
		pos.x = rightBorderLimit;
        
        NSLog(@"player velocity zeroed");
		// also set velocity to zero because the player is still accelerating towards the border
		playerVelocity = CGPointZero;
	}
    
	
	player.position = pos;
}

// #pragma mark statements are a nice way to categorize your code and to use them as "bookmarks"
#pragma mark Accelerometer & Touch Input

-(void) acceleratePlayerWithX:(double)xAcceleration
{
    xAcceleration *= 40.0f;
    
	// If the device is rotated upside down, we have to invert the accelerometer's X values.
	float invertHorizontalMovement = 1.0f;
	
#if KK_PLATFORM_IOS
	if ([CCDirector sharedDirector].deviceOrientation == kCCDeviceOrientationPortraitUpsideDown)
	{
		invertHorizontalMovement = -1.0f;
	}
#endif
	
	// adjust velocity based on current accelerometer acceleration
	//playerVelocity.x = playerVelocity.x * deceleration + (xAcceleration * sensitivity * invertHorizontalMovement);
	player.body->v.x = player.body->v.x * deceleration + (xAcceleration * sensitivity * invertHorizontalMovement);
    
	// we must limit the maximum velocity of the player sprite, in both directions (positive & negative values)
	/*if (playerVelocity.x > maxVelocity)
	{
		playerVelocity.x = maxVelocity;
	}
	else if (playerVelocity.x < -maxVelocity)
	{
		playerVelocity.x = -maxVelocity;
	}*/
    if (player.body->v.x > maxVelocity)
	{
		player.body->v.x = maxVelocity;
	}
	else if (player.body->v.x < -maxVelocity)
	{
		player.body->v.x = -maxVelocity;
	}
    
    //player.position = ccp(player.position.x+playerVelocity.x , player.position.y);
    
        // Alternatively, the above if/else if block can be rewritten using fminf and fmaxf more neatly like so:
	// playerVelocity.x = fmaxf(fminf(playerVelocity.x, maxVelocity), -maxVelocity);
}

// only used for Mac OS
-(void) keepAccelerating:(ccTime)delta
{
	[self acceleratePlayerWithX:currentKeyAcceleration];
}

#if KK_PLATFORM_IOS

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	[self acceleratePlayerWithX:-acceleration.y];
    
    //static float prevX=0, prevY=0;
    
    //float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
    //float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
    
    //prevX = accelX;
    //prevY = accelY;
    
    //cpVect v = cpv( accelX, accelY);
    
    //spaceManager.gravity = cpvmult(v, 0);
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [player applyImpulse:cpv(0,300)];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#elif KK_PLATFORM_MAC

// Mac keyboard event processing uses the Carbon keycodes.
// See here for the full list: http://forums.macrumors.com/showthread.php?t=780577
// Nice visual key mapping: http://boredzo.org/blog/archives/2007-05-22/virtual-key-codes

// NOTE: unlike Windows apps your Mac app won't "miss" key events if the app's window loses focus.

-(BOOL) ccKeyDown:(NSEvent*)keyDownEvent
{
    
	UInt16 keyCode = [keyDownEvent keyCode];
    
    switch (keyCode)
    {
        case kVK_LeftArrow:
            
            [player applyForce:cpv(-10, 0)];
            //NSLog(@"left");
            //NSLog(@"%f", currentKeyAcceleration);
            //currentKeyAcceleration = -keyAcceleration;
            break;
        
        case kVK_RightArrow:
            [player applyForce:cpv(10, 0)];
            //NSLog(@"right");
            //NSLog(@"%f", currentKeyAcceleration);
            //currentKeyAcceleration = keyAcceleration;
            break;
            
        case kVK_Space:
            
            [player applyImpulse:cpv(0,50)];
				
        default:
            // ignore unhandled keypresses
            break;
    }

	return YES;
}

-(BOOL) ccKeyUp:(NSEvent*)keyUpEvent
{
	UInt16 keyCode = [keyUpEvent keyCode];
    
	switch (keyCode)
    {
        case kVK_LeftArrow:
        case kVK_RightArrow:
            // not being able to "hold still" makes the game more challenging
            //currentKeyAcceleration = 0;
            break;
				
        default:
            // ignore unhandled keypresses
            break;
	}
	
	return YES;
}

#endif

#pragma mark Scene Creation and Teardown

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PhysicsLayer *layer = [PhysicsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    
	if ((self = [super init]))
	{
		CCLOG(@"%@ init", NSStringFromClass([self class]));
        
#if KK_PLATFORM_IOS
		// Yes, we want to receive accelerometer input events.
		self.isAccelerometerEnabled = YES;
#elif KK_PLATFORM_MAC
		self.isKeyboardEnabled = YES;
#endif
        
		
        
		spaceManager = [[SpaceManagerCocos2d alloc] init];
		spaceManager.constantDt = 0.01f;
        spaceManager.gravity = CGPointMake(0, -800);
		spaceManager.space->iterations = 8;
		
		[spaceManager addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
		[spaceManager start];
		
		// Note: SpaceManager collision handling adds some overhead. You can always switch back to
		// Chipmunk C-style collision handling if you are experiencing slowdowns during mass collision events.
		[spaceManager addCollisionCallbackBetweenType:kCollisionTypeCircle 
											otherType:kCollisionTypeCircle
											   target:self
											 selector:@selector(boxCollision:arbiter:space:)
											  moments:COLLISION_BEGIN, COLLISION_SEPARATE, nil];
        
		/*NSString* message = @"Tap Screen For More Awesome!";
         if ([CCDirector sharedDirector].currentPlatformIsMac)
         {
         message = @"Click Window For More Awesome!";
         }
         
         CCLabelTTF* label = [CCLabelTTF labelWithString:message fontName:@"Marker Felt" fontSize:32];
         [self addChild:label];
         [label setColor:ccc3(222, 222, 255)];
         label.position = CGPointMake(screenSize.width / 2, screenSize.height - 50);*/
		
		//CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"dg_grounds32.png" capacity:150];
		//[self addChild:batch z:0 tag:kTagBatchNode];
		
        //[self scheduleUpdate];
        //[self schedule:@selector(keepAccelerating:)];
        
		// Add a few objects initially
		//for (int i = 0; i < 1; i++)
		//{
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        [self addNewPlayerAt:CGPointMake(screenSize.width/2,screenSize.height/2) ];
		//}
		
		//[self addSomeJoinedBodies:CGPointMake(screenSize.width / 3, screenSize.height -50)];
		
        currentKeyAcceleration = 0;
        
#if KK_PLATFORM_IOS
		self.isTouchEnabled = YES;
#elif KK_PLATFORM_MAC
		self.isMouseEnabled = YES;
#endif
	}
    
	return self;
}

-(void) dealloc
{
	[spaceManager release];
	spaceManager = nil;
    
    [player release];
    player = nil;
    
	[super dealloc];
}

-(void) onExit
{
	[spaceManager stop];
}



@end
