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
#import "WindBlowController.h"
#import "BarController.h"
#import "AngleDialController.h"

// Model classes
#import "GameObjectModel.h"

// Physics Engine
#import "ObjectiveChipmunk.h"
// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";

// Helper classes
#import "MyMath.h"
#import "ViewHelper.h"


@implementation PlaySceneController

@synthesize battleField = _battleField;
@synthesize dataFromLevelDesigner = _dataFromLevelDesigner;
@synthesize pigPlayController = _pigPlayController;
@synthesize wolfPlayController = _wolfPlayController;
@synthesize blockPlayControllerArray = _blockPlayControllerArray;
@synthesize windBlowControllerArray = _windBlowControllerArray;
@synthesize breathPowerBarController = _breathPowerBarController;
@synthesize animateBreathPowerBarTimer = _animateBreathPowerBarTimer;
@synthesize angleDialController = _angleDialController;
@synthesize score = _score;
@synthesize scoreDisplay = _scoreDisplay;

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
    
    //set color of background (area outside battlefield)
    self.view.backgroundColor = [UIColor blackColor];
    
    //Init breath power bar
    _breathPowerBarController = [[BarController alloc]initForPlayScene];
    [self.view addSubview:_breathPowerBarController.bar];
    
    //Init angle dial
    _angleDialController = [[AngleDialController alloc]initForPlayScene];
    [self.view addSubview:_angleDialController.dialView];

    
    // Create and initialize the space that physics objects can exist in
	space = [[ChipmunkSpace alloc] init];
    space.gravity = cpv(0.0, 1000.0);
	
	[space addBounds:background.bounds thickness:1000.0f elasticity:0.3f friction:0.75f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
    // ****** Collision Handlers *******
    // Here we dictate the "special" effects of certain objects colliding.
    
    // W1. Wind blows disintegrates when it touches ground.
    // W2. Wind blows disintegrates when it touches non-straw blocks.
    // W3. Wind blows lose half power when it touches straw.
    // W4. Wind blows pass through other wind blows.
    // W5. Wind blows pass through wolf.
    // W6. Wind blows (fire) pass through blocks and decreases block's mass.
    // W7. Wind blows (ice) pass through blocks and decreases block's friction.
    // W8. Wind blows (grass) disintegrates when hit blocks and pulls blocks towards itself.
    // W9. Wind blows whack pig.
    // P1. Pig gets whacked by block.
    // P2. Pig gets whacked by border.
    
    // W1.
    [space addCollisionHandler:self
                         typeA:[WindBlowController class] typeB:borderType
                         begin:nil
                      preSolve:nil
                     postSolve:@selector(windBlowDisintegrate:space:)
                      separate:@selector(windBlowDisintegrate:space:)
     ];
    
    // W2., W3., W5., W6., W8.
    [space addCollisionHandler:self
                         typeA:[WindBlowController class] typeB:[BlockPlayController class]
                         begin:@selector(beginCollisionBetweenWindBlowAndBlock:space:)
                      preSolve:nil
                     postSolve:@selector(postSolveCollisionBetweenWindBlowAndBlock:space:)
                      separate:@selector(separateCollisionBetweenWindBlowAndBlock:space:)
     ];
    
    // W4.
    [space addCollisionHandler:self
                         typeA:[WindBlowController class] typeB:[WindBlowController class]
                         begin:@selector(noCollision:space:)
                      preSolve:nil
                     postSolve:nil
                      separate:nil
     ];
    
    // W5.
    [space addCollisionHandler:self
                         typeA:[WindBlowController class] typeB:[WolfPlayController class]
                         begin:@selector(noCollision:space:)
                      preSolve:nil
                     postSolve:nil
                      separate:nil
     ];
    
    
    // W9.
    [space addCollisionHandler:self
                         typeA:[WindBlowController class] typeB:[PigPlayController class]
                         begin:@selector(beginCollisionBetWeenWindBLowAndPig:space:)
                      preSolve:nil
                     postSolve:@selector(postSolveCollisionBetWeenWindBLowAndPig:space:)
                      separate:@selector(separateCollisionBetWeenWindBLowAndPig:space:)
     ];
    
    
    // P1.
    [space addCollisionHandler:self
                         typeA:[PigPlayController class] typeB:[BlockPlayController class]
                         begin:nil
                      preSolve:nil
                     postSolve:@selector(postSolveCollisionBetWeenPigAndBlock:space:)
                      separate:nil
     ];
    
    // P2.
	[space addCollisionHandler:self
                         typeA:[PigPlayController class] typeB:borderType
                         begin:nil
                      preSolve:nil
                     postSolve:@selector(postSolveCollisionBetweenPigAndBorder:space:)
                      separate:nil
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
    [_wolfPlayController.button addTarget:self action:@selector(touchDownWolf) forControlEvents:UIControlEventTouchDown];
    [_wolfPlayController.button addTarget:self action:@selector(touchUpWolf) forControlEvents:UIControlEventTouchUpInside];
    [_wolfPlayController.button addTarget:self action:@selector(touchUpWolf) forControlEvents:UIControlEventTouchUpOutside];
    
    
    // **** Setting Starting Game State ****
    _wolfBreathType = kNorm;
    _currBreathTypeDisplay.text = @"No orb equipped. Your breath is merely fresh and minty.";
    _score = 0;
    [_scoreDisplay setTextColor:[UIColor redColor]];
    [_scoreDisplay setBackgroundColor:[UIColor clearColor]];
    [_scoreDisplay setText:[[NSString alloc]initWithFormat:@"%d",_score]];

}


-(void)windBlowDisintegrate:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, dontCareShape);
    [self realisticDisappearWindBlow:windBlowShape Duration:1];
}


