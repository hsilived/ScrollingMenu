//
//  Level.m
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-10.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.

#import "Level.h"
#import "GameModel.h"

@interface Level () {
 
    GameModel *gameModel;
}

@end

@implementation Level

@synthesize levelTitle, levelID, worldID, levelType;

- (id)initWithLevelID:(NSInteger)_levelID {
    
    self = [super init];
    
    if (self) {
        
        gameModel = [GameModel sharedManager];
        
        levelTitle = [NSString stringWithFormat:@"Level %d", _levelID];
        
        NSDictionary *tempLevel = [gameModel.levels valueForKey:levelTitle];
        
        levelID = [[tempLevel objectForKey:@"levelID"] intValue];
        levelType = [[tempLevel objectForKey:@"levelType"] intValue];
        worldID = [[tempLevel objectForKey:@"LevelGroupNumber"] intValue];
        self.levelTargetScore = [tempLevel objectForKey:@"levelTargetScore"];
    }
    
    return self;
}

@end
