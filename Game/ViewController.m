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
    
    //Set the content size so that the gamearea is scrollable.
    //Otherwise it defaults to the current window size.
    CGFloat gameareaHeight = backgroundHeight + groundHeight;
    CGFloat gameareaWidth = backgroundWidth;
    [_gamearea setContentSize:CGSizeMake(gameareaWidth, gameareaHeight)];
    
    
    // *** ps03 Problem 1 ***
    
    //Load image resources into UIImage objects
    UIImage *pigImage = [UIImage imageNamed:@"pig.png"];
    UIImage *wolfsImage = [UIImage imageNamed:@"wolfs.png"];
    UIImage *strawImage = [UIImage imageNamed:@"straw.png"];
    
    //Crop a wolf from wolfs.png
    CGFloat wolfsHeight = wolfsImage.size.height;
    CGFloat wolfsWidth = wolfsImage.size.width;
    CGRect croppingRect = CGRectMake(26, 0, 173, 148);
    CGImageRef wolfImageRef = CGImageCreateWithImageInRect([wolfsImage CGImage], croppingRect);
    UIImage *wolfNormalImage = [UIImage imageWithCGImage:wolfImageRef];
    //CGImageRelease(wolfImageRef);
    
    //Place each UIImage object into UIImageView object
    UIImageView *pig = [[UIImageView alloc]initWithImage:pigImage];
    UIImageView *straw = [[UIImageView alloc]initWithImage:strawImage];
    UIImageView *wolfNormal = [[UIImageView alloc]initWithImage:wolfNormalImage];
    
    
    //Get width and height of pig, straw, and wolfNormal
    CGFloat pigWidth = pigImage.size.width;
    CGFloat pigHeight = pigImage.size.height;
    CGFloat strawWidth = strawImage.size.width;
    CGFloat strawHeight = strawImage.size.height;
    CGFloat wolfNormalWidth = wolfNormalImage.size.width;
    CGFloat wolfNormalHeight = wolfNormalImage.size.height;
    
    //Find scaling factor to make pig, wolfNormal, and straw images fit into the palette.
    //Scaling factor should be derived from scaling the height of the images.
    //
    //
    //            scaling_factor = final_height / original_height
    //
    //
    CGFloat paletteHeight = _palette.bounds.size.height;
    CGFloat wolfNormalScalingFactor = paletteHeight / wolfNormalHeight;
    CGFloat pigScalingFactor = paletteHeight / pigHeight;
    CGFloat strawScalingFactor = paletteHeight / strawHeight;
    
    //Compute the scaled height and width of the pig, wolfNormal, and straw
    CGFloat pigScaledHeight = pigHeight * pigScalingFactor;
    CGFloat pigScaledWidth = pigWidth * pigScalingFactor;
    CGFloat strawScaledHeight = strawHeight * strawScalingFactor;
    CGFloat strawScaledWidth = strawWidth * strawScalingFactor;
    CGFloat wolfNormalScaledHeight = wolfNormalHeight * wolfNormalScalingFactor;
    CGFloat wolfNormalScaledWidth = wolfNormalWidth * wolfNormalScalingFactor;
    
    //Compute the X positions of the pig, wolfNormal, and straw
    //
    // Images are positioned as such (from left to right):
    // wolfNormal, pig, straw
    //
    CGFloat bufferSpaceInBetweenItems = 20;
    CGFloat wolfNormalX = 0;
    CGFloat pigX = wolfNormalX + wolfNormalScaledWidth + bufferSpaceInBetweenItems;
    CGFloat strawX = pigX + pigScaledWidth + bufferSpaceInBetweenItems;
    
    //The Y positions of the wolfNormal, pig, and straw are the same.
    //All objects in the palette have the same Y.
    CGFloat objectsInPaletteY = 0;
    
    //Configure the UIImageView objects' frames.
    wolfNormal.frame = CGRectMake(wolfNormalX, objectsInPaletteY, wolfNormalScaledWidth, wolfNormalScaledHeight);
    pig.frame = CGRectMake(pigX, objectsInPaletteY, pigScaledHeight,pigScaledWidth);
    straw.frame = CGRectMake(strawX, objectsInPaletteY, strawScaledHeight, strawScaledWidth);
    
    //Add these views as subviews of the palette.
    [_palette addSubview:wolfNormal];
    [_palette addSubview:pig];
    [_palette addSubview:straw];
    
    
    //BULLSHIT BELOW TODO
//   pig.frame = CGRectMake(0, 200, pigScaledHeight,pigScaledWidth);
// pig.transform = CGAffineTransformMakeTranslation(0, 200);
//  [_gamearea addSubview:pig];
//    NSLog(@"pig:  %lf %lf",pig.frame.origin.x,pig.frame.origin.y);

    
    
//    GameObjectView* kcsim = [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"kcsim.jpg"]  Origin:CGPointZero Width:[UIImage imageNamed:@"kcsim.jpg"].size.width Height:[UIImage imageNamed:@"kcsim.jpg"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:kcsim];
//   [kcsim rotateAnAdditional:50];
//    [kcsim rotateAnAdditional:50];
//    [kcsim rotateAnAdditional:50];
//    [kcsim scaleAnAdditional:0.25];
//    for (int i= 0; i < 5; i++) {
//   [kcsim translateAnAdditional:CGPointMake(0,10)];
//    }
    
   
    GameObjectView* peashooter= [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"Peashooter.png"]  Origin:CGPointZero Width:[UIImage imageNamed:@"Peashooter.png"].size.width Height:[UIImage imageNamed:@"Peashooter.png"].size.height EnableUserInteraction:NO];
    
    [_gamearea addSubview:peashooter];
    
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
