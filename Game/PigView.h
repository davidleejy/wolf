//
//  PigView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"
#import "DeveloperSettings.h"

@interface PigView : GameObjectView


// ***** Constructors ******

- (id) initWithController:(UIViewController*) myController;
    // EFFECTS: Designated Constructor


- (id) initDefaultWithController:(UIViewController*)myController;
    // EFFECTS: Constructor that initialises this object with default size.

@end
