//
//  MultiRoomLayer.m
//  SteelPanParadise
//
//  Created by William Conroy on 6/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "MultiRoomLayer.h"
#import "PhysicsLayer.h"
#import "AppUtility.h"

enum 
{
	kCollisionTypeWall,
    kCollisionTypePortal,
	kCollisionTypeCircle,
};

// MultiRoomLayer implementation
@implementation MultiRoomLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MultiRoomLayer *layer = [MultiRoomLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)drawRoomWalls
{
    for(int i = 0; i < (int)[[roomParser roomWalls] count]; i++)
    {
        NSArray * roomWall = [[roomParser roomWalls] objectAtIndex:i];
        NSUInteger numWallSecs = (NSUInteger)[roomWall count];
        
        CGPoint poly[(int)[roomWall count]];
        
        for(NSUInteger j = 0; j < numWallSecs; j++)
        {
            poly[j] = [[[[roomParser roomWalls] objectAtIndex:i] objectAtIndex:j] CGPointValue];
        }
        
        ccDrawPoly(poly, numWallSecs, NO);
    }
}
// looks expensive - consider extracting out into polys on init
-(void) draw
{
    [self drawRoomWalls];
}

static int ballHitsPortal(cpArbiter *arb, cpSpace *space, void *data)
{
	NSLog(@"Circle/Portal Collision");
	
	return 1;
}

-(void)setupCollisionHandlers
{
	cpSpaceAddCollisionHandler(spaceManager.space, 
							   kCollisionTypeCircle, 
							   kCollisionTypePortal, 
							   &ballHitsPortal, 
							   NULL, NULL, NULL, NULL);
	
}

-(void)setupRoomWalls
{
    cpBody *polyBody = cpBodyNew(INFINITY, INFINITY); 
    
    for(int i = 0; i < (int)[roomParser.roomWalls count]; i++)
    {
        NSArray * roomWall = [[roomParser roomWalls] objectAtIndex:i];
        NSUInteger numWallSecs = (NSUInteger)[roomWall count];
        
        for(NSUInteger j = 0; j < numWallSecs -1; j++)
        {
            cpShape * shape = cpSegmentShapeNew(polyBody, 
                                                [[[roomParser.roomWalls objectAtIndex:i] objectAtIndex:j] CGPointValue], 
                                                [[[roomParser.roomWalls objectAtIndex:i] objectAtIndex:j+1] CGPointValue], 
                                                1.0f);
                                             
            shape->e = 0.5; 
            shape->u = 0.1; 
            shape->collision_type = kCollisionTypeWall;
        
            cpSpaceAddStaticShape(spaceManager.space, shape);
        }
    }
}

-(void)setupPortals
{
    cpBody *polyBody = cpBodyNew(INFINITY, INFINITY); 
    
    for(int i = 0; i < (int)[roomParser.roomPortals count]; i++)
    {
        NSArray * roomWall = [[roomParser roomWalls] objectAtIndex:i];
        NSUInteger numWallSecs = (NSUInteger)[roomWall count];
        
        for(NSUInteger j = 0; j < numWallSecs -1; j++)
        {
            cpShape * shape = cpSegmentShapeNew(polyBody, 
                                                [[roomWall objectAtIndex:j] CGPointValue], 
                                                [[roomWall objectAtIndex:j+1] CGPointValue], 
                                                1.0f);
            
            shape->e = 0.5; 
            shape->u = 0.1; 
            shape->collision_type = kCollisionTypePortal;
            
            cpSpaceAddStaticShape(spaceManager.space, shape);
        }
    }
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
    
	circle->e = elasticity;
	circle->u = friction;
	circle->collision_type = kCollisionTypeCircle;
    
    player.position = pos;
    
	player.shape = circle;
    
	circle->data = player;
}

-(void)setupBouncingBall
{
    [self addNewPlayerAt:CGPointMake(800.0f, 400.0f)];
}

-(void)setupChipmunkSpace
{
    spaceManager = [[SpaceManagerCocos2d alloc] init];
    spaceManager.constantDt = 0.01f;
    spaceManager.gravity = CGPointMake(0, -800);
    spaceManager.space->iterations = 8;
    
    [spaceManager addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
    [spaceManager start];
}

-(void) onExit
{
	[spaceManager stop];
}

// this controls how quickly the velocity decelerates (lower = quicker to change direction)
const float deceleration = 0.4f;
// this determines how sensitive the accelerometer reacts (higher = more sensitive)
const float sensitivity = 6.0f;
// how fast the velocity can be at most
const float maxVelocity = 10000.0f;
-(void) acceleratePlayerWithX:(double)xAcceleration
{
    xAcceleration *= 40.0f;
    
	// If the device is rotated upside down, we have to invert the accelerometer's X values.
	float invertHorizontalMovement = 1.0f;
	if ([CCDirector sharedDirector].deviceOrientation == kCCDeviceOrientationPortraitUpsideDown)
	{
		invertHorizontalMovement = -1.0f;
	}
	
	// adjust velocity based on current accelerometer acceleration
	player.body->v.x = player.body->v.x * deceleration + (xAcceleration * sensitivity * invertHorizontalMovement);
    
    // limit vel
    if (player.body->v.x > maxVelocity)
	{
		player.body->v.x = maxVelocity;
	}
	else if (player.body->v.x < -maxVelocity)
	{
		player.body->v.x = -maxVelocity;
	}
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	[self acceleratePlayerWithX:-acceleration.y];
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [player applyImpulse:cpv(0,300)];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        roomParser = [[RoomParser alloc] initWithXMLFile:@"test1.svg"];
        
        [self setupChipmunkSpace];
        [self setupCollisionHandlers];
        [self setupRoomWalls];
        [self setupPortals];
        
        [self setupBouncingBall];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    [spaceManager release];
	spaceManager = nil;
    
    [player release];
    player = nil;
    
    [roomParser release];
    
	[super dealloc];
}
@end