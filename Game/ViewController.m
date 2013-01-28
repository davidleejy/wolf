//
//  ViewController.m
//  Game
//
//  Created by Lee Jian Yi David on 1/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Load image resources into UIImage objects
    UIImage *bgImage = [UIImage imageNamed:@"background.png"];
    UIImage *groundImage = [UIImage imageNamed:@"ground.png"];
    
    //Place each UIImage object into UIImageView object
    UIImageView *background = [[UIImageView alloc] initWithImage:bgImage];
    UIImageView *ground = [[ UIImageView alloc] initWithImage:groundImage];
    
    //Get the width and height of the 2 images
    CGFloat backgroundWidth = bgImage.size.width;
    CGFloat backgroundHeight = bgImage.size.height;
    CGFloat groundWidth = groundImage.size.width;
    CGFloat groundHeight = groundImage.size.height;
    
    //Compute the y position for the two UIImageView
    CGFloat groundY = _gamearea.frame.size.height - groundHeight;
    CGFloat backgroundY = groundY - backgroundHeight;
    
    //The frame property holds the position and size of the views.
    //The CGRectMake methods arguments are: x position, y position, width, height.
    background.frame = CGRectMake(0, backgroundY, backgroundWidth, backgroundHeight);
    ground.frame = CGRectMake(0, groundY, groundWidth, groundHeight);
    
    //Add these views as subviews of the gamearea.
    [_gamearea addSubview:background];
    [_gamearea addSubview:ground];
    
    //Set the content size so that the gaemarea is scrollable.
    //Otherwise it defaults to the current window size.
    CGFloat gameareaHeight = backgroundHeight + groundHeight;
    CGFloat gameareaWidth = backgroundWidth;
    [_gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    UIColor *newColor;
    UIButton *button = (UIButton*)sender;
    if ([button titleColorForState:UIControlStateNormal] == [UIColor blackColor]) {
        newColor = [UIColor lightGrayColor];
    } else {
        newColor = [UIColor blackColor];
    }
    [button setTitleColor:newColor forState:UIControlStateNormal];
}
@end
