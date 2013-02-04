//
//  GameBlock.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UIView+ExploreViewHierarchy.h"
#import "BlockView.h"
#import "GameBlock.h"



@implementation GameBlock


//Ctor
-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV {
    if (self = [super initWith:kGameObjectBlock UnderControlOf:self AndPalette:paletteSV AndGameArea:gameAreaSV]) {
        self.origin = CGPointMake(110, 0);
        self.paletteLocation = CGPointMake(110,0);
        self.angle = 0;
        self.width = 55;
        self.height = 55;
        return self;
    }
    return nil;
}

//Override Transforms


- (void)translate:(UIPanGestureRecognizer *)panRecognizer{
    
    [super translate:panRecognizer];
    
    if ([panRecognizer.view isDescendantOfView:self.gameArea]) {
        ;//create a new view in the palette.
        //insert a new view in the model.
    }
}


- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer {
    
    if ([doubleTapRecognizer.view isDescendantOfView:self.gameArea]) {
        ;// Remove view from gameArea.
        // Remove view in model.
    }
}



- (void)changeMaterial:(UITapGestureRecognizer *)singleTapRecognizer{
    
    // Only allow material changing in gamearea.
    if ( [singleTapRecognizer.view isDescendantOfView:self.gameArea])
        [(BlockView*)singleTapRecognizer.view nextMaterial];
}



//override reset
//- (void)reset{
//    
//    
//    
//}



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
