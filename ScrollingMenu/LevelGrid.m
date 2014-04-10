//
//  MenuLevel.m
//  MenuLevel
//
//  Created by DeviL on 1/22/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelGrid.h"
#import "LevelButton.h"
#import "GameModel.h"

#pragma mark - MenuLevel private Interface

@interface LevelGrid() {
    
    GameModel *gameModel;
}

@property (nonatomic, readonly) CGSize gridSize;

@end

@implementation LevelGrid

@synthesize backgroundFileName, gridSize, size, levels;

- (LevelGrid *)initWithSize:(CGSize)aSize  {
    
    if (self = [super init]) {
        
        gameModel = [GameModel sharedManager];
        levels = gameModel.levels;
        
        int iconWidth, iconheight;
        
        iconWidth = 103.0f;
        iconheight = 120.0f;
        
        int gridPadding = 10;
        int gridRows = aSize.height;
        int gridCols = aSize.width;
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        gridSize = aSize;
        size = CGSizeMake(gridCols * (gridPadding + iconWidth) - gridPadding, gridRows * (gridPadding + iconheight) - gridPadding);
        
        // default values
        backgroundFileName = @"button"; // image for button level
        
        //self.anchorPoint = CGPointZero;
        int x = 0;
        
        for (int row = 0; row < gridRows; row++) {
            
            for (int col = 0; col < gridCols; col++) {
                
                NSDictionary *tempLevel = [levels valueForKey:[NSString stringWithFormat:@"Level %d", x + 1]];
                //int menuItem = (col + 1 + (row * gridCols));
                
                NSString *levelTitle = [tempLevel objectForKey:@"levelTitle"];
                int levelNumber = [[tempLevel objectForKey:@"levelNumber"] intValue];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *userLevelData = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:levelTitle]];
                
                NSInteger starsCollected = [[userLevelData objectForKey:@"highStarsCollected"] integerValue];
                
                BOOL levelLocked;
                if (x == 0)
                    levelLocked = NO;
                else
                    levelLocked = ![[userLevelData objectForKey:@"unlocked"] boolValue];
                
                [self createMenuItem:levelNumber position:CGPointMake(col * (iconWidth + (col == 0 ? 0 : gridPadding)) + (iconWidth / 2), (gridRows - row) * iconheight + ((gridRows - row - 1) * gridPadding) - (iconheight / 2)) life:starsCollected locked:levelLocked];
                
                x++;
            }
        }
    }
    
    return self;
}

- (LevelButton *)createMenuItem:(NSInteger)level position:(CGPoint)position life:(NSInteger)life locked:(BOOL)locked {
    
    // create button with background
    LevelButton *item = [[LevelButton alloc] initWithImageNamed:@"button"];
    // settings
    [self setMenuItem:item Level:level andImage:backgroundFileName position:position life:life locked:locked];
    
    return item;
}

#pragma mark MenuLevel Private Methods

- (void)setMenuItem:(LevelButton *)item Level:(NSInteger)level andImage:(NSString *)bgImage position:(CGPoint)position life:(NSInteger)life locked:(BOOL)locked {
    
    item.position = position;
    item.name = @"level";
    [self addChild:item];
    
    item.name = [NSString stringWithFormat:@"%d", level];
    
    [item setBackgroundImage:bgImage];
    
    [item setLevelText:[NSString stringWithFormat:@"%d", level]];
    
    [item setLocked:locked];
    
    [item setLevelStars:life];
}

@end
