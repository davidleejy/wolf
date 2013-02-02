//
//  PigView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PigView.h"

@interface PigView (private)
    
FOUNDATION_EXPORT NSString* imagePath;
FOUNDATION_EXPORT CGFloat defaultHeight;
FOUNDATION_EXPORT CGFloat defaultWidth;

@end


@implementation PigView


// ***** Constants ******

NSString* imagePath = @"pig.png";
CGFloat defaultHeight = 88;
CGFloat defaultWidth = 88;


// ***** Constructors ******

- (id) initWithController:(GameObject*) myController {
    // EFFECTS: Constructor
    
    UIImage* pigImage = [UIImage imageNamed:imagePath];
    
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
    
    [self setWidth:defaultWidth andHeight:defaultHeight]; // Set default size.
    
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
