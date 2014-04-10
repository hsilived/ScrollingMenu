//
//  MyScene.m
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-08.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelsScene.h"
#import "LevelsScroller.h"
#import "GameModel.h"

@interface LevelsScene() {
    
    GameModel *gameModel;
    LevelsScroller *levelsScroller;
    CGPoint initialPosition, initialParallaxBackPosition, initialParallaxMidPosition;
    CGPoint initialTouch;
    int minimum_detect_distance;
    CGFloat moveAmtX;
    CGFloat moveAmtY;
    BOOL moved;
    SKLabelNode *pageLabel;
    SKSpriteNode *parallaxBackground;
    SKSpriteNode *parallaxMidground;
    LevelGrid *levelGrid;
    
}

@end

@implementation LevelsScene

@synthesize pagesCount, contentSize, content, currentPage;

- (id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        gameModel = [GameModel sharedManager];
        content = [[NSMutableArray alloc] init];
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        //add parallax backgrounds
        parallaxBackground = [self createParallaxBackground];
        [self addChild:parallaxBackground];
        
        parallaxMidground = [self createParallaxMidground];
        [self addChild:parallaxMidground];

        
        
        contentSize = CGSizeMake(500, 600);
        minimum_detect_distance = 200;
        
        self.currentPage = 1;
        
        levelsScroller = [[LevelsScroller alloc] initWithSize:self.size];
        levelsScroller.scrollDirection = VERTICAL;
        
        [self loadContent];
        
        
        //temporary label at bottom of screen to show which page we are on
        pageLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        pageLabel.position = CGPointMake(-(self.size.width / 2) + 20, -(self.size.height / 2) + 20);
        pageLabel.fontColor = [SKColor blackColor];
        pageLabel.zPosition = 50;
        pageLabel.text = @"1";
        [self addChild:pageLabel];
    }
    
    return self;
}

- (void)setCurrentPage:(int)_currentPage {
    
    currentPage = _currentPage;
    //changes the temporary label to show what the current page is
    pageLabel.text = [NSString stringWithFormat:@"%d", currentPage];
}

- (void)loadContent {
    
    [self addChild:levelsScroller];
    
    if (levelsScroller.scrollDirection == HORIZONTAL)
        levelsScroller.size = CGSizeMake(self.size.width * pagesCount, self.size.height);
    else
        levelsScroller.size = CGSizeMake(self.size.width, self.size.height * pagesCount);
    
    SKSpriteNode *content1 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content1.position = CGPointMake(-(self.size.width / 2), 0);
    content1.name = @"page1";
    SKSpriteNode *content2 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content2.name = @"page2";
    SKSpriteNode *content3 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content3.name = @"page3";
    SKSpriteNode *content4 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content4.name = @"page4";
    SKSpriteNode *content5 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content5.name = @"page5";
    SKSpriteNode *content6 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content6.name = @"page6";
    SKSpriteNode *content7 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content7.name = @"page7";
    SKSpriteNode *content8 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content8.name = @"page8";
    SKSpriteNode *content9 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:contentSize];
    content8.name = @"page9";
    
    [content addObject:content1];
    [content addObject:content2];
    [content addObject:content3];
    [content addObject:content4];
    [content addObject:content5];
    [content addObject:content6];
    [content addObject:content7];
    [content addObject:content8];
    [content addObject:content9];
    
    pagesCount = (int)content.count;
    
    for (SKSpriteNode *page in content)
        [self loadPageContent:page];
    
    [self positionPages];
}

- (void)loadPageContent:(SKSpriteNode *)page {
    
    page.anchorPoint = CGPointZero;
    
    levelGrid = [[LevelGrid alloc] initWithSize:CGSizeMake(4, 5)];
    //levelGrid.position = CGPointMake((self.size.width - levelGrid.size.width) / 2, (self.size.height - levelGrid.size.height) / 2);
    [page addChild:levelGrid];
}

- (void)positionPages {
    
	for (int i = 0; i < pagesCount; i++) {
        
        SKSpriteNode *page = [content objectAtIndex:i];
        
        if (levelsScroller.scrollDirection == HORIZONTAL)
            page.position = CGPointMake(self.size.width * i, 0);
        else
            page.position = CGPointMake(-(page.size.width / 2), -(page.size.height / 2) + self.size.height * i);
            
        [levelsScroller addChild:page];
	}
}

#pragma mark - move methods

- (void)swipeLeft {
    
    if (self.currentPage == pagesCount) {
        
        [self resetLevels];
        return;
    }

    [self moveActions:-(self.currentPage * self.size.width)];
    
    self.currentPage++;
}

- (void)swipeRight {
    
    if (self.currentPage == 1) {
        
        [self resetLevels];
        return;
    }
    
    self.currentPage--;
    
    [self moveActions:-((self.currentPage - 1) * self.size.width)];
}

- (void)swipeUp {
    
    if (self.currentPage == 1) {
        
        [self resetLevels];
        return;
    }
    
    self.currentPage--;
    
    [self moveActions:-((self.currentPage - 1) * self.size.height)];
}

- (void)swipeDown {
    
    if (self.currentPage == pagesCount) {
        
        [self resetLevels];
        return;
    }
    
    [self moveActions:-(self.currentPage * self.size.height)];
    
    self.currentPage++;
}

- (void)moveActions:(int)moveTo {
    
    //this is the amount that we need to scroll the level scroller as well as the amount that we need to scroll the parallax background
    SKAction *move = [SKAction moveToY:(moveTo * 0.2) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxBackground runAction:move];
    
    move = [SKAction moveToY:(moveTo * 0.3) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxMidground runAction:move];
    
    move = [SKAction moveToY:moveTo duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move];
}

