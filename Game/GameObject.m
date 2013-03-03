//
//  GameObject.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"
#import "PigView.h"
#import "WolfView.h"
#import "BlockView.h"
#import "GameObjectView.h"
#import "GameObjectModel.h"

// Debugging purposes
#import "UIView+ExploreViewHierarchy.h"




@interface GameObject ()

@property (readwrite) GameObjectModel *database;

@property (nonatomic, readwrite) GameObjectType objectType;

@property (nonatomic, readwrite) BOOL isFromPaletteToGameArea;
@property (readwrite) UIScrollView *palette;
@property (readwrite) UIScrollView *gameArea;

// Local properties
@property (readwrite) CGPoint initialCoords; // To improve preformance of gesture handlers
@property (readwrite) CGPoint finalCoords; // To improve preformance of gesture handlers
@property (readwrite) CGRect initialBounds; // To improve preformance of gesture handlers
@property (readwrite) CGRect initialFrame; // To improve preformance of gesture handlers
@property (readwrite) CGFloat translationX; // To improve preformance of gesture handlers
@property (readwrite) CGFloat translationY; // To improve preformance of gesture handlers
@property (readwrite) UIImageView* playableAreaInGameArea;

@end




@implementation GameObject

@synthesize database = _database;
@synthesize objectType = _objectType;
@synthesize angle = _angle;
@synthesize paletteLocation = _paletteLocation;
@synthesize isFromPaletteToGameArea = _isFromPaletteToGameArea;
@synthesize palette = _palette;
@synthesize gameArea = _gameArea;
@synthesize childMostController = _childMostController;


// Temporary variables
@synthesize initialCoords = _initialCoords;
@synthesize playableAreaInGameArea = _playableAreaInGameArea;


- (id) initWith:(GameObjectType)objType
        UnderControlOf:(GameObject*)childMostController
        AndPalette:(UIScrollView*)paletteSV
        AndGameArea:(UIScrollView*)gameAreaSV
{
    
    if (self=[super init]) {
        _objectType = objType;
        _palette = paletteSV;
        _gameArea = gameAreaSV;
        _angle = 0;
        _childMostController = childMostController; //for e.g. GameWolf object
        
        // Keep a reference to playable area in game area.
        _playableAreaInGameArea = (UIImageView*)[_gameArea viewWithTag:3];
        
        return self;
    }
    return nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView* myView = nil;
    
    // Pick a UIImageView based on Game Object type.
    switch (_objectType)
    {
        case kGameObjectWolf:
            myView = [[WolfView alloc]initWithController:_childMostController AndActionFrame:1];
            self.view = myView; //assign view to this view controller
            self.view.frame = CGRectMake(_paletteLocation.x, _paletteLocation.y, 55, 55); //align view in palette
            break;
            
        case kGameObjectPig:
            myView = [[PigView alloc]initDefaultWithController:_childMostController];
            self.view = myView;
            self.view.frame = CGRectMake(_paletteLocation.x, _paletteLocation.y, 55, 55);
            break;
            
        case kGameObjectBlock:
            //myView = [[BlockView alloc]initDefaultWithController:_childMostController];
            break;
            
        default:
            break;
    }
    
}


- (void)translate:(UIPanGestureRecognizer *)panRecognizer
// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
// if the object is in the palette, it will be moved in the game area

