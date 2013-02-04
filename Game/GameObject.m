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
#import "UIView+ExploreViewHierarchy.h"

@interface GameObject ()

@property (readwrite) GameObjectModel *database;

@property (nonatomic, readwrite) GameObjectType objectType;

@property (nonatomic, readwrite) BOOL isFromPaletteToGameArea;
@property (readwrite) UIScrollView *palette;
@property (readwrite) UIScrollView *gameArea;

// Temporary variables
@property (readwrite) CGPoint initialCoords;
@property (readwrite) UIImageView* playableAreaInGameArea;

@end




@implementation GameObject

@synthesize database = _database;
@synthesize objectType = _objectType;
@synthesize angle = _angle;
@synthesize origin = _origin;
@synthesize paletteLocation = _paletteLocation;
@synthesize width = _width;
@synthesize height = _height;
@synthesize isFromPaletteToGameArea = _isFromPaletteToGameArea;
@synthesize palette = _palette;
@synthesize gameArea = _gameArea;
@synthesize childMostController = _childMostController;


// Temporary variables
@synthesize initialCoords = _initialCoords;
@synthesize playableAreaInGameArea = _playableAreaInGameArea;


- (id) initWith:(GameObjectType)objType
        UnderControlOf:(GameObject*)childMostController
        //LinkToDatabase:(GameObjectModel*) database
        AndPalette:(UIScrollView*)paletteSV
        AndGameArea:(UIScrollView*)gameAreaSV
{
    
    if (self=[super init]) {
        _objectType = objType;
        _palette = paletteSV;
        _gameArea = gameAreaSV;
        _childMostController = childMostController; //for e.g. GameWolf object
        
        // Keep a reference to playable area in game area.
        _playableAreaInGameArea = [_gameArea viewWithTag:3];
        
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
    
    
    
    // *** ps03 Problem 1 ***
    
//    //Load image resources into UIImage objects
//    UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
//    UIImage *wolfsImage = [UIImage imageNamed:@"wolfs.png"];
//    UIImage *strawImage = [UIImage imageNamed:@"straw.png"];
//    
//    //Crop a wolf from wolfs.png
//    CGFloat wolfsHeight = wolfsImage.size.height;
//    CGFloat wolfsWidth = wolfsImage.size.width;
//    CGRect croppingRect = CGRectMake(26, 0, 173, 148);
//    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfsImage CGImage], croppingRect);
//    UIImage *wolfNormalImage = [UIImage imageWithCGImage:wolfImageRef];
//    //CGImageRelease(wolfImageRef);
//    
//    //Place each UIImage object into UIImageView object
//    UIImageView *pig = [[UIImageView alloc]initWithImage:pigImage];
//    UIImageView *straw = [[UIImageView alloc]initWithImage:strawImage];
//    UIImageView *wolfNormal = [[UIImageView alloc]initWithImage:wolfNormalImage];
//    
//    
//    //Get width and height of pig, straw, and wolfNormal
//    CGFloat pigWidth = pigImage.size.width;
//    CGFloat pigHeight = pigImage.size.height;
//    CGFloat strawWidth = strawImage.size.width;
//    CGFloat strawHeight = strawImage.size.height;
//    CGFloat wolfNormalWidth = wolfNormalImage.size.width;
//    CGFloat wolfNormalHeight = wolfNormalImage.size.height;
//    
//    //Find scaling factor to make pig, wolfNormal, and straw images fit into the palette.
//    //Scaling factor should be derived from scaling the height of the images.
//    //
//    //
//    //            scaling_factor = final_height / original_height
//    //
//    //
//    CGFloat paletteHeight = _palette.bounds.size.height;
//    CGFloat wolfNormalScalingFactor = paletteHeight / wolfNormalHeight;
//    CGFloat pigScalingFactor = paletteHeight / pigHeight;
//    CGFloat strawScalingFactor = paletteHeight / strawHeight;
//    
//    //Compute the scaled height and width of the pig, wolfNormal, and straw
//    CGFloat pigScaledHeight = pigHeight * pigScalingFactor;
//    CGFloat pigScaledWidth = pigWidth * pigScalingFactor;
//    CGFloat strawScaledHeight = strawHeight * strawScalingFactor;
//    CGFloat strawScaledWidth = strawWidth * strawScalingFactor;
//    CGFloat wolfNormalScaledHeight = wolfNormalHeight * wolfNormalScalingFactor;
//    CGFloat wolfNormalScaledWidth = wolfNormalWidth * wolfNormalScalingFactor;
//    
//    //Compute the X positions of the pig, wolfNormal, and straw
//    //
//    // Images are positioned as such (from left to right):
//    // wolfNormal, pig, straw
//    //
//    CGFloat bufferSpaceInBetweenItems = 20;
//    CGFloat wolfNormalX = 0;
//    CGFloat pigX = wolfNormalX + wolfNormalScaledWidth + bufferSpaceInBetweenItems;
//    CGFloat strawX = pigX + pigScaledWidth + bufferSpaceInBetweenItems;
//    
//    //The Y positions of the wolfNormal, pig, and straw are the same.
//    //All objects in the palette have the same Y.
//    CGFloat objectsInPaletteY = 0;
//    
//    //Configure the UIImageView objects' frames.
//    wolfNormal.frame = CGRectMake(wolfNormalX, objectsInPaletteY, wolfNormalScaledWidth, wolfNormalScaledHeight);
//    pig.frame = CGRectMake(pigX, objectsInPaletteY, pigScaledHeight,pigScaledWidth);
//    straw.frame = CGRectMake(strawX, objectsInPaletteY, strawScaledHeight, strawScaledWidth);
//    
//    //Add these views as subviews of the palette.
//    [_palette addSubview:wolfNormal];
//    [_palette addSubview:pig];
//    [_palette addSubview:straw];
    
}


- (void)translate:(UIPanGestureRecognizer *)panRecognizer
// MODIFIES: object model (coordinates)
// REQUIRES: game in designer mode
// EFFECTS: the user drags around the object with one finger
// if the object is in the palette, it will be moved in the game area

{
    //UIScrollView* gamearea = (UIScrollView*)[panRecognizer.view.superview.superview viewWithTag:2];
   // UIScrollView* _gameArea = _gameArea;
    //UIView* pallete = [panRecognizer.view.superview.superview viewWithTag:1];
    //UIView* _palette = _palette;
    //UIView* playableArea = [[panRecognizer.view.superview.superview viewWithTag:2] viewWithTag:3];
   // UIView* underneathArea = [[panRecognizer.view.superview.superview viewWithTag:2] viewWithTag:4];
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        _initialCoords = panRecognizer.view.center;
    }
    
    
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];    //Preset the view center
    
    panRecognizer.view.center = CGPointMake(panRecognizer.view.center.x + translation.x, panRecognizer.view.center.y + translation.y);
    
    //NSLog(@"translate panrecog view center: %f %f",panRecognizer.view.center.x,panRecognizer.view.center.y);
    
    //Disable scrolling
    _gameArea.scrollEnabled = NO;
    
    [panRecognizer setTranslation:CGPointZero inView:self.view.superview];
    
    
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
    
    
 /*
    if(panRecognizer.view.superview == _palette)
    {
        if(panRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if([self isInvalidMove:panRecognizer InPalette:_palette])
            {
                panRecognizer.view.center = CGPointMake(self.paletteLocation.x + panRecognizer.view.frame.size.width/2,self.paletteLocation.y + panRecognizer.view.frame.size.height/2);
            }
            
            if (panRecognizer.view.center.y - panRecognizer.view.frame.size.height/2 >= _palette.frame.size.height)
            {
                CGFloat offX = _gameArea.contentOffset.x + panRecognizer.view.center.x;
                panRecognizer.view.center = CGPointMake(offX,panRecognizer.view.center.y - _palette.frame.size.height);
                [_gameArea addSubview:panRecognizer.view];
                //[self scaleCurrentViewToActualSizeWithType:self.objectType];
                
                self.origin = CGPointMake(panRecognizer.view.frame.origin.x, panRecognizer.view.frame.origin.y);
                self.width = panRecognizer.view.frame.size.width;
                self.height = panRecognizer.view.frame.size.height;
				self.isFromPaletteToGameArea = YES;
            }
        }
    }
    
    else if(panRecognizer.view.superview == _gameArea)
    {
        if(panRecognizer.state == UIGestureRecognizerStateEnded)
        {
//            if([self isInvalidPosition:panRecognizer entireGameArea:gamearea entirePlayableArea:playableArea entireUnderneathArea:underneathArea])
//            {
//                panRecognizer.view.center = CGPointMake(self.origin.x + panRecognizer.view.frame.size.width/2, self.origin.y + panRecognizer.view.frame.size.height/2);
//            }
//            else
//            {
                self.origin = CGPointMake(panRecognizer.view.frame.origin.x, panRecognizer.view.frame.origin.y);
                self.width = panRecognizer.view.frame.size.width;
                self.height = panRecognizer.view.frame.size.height;
//            }
        }

    }
    
    
    
    
    _gameArea.scrollEnabled = YES; 
  */
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
    
