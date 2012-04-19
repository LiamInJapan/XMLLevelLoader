//
//  PolygonLayer.m
//  SteelPanParadise
//
//  Created by William Conroy on 6/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "PolygonLayer.h"
#import "PhysicsLayer.h"
#import "AppUtility.h"

enum 
{
	kCollisionTypeCircle,
};

// PolygonLayer implementation
@implementation PolygonLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PolygonLayer *layer = [PolygonLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// looks expensive - consider extracting out into polys on init
-(void) draw
{
    for(int i = 0; i < (int)[[aRoom roomWalls] count]; i++)
    {
        NSArray * roomWall = [[aRoom roomWalls] objectAtIndex:i];
        NSUInteger numWallSecs = (NSUInteger)[roomWall count];
        
        CGPoint poly[numWallSecs];
        
        for(NSUInteger j = 0; j < numWallSecs; j++)
        {
            poly[j] = [[roomWall objectAtIndex:j] CGPointValue];
        }
        
        ccDrawPoly(poly, numWallSecs, NO);
    }
}

-(void)setupPolys
{
    cpBody *polyBody = cpBodyNew(INFINITY, INFINITY); 
    
    for(int i = 0; i < (int)[aRoom.roomWalls count]; i++)
    {
        NSArray * roomWall = [[aRoom roomWalls] objectAtIndex:i];
        
        for(int j = 0; j < (int)[roomWall count] -1; j++)
        {
            cpShape * shape = cpSegmentShapeNew(polyBody, 
                                                [[roomWall objectAtIndex:j] CGPointValue], 
                                                [[roomWall objectAtIndex:j+1] CGPointValue], 
                                                1.0f);
                                             
            shape->e = 0.5; 
            shape->u = 0.1; 
            shape->collision_type = 0;
        
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


-(void)addRoom:(NSNotification *)notification
{
    aRoom = [[Room alloc] initWithArrayOfArrays:[[notification userInfo] valueForKey:@"roomWalls"]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addRoom:) 
                                                     name:@"addRoom"
                                                   object:nil];
        
        roomParser = [[RoomParser alloc] initWithXMLFile:@"test.svg"];
        
        [self setupChipmunkSpace];
        [self setupPolys];
        
        [self setupBouncingBall];
	}
	return self;
}

-(void) onExit
{
	[spaceManager stop];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [aRoom release];
    [roomParser release];
    
	[super dealloc];
}
@end