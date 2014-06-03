//
//  PuzzleModel.m
//  Sliders
//
//  Created by Ronnie Midthun on 6/2/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import "PuzzleModel.h"
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

@implementation PuzzleAction
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.motions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSSet *)terminalSlots
{
    NSSet* sources = [NSSet setWithArray:[self.motions allKeys]];
    NSMutableSet* destinations = [NSMutableSet setWithArray:[self.motions allValues]];
    [destinations minusSet:sources];
    return destinations;
}

-(NSSet *)sourceSlots
{
    NSMutableSet* sources = [NSMutableSet setWithArray:[self.motions allKeys]];
    NSSet* destinations = [NSSet setWithArray:[self.motions allValues]];
    [sources minusSet:destinations];
    return sources;
}


@end

@implementation PuzzleModel
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.positions = [[NSMutableArray alloc] init];
        self.actions = [[NSMutableArray alloc] init];
        self.initialPosition = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end

@implementation Puzzle
- (instancetype)initWithPuzzleModel:(PuzzleModel*)model
{
    self = [super init];
    if(self)
    {
        self.model = model;
        [self reset];
    }
    return self;
}

- (void)reset
{
    self.state = [[NSMutableDictionary alloc] initWithDictionary:self.model.initialPosition];
}

- (BOOL)doAction:(PuzzleAction*)action
{
    NSArray* usedKeys = [self.state allKeys];
    NSSet* usedSet = [NSSet setWithArray:usedKeys];
    if([usedSet intersectsSet:action.terminalSlots]) return false;
    
    NSMutableDictionary* finalState = [[NSMutableDictionary alloc] initWithDictionary:self.state];
    [action.motions enumerateKeysAndObjectsUsingBlock:^(NSNumber* source, NSNumber* dest, BOOL *stop) {
        NSString* token = self.state[source];
        if(token)
        {
            finalState[dest] = token;
        }
        else
        {
            [finalState removeObjectForKey:dest];
        }
    }];
    [action.sourceSlots enumerateObjectsUsingBlock:^(NSNumber* loc, BOOL *stop) {
        [finalState removeObjectForKey:loc];
        
    }];
    self.state = finalState;
    return true;
}
@end