//    if(panRecognizer.view.frame.origin.y > playArea.frame.size.height - panRecognizer.view.frame.size.height)
//    {
//        return YES;
//    }
//    if(panRecognizer.view.frame.origin.x < 0)
//    {
//        return YES;
//    }
//    if(panRecognizer.view.frame.origin.y < 0)
//    {
//        return YES;
//    }
//    if(panRecognizer.view.frame.origin.x > gameArea.frame.size.width - panRecognizer.view.frame.size.width)
//    {
//        return YES;
//    }
//    return NO;
}

- (void)rotate:(UIRotationGestureRecognizer *)rotationRecognizer
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture
{
    
    if ([rotationRecognizer.view isDescendantOfView:_gameArea]) {
        CGFloat angle = rotationRecognizer.rotation;
        rotationRecognizer.view.transform = CGAffineTransformRotate(rotationRecognizer.view.transform, angle);
        rotationRecognizer.rotation = 0.0;
    }
    
    
//    //update properties
//    self.angle += angle;
//    self.origin = CGPointMake(rotationRecognizer.view.frame.origin.x, rotationRecognizer.view.frame.origin.y);
//    self.width = rotationRecognizer.view.frame.size.width;
//    self.height = rotationRecognizer.view.frame.size.height;
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
    //[self reset];
}

//Self defined method to reset the controller setting as well as the view setting
- (void)reset
{
    self.view.transform = CGAffineTransformRotate(self.view.transform, -self.angle);
    self.view.frame = CGRectMake(self.paletteLocation.x, self.paletteLocation.y, 55, 55);
    self.origin = CGPointMake(self.paletteLocation.x, self.paletteLocation.y);
    self.width = 55;
    self.height = 55;
    self.angle = 0;
//    if(self.view.superview == [self.view.superview.superview viewWithTag:2])
//    {
//        [[self.view.superview.superview viewWithTag:1] addSubview:self.view];
//    }
    
    [_palette addSubview:self.view];
}


//- (void)scaleCurrentViewToActualSizeWithType:(GameObjectType)objectType
//{
//    //scale the imageView to actual size
//    switch(objectType)
//    {
//        case kGameObjectWolf:
//            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,255,150);
//            break;
//            
//        case kGameObjectPig:
//            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,88,88);
//            break;
//            
//        case kGameObjectBlock:
//            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,30,130);
//            break;
//            
//        default:
//            break;
//    }
//}


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
