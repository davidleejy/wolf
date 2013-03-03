//
//  PlaySceneController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

// View classes
#import "GameObjectView.h"
#import "PigView.h"
#import "WolfView.h"
#import "BlockView.h"

// Controller classes
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"
#import "PlaySceneController.h"
#import "PigPlayController.h"
#import "WolfPlayController.h"
#import "BlockPlayController.h"
#import "BreathPlayController.h"
#import "BarController.h"
#import "AngleDialController.h"

// Model classes
#import "GameObjectModel.h"

// Physics Engine
#import "ObjectiveChipmunk.h"
// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";

//Math
#import "MyMath.h"


@implementation PlaySceneController

@synthesize battleField = _battleField;
@synthesize dataFromLevelDesigner = _dataFromLevelDesigner;
@synthesize pigView = _pigView;
@synthesize wolfView = _wolfView;
@synthesize blockViewArray = _blockViewArray;
@synthesize pigPlayController = _pigPlayController;
@synthesize wolfPlayController = _wolfPlayController;
@synthesize blockPlayControllerArray = _blockPlayControllerArray;
@synthesize windBlowControllerArray = _windBlowControllerArray;
@synthesize breathBar = _breathBar;
@synthesize breathPowerBarController = _breathPowerBarController;
@synthesize animateBreathPowerBarTimer = _animateBreathPowerBarTimer;
@synthesize angleDialController = _angleDialController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //battleField's properties can be overwritten by source VC.
    // *** Create Battle Field ***
    
    //Load image resources into UIImage objects
    UIImage *bgImage = [UIImage imageNamed:@"background.png"];
    UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
    
    //Place each UIImage object into UIImageView object
    UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
    UIImageView *ground = [[ UIImageView alloc] initWithImage:groundImage];
    
    //Get the width and height of the 2 images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    CGFloat groundWidth = groundImage.size.width;
    CGFloat groundHeight = groundImage.size.height;
    
    //Compute the y position for the two UIImageView
    CGFloat groundY = _battleField.frame.size.height - groundHeight;
    CGFloat backgroundY = groundY - backgroundHeight;
    
    //The frame property holds the position and size of the views.
    //The CGRectMake methods arguments are: x position, y position, width, height.
    background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
    ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
    
    //Add these views as subviews of the gamearea.
    [_battleField addSubview:background];
    [_battleField addSubview:ground];
    
    //Set the content size so that the gamearea is scrollable.
    //Otherwise it defaults to the current window size.
    CGFloat gameareaHeight = backgroundHeight + groundHeight;
    CGFloat gameareaWidth = backgroundWidth;
    [_battleField setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
    
    
    //Init breath power bar
    _breathPowerBarController = [[BarController alloc]initForPlayScene];
    [self.view addSubview:_breathPowerBarController.bar];
    
    //Init angle dial
    _angleDialController = [[AngleDialController alloc]initForPlayScene];
    [self.view addSubview:_angleDialController.dialView];

    
    // Create and initialize the Chipmunk space.
	// Chipmunk spaces are containers for simulating physics.
	space = [[ChipmunkSpace alloc] init];
    space.gravity = cpv(0.0, 1000.0);
	
	// This method adds four static line segment shapes to the space.
	// Most 2D physics games end up putting all the gameplay in a box.
	// We'll tag these segment shapes with the borderType object. You'll see what this is for next.
	[space addBounds:background.bounds thickness:10.0f elasticity:1.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	// This adds a callback that happens whenever a shape tagged with the
	// [FallingButton class] object and borderType objects collide.
	// You can use any object you want as a collision type identifier.
	// I often find it convenient to use class objects to define collision types.
	// There are 4 different collision events that you can catch: begin, pre-solve, post-solve and separate.
	// See the documentation for a description of what they are all for.
    
    
    // ****** Collision Handlers *******
    // Here we dictate what happens between objects when they collide.
    
    // W1. Wind blows disintegrates when it touches ground.
    // W2. Wind blows disintegrates when it touches non-straw blocks.
    // W3. Wind blows lose half power when it touches straw.
    // W4. Wind blows pass through other wind blows.
    // W5. Wind blows pass through wolf.
    
    // W1.
    [space addCollisionHandler:self
                         typeA:[BreathPlayController class] typeB:borderType
                         begin:nil
                      preSolve:nil
                     postSolve:nil
                      separate:@selector(windBlowDisintegrate:space:)
     ];
    
    // W2. & W3.
    [space addCollisionHandler:self
                         typeA:[BreathPlayController class] typeB:[BlockPlayController class]
                         begin:@selector(beginCollisionBetweenWindBlowAndBlock:space:)
                      preSolve:nil
                     postSolve:@selector(postSolveCollisionBetweenWindBlowAndBlock:space:)
                      separate:nil
     ];
    
    // W4.
    [space addCollisionHandler:self
                         typeA:[BreathPlayController class] typeB:[BreathPlayController class]
                         begin:@selector(noCollision:space:)
                      preSolve:nil
                     postSolve:nil
                      separate:nil
     ];
    
    // W5.
    [space addCollisionHandler:self
                         typeA:[BreathPlayController class] typeB:[WolfPlayController class]
                         begin:@selector(noCollision:space:)
                      preSolve:nil
                     postSolve:nil
                      separate:nil
     ];
    
    
	[space addCollisionHandler:self
                         typeA:[PigPlayController class] typeB:borderType
                         begin:@selector(beginCollision:space:)
                      preSolve:nil
                     postSolve:@selector(postSolveCollision:space:)
                      separate:@selector(separateCollision:space:)
     ];
    
    

    
    // ******* Initialise play controllers *******
    
    _pigPlayController = [[PigPlayController alloc]initWithTransform:_dataFromLevelDesigner.pigV.transform
                                                              Bounds:_dataFromLevelDesigner.pigV.bounds
                                                               Frame:_dataFromLevelDesigner.pigV.frame
                                                              Center:_dataFromLevelDesigner.pigV.center];
    
    _wolfPlayController = [[WolfPlayController alloc]initWithTransform:_dataFromLevelDesigner.wolfV.transform Bounds:_dataFromLevelDesigner.wolfV.bounds Center:_dataFromLevelDesigner.wolfV.center];
    
    // Initialising block controllers and
    // add block controllers into an array.
    _blockPlayControllerArray = [[NSMutableArray alloc]init]; // IMPORTANT!

    for (int i = 0; i<_dataFromLevelDesigner.blocksVArray.count; i++) {
        
        BlockView* aSavedView = [_dataFromLevelDesigner.blocksVArray objectAtIndex:i];
        
        NSString *pathName;
        
        switch (aSavedView.currentMaterial) {
            case 0:
                pathName = BLOCK_STRAW_IMAGE_PATH;
                break;
            case 1:
                pathName = BLOCK_WOOD_IMAGE_PATH;
                break;
            case 2:
                pathName = BLOCK_IRON_IMAGE_PATH;
                break;
            case 3:
                pathName = BLOCK_STONE_IMAGE_PATH;
                break;
            default:
                [NSException raise:@"Unrecognized Material!" format:@"material num: %d",aSavedView.currentMaterial];
                break;
        }
        
        BlockPlayController* tempBPC = [[BlockPlayController alloc]initWithTransform:aSavedView.transform Bounds:aSavedView.bounds Center:aSavedView.center ImagePath:pathName];
        
        [_blockPlayControllerArray addObject:tempBPC];
    }
    
    
    _windBlowControllerArray = [[NSMutableArray alloc]init]; // VERY IMPORTANT TO INIT!! OTHERWISE LATER CAN'T USE THIS ARRAY.  ALSO COMPILER WON'T GIVE ANY RUNTIME OR COMPILETIME ERRORS!!

    
    
	// Add the buttons in controllers to the view hierarchy.
    
	[_battleField addSubview:_pigPlayController.button];
    
    [_battleField addSubview:_wolfPlayController.button];
    
    for (int i = 0; i<_blockPlayControllerArray.count; i++) {
        
        BlockPlayController* tempBPC = [_blockPlayControllerArray objectAtIndex:i];
        [_battleField addSubview:tempBPC.button];
    }
    
    
    
	
	// Adding physics objects
    
	[space add:_pigPlayController];
    
    [space add:_wolfPlayController];
    
    for (int i = 0; i<_blockPlayControllerArray.count; i++) {
        [space add:[_blockPlayControllerArray objectAtIndex:i]];
    }
    
    
    
    // **** Making connections ****
    
    // Connect wolf with breath power bar...
    // When wolf is held down by finger, breath power bar's progress oscillates.
    // I also call the oscillation "bubbling".
    [_wolfPlayController.button addTarget:self action:@selector(startAnimatingBreathPowerBar) forControlEvents:UIControlEventTouchDown];
    [_wolfPlayController.button addTarget:self action:@selector(stopAnimatingBreathPowerBar) forControlEvents:UIControlEventTouchUpInside];
    [_wolfPlayController.button addTarget:self action:@selector(stopAnimatingBreathPowerBar) forControlEvents:UIControlEventTouchUpOutside];
    
    

    
    
    //TODO TESTING A3
//    UIImage * b1i = [_breathPlayController windBlowInFrame:4 Of:WINDBLOW_SPRITESCREEN_PATH];
//    UIImageView *b1iv = [[UIImageView alloc]initWithImage:b1i];
//    [_battleField addSubview:b1iv];
    // TESTING TODO A3
    
    
    //TODO TESTING DIAL
//    UIImageView *mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:BLOCK_WOOD_IMAGE_PATH]];
//     UIImageView *mark2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:BLOCK_WOOD_IMAGE_PATH]];
//    
//    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ANGLE_DIAL_ARROW_DESELECTED_PATH]];
//    
//    [arrow addSubview:mark];
//    mark.frame = CGRectMake(arrow.center.x, arrow.center.y, 5, 5);
//    
//    
//    mark2.frame = CGRectMake(0, 0, 5, 5);
//
//    
//    UIImageView *dialMarkings = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ANGLE_DIAL_PATH]];
//    
//    
//    UIImageView *dial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
//                                                                     dialMarkings.frame.size.width+40
//                                                                     ,
//                                                                     dialMarkings.frame.size.height)];
//    
//    
//    dialMarkings.frame = CGRectMake(dial.frame.size.width-dialMarkings.frame.size.width,
//                                    0,
//                                    dialMarkings.frame.size.width,
//                                    dialMarkings.frame.size.height);
//    [dial addSubview:dialMarkings];
//    
//    [dial addSubview:mark2];//todo delete
//    
//    [dial addSubview:arrow];
//    
//
//    arrow.transform = CGAffineTransformScale(arrow.transform, 0.6, 0.6);
//    arrow.center = CGPointMake(50, dial.frame.size.height/2.0+20);
//    arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI/2.0);
//
//    
//    [_battleField addSubview:dial];
    
    
    NSLog(@"j begins with%d",j); //TODO delete
}


-(void)windBlowDisintegrate:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, dontCareShape);
    BreathPlayController *x = windBlowShape.data;
    [x.button removeFromSuperview];
    [_windBlowControllerArray removeObjectIdenticalTo:x];
    [space1 addPostStepRemoval:windBlowShape];
}


