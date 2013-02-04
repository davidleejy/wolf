//
//  GameObjectModel.m
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PigView.h"
#import "BlockView.h"
#import "WolfView.h"

#import "GameObjectModel.h"

@implementation GameObjectModel
// OVERVIEW: This class implements a game object model
//           There are subclasses under this class to represent the various game objects.







@end


//@synthesize name = _name;
//@synthesize origin = _origin;
//@synthesize width = _width;
//@synthesize height = _height;
//@synthesize rotation = _rotation; // Units: degrees
//
//
//// NSCoding methods
//- (void) encodeWithCoder:(NSCoder *)encoder {
//    // EFFECTS: Tells the archiver how to encode this object.
//    
//    [encoder encodeObject:_name forKey:@"name"];
//    [encoder encodeCGPoint:_origin forKey:@"origin"];
//    [encoder encodeFloat:_height forKey:@"height"];
//    [encoder encodeFloat:_width forKey:@"width"];
//    [encoder encodeFloat:_rotation forKey:@"rotation"];
//}
//
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    // EFFECTS: Tells unarchiver how to decode the object.
//    
//    [self setName: [decoder decodeObjectForKey:@"name"]];
//    [self setOrigin: [decoder decodeCGPointForKey:@"origin"]];
//    [self setHeight: [decoder decodeFloatForKey:@"height"]];
//    [self setWidth: [decoder decodeFloatForKey:@"width"]];
//    [self setRotation: [decoder decodeFloatForKey:@"rotation"]];
//    
//    return self;
//}
//
//
//@end
