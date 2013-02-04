//
//  UIView+ExploreViewHierarchy.h
//  Game
//
//  Created by Lee Jian Yi David on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExploreViewHierarchy)

- (void)exploreViewAtLevel:(int)level;
- (void)printSuperViews;

@end
