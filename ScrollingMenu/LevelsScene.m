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
#import "World.h"

@interface LevelsScene() {
    
    GameModel *gameModel;
    LevelsScroller *levelsScroller;
    CGPoint initialPosition, initialTouch, initialParallaxBackPosition, initialParallaxMidPosition;
    int minimum_detect_distance;
    CGFloat moveAmtX, moveAmtY;
    SKLabelNode *pageLabel;
    SKSpriteNode *parallaxBackground, *parallaxMidground;
    LevelGrid *levelGrid;
}

@end

@implementation LevelsScene

@synthesize pagesCount, content, currentPage;

- (id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        gameModel = [GameModel sharedManager];
        content = [[NSMutableArray alloc] init];
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.currentPage = 1;
        //the minimum amount the user must scroll before the page gets flipped to the next or previous one
        minimum_detect_distance = 200;
        
        
        levelsScroller = [[LevelsScroller alloc] initWithSize:self.size];
        levelsScroller.scrollDirection = VERTICAL;
        [self addChild:levelsScroller];
        
        
        //add parallax backgrounds
        parallaxBackground = [self createParallaxBackground:@"bg"];
        [self addChild:parallaxBackground];
        
        parallaxMidground = [self createParallaxBackground:@"mg"];
        [self addChild:parallaxMidground];

    
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
    
    //go through each world and load the levels for that world
    for (NSDictionary *tempWorld in gameModel.worlds) {

        //create an istance of the world to pass into the levelGrid object
        World *world = [[World alloc] init];
        world.title = [tempWorld objectForKey:@"WorldTitle"];
        world.worldID = [[tempWorld objectForKey:@"WorldID"] intValue];

        levelGrid = [[LevelGrid alloc] initWithWorld:world];
        levelGrid.position = CGPointMake((self.size.width - levelGrid.size.width) / 2, (self.size.height - levelGrid.size.height) / 2);
        
        //create a container to hold the level grid and to put into the levelScroller
        SKSpriteNode *worldContent = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:self.size];
        worldContent.position = CGPointMake(-(self.size.width / 2), 0);
        worldContent.name = world.title;
        worldContent.anchorPoint = CGPointZero;
        
        [worldContent addChild:levelGrid];
        [content addObject:worldContent];   
    }
        
    pagesCount = (int)content.count;
    
    if (levelsScroller.scrollDirection == HORIZONTAL)
        levelsScroller.size = CGSizeMake(self.size.width * pagesCount, self.size.height);
    else
        levelsScroller.size = CGSizeMake(self.size.width, self.size.height * pagesCount);
    
    [self positionPages];
}

- (void)positionPages {
    
	for (int i = 0; i < pagesCount; i++) {
        
        SKSpriteNode *page = [content objectAtIndex:i];
        
        //load the levels grids in the scroller side by side
        if (levelsScroller.scrollDirection == HORIZONTAL)
            page.position = CGPointMake(-(page.size.width / 2) + self.size.width * i, -(page.size.height / 2));
        else
            page.position = CGPointMake(-(page.size.width / 2), -(page.size.height / 2) + self.size.height * i);
            
        [levelsScroller addChild:page];
	}
}

#pragma mark - move methods

- (void)swipeLeft {
    
    if (self.currentPage == pagesCount) {
        
        //they are on the last page and trying to go forwards so reset the page
        [self resetLevels];
        return;
    }

    //adjust the parallax backgrounds and levels scroll to the next or previous page based on their swipe direction
    [self xMoveActions:-(self.currentPage * self.size.width)];
    
    self.currentPage++;
}

- (void)swipeRight {
    
    if (self.currentPage == 1) {
        
        //they are on the first page and trying to go backwards so reset the page
        [self resetLevels];
        return;
    }
    
    self.currentPage--;
    
    //adjust the parallax backgrounds and levels scroll to the next or previous page based on their swipe direction
    [self xMoveActions:-((self.currentPage - 1) * self.size.width)];
}

- (void)swipeUp {
    
    if (self.currentPage == 1) {
        
        //they are on the first page and trying to go backwards so reset the page
        [self resetLevels];
        return;
    }
    
    self.currentPage--;
    
    //adjust the parallax backgrounds and levels scroll to the next or previous page based on their swipe direction
    [self yMoveActions:-((self.currentPage - 1) * self.size.height)];
}

