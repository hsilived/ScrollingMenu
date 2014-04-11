//
//  LevelButton.h
//  match3
//
//  Created by DeviL on 1/24/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LevelButton : SKSpriteNode

@property (nonatomic, retain) SKSpriteNode *lockSprite;
@property (nonatomic, retain) SKSpriteNode *bgImage;
@property (nonatomic, retain) SKLabelNode *textLabel;
@property (nonatomic, retain) NSArray *starSprites;
@property (nonatomic, assign) BOOL isLocked;

- (void)setBackgroundImage:(NSString *)image;
- (void)setLocked:(BOOL)locked;
- (void)setLevelText:(NSString *)text;
- (void)setLevelStars:(NSInteger)life;

@property (nonatomic, readonly) SEL actionTouchDown;
@property (nonatomic, readonly) SEL actionTouchMoved;
@property (nonatomic, readonly, weak) id targetTouchDown;
@property (nonatomic, readonly, weak) id targetTouchMoved;

- (id)initWithImageNamed:(NSString *)image;
- (id)initWithSize:(CGSize)size;

- (void)setTouchDownTarget:(id)target action:(SEL)action;

@end
