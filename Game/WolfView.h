//
//  WolfView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"
#import "DeveloperSettingsForViewClasses.h"

@interface WolfView : GameObjectView


//***** Properties ******

@property UIImage* wolfsImage; // Many wolfs in this image



//***** Constructors ******

- (id) initDefaultWithController:(GameObject *)myController;
// EFFECTS: Constructor that initialises this object with default size. Picks frame 1 out of 15.

- (id) initWithController:(GameObject*)myController AndFrame:(NSUInteger)desiredFrame;
// EFFECTS: Constructor that initialises this object with default size. You pick frame.

- (void) changeActionTo:(NSUInteger)desiredFrame;
// MODIFIES: image in UIImageView superclass.
// EFFECTS: Changes wolf's action to that which corresponds to desired frame.
//          Maintains default size.



@end