{
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        _initialCoords = panRecognizer.view.center;
        
        _gameArea.scrollEnabled = NO; //Disable scrolling
    }
    
    
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];

    panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x + translation.x, panRecognizer.view.center.y + translation.y);

    [panRecognizer setTranslation:CGPointZero inView:self.view.superview];
    
    if ([panRecognizer.view isDescendantOfView:_palette] &&
        panRecognizer.view.center.y > _palette.frame.size.height) {
        [_gameArea addSubview:panRecognizer.view];
        panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x+ _gameArea.contentOffset.x, 0);
    }

    
    //Where the view object _ends_ up depends on whether it belonged to the palette or game area.
	if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        if([panRecognizer.view isDescendantOfView: _palette]) {
            
            if([self isInvalidMove:panRecognizer InPalette:_palette])
            {
                // Put view back into palette
                panRecognizer.view.center = CGPointMake(self.paletteLocation.x + panRecognizer.view.frame.size.width/2,self.paletteLocation.y + panRecognizer.view.frame.size.height/2);
            }
        if (panRecognizer.view.center.y - panRecognizer.view.frame.size.height/2 >= _palette.frame.size.height)
        {
            CGFloat offX = _gameArea.contentOffset.x + panRecognizer.view.center.x;
            panRecognizer.view.center = CGPointMake(offX,panRecognizer.view.center.y - _palette.frame.size.height);
            [_gameArea addSubview:panRecognizer.view];
            
        }
            
            
        }
        else if ([panRecognizer.view isDescendantOfView: _gameArea]){
            // should check that this view object is in a game area that makes sense.
            if([self isInvalidPosition:panRecognizer
                      WithRespectTo:_playableAreaInGameArea])
                      {
                          panRecognizer.view.center = _initialCoords;
                      }
        }
        
        _gameArea.scrollEnabled = YES;
    }
    

}

//Self defined method to check whether a game object that is in game area is in an area that makes sense.
// For e.g. a game object shouldn't be embedded in the ground.
// For e.g. a game object shouldn't be half embedded in the wall of the game area.
- (BOOL)isInvalidPosition:(UIPanGestureRecognizer *)panRecognizer WithRespectTo:(UIView *)playableArea
{
    
    // Check whether view object is embedded in ground.
    if (panRecognizer.view.frame.origin.y + panRecognizer.view.frame.size.height >
        playableArea.frame.origin.y + playableArea.frame.size.height) {
        return YES;
    }
    
    // Check whether view object has part of it in left wall.
    if (panRecognizer.view.frame.origin.x < playableArea.frame.origin.x) {
        return YES;
    }
    
    // Check whether view object has part of it over the sky.
    if (panRecognizer.view.frame.origin.y < playableArea.frame.origin.y) {
        return YES;
    }
    
    // Check whether view object has part of it in right wall.
    if (panRecognizer.view.frame.origin.x + panRecognizer.view.frame.size.width >
        playableArea.frame.origin.x + playableArea.frame.size.width) {
        return YES;
    }
    
    return NO;
    
}

- (void)rotate:(UIRotationGestureRecognizer *)rotationRecognizer
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture
{
    
    if ([rotationRecognizer.view isDescendantOfView:_gameArea]) {
        CGFloat angle = rotationRecognizer.rotation;
        //NSLog(@"Before rotate %@",rotationRecognizer.view);
        rotationRecognizer.view.transform = CGAffineTransformRotate(rotationRecognizer.view.transform, angle);
        //NSLog(@"After rotation: %@",rotationRecognizer.view);
        _angle += angle;
        
        rotationRecognizer.rotation = 0.0;
    }
    

}

- (void)zoom:(UIPinchGestureRecognizer *)pinchRecognizer
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture
{
    
    if ([pinchRecognizer.view isDescendantOfView:_gameArea]) {
        CGFloat scale = pinchRecognizer.scale;
        pinchRecognizer.view.transform = CGAffineTransformScale(pinchRecognizer.view.transform, scale, scale);
        pinchRecognizer.scale = 1.0;
    }
    
//	//update properties
//    self.origin = CGPointMake(pinchRecognizer.view.frame.origin.x, pinchRecognizer.view.frame.origin.y);
//    self.width = pinchRecognizer.view.frame.size.width;
//    self.height = pinchRecognizer.view.frame.size.height;
}

//Self defined method to deal with double tap gesture
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer
{
    // This is empty because object types have different destroy implementations.
}


- (BOOL)isInvalidMove:(UIPanGestureRecognizer *)panRecognizer InPalette:(UIView *)palette
{
    if(panRecognizer.view.frame.origin.x > 0 && panRecognizer.view.frame.origin.y == 0)
    {
        return YES;
    }
    if(panRecognizer.view.frame.origin.x >= 0 && (panRecognizer.view.frame.origin.y > 0 && panRecognizer.view.frame.origin.y < palette.frame.size.height))
    {
        return YES;
    }
    if(panRecognizer.view.frame.origin.x < 0)
    {
        return YES;
    }
    if(panRecognizer.view.frame.origin.y < 0)
    {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
