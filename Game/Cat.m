//
//  Cat.m
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Cat.h"

@implementation Cat


-(void) fervour:(int)L {
    [super setLk:88.888];
    self.biteStr = L;
}

- (void) print {
    [super print];
    NSLog(@"BiteStr is %d\n",self.biteStr);
}

@end
