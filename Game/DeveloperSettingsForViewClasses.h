//
//  DeveloperSettingsForViewClasses.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeveloperSettingsForViewClasses : NSObject


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

FOUNDATION_EXPORT NSString *WOOD_IMAGE_PATH;
FOUNDATION_EXPORT NSString *IRON_IMAGE_PATH;
FOUNDATION_EXPORT NSString *STRAW_IMAGE_PATH;
FOUNDATION_EXPORT NSString *STONE_IMAGE_PATH;

FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_ASPECT_WIDTH;
FOUNDATION_EXPORT CGFloat BLOCK_DEFAULT_ASPECT_HEIGHT;

FOUNDATION_EXPORT CGFloat BLOCK_WIDTH;
FOUNDATION_EXPORT CGFloat BLOCK_HEIGHT;


@end
