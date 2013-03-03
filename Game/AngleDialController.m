//
//  AngleDialController.m
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AngleDialController.h"
#import "MyMath.h"
#import "DeveloperSettings.h"

#define ARROW_SCALE_DOWN 0.6 //scale down the arrow image
#define TOP_DIAL_BOUNDARY_RADIANS 0.270796628
#define BTM_DIAL_BOUNDARY_RADIANS 2.100796443
#define JERK_WHEN_ARROW_EXCEEDS_BOUNDARY_RADIANS 0.02

@implementation AngleDialController

@synthesize dialView = _dialView;
@synthesize arrow = _arrow;
@synthesize selectedArrowImage = _selectedArrowImage;
@synthesize deselectedArrowImage = _deselectedArrowImage;

-(AngleDialController*) initForPlayScene {
    
    self = [super init];
    if (!self) return nil;
    
    //Initialise selectedArrowImage and deselectedArrowImage
    _deselectedArrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ANGLE_DIAL_ARROW_DESELECTED_PATH]];
    _selectedArrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ANGLE_DIAL_ARROW_SELECTED_PATH]];
    
    //Initialise the arrow holder. By itself, the arrow holder is blank
    _arrow = [[UIImageView alloc]initWithFrame:_selectedArrowImage.frame]; //_arrow should mirror the dimensions of arrows.
    
    //Initialise the dial markings
    UIImageView *dialMarkings = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ANGLE_DIAL_PATH]];
    
    //Initialise the dial view (root-most view). dialView holds all the other views.
    _dialView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                              dialMarkings.frame.size.width+40
                                                              ,
                                                              dialMarkings.frame.size.height)];
    _dialView.center = CGPointMake(1024/2.0, 768/2.0);
    
    
    dialMarkings.frame = CGRectMake(_dialView.frame.size.width-dialMarkings.frame.size.width,
                                    0,
                                    dialMarkings.frame.size.width,
                                    dialMarkings.frame.size.height);
    
    [_dialView addSubview:dialMarkings];
    [_dialView addSubview:_arrow];
    
    // Position the arrow holder nicely
    _arrow.transform = CGAffineTransformScale(_arrow.transform, ARROW_SCALE_DOWN, ARROW_SCALE_DOWN);
    _arrow.center = CGPointMake(50, _dialView.frame.size.height/2.0+20);
    
    [self resetAngleZero];
    
    [self deSelectedArrow];
    
    [self dropAlpha];
    
    //Attach gesture recognizers
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveArrow:)];
    [_dialView addGestureRecognizer:panRecog];
    _dialView.userInteractionEnabled = YES; //IMPORTANT!
    
    return self;
    
}


- (void)moveArrow:(UIPanGestureRecognizer *)panRecognizer
{
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        [self selectedArrow];
        [self resetAlphaToOne];
    }
    
    CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];
    
//    NSLog(@"%.3f %.3f %.3f %.9f",translation.x,translation.y,[MyMath rotationOfNonSkewedAffineTransform:_arrow.transform], [self angleShown]);
    
    // Check to see if arrow is within dial markings before rotating the arrow.
    if (TOP_DIAL_BOUNDARY_RADIANS < [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform] &&
        [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform] < BTM_DIAL_BOUNDARY_RADIANS)
    {
        _arrow.transform = CGAffineTransformRotate(_arrow.transform, translation.y/100);
    }
    else if (TOP_DIAL_BOUNDARY_RADIANS >= [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform]){
        _arrow.transform = CGAffineTransformRotate(_arrow.transform, JERK_WHEN_ARROW_EXCEEDS_BOUNDARY_RADIANS);
    }
    else if ([MyMath rotationOfNonSkewedAffineTransform:_arrow.transform] >= BTM_DIAL_BOUNDARY_RADIANS){
        _arrow.transform = CGAffineTransformRotate(_arrow.transform, -JERK_WHEN_ARROW_EXCEEDS_BOUNDARY_RADIANS);
    }
    
    [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view.superview];
    
	if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // Arrow might exceed dial boundaries.  If arrow exceeds dial boundaries, make arrow point to the boundary.
        if (TOP_DIAL_BOUNDARY_RADIANS >= [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform]){
            double currAngle = [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform];
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, -currAngle);
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, TOP_DIAL_BOUNDARY_RADIANS);
        }
        else if ([MyMath rotationOfNonSkewedAffineTransform:_arrow.transform] >= BTM_DIAL_BOUNDARY_RADIANS){
            double currAngle = [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform];
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, -currAngle);
            _arrow.transform = CGAffineTransformRotate(_arrow.transform, BTM_DIAL_BOUNDARY_RADIANS);
        }

        [self deSelectedArrow];
        [self dropAlpha];
    }
    
    
}


- (void) resetAngleZero {
    double currAngle = [MyMath rotationOfNonSkewedAffineTransform:_arrow.transform];
    _arrow.transform = CGAffineTransformRotate(_arrow.transform, -currAngle);
    _arrow.transform = CGAffineTransformRotate(_arrow.transform, M_PI/2.0);
}


- (double) angleShown {
    return -([MyMath rotationOfNonSkewedAffineTransform:_arrow.transform] - M_PI/2.0);
}

- (void) dropAlpha{
    _dialView.alpha = 0.25;
}

- (void) resetAlphaToOne{
    _dialView.alpha = 1;
}

-(void) selectedArrow{
    [_arrow addSubview:_selectedArrowImage];
}

-(void) deSelectedArrow{
    [_arrow addSubview:_deselectedArrowImage];
}

@end
