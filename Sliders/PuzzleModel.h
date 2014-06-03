//
//  PuzzleModel.h
//  Sliders
//
//  Created by Ronnie Midthun on 6/2/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

/*
    A puzzle consists of:
        a set of locations:
            simple X,Y
        a set of operations:
            a control location & sprite
            a set of arrows indicating movement
        a set of markers in a valid winning array (for initializing in a fair manner)
        a set of win conditions:
            TBD, this is hardest part
 */

#import <Foundation/Foundation.h>
@interface PuzzleLocation : NSObject
-(instancetype)initWithX:(int)x Y:(int)y;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@end

@interface PuzzleAction : NSObject
@property (nonatomic, strong) NSString* imageName;  //a control image, if any is defined
@property (nonatomic, strong) PuzzleLocation* location;                //location of control point
@property (nonatomic, strong) NSMutableDictionary* motions;     //each movement is of form key->value
@property (nonatomic, readonly) NSSet* terminalSlots;    //values that aren't also keys,
                                                                //means these spots must be clear in order to move
@property (nonatomic, readonly) NSSet* sourceSlots;     //keys that aren't values, these will be emptied
@end


@interface PuzzleModel : NSObject
@property (nonatomic, strong) NSMutableArray* positions;    //puzzle location for each position in the puzzle
@property (nonatomic, strong) NSMutableArray* actions;
@property (nonatomic, strong) NSMutableDictionary* startPosition;     //name of marker at each location
@end

@interface Puzzle : NSObject
@property (nonatomic, strong) PuzzleModel* model;
@property (nonatomic, strong) NSMutableDictionary* state;
- (instancetype)initWithPuzzleModel:(PuzzleModel*)model;
- (void)reset;
- (BOOL)doAction:(PuzzleAction*)action;
@end


