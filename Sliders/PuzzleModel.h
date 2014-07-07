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



@protocol PuzzlePath<NSObject>
- (CGPoint)locationWithOffset:(float) offset;
@end


@interface PuzzleLocation : NSObject
-(instancetype)initWithX:(int)x Y:(int)y;
@property (nonatomic, assign) CGPoint loc;
//TODO: win flags
@end

//the object that goes inside the cycle dictionary
@interface PuzzleCycleData : NSObject
- (instancetype)initLinearWithDestinationIndex:(NSInteger)destination start:(CGPoint)start end:(CGPoint)end;
@property (nonatomic, assign) NSInteger destination;    //the index into the locations array
@property (nonatomic, strong) NSObject<PuzzlePath>* path;
@end

//a possible move direction
@interface PuzzleCycle : NSObject
@property (nonatomic, strong) NSMutableDictionary* moves;   //locationIndex -> PuzzleCycleData
@end

//the puzzle itself
@interface PuzzleDefinition : NSObject
- (instancetype)initWithCycles:(NSArray*)cycles locations:(NSArray*)locations;
@property (nonatomic, strong) NSArray* cycles;
@property (nonatomic, strong) NSArray* locations;
@end

/*
    The state of a puzzle at any given time is determined by:
        puzzle definition
        array of gems/location
        chosen cycle
        chosen location
        offset within cycle
 
From this data, we need a means to get an array of gem locations, detect possible moves and test win conditions.
 Possible moves (based on cycle/location)
 First, make sure gem in location
 if so, loop through destinations:
    If destination is empty, then valid
    If destination is original location, then valid
    If destination is full, then need to check next destination
 
    Failure case?   Either looping to previously found gem (should not be possible!) or no destination for the location
 
 
 Gem locations:
    start by setting each gem location to it's current location (in the definition
    set current location == chosen location
    while location has a gem and not cycled
        move gem along the path
        set current location to destination location
        if no destination, then something has gone very wrong
 
 */
//the things moving on the puzzle
//@interface Gem : NSObject
////sprite
////some kind of identifying properties
//@end

//the puzzle as it stands at the moment
@interface Puzzle : NSObject
- (instancetype)initWithSize:(NSInteger)size;
@property (nonatomic, strong) PuzzleDefinition* definition;
@property (nonatomic, assign) NSInteger gemCount;     //temporary
//@property (nonatomic, strong) NSArray* gems;            //points to the actual gem data
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger* gemAssignments;  //what gem is located in each location (-1) is empty
- (BOOL)isValidCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex;
- (void)moveCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex;
- (void)locations:(CGPoint*)locations cycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex offset:(float)offset;
- (BOOL)isGameWon;
@end




