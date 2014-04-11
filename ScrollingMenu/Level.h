//
//  Level.h
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-10.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong) NSString *levelTitle;
@property (nonatomic) int levelID;
@property (nonatomic) int levelType;
@property (nonatomic) int worldID;
@property (nonatomic, strong) NSArray *levelTargetScore;

- (id)initWithLevelID:(NSInteger)levelID;

@end
