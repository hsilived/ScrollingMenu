//
//  MyScene.h
//  ScrollingMenu
//

//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LevelGrid.h"

@interface LevelsScene : SKScene

@property (nonatomic) int pagesCount;
@property (nonatomic, assign) int currentPage;
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSMutableArray *content;
@property (strong, nonatomic) NSMutableDictionary *levels;

- (void)levelSelected:(NSInteger)level;

@end
