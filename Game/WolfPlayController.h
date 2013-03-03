//
//  WolfPlayController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface WolfPlayController : NSObject <ChipmunkObject>

@property (readwrite) UIButton *button; // TODO refactor name.  This is the view.
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;
@property (readwrite) int touchedShapes;


//***** Unique to wolf ******
@property (readonly) UIImage* wolfsImage; // Many wolfs in this image
@property (readonly) NSMutableArray* wolfBlowingImagesSequence;

- (void)updatePosition;

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter;
// REQUIRES: Non-skewed transform
// EFFECTS: ctor

- (void)animateBlowWithDeltaTime:(double)dt RepeatCount:(uint)cnt;
// EFFECTS: Animates the wolf with wind blowing action.

//- (void)animateBlowWithDeltaTime:(double)dt RepeatCount:(uint)cnt PerformAtEnd:(SEL)selector1;
//// EFFECTS: Animates the wolf with wind blowing action and selector is called at end.

@end
