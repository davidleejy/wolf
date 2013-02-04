//
//  GameBlock.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"
@class BlockView;


@interface GameBlock : GameObject


// Holds blockView objects that belong to game area
@property (readwrite) NSMutableArray* gameAreaContainment;

// Holds a SINGLE blockView object that belongs to the palette.
@property (readwrite) BlockView* blockViewInPalette;



//Ctor
-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV;

//Override Transforms
- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;


- (void)changeMaterial:(UITapGestureRecognizer *)singleTapRecognizer;

- (void)createBlockIconInPalette;

//override reset
//- (void)reset;

@end
