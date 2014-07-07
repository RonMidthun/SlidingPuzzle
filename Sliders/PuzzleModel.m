//
//  PuzzleModel.m
//  Sliders
//
//  Created by Ronnie Midthun on 6/2/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import "PuzzleModel.h"
#import "PuzzlePaths.h"

@implementation PuzzleLocation
-(instancetype)initWithX:(int)x Y:(int)y
{
    self = [super init];
    if(self)
    {
        self.x = x;
        self.y = y;
    }
    return self;
}
@end



@implementation PuzzleCycleData
- (instancetype)initLinearWithDestinationIndex:(NSInteger)destination start:(CGPoint)start end:(CGPoint)end
{
    self = [super init];
    if (self) {
        self.destination = destination;
        self.path = [[PuzzlePathLerp alloc] initWithStart:start end:end];
    }
    return self;
}
@end


@implementation PuzzleCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moves = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end

@implementation PuzzleDefinition
- (instancetype)initWithCycles:(NSArray*)cycles locations:(NSArray*)locations
{
    self = [super init];
    if (self) {
        self.cycles = cycles;
        self.locations = locations;
    }
    return self;
}
@end


//@implementation Gem
//@end

@implementation Puzzle
- (instancetype)initWithSize:(NSInteger)size
{
    self = [super init];
    if (self) {
        self.size = size;
        self.gemAssignments = malloc(sizeof(NSInteger) * size);
    }
    return self;
}

-(void)dealloc
{
    free(self.gemAssignments);
}

- (BOOL)isValidCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex
{
    //note there is no test for non simple looped cycles
    if(self.gemAssignments[locationIndex] == -1)
    {   //there isn't anything to move
        return NO;
    }
    PuzzleCycle* testCycle = self.definition.cycles[cycleIndex];
    NSInteger currentLocation = locationIndex;
    PuzzleCycleData* data;
    while((data = [testCycle.moves objectForKey:@(currentLocation)]))
    {
        if(data.destination == locationIndex)
        {   //cycled back to the beginning
            return YES;
        }
        if(self.gemAssignments[data.destination] == -1)
        {   //clear spot found
            return YES;
        }
        currentLocation = data.destination;
    }
    //blocked
    return NO;
}
- (BOOL)moveCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex
{
    return YES;
}
- (NSArray*)locationsWithCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex offset:(float)offset
{
    return @[];
}
- (BOOL)isGameWon
{
    return NO;
}
@end




