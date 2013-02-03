//
//  GameObjectView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"

@interface GameObjectView ()

@property (readwrite) CGFloat rotationInRads;
@property (readwrite) CGFloat scalingFactor;

@end



@implementation GameObjectView

// ******* Properties *******

@synthesize myController = _myController;
@synthesize rotationInRads = _rotationInRads;
@synthesize scalingFactor = _scalingFactor;


// ******* Constructor *******

- (id) initWithController:(GameObject*)yourController UIImage:(UIImage*)img Origin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height EnableUserInteraction:(BOOL)userInteractionIsDesired {
    // EFFECTS: Designated constructor. Origin, width and height refer to frame property in UIView.

    // Init super class. Super class is UIImageView
    self = [super initWithImage:img];
    if (!self) return nil; // Error handling
    
    // Setting some properties
    [super setFrame:CGRectMake(origin.x, origin.y, width, height)];
    
    // Initialising this class' properties
    _myController = yourController;
    _rotationInRads = 0;
    _scalingFactor = 1;
    
    // Switching on/off user interaction
    if (userInteractionIsDesired)
        [self enableCustomUserInteraction];
    else
        [self disableCustomUserInteraction];
    
    
    return self;
}



// ******* Setters *******

- (void) translateAnAdditional:(CGPoint)arbXYOffset {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: translates this object w.r.t. superview by an additional coordinates.
    
    //self.transform = CGAffineTransformTranslate(self.transform, arbXYOffset.x, arbXYOffset.y);
    
    //self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(arbXYOffset.x, arbXYOffset.y));
    
    self.frame = CGRectMake((self.frame.origin.x + arbXYOffset.x),
                            (self.frame.origin.y + arbXYOffset.y),
                            self.frame.size.width,
                            self.frame.size.height);
}


- (void) rotateAnAdditionalDeg:(CGFloat)degrees {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: rotates this object w.r.t. superview by an additional degrees.
    
    CGFloat radians = degrees * M_PI / 180.0;
    
    [self rotateAnAdditionalRads:radians];
}

- (void) rotateAnAdditionalRads:(CGFloat)radians {
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: rotates this object w.r.t. superview by an additional radians.
    
    // Remember to record this
    _rotationInRads += radians;
    
    self.contentMode = UIViewContentModeCenter;
    
    self.transform = CGAffineTransformMakeRotation(_rotationInRads);
    
    //self.transform = CGAffineTransformRotate(self.transform, rads);
    
    //self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeRotation(rads));
}

- (void) scaleAnAdditional:(CGFloat)scalingFactor {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: scales this object's width and height by scaling factor.
    //          scaling is w.r.t. superview.
    
    self.contentMode = UIViewContentModeScaleToFill;
    
    CGFloat newBoundsWidth = self.bounds.size.width * scalingFactor;
    CGFloat newBoundsHeight = self.bounds.size.height * scalingFactor;
    
    NSLog(@"origFrame: %lf %lf",self.frame.size.width, self.frame.size.height); //todo
    NSLog(@"orig: %lf %lf",self.bounds.size.width, self.bounds.size.height); //todo
    NSLog(@"news: %lf %lf",newBoundsWidth, newBoundsHeight); //todo
    
    // Remember to record this
    _scalingFactor *= scalingFactor;
    
    self.bounds = CGRectMake(self.bounds.origin.x,
                             self.bounds.origin.y,
                             newBoundsWidth,
                             newBoundsHeight);
    
    NSLog(@"adj: %lf %lf",self.bounds.size.width, self.bounds.size.height); //todo
    NSLog(@"adjFrame: %lf %lf",self.frame.size.width, self.frame.size.height); //todo
    
// **** attempt 2
//    CGFloat newWidth = self.frame.size.width * scalingFactor;
//    CGFloat newHeight = self.frame.size.height * scalingFactor;
//    
//    // Remember to record this
//    _scalingFactor *= scalingFactor;
//    
//    self.frame = CGRectMake(self.frame.origin.x,
//                            self.frame.origin.y,
//                            newWidth,
//                            newHeight);
    
    // **attempt 1**
    //self.transform = CGAffineTransformScale(self.transform, scalingFactor, scalingFactor);
    
    //self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(scalingFactor, scalingFactor));
}


