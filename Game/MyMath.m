//
//  MyMath.m
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MyMath.h"

@implementation MyMath


// Helper functions

+ (double) rotationOfNonSkewedAffineTransform:(CGAffineTransform) x {
    return atan2(x.b, x.a);
}


+ (double) horizScaleFactorOf:(CGAffineTransform) x {
    return sqrt(x.a*x.a + x.c*x.c);
}


+ (double) vertScaleFactorOf:(CGAffineTransform) x {
    return sqrt(x.b*x.b + x.d*x.d);
}

@end