- (void)swipeDown {
    
    if (self.currentPage == pagesCount) {
        
        //they are on the last page and trying to go forwards so reset the page
        [self resetLevels];
        return;
    }
    
    //adjust the parallax backgrounds and levels scroll to the next or previous page based on their swipe direction
    [self yMoveActions:-(self.currentPage * self.size.height)];
    
    self.currentPage++;
}

- (void)resetLevels {
    
    //just reset the levels scroller to the central position based on whatever the current page is
    if (levelsScroller.scrollDirection == HORIZONTAL)
        [self xMoveActions:-((self.currentPage - 1) * self.size.width)];
    else if (levelsScroller.scrollDirection == VERTICAL)
        [self yMoveActions:-((self.currentPage - 1) * self.size.height)];
}

- (void)xMoveActions:(int)moveTo {
    
    //this is the amount that we need to scroll the level scroller as well as the amount that we need to scroll the parallax background
    
    //parallax background moves the slowest so times the movement by a small number
    SKAction *move = [SKAction moveToX:(moveTo * 0.2) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxBackground runAction:move];
    
    //parallax midground moves faster so times the movement by a bigger number than the parallax background
    move = [SKAction moveToX:(moveTo * 0.3) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxMidground runAction:move];
    
    //duration must be the same for all 3 or it looks like the backgrounds are trying to play catch up
    move = [SKAction moveToX:moveTo duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move];
}

