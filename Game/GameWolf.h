//
//  GameWolf.h
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"

@interface GameWolf : GameObject

-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV;

//Override transforms. Wolf different from other game objects
- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;


@end
