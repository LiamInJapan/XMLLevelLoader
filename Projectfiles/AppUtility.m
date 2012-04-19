//
//  AppUtility.m
//  CaveBlast
//
//  Created by William Conroy on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppUtility.h"


@implementation AppUtility

+ (CGFloat) fetchWindowWidth
{
	return [[CCDirector sharedDirector] winSize].width;
	
}

+(BOOL)checkIfString:(NSString *)thisStr containsSubstring:(NSString *)str
{
    NSRange textRange;
    textRange =[thisStr rangeOfString:str];
    
    if(textRange.location != NSNotFound)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

+ (CGFloat) fetchWindowHeight
{
	return [[CCDirector sharedDirector] winSize].height;
    
}

+ (CGPoint) fetchWindowCenter
{
	return ccp([self fetchWindowWidth]/2, [self fetchWindowHeight]/2);
}

@end
