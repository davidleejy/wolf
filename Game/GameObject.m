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

@property (readwrite) GameObjectModel *model;
@property (nonatomic, readwrite) GameObjectType objectType;

@property (nonatomic, readwrite) BOOL isFromPaletteToGameArea;
@property (readwrite) UIScrollView *palette;
@property (readwrite) UIScrollView *gameArea;

@end




@implementation GameObject

@synthesize model = _model;
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

- (id) initWith:(GameObjectType)objType
 UnderControlOf:(GameObject*)childMostController
     AndPalette:(UIScrollView*)paletteSV
    AndGameArea:(UIScrollView*)gameAreaSV {
    
    if (self=[super init]) {
        _objectType = objType;
        _palette = paletteSV;
        _gameArea = gameAreaSV;
        _childMostController = childMostController; //for e.g. GameWolf object
        return self;
    }
    return nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView* myView;
    
    // Pick a UIImageView based on Game Object type.
    switch (_objectType)
    {
        case kGameObjectWolf:
            myView = [[WolfView alloc]initWithController:_childMostController AndActionFrame:1];
            break;
            
        case kGameObjectPig:
            myView = [[PigView alloc]initDefaultWithController:_childMostController];
            break;
            
        case kGameObjectBlock:
            myView = [[BlockView alloc]initDefaultWithController:_childMostController];
            break;
            
        default:
            break;
    }
    
    //assign view to this view controller
    self.view = myView;
    
    //align view in palette
    self.view.frame = CGRectMake(_paletteLocation.x, _paletteLocation.y, 55, 55);
    
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
    UIScrollView* gamearea = _gameArea;
    //UIView* pallete = [panRecognizer.view.superview.superview viewWithTag:1];
    UIView* pallete = _palette;
    //UIView* playableArea = [[panRecognizer.view.superview.superview viewWithTag:2] viewWithTag:3];
   // UIView* underneathArea = [[panRecognizer.view.superview.superview viewWithTag:2] viewWithTag:4];
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];
    
    //Preset the view center
    panRecognizer.view.center = CGPointMake(self.view.center.x + translation.x, self.view.center.y + translation.y);
    
    //Disable scrolling
    gamearea.scrollEnabled = NO;
    
    
    
	//If current game object is in the palette
    if(panRecognizer.view.superview == _palette)
    {
        NSLog(@"pan.view.superview == palette");
        if(panRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if([self isInvalidMove:panRecognizer InPalette:pallete])
            {
                panRecognizer.view.center = CGPointMake(self.paletteLocation.x + panRecognizer.view.frame.size.width/2,self.paletteLocation.y + panRecognizer.view.frame.size.height/2);
            }
            
            if (panRecognizer.view.center.y - panRecognizer.view.frame.size.height/2 >= pallete.frame.size.height)
            {
                CGFloat offX = gamearea.contentOffset.x + panRecognizer.view.center.x;
                panRecognizer.view.center = CGPointMake(offX,panRecognizer.view.center.y - pallete.frame.size.height);
                [gamearea addSubview:panRecognizer.view];
                [self scaleCurrentViewToActualSizeWithType:self.objectType];
                
                self.origin = CGPointMake(panRecognizer.view.frame.origin.x, panRecognizer.view.frame.origin.y);
                self.width = panRecognizer.view.frame.size.width;
                self.height = panRecognizer.view.frame.size.height;
				self.isFromPaletteToGameArea = YES;
            }
            [panRecognizer.view printSuperViews];
        }
    }
    
    else if(panRecognizer.view.superview == _gameArea)
    {
        NSLog(@"pan.view.superview == gamearea");
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
        [panRecognizer.view printSuperViews];
    }
    
    [panRecognizer setTranslation:CGPointZero inView:self.view.superview];
    gamearea.scrollEnabled = YES;
}

//Self defined method to check whether a game object is underneath
//- (BOOL)isInvalidPosition:(UIPanGestureRecognizer *)panRecognizer entireGameArea:(UIView *)gameArea entirePlayableArea:(UIView*)playArea entireUnderneathArea:(UIView*)underneathArea
//{
//    //NSLog(@"The current origin x is %f",panRecognizer.view.frame.origin.)
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
//}

- (void)rotate:(UIRotationGestureRecognizer *)rotationRecognizer
// MODIFIES: object model (rotation)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is rotated with a two-finger rotation gesture
{
    CGFloat angle = rotationRecognizer.rotation;
    self.view.transform = CGAffineTransformRotate(self.view.transform, angle);
    rotationRecognizer.rotation = 0.0;
    
    //update properties
    self.angle += angle;
    self.origin = CGPointMake(rotationRecognizer.view.frame.origin.x, rotationRecognizer.view.frame.origin.y);
    self.width = rotationRecognizer.view.frame.size.width;
    self.height = rotationRecognizer.view.frame.size.height;
}
- (void)zoom:(UIPinchGestureRecognizer *)pinchRecognizer
// MODIFIES: object model (size)
// REQUIRES: game in designer mode, object in game area
// EFFECTS: the object is scaled up/down with a pinch gesture
{
	CGFloat scale = pinchRecognizer.scale;
    self.view.transform = CGAffineTransformScale(self.view.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
    
	//update properties
    self.origin = CGPointMake(pinchRecognizer.view.frame.origin.x, pinchRecognizer.view.frame.origin.y);
    self.width = pinchRecognizer.view.frame.size.width;
    self.height = pinchRecognizer.view.frame.size.height;
}

//Self defined method to deal with double tap gesture
- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer
{
//    if(self.view.superview != [self.view.superview.superview viewWithTag:1])
//    {
//        [self reset];
//    }
    [self reset];
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


- (void)scaleCurrentViewToActualSizeWithType:(GameObjectType)objectType
{
    //scale the imageView to actual size
    switch(objectType)
    {
        case kGameObjectWolf:
            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,255,150);
            break;
            
        case kGameObjectPig:
            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,88,88);
            break;
            
        case kGameObjectBlock:
            self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,30,130);
            break;
            
        default:
            break;
    }
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
