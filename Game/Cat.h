//
//  Cat.h
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parent.h"

@interface Cat : Parent

@property (readwrite) int biteStr;

-(void) fervour:(int)L;

@end
