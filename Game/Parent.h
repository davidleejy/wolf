//
//  Parent.h
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parent : NSObject

@property (readwrite) CGFloat lives;

- (id) setLk:(CGFloat)n;
- (void) print;
- (void) shout;

@end
