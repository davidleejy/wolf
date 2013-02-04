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


//Ctor
-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV;

//Override Transforms
- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;


- (void)changeMaterial:(UITapGestureRecognizer *)singleTapRecognizer;

//override reset
//- (void)reset;

@end
