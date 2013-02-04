//
//  UIView+ExploreViewHierarchy.m
//  Game
//
//  Created by Lee Jian Yi David on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UIView+ExploreViewHierarchy.h"

void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("    ");
    
    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}

@implementation UIView (ExploreViewHierarchy)

- (void)exploreViewAtLevel:(int)level
{
    doLog(level, @"%@", [[self class] description]);
    doLog(level, @"%@", NSStringFromCGRect([self frame]));
    for (UIView *subview in [self subviews])
        [subview exploreViewAtLevel:(level + 1)];
}

- (void)exploreSuperViews:(int)level
{
    doLog(level, @"%@", [[self class] description]);
    doLog(level, @"%@", NSStringFromCGRect([self frame]));
//    for (UIView *asuperview in [self superview])
//        [asuperview exploreSuperViews:(level + 1)];
    UIView* ASuperView;
    if (self.superview) {
        [ASuperView exploreSuperViews:(level+1)];
    }
    else
        return;
    return;
}

- (void)printSuperViews {
    NSLog(@"####printSuperViews STARTED####");
    printf("Curr View:");
    int padding = 0;
    
    UIView* viewPtr = self;
    
    while (viewPtr != NULL) {
        for (int i = padding; i != 0; i--) {
            printf("  ");
        }
        NSLog(@"%@",viewPtr);
        viewPtr = viewPtr.superview;
    }
    NSLog(@"####printSuperViews ENDED####");
}

@end
