//
//  GameModel.m
//  Match3
//
//  Created by DeviL on 2012-11-27.
//  Copyright (c) 2012 Orange Think Box. All rights reserved.
//

#import "GameModel.h"

static GameModel *sharedManager;

@implementation GameModel

@synthesize levels;

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
    
    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    
    NSLog(@"!!!!! LOADING Levels !!!!! FROM - %@", bundle);
    
    levels = [NSMutableDictionary dictionaryWithContentsOfFile:bundle];
    //myKeys = [levels allKeys];
}
@end
