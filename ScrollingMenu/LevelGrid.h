//
//  MenuLevel.h
//  ScrollingMenu
//
//  Created by DeviL on 1/22/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "World.h"

@interface LevelGrid : SKSpriteNode

//@property (nonatomic, readonly) CGSize size;
@property (nonatomic, retain) NSString *backgroundFileName;
@property (nonatomic, retain) NSArray *levels;

- (instancetype)initWithWorld:(World *)world;

@end