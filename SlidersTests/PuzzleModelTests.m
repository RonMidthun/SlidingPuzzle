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
@property (nonatomic, strong) PuzzleModel* model;
@property (nonatomic, strong) Puzzle* puzzle;
@property (nonatomic, strong) PuzzleAction* linear;
@property (nonatomic, strong) PuzzleAction* circular;
@end

@implementation PuzzleModelTests

- (void)setUp
{
    [super setUp];
    self.model = [[PuzzleModel alloc] init];
    //a simple puzzle with three nodes (0,1,2)
    //there are two actions: linear   0->1, 1->2  and circular 0->1,1->2,2->0
    self.linear = [[PuzzleAction alloc] init];
    self.linear.motions[@0] = @1;
    self.linear.motions[@1] = @2;
    self.circular = [[PuzzleAction alloc] init];
    self.circular.motions[@0] = @1;
    self.circular.motions[@1] = @2;
    self.circular.motions[@2] = @0;
    //start position is set per test as needed
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLinearTerminalSlots
{
    XCTAssertEqualObjects(self.linear.terminalSlots, [[NSSet alloc] initWithArray:@[@2]], @"");
}

- (void)testLinearSourceSlots
{
    XCTAssertEqualObjects(self.linear.sourceSlots, [[NSSet alloc] initWithArray:@[@0]], @"");

}

- (void)testCircularTerminalSlots
{
    XCTAssertEqualObjects(self.circular.terminalSlots, [[NSSet alloc] init], @"");
}

- (void)testCircularSourceSlots
{
    XCTAssertEqualObjects(self.circular.sourceSlots, [[NSSet alloc] init], @"");
}

- (void)testCircularMotion
{
    id setup = @{ @0:@"A", @1:@"B", @2:@"C"};
    id final = @{ @0:@"C", @1:@"A", @2:@"B"};
    [self.model.startPosition addEntriesFromDictionary:setup];
    Puzzle* testPuzzle = [[Puzzle alloc] initWithPuzzleModel:self.model];
    XCTAssertEqualObjects(testPuzzle.state, setup, @"puzzle initial state set");
    XCTAssertTrue([testPuzzle doAction:self.circular], @"action passed");
    XCTAssertEqualObjects(testPuzzle.state, final, @"puzzle final state set");
}

- (void)testLinearMotion
{
    id setup = @{ @0:@"A", @1:@"B"};
    id final = @{ @1:@"A", @2:@"B"};
    [self.model.startPosition addEntriesFromDictionary:setup];
    Puzzle* testPuzzle = [[Puzzle alloc] initWithPuzzleModel:self.model];
    XCTAssertEqualObjects(testPuzzle.state, setup, @"puzzle initial state set");
    XCTAssertTrue([testPuzzle doAction:self.linear], @"action passed");
    XCTAssertEqualObjects(testPuzzle.state, final, @"puzzle final state set");
}

- (void)testLinearBlock
{
    id setup = @{ @0:@"A", @1:@"B", @2:@"C"};
    [self.model.startPosition addEntriesFromDictionary:setup];
    Puzzle* testPuzzle = [[Puzzle alloc] initWithPuzzleModel:self.model];
    XCTAssertEqualObjects(testPuzzle.state, setup, @"puzzle initial state set");
    XCTAssertFalse([testPuzzle doAction:self.linear], @"action blocked");
    [testPuzzle doAction:self.linear];
    XCTAssertEqualObjects(testPuzzle.state, setup, @"puzzle final state set");
    
}







@end
