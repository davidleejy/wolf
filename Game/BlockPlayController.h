//
//  BlockPlayController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"

typedef enum {kStraw, kWood, kIron, kStone} Material;

@interface BlockPlayController : NSObject <ChipmunkObject>

@property (readwrite) UIButton *button;
@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects;
@property (readwrite) int touchedShapes;
@property (readonly) Material material;

// ***** Properties unique to a block
@property(readonly) NSString *materialImagePath; // Can use this to test block type also.


- (void)updatePosition;

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter ImagePath:(NSString*)materialImagePath;
// REQUIRES: Non-skewed transform. Valid materialImagePath, otherwise exception is raised.
// EFFECTS: ctor

@end
