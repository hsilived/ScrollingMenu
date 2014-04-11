//
//  LevelButton.m
//  match3
//
//  Created by DeviL on 1/24/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelButton.h"
#import <objc/message.h>
#import "LevelsScene.h"

@interface LevelButton() {
    
    int levelFontSize;
    BOOL selecting;
}

@property (nonatomic, readonly) LevelsScene *levelScene;
@property (nonatomic, strong) SKTexture *upTexture;
@property (nonatomic, strong) SKTexture *downTexture;
@property (nonatomic, strong) SKAction *buttonSound;

@end

@implementation LevelButton

@synthesize bgImage, isLocked, textLabel, lockSprite;

- (id)initWithImageNamed:(NSString *)image {
    
    self = [super initWithImageNamed:image];
    
    if (self) {
        
        levelFontSize = 32.0f;
        
        bgImage = [SKSpriteNode spriteNodeWithImageNamed:image];
        bgImage.anchorPoint = CGPointMake(0.5, 0.5);
        bgImage.position = CGPointMake(-(self.frame.size.width / 2) + self.size.width / 2, -(self.frame.size.height / 2) + self.size.height / 2);
        [self addChild:bgImage];
        
        self.buttonSound = [SKAction playSoundFileNamed:@"tap.caf" waitForCompletion:NO];
        
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

- (id)initWithSize:(CGSize)size {
    
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {

        bgImage = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        bgImage.anchorPoint = CGPointMake(0.5, 0.5);
        bgImage.position = CGPointMake(-(self.frame.size.width / 2) + self.size.width - kLevelIconSize / 2, -(self.frame.size.height / 2) + self.size.height - kLevelIconSize / 2);
        [self addChild:bgImage];
        
        self.buttonSound = [SKAction playSoundFileNamed:@"tap.caf" waitForCompletion:NO];
        
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

- (LevelsScene *)levelScene {
    
    return (LevelsScene *)self.scene;
}

- (BOOL)isLocked {
    
    return self.lockSprite.hidden;
}

- (void)setIsLocked:(BOOL)locked {
    
    self.lockSprite.hidden = !locked;
}

- (void)setBackgroundImage:(NSString *)image {
    
    //background image
    bgImage.texture = [SKTexture textureWithImageNamed:image];
}

- (void)setLocked:(BOOL)locked {
    
    isLocked = locked;
    
    // lock image
    lockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"lock"];
    lockSprite.hidden = !isLocked;
    textLabel.hidden = isLocked;
    [bgImage addChild:lockSprite];
}

- (void)setLevelText:(NSString *)text {
    
    textLabel = [SKLabelNode labelNodeWithFontNamed:kLevelFontName];
    textLabel.fontSize = levelFontSize;
    textLabel.position = CGPointMake(0, 10);
    textLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    textLabel.text = text;
    textLabel.color = kLevelFontColor;
    textLabel.hidden = isLocked;
    
    [bgImage addChild:textLabel];
}

- (void)setLevelStars:(NSInteger)life {
    
    NSMutableArray *stars = [[NSMutableArray alloc] init];
    
    for (int c = 0; c < kNumberOfStars; c++) {
        
        // star
        if (c < life) {
            
            SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"level_star"];
            //star.anchorPoint = CGPointMake(0, 0);
            //star.position = CGPointMake(-(self.frame.size.width / 2) + self.size.width / (kNumberOfStars + 1) * (c + 1), -0.2405 * self.frame.size.height);
            star.position = CGPointMake(0.2607 * self.frame.size.width * (c - 1), -0.2405 * self.frame.size.height);
            [self addChild:star];
            [stars addObject:star];
        }
    }
    
    self.starSprites = stars;
}


#pragma mark - Setting Target-Action pairs

- (void)setTouchDownTarget:(id)target action:(SEL)action {
    
    _targetTouchDown = target;
    _actionTouchDown = action;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    objc_msgSend(_targetTouchDown, _actionTouchDown);
    //[self setIsSelected:YES];
    [self.levelScene touchesBegan:touches withEvent:event];
    
    SKAction *squish = [SKAction scaleXTo:0.8 y:0.8 duration:0.1];
    [self runAction:squish];
    selecting = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    objc_msgSend(_targetTouchMoved, _actionTouchMoved);
    [self.levelScene touchesMoved:touches withEvent:event];
    
    SKAction *normal = [SKAction scaleXTo:1.0 y:1.0 duration:0.1];
    [self runAction:normal];
    selecting = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //objc_msgSend(_targetTouchMoved, _actionTouchMoved);
    [self.levelScene touchesEnded:touches withEvent:event];
    
    if (selecting) {
        
        [self runAction:[self selectLevel] completion:^{
            
            [self runAction:_buttonSound];
            
            int level = self.name.intValue;
            
            [self.levelScene levelSelected:level];
        }];
    }
}

- (SKAction *)selectLevel {
    
    self.zPosition = 1;
    
    SKAction *squish = [SKAction scaleXTo:1.2 y:0.8 duration:0.1];
    squish.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *moveDownSquish = [SKAction moveByX:0.0 y:10 duration:0.2];
    moveDownSquish.timingMode = SKActionTimingEaseInEaseOut;
    //SKAction *squishSound = [self squishSound];
    
    SKAction *grow = [SKAction scaleXTo:0.8 y:1.2 duration:0.2];
    grow.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *normal = [SKAction scaleXTo:1.0 y:1.0 duration:0.2];
    normal.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *moveUpNormal = [SKAction moveByX:0.0 y:-10 duration:0.2];
    moveUpNormal.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *groupSquish = [SKAction group:@[squish]];
    SKAction *groupGrow = [SKAction group:@[moveDownSquish, grow]];
    SKAction *groupNormal = [SKAction group:@[normal, moveUpNormal]];
    
    SKAction *sequence = [SKAction sequence:@[groupSquish, groupGrow, groupNormal]];
    
    self.zPosition = 0;

    return sequence;
}
@end
