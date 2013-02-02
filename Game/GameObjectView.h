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



// ******* Constructors *******

- (id) initWithController:(GameObject*)yourController :(UIImage*)img :(CGPoint)origin :(CGFloat)width :(CGFloat)height EnableUserInteraction:(BOOL)userInteractionIsDesired;
// EFFECTS: Designated constructor. Origin, width and height refer to frame property in UIView.



// ******* Setters *******

- (void) translateAnAdditional:(CGPoint)arbXYOffset;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: translates this object w.r.t. superview by an additional coordinates.

- (void) rotateAnAdditional:(CGFloat)degrees;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: rotates this object w.r.t. superview by an additional degrees.

- (void) scaleAnAdditional:(CGFloat)scalingFactor;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: scales this object's width and height by scaling factor.
//          scaling is w.r.t. superview.

- (void) setOrigin:(CGPoint)coordinates;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets origin of this object w.r.t. superview.

- (void) setWidth:(CGFloat)myWidth andHeight:(CGFloat)myHeight;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets width and height of this object w.r.t. superview.

- (void) setRotationAngle:(CGFloat)degrees;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: sets angle of rotation of this object w.r.t. superview.

- (void) enableCustomUserInteraction;
// EFFECTS: Switch on custom user interaction.

- (void) disableCustomUserInteraction;
// EFFECTS: Switch off custom user interaction.


@end
