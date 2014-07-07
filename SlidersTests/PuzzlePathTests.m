//
//  PuzzlePathTests.m
//  Sliders
//
//  Created by Ronnie Midthun on 7/6/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PuzzlePaths.h"

@interface PuzzlePathTests : XCTestCase
@property (nonatomic, strong) NSObject<PuzzlePath>* path;
@end

@implementation PuzzlePathTests


- (void)testLerp {
    self.path = [[PuzzlePathLerp alloc] initWithStart:CGPointMake(2, 2) end:CGPointMake(4, 2)];
    CGPoint sample0 = [self.path locationWithOffset:0];
    CGPoint sampleHalf = [self.path locationWithOffset:0.5];
    CGPoint sample1 = [self.path locationWithOffset:1];
    XCTAssert(CGPointEqualToPoint(sample0, CGPointMake(2, 2)), @"start");
    XCTAssert(CGPointEqualToPoint(sampleHalf, CGPointMake(3, 2)), @"halfway");
    XCTAssert(CGPointEqualToPoint(sample1, CGPointMake(4, 2)), @"end");
}


@end
