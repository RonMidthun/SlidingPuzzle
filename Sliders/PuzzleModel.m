//
//  PuzzleModel.m
//  Sliders
//
//  Created by Ronnie Midthun on 6/2/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import "PuzzleModel.h"
@implementation PuzzleLocation
@end

@implementation PuzzleAction
@end

@implementation PuzzleModel
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

