//
//  MenuItem.h
//  MenuLevel
//
//  Created by DeviL on 1/22/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LevelGridItem : SKSpriteNode

@property (nonatomic, retain) SKSpriteNode *lockSprite;
@property (nonatomic, retain) SKSpriteNode *bgImage;
@property (nonatomic, retain) SKLabelNode *textLabel;
@property (nonatomic, retain) NSArray *starSprites;
@property (nonatomic, assign) BOOL isLocked;

- (id)initWithSize:(CGSize)size;

- (void)setBackgroundImage:(NSString *)image;
- (void)setLocked:(BOOL)locked;
- (void)setLevelText:(NSString *)text;
- (void)setLevelStars:(NSInteger)life;

@end
