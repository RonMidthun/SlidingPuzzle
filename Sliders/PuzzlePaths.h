//
//  PuzzlePaths.h
//  Sliders
//
//  Created by Ronnie Midthun on 7/6/14.
//  Copyright (c) 2014 Ronnie Midthun. All rights reserved.
//

#import "PuzzleModel.h"

@interface PuzzlePathLerp: NSObject<PuzzlePath>
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;
- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end;
@end
