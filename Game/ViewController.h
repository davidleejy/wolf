//
//  ViewController.h
//  Game
//
//  Created by Lee Jian Yi David on 1/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObjectView.h"

@interface ViewController : UIViewController

- (IBAction)buttonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *gamearea;
@property (weak, nonatomic) IBOutlet UIScrollView *palette;

@end
