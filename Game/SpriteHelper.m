//
//  SpriteHelper.m
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SpriteHelper.h"

@implementation SpriteHelper


+(CGRect) getCroppingRect:(UIImage*)spriteScreen
            RowsOfSprites:(int)r
            ColsOfSprites:(int)c
              SpriteCount:(int)sCount
       DesiredSpriteIndex:(int)idx
{
    
    if (idx < 0 || idx >= sCount) {
        [NSException raise:@"getCroppingRect:RowOfSprites:ColsOfSprites:...." format:@"%d is an invalid frame! Choose from frames 0 ~ %d. Error is handled by setting desired sprite index to 0.", idx, sCount];
        idx = 0;
    }
    
    
    CGFloat allFramesHeight = spriteScreen.size.height;
    CGFloat allFramesWidth = spriteScreen.size.width;
    CGFloat singleFrameHeight = allFramesHeight / r;
    CGFloat singleFrameWidth = allFramesWidth / c;
    CGFloat frameX = (idx % c) * singleFrameWidth;
    CGFloat frameY = ((int)((float)idx) / c) * singleFrameHeight;
    
    return CGRectMake(frameX, frameY, singleFrameWidth, singleFrameHeight);
}

@end