- (void) setFrameOrigin:(CGPoint)coords {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets origin of this object w.r.t. superview.
    
    //self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-(self.frame.origin.x), -(self.frame.origin.y)));
    //self.transform = CGAffineTransformTranslate(self.transform, coordinates.x, coordinates.y);
    
    self.frame = CGRectMake(coords.x,
                            coords.y,
                            self.frame.size.width,
                            self.frame.size.height);
}



- (void) setFrameCenter:(CGPoint)coords {
    // MODIFIES: bounds property in UIImageView superclass.
    // EFFECTS: sets bounds origin of this object w.r.t. superview.
    
    self.center = coords;
}



- (void) setFrameWidth:(CGFloat)myWidth andFrameHeight:(CGFloat)myHeight {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets width and height of this object w.r.t. superview.
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, myWidth, myHeight);
}


- (void) setBoundsWidth:(CGFloat)myWidth andBoundsHeight:(CGFloat)myHeight {
// MODIFIES: bounds property in UIImageView superclass.
// EFFECTS: sets bound's width and height of this object w.r.t. superview.
    
    self.bounds = CGRectMake([self boundsX], [self boundsY], myWidth, myHeight);
}

- (void) setRotationAngleDeg:(CGFloat)degrees {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets angle of rotation of this object w.r.t. superview.
    
    
    // Reset rotation to 0 radians.
    [self rotateAnAdditionalRads: -_rotationInRads ]; //note the negative sign
    
    CGFloat radians = degrees * M_PI / 180.0;
    
    [self rotateAnAdditionalRads:radians];
    
    
    //self.transform = CGAffineTransformIdentity;
    //[self rotateAnAdditionalDeg:degrees];
}


- (void) setRotationAngleRads:(CGFloat)radians {
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets angle of rotation of this object w.r.t. superview.
    
    // Reset rotation to 0 radians.
    [self rotateAnAdditionalRads: -_rotationInRads ]; //note the negative sign
    
    [self rotateAnAdditionalRads:radians];
    
}

- (void) enableCustomUserInteraction {
    // EFFECTS: Switch on custom user interaction.
    
    
    self.userInteractionEnabled = YES;
    
    //  Add gesture recognizers
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:_myController action:@selector(rotate:)];
    [self addGestureRecognizer:rotation];
    
    UIPanGestureRecognizer *translate = [[UIPanGestureRecognizer alloc] initWithTarget:_myController action:@selector(translate:)];
    [self addGestureRecognizer:translate];
    
    UITapGestureRecognizer *destroy = [[UITapGestureRecognizer alloc] initWithTarget:_myController action:@selector(destroy:)];
    destroy.numberOfTapsRequired = 2;
    [self addGestureRecognizer:destroy];
    
    UIPinchGestureRecognizer *zoom = [[UIPinchGestureRecognizer alloc] initWithTarget:_myController action:@selector(zoom:)];
    [self addGestureRecognizer:zoom];
}



- (void) disableCustomUserInteraction {
// EFFECTS: Switch off custom user interaction.
    
    self.userInteractionEnabled = NO;
}




// ******* Getters *******

- (CGFloat) frameX {
// Effects: returns the x coordinate of the origin of this object's frame.
    return self.frame.origin.x;
}

- (CGFloat) frameY {
// Effects: returns the y coordinate of the origin of this object's frame.
    return self.frame.origin.y;
}

- (CGFloat) frameWidth {
// Effects: returns the wdith of this object's frame.
    return self.frame.size.width;
}

- (CGFloat) frameHeight {
// Effects: returns the height of this object's frame.
    return self.frame.size.height;
}

- (CGFloat) boundsX {
    // Effects: returns the x coordinate of the origin of this object's bounds.
    return self.bounds.origin.x;
}

- (CGFloat) boundsY {
    // Effects: returns the y coordinate of the origin of this object's bounds.
    return self.bounds.origin.y;
}

- (CGFloat) boundsWidth {
    // Effects: returns the wdith of this object's bounds.
    return self.bounds.size.width;
}

- (CGFloat) boundsHeight {
    // Effects: returns the height of this object's bounds.
    return self.bounds.size.height;
}

- (CGFloat) frameCenterX {
// Effects: returns the x coordinate of the center of this object's frame.
    return self.center.x;
}

- (CGFloat) frameCenterY {
// Effects: returns the y coordinate of the center of this object's frame.
    return self.center.y;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
