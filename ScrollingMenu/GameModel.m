//
//  GameModel.m
//  ScrollingMenu
//
//  Created by DeviL on 2012-11-27.
//  Copyright (c) 2012 Orange Think Box. All rights reserved.
//

#import "GameModel.h"

static GameModel *sharedManager;

@implementation GameModel

@synthesize levels, worlds;

+ (GameModel *)sharedManager {
    
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[GameModel alloc] init]; });
    
	return sharedManager;
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        self.squareSize = 110.0f;
        self.tileSize = 100.0f;
        
        [self loadLevels];
    }
    
    return self;
}

- (void)loadLevels {
    
    NSString *levelsPath = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    levels = [NSMutableDictionary dictionaryWithContentsOfFile:levelsPath];

    
    //sort the worlds plist by worldID
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"WorldID" ascending:YES];
    worlds = [[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Worlds" ofType:@"plist"]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
}
@end
