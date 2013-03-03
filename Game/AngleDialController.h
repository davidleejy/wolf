//
//  AngleDialController.h
//  Game
//
//  Created by Lee Jian Yi David on 3/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AngleDialController : NSObject

@property(readwrite) UIImageView* dialView;
@property(readwrite) UIImageView* arrow; // Is blank by itself. Contains the dimensions to hold arrows.
@property(readwrite) UIImageView* selectedArrowImage;
@property(readwrite) UIImageView* deselectedArrowImage;

-(AngleDialController*) initForPlayScene;
// EFFECTS: ctor for play scene

- (void)moveArrow:(UIPanGestureRecognizer *)panRecognizer;
//MODIFIES: arrow (and thus modifying dialView also)
//EFFECTS: sets arrow according to panning action.

- (void) resetAngleZero;
// MODIFIES: dialView
// EFFECTS: sets angle to 0.

- (double) angleShown;
// EFFECTS: returns the angle shown.

- (void) dropAlpha;
//MODIFIES: dialView
//EFFECTS: sets alpha of dialView to 0.2.

- (void) resetAlphaToOne;
//MODIFIES: dialView
//EFFECTS: sets alpha of dialView to 1.0.

-(void) selectedArrow;
//MODIFIES: arrow (and thus modifying dialView also)
//EFFECTS: sets arrow to selected picture.

-(void) deSelectedArrow;
//MODIFIES: arrow (and thus modifying dialView also)
//EFFECTS: sets arrow to deselected picture.

@end
