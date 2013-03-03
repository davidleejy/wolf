//
//  BreathPlayController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BreathPlayController.h"
#import "DeveloperSettings.h"
#import "MyMath.h"
#import <QuartzCore/QuartzCore.h>

@interface BreathPlayController ()
@property (readwrite) NSMutableArray* windBlowSequence;
@end

@implementation BreathPlayController

@synthesize button = _button;
@synthesize touchedShapes = _touchedShapes;
@synthesize body = _body;
@synthesize chipmunkObjects = _chipmunkObjects;
@synthesize windBlowSequence = _windBlowSequence;

static cpFloat frand_unit(){return 2.0f*((cpFloat)rand()/(cpFloat)RAND_MAX) - 1.0f;}

- (void)buttonClicked {
	// Apply a random velcity change to the body when the button is clicked.
	cpVect v = cpvmult(cpv(frand_unit(), frand_unit()), 300.0f);
	_body.vel = cpvadd(_body.vel, v);
	
	_body.angVel += 5.0f*frand_unit();
}

- (void)updatePosition {
	_button.transform = _body.affineTransform;
}

- (id) init { //TODO delete
    
    self = [super init];
    if (!self) return nil;
    
    //Cut up sprites from sprite screen and populate _windblowsequence
    _windBlowSequence = [[NSMutableArray alloc]init];
    for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
        [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW_SPRITESCREEN_PATH]];
    }
    
    
    //put into button
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"breath" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_button setImage:[_windBlowSequence objectAtIndex:0] forState:UIControlStateNormal];
    _button.bounds = CGRectMake(0, 0,((UIImage*)[_windBlowSequence objectAtIndex:0]).size.width, ((UIImage*)[_windBlowSequence objectAtIndex:0]).size.height);
    _button.frame = CGRectMake(600, 200,
                               ((UIImage*)[_windBlowSequence objectAtIndex:0]).size.width,
                               ((UIImage*)[_windBlowSequence objectAtIndex:0]).size.height);
    
    return self;
}

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter {
    if(self = [super init]){
        
        //Cut up sprites from sprite screen and populate _windblowsequence
        _windBlowSequence = [[NSMutableArray alloc]init];
        for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
            [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW_SPRITESCREEN_PATH]];
        }
        
        //Find actual size:
        double widthActual = [MyMath horizScaleFactorOf:myTransform]*myBounds.size.width;
        double heightActual = [MyMath vertScaleFactorOf:myTransform]*myBounds.size.height;
        
        //Get image
        UIImageView* pic = [[UIImageView alloc]initWithImage:[_windBlowSequence objectAtIndex:0]];
        pic.bounds = CGRectMake(0, 0, widthActual, heightActual);
        // Using QuartzCore to grab a UIImage object that is the same size as its UIImageView
        UIGraphicsBeginImageContext(pic.bounds.size);
        [pic.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
		// Set up the breath picture
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button setTitle:@"Breath" forState:UIControlStateNormal];
		[_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[_button setImage:resultingImage forState:UIControlStateNormal];
        _button.bounds = CGRectMake(0, 0, widthActual, heightActual);
        
        
		[_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchDown];
		
		// Set up Chipmunk objects.
		cpFloat mass = 1.0f;
		
		// The moment of inertia is like the rotational mass of an object.
		// Chipmunk provides a number of helper functions to help you estimate the moment of inertia.
		cpFloat moment = cpMomentForBox(mass, widthActual, heightActual);
        
		
		// A rigid body is the basic skeleton you attach joints and collision shapes too.
		// Rigid bodies hold the physical properties of an object such as the postion, rotation, and mass of an object.
		// You attach collision shapes to rigid bodies to define their shape and allow them to collide with other objects,
		// and you can attach joints between rigid bodies to connect them together.
		_body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
        _body.angle = [MyMath rotationOfNonSkewedAffineTransform:myTransform];
        _body.pos = cpv(myCenter.x, myCenter.y);
		
		ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:_body radius:WINDBLOW_BREATH_RADIUS offset:cpv(0, 0)];
		
		shape.elasticity = 0.3f;
		
		shape.friction = 0.3f;
		
		shape.collisionType = [BreathPlayController class];
		
		shape.data = self;
		
		_chipmunkObjects = [[NSArray alloc] initWithObjects:_body, shape, nil];
	}
	
	return self;
    
}


- (void)animateWithDeltaTime:(double)dt RepeatCount:(uint)cnt {
    _button.imageView.animationImages = _windBlowSequence;
    _button.imageView.animationDuration = dt;
    _button.imageView.animationRepeatCount = cnt;
    [_button.imageView startAnimating];
}

- (void) dropAlpha {
    _button.imageView.alpha = 0.2;
}

- (void) resetAlphaToOne {
    _button.imageView.alpha = 1;
}



// HELPER FUNCTIONS

- (CGRect) getCroppingRectForFrame:(NSUInteger)desiredFrame Of:(NSString*)spriteScreenPath  {
    // EFFECTS: Returns a CGRect the size of one breath
    
    // Error handling
    if (desiredFrame < 1 || desiredFrame > WINDBLOW_SPRITESCREEN_SPRITE_COUNT) {
        [NSException raise:@"getCroppingRectFor windblow" format:@"%d is an invalid frame! Choose from frames 1 ~ %d. Error is handled by setting desiredFrame to 1.", desiredFrame, WINDBLOW_SPRITESCREEN_SPRITE_COUNT];
        desiredFrame = 1;
    }
    
    UIImage* ss = [UIImage imageNamed:spriteScreenPath];
    CGFloat singleFrameHeight = ss.size.height;
    CGFloat singleFrameWidth = ss.size.width/ WINDBLOW_SPRITESCREEN_SPRITE_COUNT;
    
    CGFloat frameX = (desiredFrame-1)*singleFrameWidth;
    
    return CGRectMake(frameX, 0, singleFrameWidth, singleFrameHeight);
}


- (UIImage*) windBlowInFrame:(NSUInteger)desiredFrame Of:(NSString*)spriteScreenPath{
    // REQUIRES: Valid action frame number.
    
    CGRect croppingRect = [self getCroppingRectForFrame:desiredFrame Of:spriteScreenPath];
    
    UIImage* ss = [UIImage imageNamed:spriteScreenPath];
    CGImageRef refToDesiredFrame = CGImageCreateWithImageInRect([ss CGImage], croppingRect);
    UIImage *result = [UIImage imageWithCGImage:refToDesiredFrame];
    
    return result;
}

@end
