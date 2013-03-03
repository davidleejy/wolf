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
@property (readonly) NSMutableArray* wolfBlowingSpriteSequence;
@property (readonly) NSMutableArray* windSuckSpriteSequence;

- (void)updatePosition;

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter;
// REQUIRES: Non-skewed transform
// EFFECTS: ctor

- (void)animateBlowWithDeltaTime:(double)dt RepeatCount:(uint)cnt;
// EFFECTS: Animates the wolf with blowing action. Only body is animated.

- (void)animateOneBlowThatCompletesInSecs:(double)duration;
// EFFECTS: Animates the wolf ONCE with blowing action complete with sucking and blowing out.

- (CGPoint)wolfMouthCoordinates;
// EFFECTS: returns the coordinates of where the wolf's mouth is. This is where
//      wind should be blown out /sucked in from.


@end
