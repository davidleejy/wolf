//
//  GameBlock.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"
@class BlockView;
@class GameObjectModel; // the database

@interface GameBlock : GameObject


// Holds blockView objects that belong to game area
@property (readwrite) NSMutableArray* gameAreaContainment;

// Holds a SINGLE blockView object that belongs to the palette.
@property (readwrite) BlockView* blockViewInPalette;

// Just to clarify, this class's view property is UNUSED.
// This class's view property is UNUSED NOW AND WILL BE UNUSED FOREVER.
// NEVER EVER "play around" with this class's view property.
// Playing around with this class's view property can result runtime crashes.


//Ctor
-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV;

//Override Transforms
- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;


- (void)changeMaterial:(UITapGestureRecognizer *)singleTapRecognizer;

- (void)createBlockIconInPalette;

- (void)reset;
- (void) saveTo:(GameObjectModel*)database;
- (void) loadFrom:(GameObjectModel*)database;


@end
