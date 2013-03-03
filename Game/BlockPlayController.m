//
//  BlockPlayController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BlockPlayController.h"
#import "DeveloperSettings.h"
#import "MyMath.h"
#import <QuartzCore/QuartzCore.h>

@interface BlockPlayController ()

@property (readwrite) Material material;

@end



@implementation BlockPlayController

@synthesize button = _button;
@synthesize touchedShapes = _touchedShapes;
@synthesize body = _body;
@synthesize chipmunkObjects = _chipmunkObjects;
@synthesize material = _material;


- (void)updatePosition {
	_button.transform = _body.affineTransform;
}

- (id)initWithTransform:(CGAffineTransform)myTransform Bounds:(CGRect)myBounds Center:(CGPoint)myCenter ImagePath:(NSString*)materialImagePath{
    
    if(self = [super init]){
        
        //Find actual size:
        double widthActual = [MyMath horizScaleFactorOf:myTransform]*myBounds.size.width;
        double heightActual = [MyMath vertScaleFactorOf:myTransform]*myBounds.size.height;
        
        cpFloat mass;
        cpFloat friction;
        
        //Set material property
        if ([materialImagePath isEqualToString:BLOCK_STRAW_IMAGE_PATH]) {
            _material = kStraw;
            mass = 0.01f * widthActual * heightActual;
            friction = 0.3f;
        }
        else if ([materialImagePath isEqualToString:BLOCK_WOOD_IMAGE_PATH]) {
            _material = kWood;
            mass = 0.05f * widthActual * heightActual;
            friction = 0.7f;
        }
        else if ([materialImagePath isEqualToString:BLOCK_IRON_IMAGE_PATH]) {
            _material = kIron;
            mass = 0.2f * widthActual * heightActual;
            friction = 0.5f;
        }
        else if ([materialImagePath isEqualToString:BLOCK_STONE_IMAGE_PATH]) {
            _material = kStone;
            mass = 0.1f * widthActual * heightActual;
            friction = 0.9f;
        }
        else
            [NSException raise:@"init BlockPlayController" format:@"Invalid material image path: %@",materialImagePath];
       
        
        //Get image
        UIImageView* pic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:materialImagePath]];
        pic.bounds = CGRectMake(0, 0, widthActual, heightActual);
        // Using QuartzCore to grab a UIImage object that is the same size as its UIImageView
        UIGraphicsBeginImageContext(pic.bounds.size);
        [pic.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
		// Set up the pig picture
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button setImage:resultingImage forState:UIControlStateNormal];
        [_button setUserInteractionEnabled:NO];
        _button.bounds = CGRectMake(0, 0, widthActual, heightActual);
        
		
		// Set up Chipmunk objects.
		
		
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
		shape.elasticity = 0.0f;
		// The friction propertry should be self explanatory. Friction values go from 0 and up- they can be higher than 1f.
		shape.friction = friction;
		
		// Set the collision type to a unique value (the class object works well)
		// This type is used as a key later when setting up callbacks.
		shape.collisionType = [BlockPlayController class];
		
		// Set data to point back to this object.
		// That way you can get a reference to this object from the shape when you are in a callback.
		shape.data = self;
		
		_chipmunkObjects = [[NSArray alloc] initWithObjects:_body, shape, nil];
	}
	
	return self;
    
}



@end
