//
//  BarController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarController : NSObject

@property(readwrite) UIProgressView* bar;
@property(readonly) BOOL progressLastTouchWasLowerEndOfBar; // used in bubbling progress bar.


- (BarController*) initForPlayScene;
// EFFECTS: ctor for play scene

- (void) bubbleTheBar:(CGFloat)unitStep;
// REQUIRES: unitStep to be between 0.0 and 1.0.
// MODIFIES: bar
// EFFECTS: changes progress of bar by incrementing or
//      decrementing the bar by 1 unitStep.

- (void) resetZero;
// MODIFIES: bar
// EFFECTS: sets progress of bar to 0.

@end
