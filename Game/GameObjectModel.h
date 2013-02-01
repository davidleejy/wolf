//
//  GameObjectModel.h
//  Game
//
//  Created by Lee Jian Yi David on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

/* *****************************************
 
    Data persistance with Object Archives
        1. Adhere to NSCoding protocol
        2. Implement encodeWithCoder & initWithCoder methods.
 
 ******************************************** */



@interface GameObjectModel : NSObject <NSCoding>
// OVERVIEW: This class implements a game object model
//           There are subclasses under this class to represent the various game objects.

@property (readwrite) NSString* name;

@property (readwrite) CGPoint origin;

@property (readwrite) CGFloat width;

@property (readwrite) CGFloat height;

@property (readwrite) CGFloat rotation; // Units: degrees.


// NSCoding methods

- (void) encodeWithCoder:(NSCoder *)coder;
// EFFECTS: Tells the archiver how to encode this object.

- (id) initWithCoder:(NSCoder *)decoder;
// EFFECTS: Tells unarchiver how to decode the object.

@end
