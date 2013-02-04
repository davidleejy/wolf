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
#import "GameObjectModel.h"

@interface GameBlock ()
    @property (readwrite) BOOL thisBlockBeganInPalette; // Is a temp variable to decrease the time taken to execute handler of transforms.
@end


@implementation GameBlock

@synthesize gameAreaContainment = _gameAreaContainment;
@synthesize blockViewInPalette = _blockViewInPalette;
@synthesize thisBlockBeganInPalette = _thisBlockBeganInPalette;


//Ctor
-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV {
    if (self = [super initWith:kGameObjectBlock UnderControlOf:self AndPalette:paletteSV AndGameArea:gameAreaSV]) {
        self.paletteLocation = CGPointMake(110,0);
        self.angle = 0;
        
        [self createBlockIconInPalette];
        _gameAreaContainment = [[NSMutableArray alloc]init];
        return self;
    }
    return nil;
}



- (void)translate:(UIPanGestureRecognizer *)panRecognizer{
    
    // Remember where this block started from. Game area or palette?
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([panRecognizer.view isDescendantOfView: self.palette]) {
            _thisBlockBeganInPalette = YES;
        }
        else
            _thisBlockBeganInPalette = NO;
    }
    
    
    
     //        NOTE !
    [super translate:panRecognizer];
     //        NOTE !
    
    
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (_thisBlockBeganInPalette && [panRecognizer.view isDescendantOfView:self.gameArea]) {
            
            //adjust this block to specified height and width
            panRecognizer.view.frame = CGRectMake(panRecognizer.view.frame.origin.x,
                                                  panRecognizer.view.frame.origin.y,
                                                  30,130);
            
            //insert this view in the NSMutableArray property, blockViewsInGameAreaContainment.
            [_gameAreaContainment addObject:_blockViewInPalette];
            
            //create a new view in the palette.
            [self createBlockIconInPalette];
        }
        else if (!_thisBlockBeganInPalette) {
            // nothing to do.
        }
    }
    
    //NSLog(@"gameareacontainment after reset %@", _gameAreaContainment);

}


- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer {
    
    if (doubleTapRecognizer.state == UIGestureRecognizerStateEnded) {
            
        if ([doubleTapRecognizer.view isDescendantOfView:self.gameArea]) {
            
            // Target this blockView object. This blockView object is inside the gameAreaContainment array.
            NSUInteger idx = [_gameAreaContainment indexOfObjectIdenticalTo:doubleTapRecognizer.view];
            
            // Remove it from gameArea.
            [(BlockView*)[_gameAreaContainment objectAtIndex:idx] removeFromSuperview];
            
            // Remove this view object from game area containment array.
            [ _gameAreaContainment removeObjectAtIndex:idx];
        }
    }
}



- (void)changeMaterial:(UITapGestureRecognizer *)singleTapRecognizer{
    
    if (singleTapRecognizer.state == UIGestureRecognizerStateEnded) {
        // Only allow material changing in gamearea.
        if ( [singleTapRecognizer.view isDescendantOfView:self.gameArea])
            [(BlockView*)singleTapRecognizer.view nextMaterial];
    }
}


- (void)createBlockIconInPalette {
    _blockViewInPalette = [[BlockView alloc] initDefaultWithController:self];
    _blockViewInPalette.frame = CGRectMake(110, 0, 55, 55);
    [self.palette addSubview:_blockViewInPalette];
}



- (void)reset{
    // Clear up the game area
    BlockView* eachElement;
    for (eachElement in _gameAreaContainment) {
        [eachElement removeFromSuperview];
    }
    [_gameAreaContainment removeAllObjects];
}


- (void) saveTo:(GameObjectModel*)database {
    
    [database makeCleanBlocksData];
    
    database.blocksVArray = [[NSMutableArray alloc] initWithArray:_gameAreaContainment];
    
}


- (void) loadFrom:(GameObjectModel*)database {
    
    [self reset]; // Remove all blocks from gameAreaContainment property.
    
    // Traverse database storage and refill gameAreaContainment property with
    //  the necessary pieces of info from database storage.
    for (int i = 0; i < database.blocksVArray.count; i++) {
        
        BlockView* savedView = [database.blocksVArray objectAtIndex:i];
        BlockView* newView = [[BlockView alloc] initDefaultWithController:self];
        
        // configure the newView to have the same settings like savedView
        newView.transform = savedView.transform;
        newView.frame = savedView.frame;
        newView.bounds = savedView.bounds;
        [newView showMaterial:savedView.currentMaterial];
        
        // add to game area
        [self.gameArea addSubview:newView];
        
        // add to game area containment array
        [_gameAreaContainment addObject:newView];
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
