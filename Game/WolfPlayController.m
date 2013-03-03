//
//  WolfPlayController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WolfPlayController.h"
#import "DeveloperSettings.h"
#import "MyMath.h"
#import "SpriteHelper.h"
#import <QuartzCore/QuartzCore.h>


@interface WolfPlayController ()
- (CGRect) getCroppingRectForWolfs:(NSUInteger) desiredFrame;
// EFFECTS: Returns a CGRect that when applied to wolfs.png, bounds the desired frame.

- (UIImage*) wolfInFrame:(NSUInteger) desiredFrame;
// EFFECTS: Returns a wolf belonging to the desired frame.

//***** Unique to wolf ******
@property (readwrite) UIImage* wolfsImage; // Many wolfs in this image
@property (readwrite) NSMutableArray* wolfBlowingSpriteSequence;
@property (readwrite) NSMutableArray* windSuckSpriteSequence;

@end


@implementation WolfPlayController

@synthesize button = _button;
@synthesize touchedShapes = _touchedShapes;
@synthesize body = _body;
@synthesize chipmunkObjects = _chipmunkObjects;
@synthesize wolfsImage = _wolfsImage;
@synthesize wolfBlowingSpriteSequence = _wolfBlowingImagesSequence;
@synthesize windSuckSpriteSequence = _windSuckSpriteSequence;

static cpFloat frand_unit(){return 2.0f*((cpFloat)rand()/(cpFloat)RAND_MAX) - 1.0f;}



- (void)updatePosition {
	_button.transform = _body.affineTransform;
}

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter {
    if(self = [super init]){
        
        //Fill up wind suck sprite sequence
        UIImage *windSuckSpriteScreen = [UIImage imageNamed:WOLF_WINDSUCK_SPRITESCREEN_PATH];
        _windSuckSpriteSequence = [[NSMutableArray alloc]init];
        for (int i = 0; i < WOLF_WINDSUCK_SPRITESCREEN_SPRITE_COUNT; i++) {
            CGRect croppingRect = [SpriteHelper getCroppingRect:windSuckSpriteScreen
                                                  RowsOfSprites:WOLF_WINDSUCK_SPRITESCREEN_ROWS
                                                  ColsOfSprites:WOLF_WINDSUCK_SPRITESCREEN_COLS
                                                    SpriteCount:WOLF_WINDSUCK_SPRITESCREEN_SPRITE_COUNT
                                             DesiredSpriteIndex:i];
            
            CGImageRef refToDesiredSprite = CGImageCreateWithImageInRect([windSuckSpriteScreen CGImage], croppingRect);
            [_windSuckSpriteSequence addObject:[UIImage imageWithCGImage:refToDesiredSprite]];
        }
        
        //Fill up wolf blowing sprite sequence
        _wolfsImage = [UIImage imageNamed:WOLFS_IMAGE_PATH];
        _wolfBlowingImagesSequence = [[NSMutableArray alloc]init];
        for (int i = 1; i <= WOLFS_MAX_FRAMES_TO_CHOOSE_FROM; i++) {
            [_wolfBlowingImagesSequence addObject:[self wolfInFrame:i]];
        }
        
        //Take out "normal" wolf
        UIImage* frameOne = [self wolfInFrame:1];
        
        //Find actual size:
        double widthActual = [MyMath horizScaleFactorOf:myTransform]*myBounds.size.width;
        double heightActual = [MyMath vertScaleFactorOf:myTransform]*myBounds.size.height;
        
        //Get image
        UIImageView* pic = [[UIImageView alloc]initWithImage:frameOne];
        pic.bounds = CGRectMake(0, 0, widthActual, heightActual);
        // Using QuartzCore to grab a UIImage object that is the same size as its UIImageView
        UIGraphicsBeginImageContext(pic.bounds.size);
        [pic.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
		// Set up the pig picture
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button setTitle:@"Wolf!" forState:UIControlStateNormal];
		[_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[_button setImage:resultingImage forState:UIControlStateNormal];
        _button.bounds = CGRectMake(0, 0, widthActual, heightActual);
        
        
//		[_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchDown];
		
		// Set up Chipmunk objects.
		cpFloat mass = 0.052f*widthActual*heightActual;
		
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
		
		// Chipmunk supports a number of collision shape types. See the documentation for more information.
		// Because we are storing this into a local variable instead of an instance variable, we can use the autorelease constructor.
		// We'll let the chipmunkObjects NSSet hold onto the reference for us.
		ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:_body width:widthActual height:heightActual];
		
		// The elasticity of a shape controls how bouncy it is.
		shape.elasticity = 0.3f;
		// The friction propertry should be self explanatory. Friction values go from 0 and up- they can be higher than 1f.
		shape.friction = 0.8f;
		
		// Set the collision type to a unique value (the class object works well)
		// This type is used as a key later when setting up callbacks.
		shape.collisionType = [WolfPlayController class];
		
		// Set data to point back to this object.
		// That way you can get a reference to this object from the shape when you are in a callback.
		shape.data = self;
		
		// Keep in mind that you can attach multiple collision shapes to each rigid body, and that each shape can have
		// unique properties. You can make the player's head have a different collision type for instance. This is useful
        // for brain damage.
		
		// Now we just need to initialize the instance variable for the chipmunkObjects property.
		// ChipmunkObjectFlatten() is an easy way to build this set. You can pass any object to it that
		// implements the ChipmunkObject protocol and not just primitive types like bodies and shapes.
		
		// Notice that we didn't even have to keep a reference to 'shape'. It was created using the autorelease convenience function.
		// This means that the chipmunkObjects NSSet will manage the memory for us. No need to worry about forgetting to call
		// release later when you're using Objective-Chipmunk!
		
		// Note the nil terminator at the end! (this is how it knows you are done listing objects)
		_chipmunkObjects = [[NSArray alloc] initWithObjects:_body, shape, nil];
	}
	
	return self;

}