#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    initialTouch = [touch locationInView:self.view];
    initialPosition = levelsScroller.position;
    initialParallaxBackPosition = parallaxBackground.position;
    initialParallaxMidPosition = parallaxMidground.position;
    moveAmtX = 0;
    moved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint movingPoint = [touch locationInView:self.view];
    
    moveAmtX = movingPoint.x - initialTouch.x;
    moveAmtY = movingPoint.y - initialTouch.y;

    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        levelsScroller.position = CGPointMake(initialPosition.x + moveAmtX, initialPosition.y);
        parallaxBackground.position = CGPointMake(initialParallaxBackPosition.x + moveAmtX * 0.2, initialParallaxBackPosition.y);
        parallaxMidground.position = CGPointMake(initialParallaxMidPosition.x + moveAmtX * 0.4, initialParallaxMidPosition.y);
    }
    else {
        
        levelsScroller.position = CGPointMake(initialPosition.x, initialPosition.y - moveAmtY);
        parallaxBackground.position = CGPointMake(initialParallaxBackPosition.x, initialParallaxBackPosition.y - moveAmtY * 0.2);
        parallaxMidground.position = CGPointMake(initialParallaxMidPosition.x, initialParallaxMidPosition.y - moveAmtY * 0.4);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        if ((abs(moveAmtX) < minimum_detect_distance) || (abs(moveAmtX) && !moved))
            [self resetLevels];
        
        if (!moved && moveAmtX < -(minimum_detect_distance)) {
            
            moved = YES;
            [self swipeLeft];
        }
        else if (!moved && moveAmtX > minimum_detect_distance) {
            
            moved = YES;
            [self swipeRight];
        }
        
        if (levelsScroller.position.x > 0)
            [self resetLevels];
        else if (abs(levelsScroller.position.x) > (self.size.width * (pagesCount - 1)))
            [self resetLevels];
    }
    else {
        
        if ((abs(moveAmtY) < minimum_detect_distance) || (abs(moveAmtY) && !moved))
            [self resetLevels];
        
        if (!moved && moveAmtY < -(minimum_detect_distance)) {
            
            moved = YES;
            [self swipeUp];
        }
        else if (!moved && moveAmtY > minimum_detect_distance) {
            
            moved = YES;
            [self swipeDown];
        }
        
        if (levelsScroller.position.y > 0)
            [self resetLevels];
        else if (abs(levelsScroller.position.y) > (self.size.height * (pagesCount - 1)))
            [self resetLevels];
    }
    
    moved = NO;
}

- (void)resetLevels {
    
    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        int moveTo = -((self.currentPage - 1) * self.size.width);
        
        SKAction *move = [SKAction moveToX:moveTo duration:0.1];
        move.timingMode = SKActionTimingEaseIn;
        [levelsScroller runAction:move];
    }
    else if (levelsScroller.scrollDirection == VERTICAL) {
        
        int moveTo = -((self.currentPage - 1) * self.size.height);
        
        SKAction *move = [SKAction moveToY:(moveTo * 0.2) duration:0.1];
        move.timingMode = SKActionTimingEaseIn;
        [parallaxBackground runAction:move];
        
        move = [SKAction moveToY:(moveTo * 0.3) duration:0.5];
        move.timingMode = SKActionTimingEaseIn;
        [parallaxMidground runAction:move];
        
        move = [SKAction moveToY:moveTo duration:0.1];
        move.timingMode = SKActionTimingEaseIn;
        [levelsScroller runAction:move];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    /* Called before each frame is rendered */
}

- (void)levelSelected:(NSInteger)level {
    

}


#pragma mark - Parallax methods

- (SKSpriteNode *)createParallaxBackground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(768, 3070)];
    background.position = CGPointMake(0, 0);
    background.zPosition = -100;
    
    SKSpriteNode *background1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg0001"];
    background1.position = CGPointMake(0, -307);
    [background addChild:background1];
    
    SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg0002"];
    background2.position = CGPointMake(0, 307);
    [background addChild:background2];
    
    SKSpriteNode *background3 = [SKSpriteNode spriteNodeWithImageNamed:@"bg0003"];
    background3.position = CGPointMake(0, 921);
    [background addChild:background3];
    
    SKSpriteNode *background4 = [SKSpriteNode spriteNodeWithImageNamed:@"bg0004"];
    background4.position = CGPointMake(0, 1535);
    [background addChild:background4];
    
    SKSpriteNode *background5 = [SKSpriteNode spriteNodeWithImageNamed:@"bg0005"];
    background5.position = CGPointMake(0, 2149);
    [background addChild:background5];
    
    return background;
}

- (SKSpriteNode *)createParallaxMidground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(768, 3684)];
    background.position = CGPointMake(0, 0);
    background.zPosition = -99;
    
    SKSpriteNode *background1 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0001"];
    background1.position = CGPointMake(0, -307);
    [background addChild:background1];
    
    SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0002"];
    background2.position = CGPointMake(0, 307);
    [background addChild:background2];
    
    SKSpriteNode *background3 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0004"];
    background3.position = CGPointMake(0, 921);
    [background addChild:background3];
    
    SKSpriteNode *background4 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0004"];
    background4.position = CGPointMake(0, 1535);
    [background addChild:background4];
    
    SKSpriteNode *background5 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0005"];
    background5.position = CGPointMake(0, 2149);
    [background addChild:background5];
    
    SKSpriteNode *background6 = [SKSpriteNode spriteNodeWithImageNamed:@"mg0004"];
    background6.position = CGPointMake(0, 2763);
    [background addChild:background6];
    
    return background;
}


@end
