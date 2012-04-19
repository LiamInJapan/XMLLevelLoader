//
//  RoomParser.m
//  CaveBlast
//
//  Created by William Conroy on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoomParser.h"
#import "AppUtility.h"

@implementation RoomParser

@synthesize roomWalls;
@synthesize roomPortals;

- (NSArray *)parsePathToPoints:(NSString *)path
{
    NSMutableArray  * ret = [NSMutableArray array];
    
    NSString * points1 = [NSString stringWithString:path];
    
    // strip unneccesary characters out
    NSString * points2 = [points1 stringByReplacingOccurrencesOfString:@"M " withString:@""];
    NSString * points3 = [points2 stringByReplacingOccurrencesOfString:@" z" withString:@""];
    
    // set up string splitters
    NSCharacterSet *spaceSplit = [NSCharacterSet characterSetWithCharactersInString:@" "];
    NSCharacterSet *commaSplit = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSCharacterSet *dotSplit = [NSCharacterSet characterSetWithCharactersInString:@"."];
    
    // split out with spaces
    NSArray *splitStrings = [points3 componentsSeparatedByCharactersInSet:spaceSplit];
    
    // loop through all string parts
    for(int i = 0; i < (int)splitStrings.count; i++)
    {
        // and process into coords and store in array
        CGPoint tmp;
        
        tmp.x = [[[[[[splitStrings objectAtIndex:i] 
                     componentsSeparatedByCharactersInSet:commaSplit] 
                    objectAtIndex:0] componentsSeparatedByCharactersInSet:dotSplit] objectAtIndex:0] floatValue];
        
        tmp.y = [[[[[[splitStrings objectAtIndex:i] 
                     componentsSeparatedByCharactersInSet:commaSplit] 
                    objectAtIndex:1] componentsSeparatedByCharactersInSet:dotSplit] objectAtIndex:0] floatValue];
        
        // reverse y coord
        tmp.y = 768-tmp.y;
        
        [ret addObject:[NSValue valueWithCGPoint:tmp]];
    }
    
    // close the poly - TODO - this is unneccesary for portals so think about how to deal with this (shouldn't break...)
    [ret addObject:[ret objectAtIndex:0]];

    // TODO test out if this retain is neccesary at a later point...
    return [ret retain];
}

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    roomWalls   = [[NSMutableArray alloc] init];
    roomPortals = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}



- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"path"])
    {
        if([AppUtility checkIfString:[attributeDict objectForKey:@"id"] containsSubstring:@"portal"])
        {
            NSLog(@"FOUND A PORTAL");
            [roomPortals addObject:[self parsePathToPoints:[attributeDict objectForKey:@"d"]]];
        }
        else if([AppUtility checkIfString:[attributeDict objectForKey:@"id"] containsSubstring:@"room"])
        {
            [roomWalls addObject:[self parsePathToPoints:[attributeDict objectForKey:@"d"]]];
        }
    }
}

- (void) dealloc
{
	[super dealloc];
    
    [roomWalls release];
    [roomPortals release];
}

- (id)initWithXMLFile:(NSString *)xml
{
    if ((self = [super initWithXMLFile:xml])) 
    {
        
    }
    return self;
}

@end
