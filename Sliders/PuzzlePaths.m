//
//  PuzzlePaths.m
//  Sliders
//
//  Created by Ronnie Midthun on 7/6/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import "PuzzlePaths.h"

@implementation PuzzlePathLerp
-(instancetype)initWithStart:(CGPoint)start end:(CGPoint)end
{
    self = [super init];
    if(self)
    {
        self.start = start;
        self.end = end;
    }
    return self;
}

-(CGPoint)locationWithOffset:(float)offset
{
    float reverse = 1.f - offset;
    return CGPointMake(self.start.x * reverse + self.end.x * offset, self.start.y * reverse + self.end.y * offset);
}
@end
