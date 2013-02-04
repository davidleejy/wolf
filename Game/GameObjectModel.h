//
//  GameObjectModel.h
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WolfView;
@class PigView;
@class BlockView;


@interface GameObjectModel : NSObject
// OVERVIEW: This class implements a game object model
//           There are subclasses under this class to represent the various game objects.


@property (readwrite) UIScrollView* palette;
@property (readwrite) UIScrollView* gamearea;

@property (readwrite) WolfView* wolfData;
@property (readwrite) PigView* pigData;
@property (readwrite) NSMutableArray* blocksData;





@end



// must ensure protocol: <NSCoding>

//@property (readwrite) NSString* name;
//
//@property (readwrite) CGPoint origin;
//
//@property (readwrite) CGFloat width;
//
//@property (readwrite) CGFloat height;
//
//@property (readwrite) CGFloat rotation; // Units: degrees.
//
//
//// NSCoding methods
//
//- (void) encodeWithCoder:(NSCoder *)coder;
//// EFFECTS: Tells the archiver how to encode this object.
//
//- (id) initWithCoder:(NSCoder *)decoder;
//// EFFECTS: Tells unarchiver how to decode the object.
//
//@end
