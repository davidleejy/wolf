//
//  GamePig.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GamePig.h"
#import "GameObjectModel.h"
#import "PigView.h"


@interface GamePig()

@property (readwrite) UIView* superViewBeforeTranslate;

@end


@implementation GamePig

@synthesize superViewBeforeTranslate = _superViewBeforeTranslate;


-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV {
    if (self = [super initWith:kGameObjectPig UnderControlOf:self AndPalette:paletteSV AndGameArea:gameAreaSV]) {
        self.paletteLocation = CGPointMake(55,0);
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
                                                  88,88);
        }
        
        
    }
}


- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer {
    
    if (doubleTapRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([doubleTapRecognizer.view isDescendantOfView:self.gameArea]) {
            doubleTapRecognizer.view.transform = CGAffineTransformIdentity;
            doubleTapRecognizer.view.frame = CGRectMake(55, 0, 55, 55);
            [self.palette addSubview:doubleTapRecognizer.view];
        }
        
    }
}


- (void) reset {
    if ([self.view isDescendantOfView:self.gameArea]) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = CGRectMake(55, 0, 55, 55);
        [self.palette addSubview:self.view];
    }
}


- (void) saveTo:(GameObjectModel*)database {
    database.pigV = (PigView*)self.view;
    
    if ([self.view isDescendantOfView:self.palette]) {
        database.pigLocation = inPalette;
    }
    else if ([self.view isDescendantOfView:self.gameArea]) {
        database.pigLocation = inGameArea;
    }
    else {
        database.pigLocation = unknown;
        [NSException raise:@"GamePig class's saveTo: method" format:@"Pig location cannot be unknown."];
    }
    
}

- (void) loadFrom:(GameObjectModel*)database {
    
    [self reset];
    
    if (database.pigLocation == inPalette) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = CGRectMake(55, 0, 55, 55);
        [self.palette addSubview:self.view];
    }
    else if (database.pigLocation == inGameArea){
        
        
        self.view.frame = CGRectMake(database.pigV.frame.origin.x, database.pigV.frame.origin.y, database.pigV.frame.size.width, database.pigV.frame.size.height);

        self.view.bounds = CGRectMake(database.pigV.bounds.origin.x, database.pigV.bounds.origin.y, database.pigV.bounds.size.width, database.pigV.bounds.size.height);

        [self.gameArea addSubview:self.view];
        
        self.view.transform = CGAffineTransformMake(database.pigV.transform.a, database.pigV.transform.b, database.pigV.transform.c, database.pigV.transform.d, database.pigV.transform.tx, database.pigV.transform.ty);
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
