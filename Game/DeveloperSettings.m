//
//  DeveloperSettingsForViewClasses.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DeveloperSettings.h"

@implementation DeveloperSettings


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

NSString *BLOCK_WOOD_IMAGE_PATH = @"wood.png";
NSString *BLOCK_IRON_IMAGE_PATH = @"iron.png";
NSString *BLOCK_STRAW_IMAGE_PATH = @"straw.png";
NSString *BLOCK_STONE_IMAGE_PATH = @"stone.png";

CGFloat BLOCK_DEFAULT_ASPECT_WIDTH = 15;
CGFloat BLOCK_DEFAULT_ASPECT_HEIGHT = 65;

CGFloat BLOCK_DEFAULT_WIDTH = 30;
CGFloat BLOCK_DEFAULT_HEIGHT = 130;


// WindBlow
NSString *WINDBLOW_SPRITESCREEN_PATH = @"windblow.png";
NSUInteger WINDBLOW_SPRITESCREEN_SPRITE_COUNT = 4;
CGFloat WINDBLOW_BREATH_RADIUS = 40;


// Angle dial
NSString *ANGLE_DIAL_ARROW_DESELECTED_PATH = @"direction-arrow.png";
NSString *ANGLE_DIAL_ARROW_SELECTED_PATH = @"direction-arrow-selected.png";
NSString *ANGLE_DIAL_PATH = @"direction-degree.png";


// Colors

+ (UIColor *)DARK_PURPLE_COLOR{
    return [UIColor colorWithRed:143/255.0 green:30/255.0 blue:136/255.0 alpha:1.0];
}
+ (UIColor *)DARK_ORANGE_COLOR{
    return [UIColor colorWithRed:244.0/255.0 green:103/255.0 blue:140/255.0 alpha:1.0];
}

@end
