//
//  AppUtility.h
//  Cave Blast
//
//  Created by William Conroy on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface AppUtility : NSObject {
    
}

+ (CGPoint) fetchWindowCenter;

+(BOOL)checkIfString:(NSString *)thisStr containsSubstring:(NSString *)str;

@end