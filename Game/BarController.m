//
//  BarController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BarController.h"
#import "DeveloperSettings.h"
#import "MyMath.h"

@interface BarController ()
@property (readwrite) BOOL progressLastTouchWasLowerEndOfBar;

@end

@implementation BarController

@synthesize bar = _bar;
@synthesize progressLastTouchWasLowerEndOfBar = _progressLastTouchWasLowerEndOfBar;

- (BarController*) initForPlayScene {
    
    self = [super init];
    if (!self) return nil;
    
    _bar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _bar.trackTintColor= [DeveloperSettings DARK_ORANGE_COLOR];
    _bar.progressTintColor=[DeveloperSettings DARK_PURPLE_COLOR];
    _bar.frame = CGRectMake(25, 200, 500, _bar.frame.size.height);
    [_bar setProgress:0];
    _progressLastTouchWasLowerEndOfBar = YES;
    
    return self;
}


- (void) bubbleTheBar:(CGFloat)unitStep {
    
    if ([MyMath doubleApproxEq:_bar.progress :0]) {
        _progressLastTouchWasLowerEndOfBar = YES;
    }
    else if ([MyMath doubleApproxEq:_bar.progress :1]) {
        _progressLastTouchWasLowerEndOfBar = NO;
    }
    
    if (_progressLastTouchWasLowerEndOfBar)
        [_bar setProgress: _bar.progress+unitStep];
    else
        [_bar setProgress: _bar.progress-unitStep];
}


- (void) resetZero {
    [_bar setProgress: 0];
}


@end
