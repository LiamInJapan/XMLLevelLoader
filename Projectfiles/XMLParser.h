//
//  XMLParser.h
//  SteelPanParadise
//
//  Created by William Conroy on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLParser : NSObject <NSXMLParserDelegate> {
    
    NSXMLParser *myXMLParser;
    
}

- (id)initWithXMLFile:(NSString *)xml;

@property (nonatomic, retain) NSXMLParser *myXMLParser;

@end
