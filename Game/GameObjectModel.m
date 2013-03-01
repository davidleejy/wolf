//
//  GameObjectModel.m
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PigView.h"
#import "BlockView.h"
#import "WolfView.h"

#import "GameObjectModel.h"

@implementation GameObjectModel
// OVERVIEW: This class implements a game object model
//           There are subclasses under this class to represent the various game objects.

@synthesize wolfV = _wolfV;
@synthesize wolfLocation = _wolfLocation;
@synthesize pigV = _pigV;
@synthesize pigLocation = _pigLocation;
@synthesize blocksVArray = _blocksVArray;


-(void) encodeWithCoder: (NSCoder*)coder
{
    // Save wolf data
    [coder encodeObject:_wolfV forKey:@"wolf_view_data_part1"];
    
    NSNumber *wolfLocationBox = [NSNumber numberWithInt:_wolfLocation];
    [coder encodeObject:wolfLocationBox forKey:@"wolf_view_data_part2"];
    
     // Save pig data
    [coder encodeObject:_pigV forKey:@"pig_view_data_part1"];
    
    NSNumber *pigLocationBox = [NSNumber numberWithInt:_pigLocation];
    [coder encodeObject:pigLocationBox forKey:@"pig_view_data_part2"];
    
     // Save blocks data
    NSData* blockObjectData = [NSKeyedArchiver archivedDataWithRootObject:_blocksVArray];
    [[NSUserDefaults standardUserDefaults] setObject:blockObjectData forKey:@"block_view_data"];
    
}

-(id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (!self) return nil;
    
    [self makeCleanAllData];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    
    // Retrieve block view data (from an array)
    NSData* blockObjectData = [currentDefaults objectForKey:@"block_view_data"];
    
    if (blockObjectData == nil) return nil;
    
    NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:blockObjectData];
    
//    NSLog(@"oldSavedArray[0] has mat %d",((BlockView*)[oldSavedArray objectAtIndex:0]).currentMaterial);
    
    if (oldSavedArray != nil)
        _blocksVArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
    else
        _blocksVArray = [[NSMutableArray alloc] init];
    
    
    //Retrieve pig view data
    _pigV = [coder decodeObjectForKey:@"pig_view_data_part1"];
    NSNumber* pigLocBox = [coder decodeObjectForKey:@"pig_view_data_part2"];
    _pigLocation = (int)[pigLocBox integerValue];
    
    
    //Retrieve wolf view data
    _wolfV = [coder decodeObjectForKey:@"wolf_view_data_part1"];
    NSNumber* wolfLocBox = [coder decodeObjectForKey:@"wolf_view_data_part2"];
    _wolfLocation = (int)[wolfLocBox integerValue];
    
    
    return self;
}


- (id) init {
    // EFFECTS: Constructor.
    
    self = [super init];
    
    if (!self) return nil;
    
    [self makeCleanAllData];
    
    return self;
}


- (void) makeCleanAllData {
    // MODIFIES: Location and NSMutableArray* properties of this class.
    // EFFECTS: Clears all properties of this class.
    
    _wolfLocation = unknown;
    _pigLocation = unknown;
    [self makeCleanBlocksData];
}


- (void) makeCleanBlocksData {
    // MODIFIES: Location and NSMutableArray* properties related to blocks in this class.
    // EFFECTS: Clears block-related properties.
    
    [_blocksVArray removeAllObjects];
}


@end
