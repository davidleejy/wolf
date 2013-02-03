//
//  BlockView.h
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GameObjectView.h"
#import "DeveloperSettingsForViewClasses.h"

@interface BlockView : GameObjectView


@property(readonly) NSArray* materialsArray;
// DESCRIPTION:
// 0 Straw
// 1 Wood
// 2 Iron
// 3 Stone

@property(readonly) NSUInteger currentMaterial;
// DESCRIPTION:
// 0 Straw
// 1 Wood
// 2 Iron
// 3 Stone

//***** Constructors *****

- (id) initDefaultWithController:(UIViewController*)myController;
// EFFECTS: Constructor that initialises this object with default size. Default block is straw.


//***** Setters *****

- (void) showMaterial:(NSUInteger)desiredMaterial;
// MODIFIES: image in UIImageView superclass
// EFFECTS: changes the material of this object.

- (void) nextMaterial;
// MODIFIES: image in UIImageView superclass
// EFFECTS: changes the material of this object to the next material in materialsArray.
//          WHen the end of materialsArray is reached, wrap around and pick the 1st material.

@end