-(bool)noCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    return FALSE;
}


-(bool)beginCollisionBetweenWindBlowAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    // Record pre collision velocity from first frame of the collision.
	if(cpArbiterIsFirstContact(arbiter)){
        CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, blockShape);
        BreathPlayController *wPC = windBlowShape.data;
        wPC.preCollisionVelocity = wPC.body.vel;
//        NSLog(@"pre collision wind vel: %.9f %.9f",wPC.body.vel.x,wPC.body.vel.y);
    }
    
    return TRUE;
}

-(void)postSolveCollisionBetweenWindBlowAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    
    // We only care about the first frame of the collision.
	// If the shapes have been colliding for more than one frame, return early.
	//if(!cpArbiterIsFirstContact(arbiter)) return;
    
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, blockShape);
    
    BreathPlayController *wPC = windBlowShape.data;
    BlockPlayController *bPC = blockShape.data;
    
    switch (bPC.material) {
        case kStraw:
            [bPC.button removeFromSuperview];
            [_blockPlayControllerArray removeObjectIdenticalTo:bPC];
            [space1 addPostStepRemoval:blockShape];
            wPC.body.vel = cpvmult(wPC.preCollisionVelocity, 0.5f);
            break;
            
        default:
            [wPC.button removeFromSuperview];
            [_windBlowControllerArray removeObjectIdenticalTo:wPC];
            [space1 addPostStepRemoval:windBlowShape];
            break;
    }
    
