//
//  ViewController.m
//  Game
//
//  Created by Lee Jian Yi David on 1/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "math.h"

// View classes
#import "GameObjectView.h"
#import "PigView.h"
#import "WolfView.h"
#import "BlockView.h"

// Controller classes
#import "GameObject.h"
#import "GameWolf.h"
#import "GamePig.h"
#import "GameBlock.h"

// Debugging
#import "UIView+ExploreViewHierarchy.h"

#import "ViewController.h"

@interface ViewController ()
    // ****** Controllers being managed ******
    @property (nonatomic,readwrite) GameWolf* wolfController;
    @property (nonatomic,readwrite) GamePig* pigController;
    @property (nonatomic,readwrite) GameBlock* blockController;
@end




@implementation ViewController

@synthesize temp = _temp;
@synthesize wolfController = _wolfController;
@synthesize pigController = _pigController;
@synthesize blockController = _blockController;

////todo
//- (void)translate:(UIPanGestureRecognizer *)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        _temp = CGAffineTransformMake(recognizer.view.transform.a, recognizer.view.transform.b, recognizer.view.transform.c, recognizer.view.transform.d, recognizer.view.transform.tx, recognizer.view.transform.ty);
//    }
//    
//    CGPoint translation = [recognizer translationInView:recognizer.view];
//    
//    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
//    
//    recognizer.view.transform = CGAffineTransformTranslate(_temp, translation.x, translation.y);
//    
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view]; //reset recognizer
//    }
//}
////todo
//- (void) rotate:(UIRotationGestureRecognizer *)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        _temp = CGAffineTransformMake(recognizer.view.transform.a, recognizer.view.transform.b, recognizer.view.transform.c, recognizer.view.transform.d, recognizer.view.transform.tx, recognizer.view.transform.ty);
//    }
//    
////    CGFloat iniRotationRads = [(GameObjectView*)recognizer.view rotationInRads];
//    CGFloat rotationRads = [recognizer rotation];
//    
////    NSLog(@"ini rotation in degs: %lf",[(GameObjectView*)recognizer.view rotationInRads]* 180.0 /M_PI);
////    NSLog(@"rotation detected of %lf degs",rotationRads * 180.0 /M_PI);
//    
//    //recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, iniRotationRads+rotationRads);
//    
//    //recognizer.view.transform = CGAffineTransformConcat(recognizer.view.transform, CGAffineTransformMakeRotation(iniRotationRads+rotationRads));
//    
//    recognizer.view.transform = CGAffineTransformRotate(_temp, rotationRads);
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//      //[(GameObjectView*)recognizer.view rotateAnAdditionalRads:rotationRads];
//       // NSLog(@"fin rotation in degs: %lf",[(GameObjectView*)recognizer.view rotationInRads]* 180.0 /M_PI);
//        [recognizer setRotation:0]; //reset recognizer
//    }
//}
//
//- (void) zoom:(UIPinchGestureRecognizer *)recognizer {
//    NSLog(@"zoom detected");
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        _temp = CGAffineTransformMake(recognizer.view.transform.a, recognizer.view.transform.b, recognizer.view.transform.c, recognizer.view.transform.d, recognizer.view.transform.tx, recognizer.view.transform.ty);
//    }
//    
//    CGFloat scalingFactor = [recognizer scale];
//    
//    recognizer.view.transform = CGAffineTransformScale(_temp, scalingFactor, scalingFactor);
//    
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        [recognizer setScale:1.0];
//    }
//    
////    CGFloat iniScaleFactor = [(GameObjectView*)recognizer.view scalingFactor];
////    
////    CGFloat additionalScalingFactor = [recognizer scale];
////    
////    NSLog(@"ini scalingfactor: %lf",[(GameObjectView*)recognizer.view scalingFactor]);
////    NSLog(@"additional scaling factor of %lf",additionalScalingFactor);
////    
////    recognizer.view.transform = CGAffineTransformMakeScale(iniScaleFactor*additionalScalingFactor, iniScaleFactor*additionalScalingFactor);
////    
////    if (recognizer.state == UIGestureRecognizerStateEnded) {
////        [(GameObjectView*)recognizer.view scaleAnAdditional:additionalScalingFactor];
////        NSLog(@"fin scaling Factor: %lf",[(GameObjectView*)recognizer.view scalingFactor]);
////    }
//}
//
//- (void) destroy:(UITapGestureRecognizer *)recognizer {
//    NSLog(@"destroy detected");
//}

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
    
    //Assign ImageView tags
    background.tag = 3;
    ground.tag = 4;
    
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
    
    
    //Initialize controllers being managed.
    _wolfController = [[GameWolf alloc] initWithPalette:_palette AndGameArea:_gamearea];
    [_palette addSubview:_wolfController.view];
    
    NSLog(@"##### %@",_gamearea);

    _pigController = [[GamePig alloc] initWithPalette:_palette AndGameArea:_gamearea];
    [_palette addSubview:_pigController.view];

    _blockController = [[GameBlock alloc] initWithPalette:_palette AndGameArea:_gamearea];
    [_palette addSubview:_blockController.view];
    
    
    
