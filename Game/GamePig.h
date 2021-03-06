//
//  GamePig.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"
@class GameObjectModel; // the database


@interface GamePig : GameObject

-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV;

//Override transforms. Pig different from other game objects
- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;

- (void) reset;
- (void) saveTo:(GameObjectModel*)database;
- (void) loadFrom:(GameObjectModel*)database;

@end
