//
//  BreathPlayController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface WindBlowController : NSObject <ChipmunkObject>

@property (readwrite) UIButton *button; // TODO refactor name.  This is the view.
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;
@property (readwrite) int touchedShapes;


//Used in collision handlers as a temp variable.
@property (readwrite) cpVect preCollisionVelocity;
/*
For example, the collision handler (begin collision) records
the wind blow object's pre-collision velocity here.
Then, the collision handler (post collision) will use this recorded
pre-collision velocity to make decisions about what the post-
collision velocity should be.
*/



//***** Unique to breath ******
@property (readonly) NSMutableArray* windBlowSequence;

- (void)updatePosition;

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter;
// REQUIRES: Non-skewed transform
// EFFECTS: ctor

- (id) init; //TODO delete

- (void)animateWithDeltaTime:(double)dt RepeatCount:(uint)cnt;
// EFFECTS: Animates the breath

- (void) dropAlpha;
//MODIFIES: dialView
//EFFECTS: sets alpha of dialView to 0.2.

- (void) resetAlphaToOne;
//MODIFIES: dialView
//EFFECTS: sets alpha of dialView to 1.0.


// *** HELPER FUNCTIONS ***
// Useful for debugging.

- (UIImage*) windBlowInFrame:(NSUInteger)desiredFrame Of:(NSString*)spriteScreenPath;

@end
