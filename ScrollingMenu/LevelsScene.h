//
//  MyScene.h
//  ScrollingMenu
//

//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LevelsScene : SKScene

@property (nonatomic) int pagesCount;
@property (nonatomic, assign) int currentPage;
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSMutableArray *content;

@end
