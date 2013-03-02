//
//  BreathPlayController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface BreathPlayController : NSObject <ChipmunkObject>

@property (readwrite) UIButton *button; // TODO refactor name.  This is the view.
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;
@property (readwrite) int touchedShapes;

//***** Unique to breath ******
@property (readonly) NSMutableArray* windBlowSequence;

- (void)updatePosition;

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter;
// REQUIRES: Non-skewed transform
// EFFECTS: ctor

- (id) init; //TODO delete

- (void)animateWithDeltaTime:(double)dt RepeatCount:(uint)cnt;
// EFFECTS: Animates the breath


// *** HELPER FUNCTIONS ***
// Useful for debugging.

- (UIImage*) windBlowInFrame:(NSUInteger)desiredFrame Of:(NSString*)spriteScreenPath;

@end
