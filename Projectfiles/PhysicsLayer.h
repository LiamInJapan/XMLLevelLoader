/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"



@interface PhysicsLayer : CCLayer <SpaceManagerSerializeDelegate>
{
	SpaceManagerCocos2d* spaceManager;
    
    cpCCSprite * player;
    CGPoint playerVelocity;
    
    float currentKeyAcceleration;
}

+(CCScene *) scene;

@end
