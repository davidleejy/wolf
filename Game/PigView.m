//
//  PigView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PigView.h"


@implementation PigView


// ***** Constructors ******

- (id) initWithController:(GameObject*) myController {
    // EFFECTS: Designated Constructor
    
    UIImage* pigImage = [UIImage imageNamed:PIG_IMAGE_PATH];
    
    self = [super initWithController:myController
                    UIImage:pigImage
                    Origin:CGPointZero
                    Width:pigImage.size.width
                    Height:pigImage.size.height
                    EnableUserInteraction:YES];
    
    if (self)
        return self;
    else
        return nil;
}



- (id) initDefaultWithController:(GameObject *)myController {
// EFFECTS: Constructor that initialises this object with default size.

    self = [self initWithController:myController]; // Use designated constructor
    
    if (!self) return nil; // Error handling
    
    [self setFrameWidth:PIG_DEFAULT_WIDTH andFrameHeight:PIG_DEFAULT_HEIGHT]; // Set default size.
    
    return self;
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
