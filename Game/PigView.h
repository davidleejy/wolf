//
//  PigView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"

@interface PigView : GameObjectView


// ***** Constructors ******

- (id) initWithController:(GameObject*) myController;
    // EFFECTS: Designated Constructor


- (id) initDefaultWithController:(GameObject *)myController;
    // EFFECTS: Constructor that initialises this object with default size.

@end
