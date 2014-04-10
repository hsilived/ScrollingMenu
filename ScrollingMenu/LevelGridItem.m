//
//  MenuItem.m
//  MenuLevel
//
//  Created by DeviL on 1/22/2014.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelGridItem.h"

@implementation LevelGridItem

@synthesize bgImage, isLocked, textLabel, lockSprite;

- (id)initWithSize:(CGSize)size {
    
    self = [super initWithColor:[SKColor clearColor] size:size];
    
    if (self) {
        
        //self.anchorPoint = CGPointZero;
        //background image
        bgImage = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(kLevelIconSize, kLevelIconSize)];
        bgImage.anchorPoint = CGPointMake(0.5, 0.5);
        bgImage.position = CGPointMake(-(self.frame.size.width / 2) + self.size.width - kLevelIconSize / 2, -(self.frame.size.height / 2) + self.size.height - kLevelIconSize / 2);
        [self addChild:bgImage];
    }
    
    return self;
}


- (BOOL)isLocked {
    
    return self.lockSprite.hidden;
}

- (void)setIsLocked:(BOOL)locked {
    
    self.lockSprite.hidden = !locked;
}

- (void)setBackgroundImage:(NSString *)image {
    
    //background image
    [bgImage runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:image]]];// = [SKSpriteNode spriteNodeWithImageNamed:bgImage];
    //[self addChild:item.bgImage];
}

- (void)setLocked:(BOOL)locked {

    isLocked = locked;
    
    // lock image
    lockSprite = [SKSpriteNode spriteNodeWithImageNamed:kLevelLockFileName];
    lockSprite.hidden = !isLocked;
    textLabel.hidden = isLocked;
    [bgImage addChild:lockSprite];
}

- (void)setLevelText:(NSString *)text {
    
    textLabel = [SKLabelNode labelNodeWithFontNamed:kLevelFontName];
    textLabel.fontSize = kLevelFontSize;
    //textLabel.position = CGPointMake(-(bgImage.size.width / 2) + bgImage.size.width - kLevelIconSize / 2, -(bgImage.size.height / 2) + bgImage.size.height / 2);
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
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:c < life ? @"star" : @"star_low"];
        //star.anchorPoint = CGPointMake(0, 0);
        star.position = CGPointMake(-(self.frame.size.width / 2) + self.size.width / (kNumberOfStars + 1) * (c + 1), -(self.frame.size.height / 2) + star.frame.size.height / 2);
        [self addChild:star];
        [stars addObject:star];
    }
    
    self.starSprites = stars;
}

@end
