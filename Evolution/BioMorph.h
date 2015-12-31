//
//  BioMorph.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "Morph.h"

@interface BioMorph : Morph

@property (nonatomic, retain) NSArray *genes;
@property (nonatomic, retain) NSArray *xOffsets;
@property (nonatomic, retain) NSArray *yOffsets;

@property (nonatomic, assign) CGFloat yOffset;

@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat xMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat yMax;
@end
