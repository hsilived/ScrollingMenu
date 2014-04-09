//
//  LevelsScroller.m
//  ScrollingMenu
//
//  Created by DeviL on 2014-04-08.
//  Copyright (c) 2014 Orange Think Box. All rights reserved.
//

#import "LevelsScroller.h"

@implementation LevelsScroller

- (LevelsScroller *)initWithSize:(CGSize)size {

    if (self = [super initWithColor:[SKColor clearColor] size:size]) {
        
        self.size = size;
        self.name = @"levelsScroller";
        
    }
    
    return self;
}

@end
