//
//  GamePig.m
//  Game
//
//  Created by Lee Jian Yi David on 2/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "GamePig.h"



@implementation GamePig

-(id)initWithPalette:(UIScrollView*)paletteSV AndGameArea:(UIScrollView*)gameAreaSV {
    if (self = [super initWith:kGameObjectPig UnderControlOf:self AndPalette:paletteSV AndGameArea:gameAreaSV]) {
        self.origin = CGPointMake(55, 0);
        self.paletteLocation = CGPointMake(55,0);
        self.angle = 0;
        self.width = 55;
        self.height = 55;
        return self;
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
