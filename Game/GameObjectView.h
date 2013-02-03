//
//  GameObjectView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObject.h"

#import <UIKit/UIKit.h>

@interface GameObjectView : UIImageView


// ******* Properties *******

@property (readwrite) GameObject* myController;
@property (readonly) CGFloat rotationInRads;
@property (readonly) CGFloat scalingFactor;


// ******* Constructors *******

- (id) initWithController:(GameObject*)yourController UIImage:(UIImage*)img Origin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height EnableUserInteraction:(BOOL)userInteractionIsDesired;
// EFFECTS: Designated constructor. Origin, width and height refer to frame property in UIView.



// ******* Setters *******

- (void) translateAnAdditional:(CGPoint)arbXYOffset;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: translates this object w.r.t. superview by an additional coordinates.

- (void) rotateAnAdditionalDeg:(CGFloat)degrees;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: rotates this object w.r.t. superview by an additional degrees.

- (void) rotateAnAdditionalRads:(CGFloat)radians;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: rotates this object w.r.t. superview by an additional radians.

- (void) scaleAnAdditional:(CGFloat)scalingFactor;
// MODIFIES: bounds (and indirectly frame) property in UIImageView superclass.
// EFFECTS: scales this object's bound's width and height by scaling factor.

- (void) setFrameOrigin:(CGPoint)coords;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets frame origin of this object w.r.t. superview.

- (void) setFrameCenter:(CGPoint)coords;
// MODIFIES: center property in UIImageView superclass.
// EFFECTS: sets center of this object w.r.t. superview.

- (void) setFrameWidth:(CGFloat)myWidth andFrameHeight:(CGFloat)myHeight;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets frame's width and height of this object w.r.t. superview.

- (void) setBoundsWidth:(CGFloat)myWidth andBoundsHeight:(CGFloat)myHeight;
// MODIFIES: bounds property in UIImageView superclass.
// EFFECTS: sets bound's width and height of this object w.r.t. superview.

- (void) setRotationAngleDeg:(CGFloat)degrees;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets angle of rotation of this object w.r.t. superview.

- (void) setRotationAngleRads:(CGFloat)radians;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets angle of rotation of this object w.r.t. superview.

- (void) enableCustomUserInteraction;
// EFFECTS: Switch on custom user interaction.

- (void) disableCustomUserInteraction;
// EFFECTS: Switch off custom user interaction.




// ******* Getters *******

- (CGFloat) frameX;
// Effects: returns the x coordinate of the origin of this object's frame.

- (CGFloat) frameY;
// Effects: returns the y coordinate of the origin of this object's frame.

- (CGFloat) frameWidth;
// Effects: returns the wdith of this object's frame.

- (CGFloat) frameHeight;
// Effects: returns the height of this object's frame.

- (CGFloat) boundsX;
// Effects: returns the x coordinate of the origin of this object's bounds.

- (CGFloat) boundsY;
// Effects: returns the y coordinate of the origin of this object's bounds.

- (CGFloat) boundsWidth;
// Effects: returns the wdith of this object's bounds.

- (CGFloat) boundsHeight;
// Effects: returns the height of this object's bounds.

- (CGFloat) frameCenterX;
// Effects: returns the x coordinate of the center of this object's frame.

- (CGFloat) frameCenterY;
// Effects: returns the y coordinate of the center of this object's frame.

@end
