//
//  BreathPlayController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WindBlowController.h"
#import "DeveloperSettings.h"
#import "MyMath.h"
#import "SpriteHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface WindBlowController ()
@property (readwrite) NSMutableArray* windBlowSequence;
@property (readwrite) BreathType breathType;
@property (readwrite) NSMutableArray* windDisperseSequence;
@end

@implementation WindBlowController

@synthesize button = _button;
@synthesize touchedShapes = _touchedShapes;
@synthesize body = _body;
@synthesize chipmunkObjects = _chipmunkObjects;
@synthesize windBlowSequence = _windBlowSequence;
@synthesize breathType = _breathType;
@synthesize windDisperseSequence = _windDisperseSequence;



- (void)updatePosition {
	_button.transform = _body.affineTransform;
}


- (id)initWithTransform:(CGAffineTransform)myTransform
                 Bounds:(CGRect)myBounds
                 Center:(CGPoint)myCenter
             BreathType:(BreathType)type{
    if(self = [super init]){
        
        //Find actual size:
        double widthActual = [MyMath horizScaleFactorOf:myTransform]*myBounds.size.width;
        double heightActual = [MyMath vertScaleFactorOf:myTransform]*myBounds.size.height;
        
		cpFloat mass;
        _windBlowSequence = [[NSMutableArray alloc]init]; //IMPT!
        _windDisperseSequence = [[NSMutableArray alloc]init]; // IMPT!
        
        //Set breathe type
        if (type == kNorm) {
            mass = 100.0f;
            _breathType = kNorm;
            // Cut up sprites from wind blow sprite screen and populate _windblowsequence
            for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
                [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW_SPRITESCREEN_PATH]];
            }
            
            //Fill up windDisperseSequence
            UIImage *windDisperseSpriteScreen = [UIImage imageNamed:WINDDISPERSE_SPRITESCREEN_PATH];
            for (int i = 0; i < WINDDISPERSE_SPRITESCREEN_SPRITE_COUNT; i++) {
                CGRect croppingRect = [SpriteHelper getCroppingRect:windDisperseSpriteScreen
                                                      RowsOfSprites:2
                                                      ColsOfSprites:5
                                                        SpriteCount:WINDDISPERSE_SPRITESCREEN_SPRITE_COUNT
                                                 DesiredSpriteIndex:i];
                
                CGImageRef refToDesiredSprite = CGImageCreateWithImageInRect([windDisperseSpriteScreen CGImage], croppingRect);
                [_windDisperseSequence addObject:[UIImage imageWithCGImage:refToDesiredSprite]];
            }
            
        }
        else if (type == kFire) {
            mass = 65.0f;
            _breathType = kFire;
            // Cut up sprites from wind blow1 sprite screen and populate _windblowsequence
            for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
                [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW1_SPRITESCREEN_PATH]];
            }
            
            //Fill up windDisperseSequence
            UIImage *windDisperseSpriteScreen = [UIImage imageNamed:WINDDISPERSE1_SPRITESCREEN_PATH];
            for (int i = 0; i < WINDDISPERSE1_SPRITESCREEN_SPRITE_COUNT; i++) {
                CGRect croppingRect = [SpriteHelper getCroppingRect:windDisperseSpriteScreen
                                                      RowsOfSprites:2
                                                      ColsOfSprites:4
                                                        SpriteCount:WINDDISPERSE1_SPRITESCREEN_SPRITE_COUNT
                                                 DesiredSpriteIndex:i];
                
                CGImageRef refToDesiredSprite = CGImageCreateWithImageInRect([windDisperseSpriteScreen CGImage], croppingRect);
                [_windDisperseSequence addObject:[UIImage imageWithCGImage:refToDesiredSprite]];
            }
            
        }
        else if (type == kIce) {
            mass = 65.0f;
            _breathType = kIce;
            // Cut up sprites from wind blow2 sprite screen and populate _windblowsequence
            for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
                [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW2_SPRITESCREEN_PATH]];
            }
            
            //Fill up windDisperseSequence
            UIImage *windDisperseSpriteScreen = [UIImage imageNamed:WINDDISPERSE2_SPRITESCREEN_PATH];
            for (int i = 0; i < WINDDISPERSE2_SPRITESCREEN_SPRITE_COUNT; i++) {
                CGRect croppingRect = [SpriteHelper getCroppingRect:windDisperseSpriteScreen
                                                      RowsOfSprites:3
                                                      ColsOfSprites:3
                                                        SpriteCount:WINDDISPERSE2_SPRITESCREEN_SPRITE_COUNT
                                                 DesiredSpriteIndex:i];
                
                CGImageRef refToDesiredSprite = CGImageCreateWithImageInRect([windDisperseSpriteScreen CGImage], croppingRect);
                [_windDisperseSequence addObject:[UIImage imageWithCGImage:refToDesiredSprite]];
            }
        }
        else if (type == kPlasma) {
            mass = 50.0f;
            _breathType = kPlasma;
            // Cut up sprites from wind blow3 sprite screen and populate _windblowsequence
            for (int i = 1; i <= WINDBLOW_SPRITESCREEN_SPRITE_COUNT; i++) {
                [_windBlowSequence addObject:[self windBlowInFrame:i Of:WINDBLOW3_SPRITESCREEN_PATH]];
            }
            
            //Fill up windDisperseSequence
            UIImage *windDisperseSpriteScreen = [UIImage imageNamed:WINDDISPERSE3_SPRITESCREEN_PATH];
            for (int i = 0; i < WINDDISPERSE3_SPRITESCREEN_SPRITE_COUNT; i++) {
                CGRect croppingRect = [SpriteHelper getCroppingRect:windDisperseSpriteScreen
                                                      RowsOfSprites:2
                                                      ColsOfSprites:4
                                                        SpriteCount:WINDDISPERSE3_SPRITESCREEN_SPRITE_COUNT
                                                 DesiredSpriteIndex:i];
                
                CGImageRef refToDesiredSprite = CGImageCreateWithImageInRect([windDisperseSpriteScreen CGImage], croppingRect);
                [_windDisperseSequence addObject:[UIImage imageWithCGImage:refToDesiredSprite]];
            }
        }
        else
            [NSException raise:@"init WindBlowController" format:@"Invalid breath type: %d",type];
        
        
        
        //Get image from index 0 of windBlowSequence.
        UIImageView* pic = [[UIImageView alloc]initWithImage:[_windBlowSequence objectAtIndex:0]];
        pic.bounds = CGRectMake(0, 0, widthActual, heightActual);
        // Using QuartzCore to grab a UIImage object that is the same size as its UIImageView
        UIGraphicsBeginImageContext(pic.bounds.size);
        [pic.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
		// Set up the breath picture
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button setImage:resultingImage forState:UIControlStateNormal];
        [_button setUserInteractionEnabled:NO];
        _button.bounds = CGRectMake(0, 0, widthActual, heightActual);
        
		
		cpFloat moment = cpMomentForBox(mass, widthActual, heightActual);
        
    
		_body = [[ChipmunkBody alloc] initWithMass:mass andMoment:moment];
        _body.angle = [MyMath rotationOfNonSkewedAffineTransform:myTransform];
        _body.pos = cpv(myCenter.x, myCenter.y);
		
		ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:_body radius:WINDBLOW_BREATH_RADIUS offset:cpv(0, 0)];
		
		shape.elasticity = 0.3f;
		
		shape.friction = 0.4f;
		
		shape.collisionType = [WindBlowController class];
		
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


- (void)animateDispersionWithDurationSecs:(double)t {
    _button.imageView.animationImages = _windDisperseSequence;
    _button.imageView.animationDuration = t;
    _button.imageView.animationRepeatCount = 1;
    [_button.imageView startAnimating];
}



// ============== OLD FUNCTIONS TO BE REFACTORED OUT ================

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
