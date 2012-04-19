//
//  PrototypeMenu.m
//  SteelPanParadise
//
//  Created by William Conroy on 6/24/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "PrototypeMenu.h"
#import "PhysicsLayer.h"
#import "PolygonLayer.h"
#import "MultiRoomLayer.h"

// PrototypeMenu implementation
@implementation PrototypeMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PrototypeMenu *layer = [PrototypeMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)loadPrototypeOne:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[PhysicsLayer scene]];
}

- (void)loadPrototypeTwo:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[PolygonLayer scene]];
}

- (void)loadPrototypeThree:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[MultiRoomLayer scene]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        CCMenuItemFont * gotoPrototypeOne   = [CCMenuItemFont itemFromString:@"Basic Player Movement Prototype" target:self
                                                                    selector:@selector(loadPrototypeOne:)];
        
        CCMenuItemFont * gotoPrototypeTwo   = [CCMenuItemFont itemFromString:@"Polygon Spaces Prototype" target:self
                                                                    selector:@selector(loadPrototypeTwo:)];
        
        CCMenuItemFont * gotoPrototypeThree = [CCMenuItemFont itemFromString:@"Multi Room Prototype" target:self
                                                                    selector:@selector(loadPrototypeThree:)];
        
        CCMenu *menu = [CCMenu menuWithItems: gotoPrototypeOne, gotoPrototypeTwo, gotoPrototypeThree, nil];
        
        [self addChild:menu z:1];
        
        [menu alignItemsVerticallyWithPadding:20];
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
	[super dealloc];
}
@end