//    NSLog(@"post solve collision wind vel: %.9f %.9f",wPC.body.vel.x,wPC.body.vel.y);
    
}


- (bool)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	// This macro gets the colliding shapes from the arbiter and defines variables for them.
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
	
	// It expands to look something like this:
	// ChipmunkShape *buttonShape = GetShapeWithFirstCollisionType();
	// ChipmunkShape *border = GetShapeWithSecondCollisionType();
	
	// Lets log the data pointers just to make sure we are getting what we think we are.
	NSLog(@"First object in the collision is %@ second object is %@.", buttonShape.data, border.data);
    NSLog(@"First object agle rot %.9f.", buttonShape.body.angle);
	
	// When we created the collision shape for the FallingButton,
	// we set the data pointer to point at the FallingButton it was associated with.
	PigPlayController *fb = buttonShape.data;
	
	// Increment the touchedShapes counter on the FallingButton object.
	// We'll decrement this in the separate callback.
	// If the counter is 0, then you know you aren't touching anything.
	// You can use this technique in platformer games to track if the player is in the air on not.
	fb.touchedShapes++;
	
	// Change the background color to gray so we know when the button is touching something.
	self.view.backgroundColor = [UIColor grayColor];
    
	// begin and pre-solve callbacks MUST return a boolean.
	// Returning false from a begin callback ignores a collision permanently.
	// Returning false from a pre-solve callback ignores the collision for just one frame.
	// See the documentation on collision handlers for more information.
	return TRUE; // We return true, so the collision is handled normally.
    
}

