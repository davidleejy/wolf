//
//  Parent.m
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Parent.h"

@implementation Parent

@synthesize lives = _lives;


- (id) setLk:(CGFloat)n {
    self.lives = n;
    return self;
}

- (void) print {
    NSLog(@"lives is %lf\n",self.lives);
}

- (void) shout {
    NSLog(@"waaaaaa");
}

@end
