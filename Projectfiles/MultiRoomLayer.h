//
//  MultiRoomLayer.h
//  CaveBlast
//
//  Created by William Conroy on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoomParser.h"
#import "Room.h"


@interface MultiRoomLayer : CCLayer <SpaceManagerSerializeDelegate> 
{
    cpCCSprite * player;
    
    SpaceManagerCocos2d* spaceManager;
    
    RoomParser * roomParser;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
