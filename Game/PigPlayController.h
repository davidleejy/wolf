//
//  PigPlayController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

@interface PigPlayController : NSObject <ChipmunkObject>

@property (readwrite) UIButton *button; // TODO refactor name.  This is the view.
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;
@property (readwrite) int touchedShapes;

- (void)updatePosition;


- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Frame:(CGRect)myFrame Center:(CGPoint)myCenter;
// REQUIRES: Non-skewed transform
// EFFECTS: ctor


@end
