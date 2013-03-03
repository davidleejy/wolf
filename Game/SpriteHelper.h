//
//  SpriteHelper.h
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpriteHelper : NSObject

+(CGRect) getCroppingRect:(UIImage*)spriteScreen
            RowsOfSprites:(int)r
            ColsOfSprites:(int)c
              SpriteCount:(int)sCount
       DesiredSpriteIndex:(int)idx;
// REQUIRES: sprites on sprite screen to be positioned in a table, with the table filled
//          row by row, from the top row first then moving on to the bottom rows.
//          Rows should be filled from left to right.
//          Height and width of each sprite should be the same for optimum results.
//
//          e.g. of a sprite screen
//          0  1  2  3  4
//          5  6  7  8  9
//
//          The numbers denote the index of the sprite.  The numbers also represent the sprites.
//          The positions of the numbers denote how the sprites are relative to one another.
// EFFECTS: returns a cropping rectangle that corresponds to the sprite in a sprite screen.

@end
