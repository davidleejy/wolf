//
//  WolfView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"
#import "DeveloperSettings.h"

@interface WolfView : GameObjectView


//***** Properties ******

@property (readonly) UIImage* wolfsImage; // Many wolfs in this image
@property (readonly) NSUInteger actionFrame; // What this wolf's action is.


//***** Constructors ******

- (id) initDefaultWithController:(UIViewController*)myController;
// EFFECTS: Constructor that initialises this object with default size. Picks frame 1 out of 15.

- (id) initWithController:(UIViewController*)myController AndActionFrame:(NSUInteger)desiredFrame;
// EFFECTS: Constructor that initialises this object with default size. You pick frame.

- (void) showActionFrame:(NSUInteger)desiredFrame;
// MODIFIES: image in UIImageView superclass.
// EFFECTS: Changes wolf's action to that which corresponds to desired frame.
//          Maintains default size.



@end
