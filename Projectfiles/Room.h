//
//  Room.h
//  CaveBlast
//
//  Created by William Conroy on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Room : NSObject {
    
    // array of array
    NSArray * roomWalls;
    NSArray * roomPortals;
}

@property (readonly) NSArray * roomWalls;
@property (readonly) NSArray * roomPortals;

- (id)initWithArrayOfArrays:(NSArray *)walls;

@end
