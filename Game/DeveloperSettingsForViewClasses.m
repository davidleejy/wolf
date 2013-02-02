//
//  DeveloperSettingsForViewClasses.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DeveloperSettingsForViewClasses.h"

@implementation DeveloperSettingsForViewClasses


// WolfView class

NSString *WOLFS_IMAGE_PATH = @"wolfs.png";
CGFloat WOLF_DEFAULT_WIDTH = 225;
CGFloat WOLF_DEFAULT_HEIGHT = 150;
NSUInteger WOLFS_MAX_FRAMES_TO_CHOOSE_FROM = 15; // Choose between 1 ~ 15
NSUInteger WOLFS_ROWS_OF_FRAMES = 3;
NSUInteger WOLFS_COLUMNS_OF_FRAMES = 5;


// PigView class

NSString *PIG_IMAGE_PATH = @"pig.png";
CGFloat PIG_DEFAULT_WIDTH = 88;
CGFloat PIG_DEFAULT_HEIGHT = 88;



// BlockView class

NSString *WOOD_IMAGE_PATH = @"wood.png";
NSString *IRON_IMAGE_PATH = @"iron.png";
NSString *STRAW_IMAGE_PATH = @"straw.png";
NSString *STONE_IMAGE_PATH = @"stone.png";

CGFloat BLOCK_DEFAULT_ASPECT_WIDTH = 15;
CGFloat BLOCK_DEFAULT_ASPECT_HEIGHT = 65;

CGFloat BLOCK_WIDTH = 30;
CGFloat BLOCK_HEIGHT = 130;

@end
