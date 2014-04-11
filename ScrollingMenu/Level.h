//
//  Level.h
//
//  Created by DeviL on 2013-01-30.
//
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong) NSString *levelTitle;
@property (nonatomic) int levelID;
@property (nonatomic) int levelType;
@property (nonatomic) int worldID;
@property (nonatomic, strong) NSArray *levelTargetScore;

- (id)initWithLevelID:(NSInteger)levelID;

@end
