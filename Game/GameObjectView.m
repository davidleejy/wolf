//
//  GameObjectView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"

@implementation GameObjectView

@synthesize myController = _myController;


- (id) initWithController:(GameObject*)yourController :(UIImage*)img :(CGPoint)origin :(CGFloat)width :(CGFloat)height EnableUserInteraction:(BOOL)userInteractionIsDesired {
    // EFFECTS: Designated constructor. Origin, width and height refer to frame property in UIView.

    // Init super class. Super class is UIImageView
    self = [super initWithImage:img];
    if (!self) return nil; // Error handling
    
    // Setting some properties
    [super setFrame:CGRectMake(origin.x, origin.y, width, height)];
    
    // Switching on/off user interaction
    if (userInteractionIsDesired)
        [self enableCustomUserInteraction];
    else
        [self disableCustomUserInteraction];
    
    
    return self;
    
}


- (void) translateAnAdditional:(CGPoint)arbXYOffset {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: translates this object w.r.t. superview by an additional coordinates.
    
    self.transform = CGAffineTransformMakeTranslation( arbXYOffset.x, arbXYOffset.y);
}


- (void) rotateAnAdditional:(CGFloat)degrees {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: rotates this object w.r.t. superview by an additional degrees.
    
    self.transform = CGAffineTransformRotate(self.transform, degrees);
}



- (void) scaleAnAdditional:(CGFloat)scalingFactor {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: scales this object's width and height by scaling factor.
    //          scaling is w.r.t. superview.
    
    self.transform = CGAffineTransformScale(self.transform, scalingFactor, scalingFactor);
}


- (void) setOrigin:(CGPoint)coordinates {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets origin of this object w.r.t. superview.
    
    self.transform = CGAffineTransformIdentity; //reset
    [self translateAnAdditional:coordinates];
}


- (void) setWidth:(CGFloat)myWidth andHeight:(CGFloat)myHeight {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets width and height of this object w.r.t. superview.
    
    self.transform = CGAffineTransformIdentity; //reset
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, myWidth, myHeight);
}


- (void) setRotationAngle:(CGFloat)degrees {
    // MODIFIES: frame property in UIImageView superclass.
    // EFFECTS: sets angle of rotation of this object w.r.t. superview.
    
    self.transform = CGAffineTransformIdentity; //reset
    [self rotateAnAdditional:degrees];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
