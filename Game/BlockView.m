//
//  BlockView.m
//  Game
//
//  Created by Lee Jian Yi David on 2/2/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BlockView.h"

@interface BlockView ()

@property(readwrite) NSArray* materialsArray;
// DESCRIPTION:
// 0 Straw
// 1 Wood
// 2 Iron
// 3 Stone

@property(readwrite) NSUInteger currentMaterial;
// DESCRIPTION:
// 0 Straw
// 1 Wood
// 2 Iron
// 3 Stone

@end


@interface BlockView (helper)

- (void) adjustToDefaultSize;
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: constructs a new UIImage object that conforms to the default size and aspect of blocks.

@end


@implementation BlockView

// ***** Synthesis ******
@synthesize materialsArray = _materialsArray;
@synthesize currentMaterial = _currentMaterial;






//***** Constructors *****

- (id) initDefaultWithController:(UIViewController*)myController {
    // EFFECTS: Constructor that initialises this object with default size. Default block is straw.
    
    // Initialise properties
    _materialsArray = [[NSArray alloc] initWithObjects:BLOCK_STRAW_IMAGE_PATH,
                                                    BLOCK_WOOD_IMAGE_PATH,
                                                    BLOCK_IRON_IMAGE_PATH,
                                                    BLOCK_STONE_IMAGE_PATH, nil];
    
    _currentMaterial = 0; // DON'T FORGET!
    
    // Default block is straw.
    UIImage* strawStockImage = [UIImage imageNamed:BLOCK_STRAW_IMAGE_PATH];
    
    self = [super initWithController:myController
                             UIImage:strawStockImage
                              Origin:CGPointZero
                               Width:strawStockImage.size.width
                              Height:strawStockImage.size.height
               EnableUserInteraction:YES];
    
    if (!self) return nil; //error handling
    
    [self adjustToDefaultSize];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:[self myController] action:@selector(changeMaterial:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapGestureRecognizer];
    
    return self;
}






//***** Setters *****

- (void) showMaterial:(NSUInteger)desiredMaterial {
    // MODIFIES: image in UIImageView superclass
    // EFFECTS: changes the material of this object.
    
    // Error handling of invalid desiredMaterial
    if (desiredMaterial >= _materialsArray.count) {
        [NSException raise:@"BlockView class" format:@"%d is an invalid block! Choose from frames 0 ~ %d. Error is handled by setting desiredBlock to 0.", desiredMaterial, (_materialsArray.count-1)];
        desiredMaterial = 0;
    }
    
    // Load image of desired material.
    UIImage* desiredBlockImage = [UIImage imageNamed:[_materialsArray objectAtIndex:desiredMaterial]];
    
    // Remember material that is switched to.
    _currentMaterial = desiredMaterial; // DON'T FORGET!
    
    [self setImage:desiredBlockImage]; //Note that _image is a property of the UIImageView class (parent class).
    
    [self adjustToDefaultSize];
}



- (void) nextMaterial {
    // MODIFIES: image in UIImageView superclass
    // EFFECTS: changes the material of this object to the next material in materialsArray.
    //          WHen the end of materialsArray is reached, wrap around and pick the 1st material.

    _currentMaterial = (_currentMaterial + 1) % (_materialsArray.count);
    [self showMaterial:_currentMaterial];
}







// ****** Helpers ******

- (void) adjustToDefaultSize {
// MODIFIES: frame property in UIImageView superclass.
// EFFECTS: constructs a new UIImage object that conforms to the default size and aspect of blocks.
    
    self.contentMode = UIViewContentModeScaleToFill;
    [self setFrameWidth:BLOCK_DEFAULT_WIDTH andFrameHeight:BLOCK_DEFAULT_HEIGHT];
    [self setBoundsWidth:BLOCK_DEFAULT_WIDTH andBoundsHeight:BLOCK_DEFAULT_HEIGHT];
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