- (void)yMoveActions:(int)moveTo {
    
    //this is the amount that we need to scroll the level scroller as well as the amount that we need to scroll the parallax background
    
    //parallax background moves the slowest so times the movement by a small number
    SKAction *move = [SKAction moveToY:(moveTo * 0.2) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxBackground runAction:move];
    
    //parallax midground moves faster so times the movement by a bigger number than the parallax background
    move = [SKAction moveToY:(moveTo * 0.3) duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [parallaxMidground runAction:move];
    
    //duration must be the same for all 3 or it looks like the backgrounds are trying to play catch up
    move = [SKAction moveToY:moveTo duration:0.5];
    move.timingMode = SKActionTimingEaseIn;
    [levelsScroller runAction:move];
}

#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    initialTouch = [touch locationInView:self.view];
    moveAmtY = 0;
    moveAmtX = 0;
    
    NSLog(@"initialTouch %f", initialTouch.y);
    
    initialPosition = levelsScroller.position;
    initialParallaxBackPosition = parallaxBackground.position;
    initialParallaxMidPosition = parallaxMidground.position;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint movingPoint = [touch locationInView:self.view];
    
    moveAmtX = movingPoint.x - initialTouch.x;
    moveAmtY = movingPoint.y - initialTouch.y;

    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        //their finger is on the page and is moving around just move the scroller and parallax backgrounds around with them
        //Check if it needs to scroll to the next page when they release their finger
        levelsScroller.position = CGPointMake(initialPosition.x + moveAmtX, initialPosition.y);
        parallaxBackground.position = CGPointMake(initialParallaxBackPosition.x + moveAmtX * 0.2, initialParallaxBackPosition.y);
        parallaxMidground.position = CGPointMake(initialParallaxMidPosition.x + moveAmtX * 0.4, initialParallaxMidPosition.y);
    }
    else {
        
        //their finger is on the page and is moving around just move the scroller and parallax backgrounds around with them
        //Check if it needs to scroll to the next page when they release their finger
        levelsScroller.position = CGPointMake(initialPosition.x, initialPosition.y - moveAmtY);
        parallaxBackground.position = CGPointMake(initialParallaxBackPosition.x, initialParallaxBackPosition.y - moveAmtY * 0.2);
        parallaxMidground.position = CGPointMake(initialParallaxMidPosition.x, initialParallaxMidPosition.y - moveAmtY * 0.4);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (levelsScroller.scrollDirection == HORIZONTAL) {
        
        //they havent moved far enough so just reset the page to the original position
        if (abs(moveAmtX) < minimum_detect_distance)
            [self resetLevels];
        
        //the user has swiped past the designated distance, so assume that they want the page to scroll
        if (moveAmtX < -minimum_detect_distance)
            [self swipeLeft];
        else if (moveAmtX > minimum_detect_distance)
            [self swipeRight];
        
        //the scroller should never have a position higher than 0 so reset it
        if (levelsScroller.position.x > 0)
            [self resetLevels];
    }
    else {
        
        if (abs(moveAmtY) < minimum_detect_distance)
            [self resetLevels];
        
        //the user has swiped past the designated distance, so assume that they want the page to scroll
        if (moveAmtY < -(minimum_detect_distance))
            [self swipeUp];
        else if (moveAmtY > minimum_detect_distance)
            [self swipeDown];
        
        //the scroller should never have a position higher than 0 so reset it
        if (levelsScroller.position.y > 0)
            [self resetLevels];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    
    /* Called before each frame is rendered */
}

#pragma mark - Parallax methods

- (SKAction *)animationObject:(NSString *)object fromAtlas:(SKTextureAtlas *)atlas start:(int)start finish:(int)finish withFrameRate:(float)framesOverOneSecond {
    
    NSMutableArray *animFrames = [NSMutableArray array];
    
    for (int x = start; x <= finish; x++)
        [animFrames addObject:[atlas textureNamed:[NSString stringWithFormat:@"anim_%@_%d.png", object, x]]];
    
    if (framesOverOneSecond == 0)
        framesOverOneSecond = 1.0 / (float)animFrames.count;
    else
        framesOverOneSecond = framesOverOneSecond / (float)animFrames.count;
    
    return [SKAction animateWithTextures:animFrames timePerFrame:framesOverOneSecond resize:YES restore:YES];
}

- (SKSpriteNode *)createParallaxBackground:(NSString *)prefix {
    
    //we pass in a prefix for the images so that we can use this method to create multiple background layers
    //the parallax background images must have the numbering format of "bg0001, mg0001, etc." for this code to work.
    //you must manually set the number of images in your parallax background
    int numberOfBackgroundImages = 5;
    int backgroundPositionX = 0, backgroundPositionY = 0;
    int width = self.size.width, height = self.size.height;
    SKSpriteNode *subBackground;
    SKTexture *backgroundTexture;
    
    //take all of the images and paste them together into 1 big background image
    //set a dummy size for now, we will change it after we know how big the individual images are
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(width, height)];
    background.position = CGPointMake(0, 0);
    background.zPosition = -100;
    
    for (int x = 1; x <= numberOfBackgroundImages; x++) {
        
        backgroundTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@%04d", prefix, x]];
        
        //cycle through the images and place them accordingly into the larger background image
        //we are also keeping track of their size so that we can sdjust the size of the bacjground image afterwards
        //if we are scrolling vertically it is assumed the the width will be the width of the page and vice versa for horizontal
        if (x == 1) {
            
            if (levelsScroller.scrollDirection == VERTICAL) {
                
                backgroundPositionY = -(backgroundTexture.size.height / 2);
                height = backgroundTexture.size.height;
            }
            else {
                
                backgroundPositionX = -(backgroundTexture.size.width / 2);
                width = backgroundTexture.size.width;
            }
        }
        else {
            
            if (levelsScroller.scrollDirection == VERTICAL) {
                
                backgroundPositionY += backgroundTexture.size.height;
                height += backgroundTexture.size.height;
            }
            else {
                
                backgroundPositionX += backgroundTexture.size.width;
                width += backgroundTexture.size.width;
            }
        }
        
        //create the sprite and add it to the background sprite
        subBackground = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        subBackground.position = CGPointMake(backgroundPositionX, backgroundPositionY);
        [background addChild:subBackground];
    }
    
    background.size = CGSizeMake(width, height);
    
    //return the large background sprite only
    return background;
}

#pragma mark - Level methods

- (void)levelSelected:(NSInteger)level {
    
    NSDictionary *tempLevel = [gameModel.levels valueForKey:[NSString stringWithFormat:@"%02d", level]];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userLevelData = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:[tempLevel objectForKey:@"LevelTitle"]]];
    
    BOOL levelLocked = (level == 1 ? NO : ![[userLevelData objectForKey:@"unlocked"] boolValue]);
    
//    self.levelNumber = [[tempLevel objectForKey:@"levelNumber"] intValue];
//    self.levelType = [[tempLevel objectForKey:@"levelType"] intValue];
//    self.levelRows = [[tempLevel objectForKey:@"levelRows"] intValue];
//    self.levelCols = [[tempLevel objectForKey:@"levelCols"] intValue];
    
    [[[UIAlertView alloc] initWithTitle:@"WHHAAAAAAA" message:[NSString stringWithFormat:@"Hey You selected %@ it is %@", [tempLevel objectForKey:@"LevelTitle"], levelLocked ? @"locked" : @"unlocked"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
