//
//  LevelsScroller.h
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-08.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    HORIZONTAL,
    VERTICAL
} ScrollDirection;

@interface LevelsScroller : SKSpriteNode

@property (nonatomic) CGSize contentSize;
@property (nonatomic) ScrollDirection scrollDirection;

- (LevelsScroller *)initWithSize:(CGSize)size;

@end