-(bool)noCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    return FALSE;
}



-(bool)beginCollisionBetweenWindBlowAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, blockShape);
    WindBlowController *wPC = windBlowShape.data;
    
    // Record pre collision velocity from first frame of the collision.
	if(cpArbiterIsFirstContact(arbiter)){
        wPC.preCollisionVelocity = wPC.body.vel;
//        NSLog(@"pre collision wind vel: %.9f %.9f",wPC.body.vel.x,wPC.body.vel.y);
    }
    
    if ( wPC.breathType == kNorm || wPC.breathType == kPlasma ) {
        return TRUE;
    }
    else if (wPC.breathType == kFire || wPC.breathType == kIce ) {
        return FALSE; // Effects of fire and ice are resolved in separation collision handler
    }
    else
        return FALSE;
}

-(void)postSolveCollisionBetweenWindBlowAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
	//if(!cpArbiterIsFirstContact(arbiter)) return;
    
    // All types of breaths will enter pre,post,sep collision handlers (if handlers exist) at the very first contact. This is so that breaths can modify the blocks even if they pass through them.
    
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, blockShape);
    
    WindBlowController *wPC = windBlowShape.data;
    BlockPlayController *bPC = blockShape.data;
    
    switch (wPC.breathType) {
        case kNorm: // ~~~~~~ Basic Breath ~~~~~~~
            if (bPC.material == kStraw) {
                [self realisticDisappearWindBlow:windBlowShape Duration:1];
                wPC.body.vel = cpvmult(wPC.preCollisionVelocity, 0.5f);
            }
            else {
                [self realisticDisappearWindBlow:windBlowShape Duration:1];
            }
            break;
        case kPlasma: // ~~~~~~ Plasma Breath ~~~~~~~
            [self realisticDisappearWindBlow:windBlowShape Duration:1];
            bPC.body.vel = cpvmult(bPC.body.vel, -1.5f);
            [ViewHelper embedText:@"Bzzzt!"
                        WithFrame:CGRectMake(bPC.body.pos.x-150/2.0, bPC.body.pos.y, 150, 25)
                        TextColor:[UIColor greenColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            break;
        default:
            break;
    }
    
//    NSLog(@"post solve collision wind vel: %.9f %.9f",wPC.body.vel.x,wPC.body.vel.y);
    
}

-(void)separateCollisionBetweenWindBlowAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, blockShape);
    WindBlowController *wPC = windBlowShape.data;
    BlockPlayController *bPC = blockShape.data;
    
    switch (wPC.breathType) {
        case kFire: // ~~~~~~ Fire Breath ~~~~~~~
        {
            double scaleFactor = 0.75 + (rand()%21)/100.0;
            bPC.body.mass *= scaleFactor;
            NSString* msg = [[NSString alloc]initWithFormat:@"-%d%% DENSITY",(int)((1.0-scaleFactor)*100.0)];
            [ViewHelper embedText:msg
                        WithFrame:CGRectMake(bPC.body.pos.x-150/2.0, bPC.body.pos.y-bPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor redColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            NSLog(@"mass is now %.9f",bPC.body.mass);
            wPC.body.vel = cpvmult(wPC.body.vel, 0.7f);
            
            _score += 1;
            [ViewHelper embedText:@"1 Pt"
                        WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                        TextColor:[UIColor yellowColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            
            //Give chance for blocks to be burnt away.
            int diceRoll = rand()%100;
            if (diceRoll < 5 && bPC.body.mass < 50.0f) {
                [self simpleDisappearBlock:blockShape];
                [ViewHelper embedText:@"BURNT TO ASHES!"
                            WithFrame:CGRectMake(bPC.body.pos.x-150/2.0, bPC.body.pos.y-bPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                            TextColor:[UIColor redColor]
                         DurationSecs:1.2 + (rand()%8)/10.0
                                   In:_battleField];
                
                _score += 100;
                [ViewHelper embedText:@"100 Pts"
                            WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                            TextColor:[UIColor yellowColor]
                         DurationSecs:0.5 + (rand()%8)/10.0
                                   In:_battleField];
            }
            
            break;
        }
        case kIce: // ~~~~~~ Ice Breath ~~~~~~~
        {
            double scaleFactor = 0.75 + (rand()%21)/100.0;
            blockShape.friction *= scaleFactor;
            NSString* msg = [[NSString alloc]initWithFormat:@"-%d%% FRICTION",(int)((1.0-scaleFactor)*100.0)];
            [ViewHelper embedText:msg
                        WithFrame:CGRectMake(bPC.body.pos.x-150/2.0, bPC.body.pos.y-bPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor blueColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            NSLog(@"friction is now %.9f",blockShape.friction);
            wPC.body.vel = cpvmult(wPC.body.vel, 0.7f);
            
            _score += 1;
            [ViewHelper embedText:@"1 Pt"
                        WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                        TextColor:[UIColor yellowColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            
            //Give chance for block to be "iced to death".
            int diceRoll = rand()%100;
            if (diceRoll < 5 && blockShape.friction < 0.20) {
                [self simpleDisappearBlock:blockShape];
                [ViewHelper embedText:@"FROZEN SOLID!"
                            WithFrame:CGRectMake(bPC.body.pos.x-150/2.0, bPC.body.pos.y-bPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                            TextColor:[UIColor blueColor]
                         DurationSecs:1.2 + (rand()%8)/10.0
                                   In:_battleField];
                
                _score += 100;
                [ViewHelper embedText:@"100 Pts"
                            WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                            TextColor:[UIColor yellowColor]
                         DurationSecs:0.5 + (rand()%8)/10.0
                                   In:_battleField];
            }
            break;
        }
        default:
            break;
    }
    
}


// ====== Collision Handlers for when these collide: Wind Blows, Pig =======

-(bool)beginCollisionBetWeenWindBLowAndPig:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, pigShape);
    WindBlowController *wPC = windBlowShape.data;
    
    // Record pre collision velocity from first frame of the collision.
	if(cpArbiterIsFirstContact(arbiter)){
        wPC.preCollisionVelocity = wPC.body.vel;
        //        NSLog(@"pre collision wind vel: %.9f %.9f",wPC.body.vel.x,wPC.body.vel.y);
    }
    
    if ( wPC.breathType == kNorm || wPC.breathType == kPlasma ) {
        return TRUE;
    }
    else if (wPC.breathType == kFire || wPC.breathType == kIce ) {
        return FALSE;
    }
    else
        return FALSE;
}


-(void)postSolveCollisionBetWeenWindBLowAndPig:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {

    // We only care about the first frame of the collision.
	if(!cpArbiterIsFirstContact(arbiter)) return;
    
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, pigShape);
    
    WindBlowController *wPC = windBlowShape.data;
    PigPlayController *pPC = pigShape.data;
    
    cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    
    switch (wPC.breathType) {
        case kNorm: // ~~~~~~ Basic Breath ~~~~~~~
        {
            [self realisticDisappearWindBlow:windBlowShape Duration:1];
            [ViewHelper embedText:@"GO AWAY!"
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y, 150, 25)
                        TextColor:[UIColor whiteColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            int pts = (int)(impulse/300.0);
            _score += pts;
            NSString* ptsEarned = [[NSString alloc]initWithFormat:@"%d Pts",pts];
            
            [ViewHelper embedText:ptsEarned
                        WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                        TextColor:[UIColor yellowColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            break;
        }
        case kPlasma: // ~~~~~~ Plasma Breath ~~~~~~~
        {
            [self realisticDisappearWindBlow:windBlowShape Duration:1];
            pPC.body.vel = cpvmult(pPC.body.vel, -1.6f);
            [ViewHelper embedText:@"Stop messing around!"
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y, 150, 25)
                        TextColor:[UIColor whiteColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            int pts = (int)(impulse/1000.0);
            _score += pts;
            
            NSString* ptsEarned = [[NSString alloc]initWithFormat:@"%d Pts",pts];

            [ViewHelper embedText:ptsEarned
                        WithFrame:CGRectMake(wPC.body.pos.x-150/2.0, wPC.body.pos.y, 150, 25)
                        TextColor:[UIColor yellowColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            break;
        }
        default:
            break;
    }
    
    
}


-(void)separateCollisionBetWeenWindBLowAndPig:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, windBlowShape, pigShape);
    WindBlowController *wPC = windBlowShape.data;
    PigPlayController *pPC = pigShape.data;
    
    switch (wPC.breathType) {
        case kFire: // ~~~~~~ Fire Breath ~~~~~~~
        {
            double scaleFactor = 0.95 + (rand()%6)/100.0;
            pPC.body.mass *= scaleFactor;
            NSString* msg = [[NSString alloc]initWithFormat:@"+%d%% ROASTED",(int)((1.0-scaleFactor)*100.0)];
            [ViewHelper embedText:msg
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor redColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            
            wPC.body.vel = cpvmult(wPC.body.vel, 0.4f);
            
            [ViewHelper embedText:@"Hot!! Hot!! Hot!!"
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor whiteColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            
            [self realisticDisappearWindBlow:windBlowShape Duration:1];
            
            break;
        }
        case kIce: // ~~~~~~ Ice Breath ~~~~~~~
        {
            double scaleFactor = 0.95 + (rand()%6)/100.0;
            pigShape.friction *= scaleFactor;
            NSString* msg = [[NSString alloc]initWithFormat:@"+%d%% FROZEN",(int)((1.0-scaleFactor)*100.0)];
            [ViewHelper embedText:msg
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor blueColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            [ViewHelper embedText:@"Co..co..coldd!"
                        WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                        TextColor:[UIColor whiteColor]
                     DurationSecs:0.5 + (rand()%8)/10.0
                               In:_battleField];
            wPC.body.vel = cpvmult(wPC.body.vel, 0.4f);
            
            [self realisticDisappearWindBlow:windBlowShape Duration:1];
            break;
        }
        default:
            break;
    }
}




// ====== Collision Handlers for when these collide: Pig, Block =======

- (void)postSolveCollisionBetWeenPigAndBlock:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    
	// We only care about the first frame of the collision.
	if(!cpArbiterIsFirstContact(arbiter)) return;
	
    CHIPMUNK_ARBITER_GET_SHAPES(arbiter, pigShape, blockShape);
    PigPlayController *pPC = pigShape.data;
    
   
    
	cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
    
    int pts = (int)(impulse/400.0);
    _score += pts;
    NSString* ptsEarned = [[NSString alloc]initWithFormat:@"%d Pts",pts];
    [ViewHelper embedText:ptsEarned
                WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                TextColor:[UIColor yellowColor]
             DurationSecs:0.5 + (rand()%8)/10.0
                       In:_battleField];
    if (pts < 50) {
        [ViewHelper embedText:@"zz..ZZZ...."
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts < 100) {
        [ViewHelper embedText:@"Snort~"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts < 200) {
        [ViewHelper embedText:@"Yikes!"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts < 300) {
        [ViewHelper embedText:@"Ow!"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts < 400) {
        [ViewHelper embedText:@"STOP IT!"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts < 500) {
        [ViewHelper embedText:@"ARRR!"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    else if (pts >= 600) {
        [ViewHelper embedText:@"Ow! Arrrr! Ow!!!"
                    WithFrame:CGRectMake(pPC.body.pos.x-150/2.0, pPC.body.pos.y-pPC.button.frame.size.height*((rand()%101)/100.0), 150, 25)
                    TextColor:[UIColor whiteColor]
                 DurationSecs:0.5 + (rand()%8)/10.0
                           In:_battleField];
    }
    
}


// ====== Collision Handlers for when these collide: Pig, Border =======

- (void)postSolveCollisionBetweenPigAndBorder:(cpArbiter*)arbiter space:(ChipmunkSpace*)space1 {
    
	// We only care about the first frame of the collision.
	if(!cpArbiterIsFirstContact(arbiter)) return;
}




static CGFloat frand(){return (CGFloat)rand()/(CGFloat)RAND_MAX;}


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
	
	// Update all physics objects
	[_pigPlayController updatePosition];
    [_wolfPlayController updatePosition];
    for (int i = 0; i<_blockPlayControllerArray.count; i++) {
        [[_blockPlayControllerArray objectAtIndex:i] updatePosition];
    }
    for (int i = 0; i<_windBlowControllerArray.count; i++) {
        [[_windBlowControllerArray objectAtIndex:i] updatePosition];
    }
    [self updateScoreDisplay];
    
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
/* space here refer to battlefield */


- (void) wolfBlowsWind:(NSNumber*)strengthFactor{
    [_wolfPlayController animateOneBlowThatCompletesInSecs:0.7]; // wolf huffs and puffs
    [self performSelector:@selector(generateWindWithFactor:) withObject:strengthFactor afterDelay:0.5]; // wind is generated when he puffs
}


- (void) generateWindWithFactor:(NSNumber*)f{
    double windBlowCenterX = _wolfPlayController.body.pos.x + _wolfPlayController.button.imageView.frame.size.width/2.0 + 20;
    double windBlowCenterY = _wolfPlayController.body.pos.y - _wolfPlayController.button.frame.size.height/3.5;
    
    WindBlowController* wBPC = [[WindBlowController alloc]initWithTransform:CGAffineTransformIdentity
                                                                     Bounds:CGRectMake(0, 0, 80, 80)
                                                                     Center:CGPointMake(windBlowCenterX, windBlowCenterY)
                                                                 BreathType:_wolfBreathType];
    
    [_windBlowControllerArray addObject:wBPC];
    
    double fd = [f doubleValue];
    
    cpVect unitDirV = cpvforangle(-[_angleDialController angleShown]);
    cpVect v = cpvmult(unitDirV, fd*2000);
	wBPC.body.vel = v;
    
    [wBPC animateWithDeltaTime:0.1 RepeatCount:0];//repeat forever
    
    
    [space add:wBPC];
    [_battleField addSubview:wBPC.button];
    
//    //wolf's mouth marker
//    UIImageView *mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:BLOCK_WOOD_IMAGE_PATH]];
//    [_battleField addSubview:mark];
//    mark.frame = CGRectMake(windBlowCenterX, windBlowCenterY, 5, 5);
	
    
//    NSLog(@"angle shown %.9f",[_angleDialController angleShown]);
    
}


// ======= Functions to make objects disappear =========
/* space here refer to battlefield */

- (void)simpleDisappearWindBlow:(ChipmunkShape*) windBlowShape {
    WindBlowController *wPC = windBlowShape.data;
    [wPC.button removeFromSuperview];
    [_windBlowControllerArray removeObjectIdenticalTo:wPC];
    [space addPostStepRemoval:windBlowShape];
}

- (void)simpleDisappearBlock:(ChipmunkShape*) blockShape {
    BlockPlayController *bPC = blockShape.data;
    [bPC.button removeFromSuperview];
    [_blockPlayControllerArray removeObjectIdenticalTo:bPC];
    [space addPostStepRemoval:blockShape];
}

-(void)realisticDisappearWindBlow:(ChipmunkShape*)windBlowShape Duration:(double)secs{
    WindBlowController *wPC = windBlowShape.data;
    [_windBlowControllerArray removeObjectIdenticalTo:wPC]; //critical in making the updating of the wind blow view stop where it is on the screen.
    [wPC animateDispersionWithDurationSecs:secs];
    [wPC.button performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:secs];
    [space addPostStepRemoval:windBlowShape]; //critical
}


// ====== Pressing the wolf during the game ======

-(void)touchDownWolf {
    [self startAnimatingBreathPowerBar];
}

-(void)touchUpWolf {
    [self stopAnimatingBreathPowerBar];
    [self performSelector:@selector(wolfBlowsWind:) withObject:[NSNumber numberWithDouble:_breathPowerBarController.bar.progress] afterDelay:0.4];
    [_breathPowerBarController performSelector:@selector(resetZero) withObject:nil afterDelay:0.4];
}


// ====== Score functions ======

- (void)updateScoreDisplay {
    [_scoreDisplay setText:[[NSString alloc]initWithFormat:@"%d",_score]];
}



// ======= Buttons ========

- (IBAction)abort:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setWolfBreathTypeToNorm:(id)sender {
    _wolfBreathType = kNorm;
    _currBreathTypeDisplay.text = @"No orb equipped. Fresh and minty breath.";
}

- (IBAction)setWolfBreathTypeFire:(id)sender {
    _wolfBreathType = kFire;
    _currBreathTypeDisplay.text = @"Orb of Embers equipped. A breath imbued with fire eats away at the insides of whatever it touches.";
}

- (IBAction)setWolfBreathTypeIce:(id)sender {
    _wolfBreathType = kIce;
    _currBreathTypeDisplay.text = @"Orb of Frost equipped. A frosty breath coats whatever it touches with a thin layer of ice.";
}

- (IBAction)setWolfBreathTypeGrass:(id)sender {
    _wolfBreathType = kPlasma;
    _currBreathTypeDisplay.text = @"Orb of Plasma equipped. An electrically charged breath pulls objects.";
}



- (void)viewDidUnload {
    [self setScoreDisplay:nil];
    [super viewDidUnload];
}
@end
