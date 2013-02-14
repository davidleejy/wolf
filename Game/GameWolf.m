//
//  GameWolf.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameWolf.h"
#import "GameObjectModel.h"
#import "WolfView.h"

//Debugging
#import "UIView+ExploreViewHierarchy.h"

@interface GameWolf()

@property (readwrite) UIView* superViewBeforeTranslate;

@end


@implementation GameWolf


@synthesize superViewBeforeTranslate = _superViewBeforeTranslate;


-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV {
    if (self = [super initWith:kGameObjectWolf UnderControlOf:self AndPalette:paletteSV AndGameArea:gameAreaSV]) {
        self.paletteLocation = CGPointMake(0,0);
        self.angle = 0;
        return self;
    }
    return nil;
}



- (void)translate:(UIPanGestureRecognizer *)panRecognizer {

    // Check where the wolf belongs before translating.
    // Where the wolf started from is important in deciding
    // whether its frame should be changed if it goes from the
    // palette into the game area.
    if (panRecognizer.state == UIGestureRecognizerStateBegan){
        if ([panRecognizer.view isDescendantOfView:self.palette]) {
            _superViewBeforeTranslate = self.palette;
        }
        else
            _superViewBeforeTranslate = self.gameArea;
    }
    
    
    //      Note
    [super translate:panRecognizer];
    //      Note
    
    
    // Check where the wolf belongs to after translating.
    // Where the wolf ends up is important in deciding
    // whether its frame should be changed if it goes from the
    // palette into the game area.
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (_superViewBeforeTranslate == self.palette &&
            [panRecognizer.view isDescendantOfView:self.gameArea]) {
            panRecognizer.view.frame = CGRectMake(panRecognizer.view.frame.origin.x,
                                                  panRecognizer.view.frame.origin.y,
                                                  225,150);
        }
    }
    
}

- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer {
    
    if (doubleTapRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([doubleTapRecognizer.view isDescendantOfView:self.gameArea]) {
            doubleTapRecognizer.view.transform = CGAffineTransformIdentity;
            doubleTapRecognizer.view.frame = CGRectMake(0, 0, 55, 55);
            [self.palette addSubview:doubleTapRecognizer.view];
        }
        
    }
    
}


- (void) reset {
    if ([self.view isDescendantOfView:self.gameArea]) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = CGRectMake(0, 0, 55, 55);
        [self.palette addSubview:self.view];
    }
}


- (void) saveTo:(GameObjectModel*)database {
    database.WolfV = (WolfView*)self.view;
    
    if ([self.view isDescendantOfView:self.palette]) {
        database.wolfLocation = inPalette;
    }
    else if ([self.view isDescendantOfView:self.gameArea]) {
        database.wolfLocation = inGameArea;
    }
    else {
        database.wolfLocation = unknown;
        [NSException raise:@"GameWolf class's saveTo: method" format:@"Wolf location cannot be unknown."];
    }
    
}

- (void) loadFrom:(GameObjectModel*)database {
    if (database.wolfLocation == inPalette) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = CGRectMake(0, 0, 55, 55);
        [self.palette addSubview:self.view];
    }
    else if (database.wolfLocation == inGameArea){
        self.view.transform = database.wolfV.transform;
        self.view.frame = database.wolfV.frame;
        self.view.bounds = database.wolfV.bounds;
        [self.gameArea addSubview:self.view];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