// The post-solve collision callback is called right after Chipmunk has finished calculating all of the
// collision responses. You can use it to find out how hard objects hit each other.
// There is also a pre-solve callback that allows you to reject collisions conditionally.
- (void)postSolveCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    
	// We only care about the first frame of the collision.
	// If the shapes have been colliding for more than one frame, return early.
	if(!cpArbiterIsFirstContact(arbiter)) return;
	
	// This method gets the impulse that was applied between the two objects to resolve
	// the collision. We'll use the length of the impulse vector to approximate the sound
	// volume to play for the collision.
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    
    
	
}

static CGFloat frand(){return (CGFloat)rand()/(CGFloat)RAND_MAX;}

// The separate callback is called whenever shapes stop touching.
- (void)separateCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, buttonShape, border);
	
	// Decrement the counter on the FallingButton.
	PigPlayController *fb = buttonShape.data;
	fb.touchedShapes--;
	
	// If touchedShapes is 0, then we know the falling button isn't touching anything anymore.
	if(fb.touchedShapes == 0){
		// Let's set the background color to a random color so you can see each time the shape touches something new.
		self.view.backgroundColor = [UIColor colorWithRed:frand() green:frand() blue:frand() alpha:1.0f];
	}
    
    
    //TODO removal cpo
//    [space1 addPostStepRemoval:buttonShape];
//    [_pigPlayController.button removeFromSuperview];
//    _pigPlayController = nil;
}

// When the view appears on the screen, start the animation timer.
- (void)viewDidAppear:(BOOL)animated {
	// Set up the display link to control the timing of the animation.
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	displayLink.frameInterval = 1;
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	
}

// This method is called each frame to update the scene.
// It is called from the display link every time the screen wants to redraw itself.
- (void)update {
	// Step (simulate) the space based on the time since the last update.
	cpFloat dt = displayLink.duration*displayLink.frameInterval;
	[space step:dt];
	
	// This sets the position and rotation of the button to match the rigid body.
	[_pigPlayController updatePosition];
    [_wolfPlayController updatePosition];
    for (int i = 0; i<_blockPlayControllerArray.count; i++) {
        [[_blockPlayControllerArray objectAtIndex:i] updatePosition];
    }
    for (int i = 0; i<_windBlowControllerArray.count; i++) {
        [[_windBlowControllerArray objectAtIndex:i] updatePosition];
    }
    
}

