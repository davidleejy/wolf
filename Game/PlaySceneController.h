//
//  PlaySceneController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h> // For chipmunk phy engine
#import "ObjectiveChipmunk.h"

// View classes
@class GameObjectView;
@class WolfView;
@class PigView;
@class BlockView;

// Controller classes
@class GameObject;
@class GameWolf;
@class GamePig;
@class GameBlock;
@class PigPlayController;
@class WolfPlayController;
@class BlockPlayController;
#import "WindBlowController.h";
@class BarController;
@class AngleDialController;

// Model classes
@class GameObjectModel;

@interface PlaySceneController : UIViewController {
    int j; //TODO delete
    
    CADisplayLink *displayLink;
	ChipmunkSpace *space;
    
}

@property (readwrite) GameObjectModel* dataFromLevelDesigner;

// ****** Views being managed ******
@property (readwrite, weak, nonatomic) IBOutlet UIScrollView *battleField;
@property (readwrite) UIProgressView *breathBar;//TODO delete these views

// ***** Controllers being managed ******
@property (readwrite) PigPlayController *pigPlayController;
@property (readwrite) WolfPlayController *wolfPlayController;
@property (readwrite) NSMutableArray *blockPlayControllerArray;
@property (readwrite) NSMutableArray *windBlowControllerArray;
@property (readwrite) BarController *breathPowerBarController;
@property (readwrite) NSTimer* animateBreathPowerBarTimer; //To link wolf with breath power bar
@property (readwrite) AngleDialController *angleDialController;


// ***** Game States ******
@property (readwrite) BreathType wolfBreathType;

// ***** Game Settings *****
//@property (readwrite) windBlowVelocity

// ***** Outlets *****
@property (weak, nonatomic) IBOutlet UITextView *currBreathTypeDisplay;

// ***** Buttons *****
- (IBAction)abort:(id)sender;
- (IBAction)makej1337:(id)sender; //TODO delete
- (IBAction)setWolfBreathTypeToNorm:(id)sender;
- (IBAction)setWolfBreathTypeFire:(id)sender;
- (IBAction)setWolfBreathTypeIce:(id)sender;
- (IBAction)setWolfBreathTypeGrass:(id)sender;



@end
