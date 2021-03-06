//
//  GameObject.h
// 
// You can add your own prototypes in this file
//




#import <UIKit/UIKit.h>

@class GameObjectView;
@class PigView;
@class WolfView;
@class BlockView;
@class GameObjectModel;

// Constants for the three game objects to be implemented
typedef enum {kGameObjectWolf, kGameObjectPig, kGameObjectBlock} GameObjectType;

@interface GameObject : UIViewController {
  // You might need to add state here.

}

@property (readonly) GameObjectModel *database;


@property (nonatomic, readonly) GameObjectType objectType;
@property (readwrite) CGFloat angle;
@property (readwrite) CGPoint paletteLocation;

@property (readonly) UIScrollView *palette;
@property (readonly) UIScrollView *gameArea;

@property (readwrite) GameObject* childMostController;


- (id) initWith:(GameObjectType)objType
        UnderControlOf:(GameObject*)childMostController
        AndPalette:(UIScrollView*)paletteSV
        AndGameArea:(UIScrollView*)gameAreaSV;

- (void)translate:(UIPanGestureRecognizer *)panRecognizer;
  // MODIFIES: object model (coordinates)
  // REQUIRES: game in designer mode
  // EFFECTS: the user drags around the object with one finger
  //          if the object is in the palette, it will be moved in the game area

- (void)rotate:(UIRotationGestureRecognizer *)rotationRecognizer;
  // MODIFIES: object model (rotation)
  // REQUIRES: game in designer mode,  object in game area
  // EFFECTS: the object is rotated with a two-finger rotation gesture

- (void)zoom:(UIPinchGestureRecognizer *)pinchRecognizer;
  // MODIFIES: object model (size)
  // REQUIRES: game in designer mode, object in game area
  // EFFECTS: the object is scaled up/down with a pinch gesture

// You will need to define more methods to complete the specification. 

- (void)destroy:(UITapGestureRecognizer*)doubleTapRecognizer;


@end
