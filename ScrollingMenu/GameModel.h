//
//  GameModel.h
//  Match3
//
//  Created by DeviL on 2012-11-27.
//  Copyright (c) 2012 Orange Think Box. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@interface GameModel : NSObject {
    
    UIViewController *parent;
}

@property (strong, nonatomic) NSMutableDictionary *levels;
@property (strong, nonatomic) NSArray *worlds;
@property (strong, nonatomic) NSArray *worldKeys;
@property (nonatomic) int tileSize;
@property (nonatomic) int squareSize;

+ (GameModel *)sharedManager;

- (void)loadLevels;

@end
