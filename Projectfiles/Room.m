//
//  Room.m
//  CaveBlast
//
//  Created by William Conroy on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Room.h"


@implementation Room

@synthesize roomWalls;
@synthesize roomPortals;

- (void) dealloc
{
	[super dealloc];
    [roomWalls release];
}

- (id)init
{
    if( (self=[super init]) ) {
        
    }
    
    return self;
}

- (id)initWithArrayOfArrays:(NSArray *)walls
{
    if ((self = [super init])) 
    {
        roomWalls = [(NSArray *)[NSArray alloc] initWithArray:walls];
    }
    
    return self;
}
@end