// The view disappeared. Stop the animation timers.
- (void)viewDidDisappear:(BOOL)animated {
	// Remove the timer.
	[displayLink invalidate];
	displayLink = nil;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (IBAction)abort:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)makej1337:(id)sender {
    j = 1337;
    NSLog(@"j is now %d",j);
    [_wolfPlayController animateBlowWithDeltaTime:0.3 RepeatCount:1];
    
    
    //TODO testing breath generation.
    double windBlowCenterX = _wolfPlayController.body.pos.x +
    _wolfPlayController.button.imageView.frame.size.width/2.0;
    double windBlowCenterY = _wolfPlayController.body.pos.y - _wolfPlayController.button.frame.size.height/3.0;
    
    BreathPlayController* wBPC = [[BreathPlayController alloc]initWithTransform:CGAffineTransformIdentity
                                                                         Bounds:CGRectMake(0, 0, 80, 80)
                                                                         Center:CGPointMake(windBlowCenterX, windBlowCenterY)];
    
    [_windBlowControllerArray addObject:wBPC];
    
    [wBPC animateWithDeltaTime:0.1 RepeatCount:0];//repeat forever
    
    [_battleField addSubview:wBPC.button];
    [space add:wBPC];
    
    //markers
    UIImageView *mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:BLOCK_WOOD_IMAGE_PATH]];
    [_battleField addSubview:mark];
    mark.frame = CGRectMake(windBlowCenterX, windBlowCenterY, 5, 5);
	
    
    NSLog(@"angle shown %.9f",[_angleDialController angleShown]);
    
    cpVect unitDirV = cpvforangle(-[_angleDialController angleShown]);
    cpVect v = cpvmult(unitDirV, _breathPowerBarController.bar.progress*2000);
	wBPC.body.vel = v;
    
    NSLog(@"num of blocks left %d",_blockPlayControllerArray.count);
    NSLog(@"num of breaths left %d",_windBlowControllerArray.count);
}


// ======= Breath Bar Functions =========

- (void)bubbleTheBreathePowerBar {
    [_breathPowerBarController bubbleTheBar:0.005];
}

- (void)startAnimatingBreathPowerBar {
    _animateBreathPowerBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(bubbleTheBreathePowerBar) userInfo:nil repeats:YES];
}

- (void)stopAnimatingBreathPowerBar {
    [_animateBreathPowerBarTimer invalidate];
    _animateBreathPowerBarTimer = nil;
}


// ======= Wolf Attack Functions ========= 


// ======= Functions to make chipmunk physics objects disappear =========



- (void) populateBattleFieldWithDataFromLevelDesigner {
    
//    //Load _pigView with _dataFromLevelDesigner
//    _pigView = [[PigView alloc]initDefaultWithController:self];
//    _pigView.transform = _dataFromLevelDesigner.pigV.transform;
//    _pigView.frame = _dataFromLevelDesigner.pigV.frame;
//    _pigView.bounds = _dataFromLevelDesigner.pigV.bounds;
//    [_battleField addSubview:_pigView];
//    
//    //Load _wolfView with _dataFromLevelDesigner
//    _wolfView = [[WolfView alloc]initDefaultWithController:self];
//    _wolfView.transform = _dataFromLevelDesigner.wolfV.transform;
//    _wolfView.frame = _dataFromLevelDesigner.wolfV.frame;
//    _wolfView.bounds = _dataFromLevelDesigner.wolfV.bounds;
//    [_battleField addSubview:_wolfView];
//    
//    //Load _blockViewArray with _dataFromLevelDesigner
//    _blockViewArray = [[NSMutableArray alloc]init];
//    
//    for (int i = 0; i < _dataFromLevelDesigner.blocksVArray.count; i++) {
//        
//        BlockView* savedView = [_dataFromLevelDesigner.blocksVArray objectAtIndex:i];
//        BlockView* newView = [[BlockView alloc] initDefaultWithController:self];
//        
//        // configure the newView to have the same settings like savedView
//        newView.transform = savedView.transform;
//        newView.frame = savedView.frame;
//        newView.bounds = savedView.bounds;
//        [newView showMaterial:savedView.currentMaterial];
//        
//        // add to game area
//        [_battleField addSubview:newView];
//        
//        // add to game area containment array
//        [_blockViewArray addObject:newView];
//    }
    
    
    
}

@end
