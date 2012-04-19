//
//  XMLParser.m
//  SteelPanParadise
//
//  Created by William Conroy on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

@synthesize myXMLParser;



-(void)loadXMLAndStartParser:(NSString *)xml
{   
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *xmlFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:xml];
    
    if([xmlFilePath length] == 0)
    {
        NSLog(@"Could not find %@", xml);
    }
    
    if([fileManager fileExistsAtPath:xmlFilePath] == NO)
    {
        NSLog(@"File doesn't exist");
        [fileManager release];
    }
    else
    {
        [fileManager release];    
    }
    
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    self.myXMLParser = xmlParser;
    [xmlParser release];
    
    [self.myXMLParser setDelegate:self];
    
    if([self.myXMLParser parse] == YES)
    {
        NSLog(@"Parsing of %@ started correctly", xml);
    }
    else
    {
        NSError *parsingError = [self.myXMLParser parserError];
        NSLog(@"%@", parsingError);
    }
}

- (void) dealloc
{
    [myXMLParser release];
    
	[super dealloc];
}

- (id)initWithXMLFile:(NSString *)xml
{
    if ((self = [super init])) 
    {
        [self loadXMLAndStartParser:xml];
        
    }
    return self;
}

@end