////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO TESTINGS

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO Peashooter Testing
   
//    GameObjectView* peashooter= [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"Peashooter.png"]  Origin:CGPointZero Width:[UIImage imageNamed:@"Peashooter.png"].size.width Height:[UIImage imageNamed:@"Peashooter.png"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:peashooter];
    
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO Wolf Testing
    
//    WolfView* aWolf = [[WolfView alloc] initWithController:self AndActionFrame:3];
//    [aWolf translateAnAdditional:CGPointMake(100, 40)];
//    
//    [_gamearea addSubview:aWolf];
//    [aWolf showActionFrame:14];

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO Block Testing
    
//    BlockView* aBlock = [[BlockView alloc] initDefaultWithController:self];
//    
//    [_gamearea addSubview:aBlock];
//    [aBlock translateAnAdditional:CGPointMake(500, 40)];
//    [aBlock showMaterial:0];
//    [aBlock rotateAnAdditionalDeg:45];
//
//    NSLog(@"inibounds ablock %lf %lf",[aBlock boundsWidth],[aBlock boundsHeight]);
//    
//    CGFloat scalefactortest = 2;
//    
//    aBlock.transform = CGAffineTransformScale(aBlock.transform, scalefactortest, scalefactortest);
//    
//    NSLog(@"finbounds ablock %lf %lf",[aBlock boundsWidth],[aBlock boundsHeight]);

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO Pig Testing

//    PigView* aPig = [[PigView alloc] initDefaultWithController:self];
//    [_gamearea addSubview:aPig];
//    PigView* aPig2 = [[PigView alloc] initDefaultWithController:self];
//    [_gamearea addSubview:aPig2];
//    PigView* aPig3 = [[PigView alloc] initDefaultWithController:self];
//    [_gamearea addSubview:aPig3];
//    
//    [aPig rotateAnAdditionalDeg:90+34];
//    [aPig rotateAnAdditionalDeg:0];
//    [aPig setFrameCenter:CGPointMake(500, 40)];
//    
//    [aPig2 rotateAnAdditionalDeg:0];
//    [aPig2 setFrameCenter:CGPointMake(550, 40)];
//    
//    
//    [aPig3 setFrameCenter:CGPointMake(600, 40)];
    
    
    
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TODO Circle Testing
    
//    GameObjectView* circ1 = [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"circle.jpg"]  Origin:CGPointZero Width:[UIImage imageNamed:@"circle.jpg"].size.width Height:[UIImage imageNamed:@"circle.jpg"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:circ1];
//    [circ1 setFrameOrigin:CGPointMake(200, 40)];
//
//    
//    GameObjectView* circ2 = [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"circle.jpg"]  Origin:CGPointZero Width:[UIImage imageNamed:@"circle.jpg"].size.width Height:[UIImage imageNamed:@"circle.jpg"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:circ2];
//    [circ2 setFrameOrigin:CGPointMake(600, 40)];
//    [circ2 rotateAnAdditionalDeg:183];
//    
//    GameObjectView* circ3 = [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"circle.jpg"]  Origin:CGPointZero Width:[UIImage imageNamed:@"circle.jpg"].size.width Height:[UIImage imageNamed:@"circle.jpg"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:circ3];
//    [circ3 rotateAnAdditionalDeg:114];
//    [circ3 setFrameOrigin:CGPointMake(900, 40)];
//    [circ3 setFrameCenter:CGPointMake(900, 100)];
//    
//    GameObjectView* circ4 = [[GameObjectView alloc] initWithController:self UIImage:[UIImage imageNamed:@"circle.jpg"]  Origin:CGPointZero Width:[UIImage imageNamed:@"circle.jpg"].size.width Height:[UIImage imageNamed:@"circle.jpg"].size.height EnableUserInteraction:NO];
//    
//    [_gamearea addSubview:circ4];
//    [circ4 setFrameOrigin:CGPointMake(900+250, 40)];
//    [circ4 rotateAnAdditionalDeg:114];
//    [circ4 scaleAnAdditional:0.5];
//    [circ4 setFrameCenter:CGPointMake(900, 100)];
//    [circ4 setAlpha:0.7];
    
}


- (IBAction)startButton:(id)sender {
}

- (IBAction)saveButton:(id)sender {
}

- (IBAction)loadButton:(id)sender {
}

- (IBAction)resetButton:(id)sender {
    //[self reset];
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
