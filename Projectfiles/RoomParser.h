//
//  RoomParser.h
//  CaveBlast
//
//  Created by William Conroy on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@interface RoomParser : XMLParser {
    
    NSMutableArray * roomWalls;
    NSMutableArray * roomPortals;
}

@property (readonly) NSMutableArray * roomWalls;
@property (readonly) NSMutableArray * roomPortals;

@end
