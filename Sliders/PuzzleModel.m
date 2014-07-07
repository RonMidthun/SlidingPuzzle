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
        self.loc = CGPointMake(x, y);
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
- (void)moveCycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex
{
    PuzzleCycle* testCycle = self.definition.cycles[cycleIndex];
    NSInteger currentLocation = locationIndex;
    NSInteger* sourceGems = malloc(sizeof(NSInteger) * self.size);
    memcpy(sourceGems, self.gemAssignments, sizeof(NSInteger) * self.size);
    while(YES)
    {
        if(sourceGems[currentLocation] != -1)
        {
            PuzzleCycleData* data = [testCycle.moves objectForKey:@(currentLocation)];
            NSAssert(data, @"moveCycle called with invalid cycle information");
            self.gemAssignments[data.destination] = sourceGems[currentLocation];
            currentLocation = data.destination;
            if(currentLocation == locationIndex)
            {
                //we have cycled back to the beginning, so we're finished
                break;
            }
        }
        else
        {
            //we have reached an empty spot, so empty the first node
            self.gemAssignments[locationIndex] = -1;
            break;
        }
    }
    free(sourceGems);
}

- (void)locations:(CGPoint*)locations cycle:(NSInteger)cycleIndex location:(NSInteger)locationIndex offset:(float)offset
{
    //current locations
    for(int i=0; i<self.size; ++i)
    {
        if(self.gemAssignments[i] != -1)
        {
            locations[self.gemAssignments[i]] = [self.definition.locations[i] loc];
        }
    }

    //for items in move cycle
    PuzzleCycle* testCycle = self.definition.cycles[cycleIndex];
    NSInteger currentLocation = locationIndex;
    while(YES)
    {
        if(self.gemAssignments[currentLocation] != -1)
        {
            PuzzleCycleData* data = [testCycle.moves objectForKey:@(currentLocation)];
            NSAssert(data, @"moveCycle called with invalid cycle information");
            //find location of gem along the path
            
            locations[self.gemAssignments[currentLocation]] = [data.path locationWithOffset:offset];
            
            currentLocation = data.destination;
            if(currentLocation == locationIndex)
            {   //completed the cycle
                break;
            }
        }
        else
        {   //end of chain
            break;
        }
    }

    
}

- (BOOL)isGameWon
{
    return NO;
}
@end




