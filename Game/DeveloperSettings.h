//
//  DeveloperSettingsForViewClasses.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeveloperSettings : NSObject


// WolfView class

FOUNDATION_EXPORT NSString *WOLFS_IMAGE_PATH;
FOUNDATION_EXPORT CGFloat WOLF_DEFAULT_WIDTH;
FOUNDATION_EXPORT CGFloat WOLF_DEFAULT_HEIGHT;
FOUNDATION_EXPORT NSUInteger WOLFS_MAX_FRAMES_TO_CHOOSE_FROM;
FOUNDATION_EXPORT NSUInteger WOLFS_ROWS_OF_FRAMES;
FOUNDATION_EXPORT NSUInteger WOLFS_COLUMNS_OF_FRAMES;


// PigView class

FOUNDATION_EXPORT NSString *PIG_IMAGE_PATH;
FOUNDATION_EXPORT CGFloat PIG_DEFAULT_WIDTH;
FOUNDATION_EXPORT CGFloat PIG_DEFAULT_HEIGHT;


// BlockView class

FOUNDATION_EXPORT NSString *BLOCK_WOOD_IMAGE_PATH;
FOUNDATION_EXPORT NSString *BLOCK_IRON_IMAGE_PATH;
FOUNDATION_EXPORT NSString *BLOCK_STRAW_IMAGE_PATH;
FOUNDATION_EXPORT NSString *BLOCK_STONE_IMAGE_PATH;

FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_ASPECT_WIDTH;
FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_ASPECT_HEIGHT;

FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_WIDTH;
FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_HEIGHT;


// WindBlow
FOUNDATION_EXPORT NSString *WINDBLOW_SPRITESCREEN_PATH;
FOUNDATION_EXPORT NSUInteger WINDBLOW_SPRITESCREEN_SPRITE_COUNT;
FOUNDATION_EXPORT CGFloat WINDBLOW_BREATH_RADIUS;

// Angle dial
FOUNDATION_EXPORT NSString *ANGLE_DIAL_ARROW_DESELECTED_PATH;
FOUNDATION_EXPORT NSString *ANGLE_DIAL_ARROW_SELECTED_PATH;
FOUNDATION_EXPORT NSString *ANGLE_DIAL_PATH;

// Colors
+ (UIColor *)DARK_PURPLE_COLOR;
+ (UIColor *)DARK_ORANGE_COLOR;

@end
