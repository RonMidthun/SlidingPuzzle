//
//  PuzzleModelTests.m
//  Sliders
//
//  Created by Ronnie Midthun on 6/2/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PuzzleModel.h"

@interface PuzzleModelTests : XCTestCase
@property (nonatomic, strong) Puzzle* puzzle;
@end


@implementation PuzzleModelTests
- (void)setUpLinear
{
    NSArray* locations = @[
                           [[PuzzleLocation alloc] initWithX:0 Y:0],
                           [[PuzzleLocation alloc] initWithX:1 Y:0],
                           [[PuzzleLocation alloc] initWithX:2 Y:0],
                           ];
    
    PuzzleCycle* cycle = [[PuzzleCycle alloc] init];
    cycle.moves[@0] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:1 start:CGPointMake(0, 0) end:CGPointMake(1, 0)];
    cycle.moves[@1] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:2 start:CGPointMake(1, 0) end:CGPointMake(2, 0)];
    
    PuzzleDefinition* def = [[PuzzleDefinition alloc] initWithCycles:@[cycle] locations:locations];
    
    self.puzzle = [[Puzzle alloc] initWithSize:3];
    self.puzzle.definition = def;
    self.puzzle.gemAssignments[0] = -1;
    self.puzzle.gemAssignments[1] = -1;
    self.puzzle.gemAssignments[2] = -1;
    
}

- (void)setUpChain
{
    NSArray* locations = @[
                           [[PuzzleLocation alloc] initWithX:0 Y:0],
                           [[PuzzleLocation alloc] initWithX:1 Y:0],
                           [[PuzzleLocation alloc] initWithX:2 Y:0],
                           ];
    
    PuzzleCycle* cycle = [[PuzzleCycle alloc] init];
    cycle.moves[@0] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:1 start:CGPointMake(0, 0) end:CGPointMake(1, 0)];
    cycle.moves[@1] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:2 start:CGPointMake(1, 0) end:CGPointMake(2, 0)];
    cycle.moves[@2] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:0 start:CGPointMake(2, 0) end:CGPointMake(0, 0)];
    
    PuzzleDefinition* def = [[PuzzleDefinition alloc] initWithCycles:@[cycle] locations:locations];
    
    self.puzzle = [[Puzzle alloc] initWithSize:3];
    self.puzzle.definition = def;
    self.puzzle.gemAssignments[0] = -1;
    self.puzzle.gemAssignments[1] = -1;
    self.puzzle.gemAssignments[2] = -1;
    
}

- (void)setUp
{
    [super setUp];
    
    //this is a simple puzzle of three locations 0 -> 1 -> 2
    // each location index is physically at CGPoint (index, 0)
    
//    NSArray* locations = @[
//                           [[PuzzleLocation alloc] initWithX:0 Y:0],
//                           [[PuzzleLocation alloc] initWithX:1 Y:0],
//                           [[PuzzleLocation alloc] initWithX:2 Y:0],
//                           ];
//    
//    PuzzleCycle* cycle = [[PuzzleCycle alloc] init];
//    cycle.moves[@0] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:1 start:CGPointMake(0, 0) end:CGPointMake(1, 0)];
//    cycle.moves[@1] = [[PuzzleCycleData alloc] initLinearWithDestinationIndex:2 start:CGPointMake(1, 0) end:CGPointMake(2, 0)];
//    
//    PuzzleDefinition* def = [[PuzzleDefinition alloc] initWithCycles:@[cycle] locations:locations];
//
//    self.puzzle = [[Puzzle alloc] initWithSize:3];
//    self.puzzle.definition = def;
//    self.puzzle.gemAssignments[0] = -1;
//    self.puzzle.gemAssignments[1] = -1;
//    self.puzzle.gemAssignments[2] = -1;
}

- (void)testEmptyCheck
{
    [self setUpChain];
    //for now, gems are just integers
    self.puzzle.gemCount = 0;
    XCTAssert(![self.puzzle isValidCycle:0 location:0], @"Empty move");
}

- (void)testMoveCheck
{
    [self setUpChain];
    self.puzzle.gemCount = 1;
    self.puzzle.gemAssignments[0] = 0;
    XCTAssert([self.puzzle isValidCycle:0 location:0], @"Open move");
}

- (void)testPushMoveCheck
{
    [self setUpChain];
    self.puzzle.gemCount = 2;
    self.puzzle.gemAssignments[0] = 0;
    self.puzzle.gemAssignments[1] = 1;
    XCTAssert([self.puzzle isValidCycle:0 location:0], @"Pushing move");
}

- (void)testBlockedCheck
{
    [self setUpLinear];
    self.puzzle.gemCount = 3;
    self.puzzle.gemAssignments[1] = 1;
    self.puzzle.gemAssignments[2] = 2;
    XCTAssert(![self.puzzle isValidCycle:0 location:1], @"Blocked move");
}

- (void)testBlockedChainCheck
{
    [self setUpLinear];
    self.puzzle.gemCount = 3;
    self.puzzle.gemAssignments[0] = 0;
    self.puzzle.gemAssignments[1] = 1;
    self.puzzle.gemAssignments[2] = 2;
    XCTAssert(![self.puzzle isValidCycle:0 location:0], @"Blocked chain move");
}

- (void)testBlockedCheckCircular
{
    [self setUpChain];
    self.puzzle.gemCount = 3;
    self.puzzle.gemAssignments[1] = 1;
    self.puzzle.gemAssignments[2] = 2;
    XCTAssert([self.puzzle isValidCycle:0 location:1], @"Blocked move circular");
}

- (void)testBlockedChainCheckCircular
{
    [self setUpChain];
    self.puzzle.gemCount = 3;
    self.puzzle.gemAssignments[0] = 0;
    self.puzzle.gemAssignments[1] = 1;
    self.puzzle.gemAssignments[2] = 2;
    XCTAssert([self.puzzle isValidCycle:0 location:0], @"Blocked chain move circular");
}



- (void)testPartialMoveCheck
{
    [self setUpChain];
    self.puzzle.gemCount = 2;
    self.puzzle.gemAssignments[0] = 0;
    self.puzzle.gemAssignments[1] = 1;
    XCTAssert([self.puzzle isValidCycle:0 location:1], @"Partial move");
}

- (void)testGapMoveCheck
{
    [self setUpChain];
    self.puzzle.gemCount = 2;
    self.puzzle.gemAssignments[0] = 0;
    self.puzzle.gemAssignments[2] = 1;
    XCTAssert([self.puzzle isValidCycle:0 location:0], @"Gap move");
}









@end


