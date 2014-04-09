//
//  MyScene.m
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-08.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelsScene.h"
#import "LevelsScroller.h"

@interface LevelsScene() {
    
    LevelsScroller *levelsScroller;
    CGPoint initialPosition, initialParallaxPosition;
    CGPoint initialTouch;
    int minimum_detect_distance;
    CGFloat moveAmtX;
    CGFloat moveAmtY;
    BOOL moved;
    SKLabelNode *pageLabel;
    SKSpriteNode *parallaxBackground;
    SKSpriteNode *parallaxMidground;
    
}

//@property (nonatomic, strong) PBParallaxScrolling * parallaxBackground;

@end

@implementation LevelsScene

@synthesize pagesCount, contentSize, content, currentPage;

- (id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        //add background
//        SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:@"bg_menu2"];
//        menu.size = self.size;
//        //menu.scale = [gameModel convertScale:1];
//        menu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//        menu.zPosition = 0;
//        [self addChild:menu];
        
        parallaxBackground = [self createParallaxBackground];
        parallaxMidground = [self createParallaxMidground];
        
        [self addChild:parallaxBackground];
        
//        NSArray * imageNames = @[@"pForeground", @"pMiddle", @"pBackground"];
//        PBParallaxScrolling * parallax = [[PBParallaxScrolling alloc] initWithBackgrounds:imageNames size:self.size direction:kPBParallaxBackgroundDirectionLeft fastestSpeed:kPBParallaxBackgroundDefaultSpeed andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
//        self.parallaxBackground = parallax;
//        self.parallaxBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//        [self addChild:parallax];
        
        pagesCount = 8;
        contentSize = CGSizeMake(500, 600);
        minimum_detect_distance = 200;
        
        content = [[NSMutableArray alloc] init];
        self.currentPage = 1;
        
        pageLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        pageLabel.position = CGPointMake(-(self.size.width / 2) + 20, -(self.size.height / 2) + 20);
        pageLabel.fontColor = [SKColor blackColor];
        pageLabel.zPosition = 50;
        pageLabel.text = @"1";
        [self addChild:pageLabel];
        
        [self loadContent];
    }
    return self;
}

- (SKSpriteNode *)createParallaxBackground {

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(768, 3070)];
    background.position = CGPointMake(0, 0);
    //parallaxBackground.anchorPoint = CGPointZero;
    background.zPosition = -100;
    
    SKSpriteNode *background1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0001"];
    background1.position = CGPointMake(0, -307);
    [background addChild:background1];
    
    SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0002"];
    background2.position = CGPointMake(0, 307);
    [background addChild:background2];
    
    SKSpriteNode *background3 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0003"];
    background3.position = CGPointMake(0, 921);
    [background addChild:background3];
    
    SKSpriteNode *background4 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0004"];
    background4.position = CGPointMake(0, 1535);
    [background addChild:background4];
    
    SKSpriteNode *background5 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0005"];
    background5.position = CGPointMake(0, 2149);
    [background addChild:background5];
    
    return background;
}

- (SKSpriteNode *)createParallaxMidground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(768, 3070)];
    background.position = CGPointMake(0, 0);
    //parallaxBackground.anchorPoint = CGPointZero;
    background.zPosition = -100;
    
    SKSpriteNode *background1 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0001"];
    background1.position = CGPointMake(0, -307);
    [background addChild:background1];
    
    SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0002"];
    background2.position = CGPointMake(0, 307);
    [background addChild:background2];
    
    SKSpriteNode *background3 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0003"];
    background3.position = CGPointMake(0, 921);
    [background addChild:background3];
    
    SKSpriteNode *background4 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0004"];
    background4.position = CGPointMake(0, 1535);
    [background addChild:background4];
    
    SKSpriteNode *background5 = [SKSpriteNode spriteNodeWithImageNamed:@"bg_0005"];
    background5.position = CGPointMake(0, 2149);
    [background addChild:background5];
    
    return background;
}

- (void)setCurrentPage:(int)_currentPage {
    
    currentPage = _currentPage;
    pageLabel.text = [NSString stringWithFormat:@"%d", currentPage];
}

- (void)didMoveToView:(SKView *)view {
    
//    UISwipeGestureRecognizer* swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
//    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipeLeftRecognizer];
//    
//    UISwipeGestureRecognizer* swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
//    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRightRecognizer];
//    
//    UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
//    [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//    [self.view addGestureRecognizer:swipeUpRecognizer];
//    
//    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
//    [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
//    [self.view addGestureRecognizer:swipeDownRecognizer];
}

- (void)loadContent {
    
    levelsScroller = [[LevelsScroller alloc] initWithSize:self.size];
    
    //levelsScroller.color = [SKColor whiteColor];
    levelsScroller.scrollDirection = VERTICAL;
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
    
    [content addObject:content1];
    [content addObject:content2];
    [content addObject:content3];
    [content addObject:content4];
    [content addObject:content5];
    [content addObject:content6];
    [content addObject:content7];
    [content addObject:content8];
    
    for (SKSpriteNode *page in content) {
        
        [self loadPageContent:page];
    }
    
    [self setPagesInArray];
}

