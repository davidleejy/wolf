//
//  ViewHelper.h
//  Game
//
//  Created by Lee Jian Yi David on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+ (UIView*) embedText:(NSString*)txt
         WithFrame:(CGRect)frame
         TextColor:(UIColor*)color
      DurationSecs:(double)t
                In:(UIView*)view1;
// MODIFIES: view1
// EFFECTS: embeds a text in a view for a specified amount of time.
//          returns a UILabel* that points to the label embedded in view1.
// NOTES: pass in t <= 0 to permanently embed the label.
//          You may disregard the returned UILabel pointer especially
//          if you've set the duration to a non-zero value.


@end
