//
//  MyMath.h
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMath : NSObject


+ (double) rotationOfNonSkewedAffineTransform:(CGAffineTransform) x;
// REQUIRES: Non-skewed CGAffineTransform data structure.
// EFFECTS: returns angle of rotation in rads.

+ (double) horizScaleFactorOf:(CGAffineTransform) x;
// REQUIRES: Non-skewed CGAffineTransform data structure.
// EFFECTS: returns horizontal scaling factor.
//          Can be multiplied by width to get actual width of a scaled (enlarged/shrunken) view.

+ (double) vertScaleFactorOf:(CGAffineTransform) x;
// REQUIRES: Non-skewed CGAffineTransform data structure.
// EFFECTS: returns horizontal scaling factor.
//          Can be multiplied by width to get actual width of a scaled (enlarged/shrunken) view.

+ (BOOL) doubleApproxEq:(double)a :(double)b;
+ (BOOL) CGFloatApproxEq:(CGFloat)a :(CGFloat)b;

@end