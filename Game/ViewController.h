//
//  ViewController.h
//  Game
//
//  Created by Lee Jian Yi David on 1/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

// View classes
@class GameObjectView;
@class WolfView;
@class PigView;
@class BlockView;

// Controller classes
@class GameObject;
@class GameWolf;
@class GamePig;
@class GameBlock;

// Model classes
@class GameObjectModel;

@interface ViewController : UIViewController



// ****** Buttons being managed ******
- (IBAction)startButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)loadButton:(id)sender;
- (IBAction)resetButton:(id)sender;


// ****** Views being managed ******
// These views have their initial configuration done in the storyboard
@property (weak, nonatomic) IBOutlet UIScrollView *gamearea;
@property (weak, nonatomic) IBOutlet UIScrollView *palette;


// ****** Controllers being managed ******
@property (nonatomic,readonly) GameWolf* wolfController;
@property (nonatomic,readonly) GamePig* pigController;
@property (nonatomic,readonly) GameBlock* blockController;


// ****** Model being managed ******
@property (readonly) GameObjectModel* database;

// Don't Care
@property (readwrite) CGAffineTransform temp;

@end