- (void)loadPageContent:(SKSpriteNode *)page {
    
    page.anchorPoint = CGPointZero;
    
    for (int row = 0; row < 4; row++) {
        
        for (int col = 0; col < 4; col++) {
            
            CGFloat xPosition = col * 100 + (100 / 2) + (10 * col) + 10;
            CGFloat yPosition = row * 100 + (100 / 2) + (10 * row) + 10;
            SKSpriteNode *contentIcon = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(100, 100)];
            contentIcon.position = CGPointMake(xPosition, yPosition);
            [page addChild:contentIcon];
        }
    }
    
}

- (void)setPagesInArray {
    
	for (int i = 0; i < pagesCount; i++) {
        
        SKSpriteNode *page = [content objectAtIndex:i];
        
        if (levelsScroller.scrollDirection == HORIZONTAL)
            page.position = CGPointMake(self.size.width * i, 0);
        else
            page.position = CGPointMake(-(page.size.width / 2), -(page.size.height / 2) + self.size.height * i);
            
        [levelsScroller addChild:page];
	}
}

- (void)swipeLeft {
    
    if (levelsScroller.scrollDirection == VERTICAL)
        return;
    
    if (self.currentPage == pagesCount) {
        
        [self reset];
        return;
    }
    
    int moveTo = -(self.currentPage * self.size.width);
    
    SKAction *move = [SKAction moveToX:moveTo duration:0.4];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move];
    
    self.currentPage++;
}

- (void)swipeRight {
    
    if (levelsScroller.scrollDirection == VERTICAL)
        return;
    
    if (self.currentPage == 1) {
        
        [self reset];
        return;
    }
    
    self.currentPage--;
    
    int moveTo = -((self.currentPage - 1) * self.size.width);
    
    SKAction *move = [SKAction moveToX:moveTo duration:0.4];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move]; 
}

- (void)swipeUp {
    
    if (levelsScroller.scrollDirection == HORIZONTAL)
        return;
    
    if (self.currentPage == 1) {
        
        [self reset];
        return;
    }
    
    self.currentPage--;
    
    int moveTo = -((self.currentPage - 1) * self.size.height);
    
    SKAction *move = [SKAction moveToY:(moveTo * 0.2) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxBackground runAction:move];
    
    move = [SKAction moveToY:moveTo duration:0.5];
    move.timingMode = SKActionTimingEaseInEaseOut;
    [levelsScroller runAction:move];
}

- (void)swipeDown {
    
    if (levelsScroller.scrollDirection == HORIZONTAL)
        return;
    
    if (self.currentPage == pagesCount) {
        
        [self reset];
        return;
    }
    
    int moveTo = -(self.currentPage * self.size.height);
    
    SKAction *move = [SKAction moveToY:(moveTo * 0.2) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxBackground runAction:move];
    
    
    move = [SKAction moveToY:moveTo duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move];
    
    self.currentPage++;
}

- (void)reset {
   
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
        
        move = [SKAction moveToY:moveTo duration:0.1];
        move.timingMode = SKActionTimingEaseIn;
        [levelsScroller runAction:move];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"minimum_detect_distance %d", minimum_detect_distance);
    
    UITouch *touch = [touches anyObject];
    initialTouch = [touch locationInView:self.view];
    initialPosition = levelsScroller.position;
    initialParallaxPosition = parallaxBackground.position;
    moveAmtX = 0;
    moved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint movingPoint = [touch locationInView:self.view];
    
    moveAmtX = movingPoint.x - initialTouch.x;
    moveAmtY = movingPoint.y - initialTouch.y;

    NSLog(@"movingPoint.x %f", movingPoint.x);
    NSLog(@"movingPoint.y %f", movingPoint.y);
    NSLog(@"moveAmtX %f", moveAmtX);
    NSLog(@"moveAmtY %f", moveAmtY);
    
    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        if (!moved && moveAmtX < -(minimum_detect_distance)) {
            
            moved = YES;
            [self swipeLeft];
        }
        else if (!moved && moveAmtX > minimum_detect_distance) {
            
            moved = YES;
            [self swipeRight];
        }
        else {

            levelsScroller.position = CGPointMake(initialPosition.x + moveAmtX, initialPosition.y);
            parallaxBackground.position = CGPointMake(initialParallaxPosition.x + (moveAmtX * 0.606), initialParallaxPosition.y);
        }
    }
    else {
        
        if (!moved && moveAmtY < -(minimum_detect_distance)) {
            
            moved = YES;
            [self swipeUp];
        }
        else if (!moved && moveAmtY > minimum_detect_distance) {
            
            moved = YES;
            [self swipeDown];
        }
        else {
            
            levelsScroller.position = CGPointMake(initialPosition.x, initialPosition.y - moveAmtY);
            parallaxBackground.position = CGPointMake(initialParallaxPosition.x, initialParallaxPosition.y - (moveAmtY * 0.2));
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        if ((abs(moveAmtX) < minimum_detect_distance) || (abs(moveAmtX) && !moved))
            [self reset];
        
        if (levelsScroller.position.x > 0)
            [self reset];
        else if (abs(levelsScroller.position.x) > (self.size.width * (pagesCount - 1)))
            [self reset];
    }
    else {
        
        if ((abs(moveAmtY) < minimum_detect_distance) || (abs(moveAmtY) && !moved))
            [self reset];
        
        if (levelsScroller.position.y > 0)
            [self reset];
        else if (abs(levelsScroller.position.y) > (self.size.height * (pagesCount - 1)))
            [self reset];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    /* Called before each frame is rendered */
    //[self.parallaxBackground update:currentTime];
}

@end
