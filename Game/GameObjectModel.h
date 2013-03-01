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

// To note where an object is.
typedef enum {inPalette, inGameArea, unknown} Location;

@interface GameObjectModel : NSObject <NSCoding>
// OVERVIEW: This class implements a game object model
//           There are no subclasses under this class to represent the various game objects.


@property (readwrite) WolfView* wolfV;
@property (readwrite) Location wolfLocation;
@property (readwrite) PigView* pigV;
@property (readwrite) Location pigLocation;
@property (readwrite) NSMutableArray* blocksVArray;
//@property (atomic) id<ModelDelegate> delegate;


- (id) init;
// EFFECTS: Constructor.

- (void) makeCleanAllData;
// MODIFIES: Location and NSMutableArray* properties of this class.
// EFFECTS: Clears all properties of this class.

- (void) makeCleanBlocksData;
// MODIFIES: Location and NSMutableArray* properties related to blocks in this class.
// EFFECTS: Clears block-related properties.

-(void) encodeWithCoder: (NSCoder*)coder;
-(id)initWithCoder:(NSCoder*)coder;


@end
