//
//  WolfView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WolfView.h"


@interface WolfView ()

@property (readwrite) UIImage* wolfsImage; // Many wolfs in this image
@property (readwrite) NSUInteger actionFrame; // What this wolf's action is.

@end


@interface WolfView (helper)

- (CGRect) getCroppingRectForWolfs:(NSUInteger) desiredFrame;
// EFFECTS: Returns a CGRect that when applied to wolfs.png, bounds the desired frame.

- (UIImage*) wolfInFrame:(NSUInteger) desiredFrame;
// EFFECTS: Returns a wolf belonging to the desired frame.

@end



@implementation WolfView


// ***** Synthesis ******
@synthesize wolfsImage = _wolfsImage;
@synthesize actionFrame = _actionFrame;


// ***** Constructors ******

- (id) initDefaultWithController:(UIViewController*)myController {
    // EFFECTS: Constructor that initialises this object with default size. Picks frame 1 out of 15.
    
    
    _wolfsImage = [UIImage imageNamed:WOLFS_IMAGE_PATH]; // MUST LINK THIS PROPERTY TO AN IMAGE WITH A BUNCH OF WOLFS!!!
    
    // Pick frame 1 out of 15.
    UIImage* frameOne = [self wolfInFrame:1];
    
    // Construct super class.
    self = [super initWithController:myController
                             UIImage:frameOne
                              Origin:CGPointZero
                               Width:frameOne.size.width
                              Height:frameOne.size.height
                            EnableUserInteraction:YES];
    
    
    if (!self) return nil; // error handling.
    
    // Remember action frame.
    _actionFrame = 1;
    
    // Set default size.
    [self setFrameWidth:WOLF_DEFAULT_WIDTH andFrameHeight:WOLF_DEFAULT_HEIGHT];
    
    return self;
}


- (id) initWithController:(UIViewController*)myController AndActionFrame:(NSUInteger)desiredFrame {
    // REQUIRES: Valid action frame.
    // EFFECTS: Constructor that initialises this object with default size. You pick frame.
    
    _wolfsImage = [UIImage imageNamed:WOLFS_IMAGE_PATH]; // MUST LINK THIS PROPERTY TO AN IMAGE WITH A BUNCH OF WOLFS!!!
    
    // Pick desired frame.
    UIImage* desiredWolfImage = [self wolfInFrame:desiredFrame];
    
    // Construct super class.
    self = [super initWithController:myController
                             UIImage:desiredWolfImage
                              Origin:CGPointZero
                               Width:desiredWolfImage.size.width
                              Height:desiredWolfImage.size.height
                            EnableUserInteraction:YES];
    
    
    if (!self) return nil; // error handling.
    
    // Remember action frame.
    _actionFrame = desiredFrame;
    
    // Set default size.
    [self setFrameWidth:WOLF_DEFAULT_WIDTH andFrameHeight:WOLF_DEFAULT_HEIGHT];
    
    return self;
}


- (void) showActionFrame:(NSUInteger)desiredFrame {
    // MODIFIES: image in UIImageView superclass.
    // EFFECTS: Changes wolf's action to that which corresponds to desired frame.
    //          Maintains default size.
    
    // Pick desired frame.
    UIImage* desiredWolfImage = [self wolfInFrame:desiredFrame];
    
    [self setImage:desiredWolfImage]; //Note that _image is a property of the UIImageView class (parent class).
}









// ***** Helper functions ******


- (CGRect) getCroppingRectForWolfs:(NSUInteger) desiredFrame {
    // EFFECTS: Returns a CGRect that when applied to wolfs.png, bounds the desired frame.
    
    // Error handling
    if (desiredFrame < 1 || desiredFrame > WOLFS_MAX_FRAMES_TO_CHOOSE_FROM) {
        [NSException raise:@"WolfView class" format:@"%d is an invalid frame! Choose from frames 1 ~ %d. Error is handled by setting desiredFrame to 1.", desiredFrame, WOLFS_MAX_FRAMES_TO_CHOOSE_FROM];
        desiredFrame = 1;
    }
    
    
    CGFloat allFramesHeight = _wolfsImage.size.height;
    CGFloat allFramesWidth = _wolfsImage.size.width;
    CGFloat singleFrameHeight = allFramesHeight / WOLFS_ROWS_OF_FRAMES;
    CGFloat singleFrameWidth = allFramesWidth / WOLFS_COLUMNS_OF_FRAMES;
    CGFloat frameX = ((desiredFrame -1) % WOLFS_COLUMNS_OF_FRAMES) * singleFrameWidth;
    CGFloat frameY = ((int)((desiredFrame - 1) / WOLFS_COLUMNS_OF_FRAMES)) * singleFrameHeight;
    
    CGRect croppingRect = CGRectMake(frameX, frameY, singleFrameWidth, singleFrameHeight);
    
    return croppingRect;
}


- (UIImage*) wolfInFrame:(NSUInteger) desiredFrame {
    // REQUIRES: Valid action frame.
    //           _wolfsImage be loaded with a bunch of wolfs.
    // EFFECTS: Returns a wolf belonging to the desired frame.
    
    CGRect croppingRect = [self getCroppingRectForWolfs:desiredFrame];
    
    CGImageRef refToDesiredWolfFrame = CGImageCreateWithImageInRect([_wolfsImage CGImage], croppingRect);
    UIImage *result = [UIImage imageWithCGImage:refToDesiredWolfFrame];
    
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