- (void)animateBlowWithDeltaTime:(double)dt RepeatCount:(uint)cnt {
    
    _button.imageView.animationImages = _wolfBlowingImagesSequence;
    _button.imageView.animationDuration = dt;
    _button.imageView.animationRepeatCount = cnt;
    [_button.imageView startAnimating];
}

- (void)animateOneBlowThatCompletesInSecs:(double)duration {
    
    // Get a UIImageView of wind sucking.
    UIImage* windSuckStart  = (UIImage*)[_windSuckSpriteSequence objectAtIndex:0];
    UIImageView* windSuck = [[UIImageView alloc]initWithImage:windSuckStart];
    
    // Configure the wind sucking UIImageView's frame such that it is near the mouth.
    CGPoint mouth = [self wolfMouthCoordinates];
    
    // Prepare to animate wind sucking
    windSuck.animationImages = _windSuckSpriteSequence;
    double windSuckAnimationDuration = duration-duration/WOLFS_MAX_FRAMES_TO_CHOOSE_FROM*2.0;
    windSuck.animationDuration = windSuckAnimationDuration;
    windSuck.animationRepeatCount = 1;
    
    // Prepare to animate wolf body expanding and contracting
    _button.imageView.animationImages = _wolfBlowingImagesSequence;
    _button.imageView.animationDuration = duration;
    _button.imageView.animationRepeatCount = 1;
    
    // Begin to animate
    [_button.imageView startAnimating];
    [_button addSubview:windSuck];
    windSuck.frame = CGRectMake(mouth.x,
                                mouth.y - windSuck.frame.size.height/2.0,
                                windSuck.frame.size.width, windSuck.frame.size.height);
    [windSuck startAnimating];
    [windSuck performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:windSuckAnimationDuration];
}



- (CGPoint)wolfMouthCoordinates {
    return CGPointMake(_button.imageView.frame.size.width,
                       _button.frame.size.height/4.63);
}

//- (void)animateBlowWithDeltaTime:(double)dt RepeatCount:(uint)cnt PerformAtEnd:(SEL)selector1 {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0]; //the animation will last for 1.0s
//    [self animateBlowWithDeltaTime:dt RepeatCount:cnt]; //some animation code here
//    [UIView commitAnimations];
//    [self performSelector:@selector(selector1) withObject:nil afterDelay:1.0];
//}


// **** HELPER FUNCTIONS ****

- (CGRect) getCroppingRectForWolfs:(NSUInteger) desiredFrame {
    // EFFECTS: Returns a CGRect that when applied to wolfs.png, bounds the desired frame.
    return [SpriteHelper getCroppingRect:_wolfsImage RowsOfSprites:WOLFS_ROWS_OF_FRAMES ColsOfSprites:WOLFS_COLUMNS_OF_FRAMES SpriteCount:WOLFS_MAX_FRAMES_TO_CHOOSE_FROM DesiredSpriteIndex:desiredFrame-1];
    
}


- (UIImage*) wolfInFrame:(NSUInteger) desiredFrame {
    // REQUIRES: Valid action frame number.
    //           _wolfsImage be loaded with a bunch of wolfs.
    // EFFECTS: Returns a wolf belonging to the desired frame.
    
    CGRect croppingRect = [self getCroppingRectForWolfs:desiredFrame];
    
    CGImageRef refToDesiredWolfFrame = CGImageCreateWithImageInRect([_wolfsImage CGImage], croppingRect);
    UIImage *result = [UIImage imageWithCGImage:refToDesiredWolfFrame];
    
    return result;
}


//- (void)buttonClicked {
//	// Apply a random velcity change to the body when the button is clicked.
//	cpVect v = cpvmult(cpv(frand_unit(), frand_unit()), 300.0f);
//	_body.vel = cpvadd(_body.vel, v);
//
//	_body.angVel += 5.0f*frand_unit();
//}

@end
