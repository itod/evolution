//
//  BioMorph.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "BioMorph.h"

//var EXAMPLES = [
//                [ 'Bug', [ 1, -2, 3, 4, -5, 1, -2, -3, 8 ] ],
//                [ 'Antlers', [ -2, -6, -1, 2, -5, -5, -1, -3, 7] ],
//                [ 'Spaceship', [ -2, 9, -3, 4, 4, 7, 2, 0, 6 ] ],
//                [ 'Frog', [ -4, 1, 4, 1, 4, 9, -9, 5, 6 ] ],
//                [ 'Medusa', [ -4, 2, 1, 3, -7, -3, -1, 8, 7 ] ],
//                ];

#define GENE_MAX_INDEX 8

@interface BioMorph ()
@property (nonatomic, retain) NSArray *xOffsets;
@property (nonatomic, retain) NSArray *yOffsets;

@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat xMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat yMax;
@end

@implementation BioMorph

- (instancetype)init {
    self = [super init];
    if (self) {
        self.propertyNames = @[@"", @""];
        self.genes = @[ @1, @(-2), @3, @4, @(-5), @1, @(-2), @(-3), @8 ]; // bug
        //self.genes = @[ @(-2), @(-6), @(-1), @2, @(-5), @(-5), @(-1), @(-3), @7 ]; // antlers
        
        self.xMin = CGFLOAT_MAX;
        self.yMin = CGFLOAT_MAX;

        self.xMax = CGFLOAT_MIN;
        self.yMax = CGFLOAT_MIN;
    }
    return self;
}


- (void)dealloc {
    self.genes = nil;
    self.xOffsets = nil;
    self.yOffsets = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Genome

- (void)renderInContext:(CGContextRef)ctx rect:(CGRect)r {
    CGPoint p = CGPointMake(NSMidX(r), NSMidY(r));
    [self tree:ctx atLocation:p depth:[self.genes[GENE_MAX_INDEX] integerValue] geneIndex:2];
}


#pragma mark -
#pragma mark Private

- (void)tree:(CGContextRef)ctx atLocation:(CGPoint)p1 depth:(NSInteger)depth geneIndex:(NSInteger)geneIdx {
    CGFloat x2 = p1.x + depth * [self.xOffsets[geneIdx] integerValue];
    CGFloat y2 = p1.y + depth * [self.yOffsets[geneIdx] integerValue];
    
    CGPoint p2 = CGPointMake(x2, y2);

    [self renderLine:ctx from:p1 to:p2];
    [self trackDimensionsFrom:p1 to:p2];

    if (depth > 0) {
        [self tree:ctx atLocation:p2 depth:depth-1 geneIndex:(geneIdx + (GENE_MAX_INDEX-1)) % GENE_MAX_INDEX];
        [self tree:ctx atLocation:p2 depth:depth-1 geneIndex:(geneIdx+1) % GENE_MAX_INDEX];
    }
}


- (void)renderLine:(CGContextRef)ctx from:(CGPoint)p1 to:(CGPoint)p2 {
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextStrokePath(ctx);
}


- (void)trackDimensionsFrom:(CGPoint)p1 to:(CGPoint)p2 {
    if (p1.x < self.xMin) {
        self.xMin = p1.x;
    }
    
    if (p2.x < self.xMin) {
        self.xMin = p2.x;
    }
    
    if (p1.x > self.xMax) {
        self.xMax = p1.x;
    }
    
    if (p2.x > self.xMax) {
        self.xMax = p2.x;
    }
    
    if (p1.y < self.yMin) {
        self.yMin = p1.y;
    }
    
    if (p2.y < self.yMin) {
        self.yMin = p2.y;
    }
    
    if (p1.y > self.yMax) {
        self.yMax = p1.y;
    }
    
    if (p2.y > self.yMax) {
        self.yMax = p2.y;
    }
}


- (CGFloat)centerY {
    return (self.yMax + self.yMin) * 0.5;
}


- (NSArray *)xOffsets {
    if (!_xOffsets) {
        self.xOffsets = @[ @(-[self.genes[1] integerValue]), @(-[self.genes[0] integerValue]), @0, self.genes[0], self.genes[1], self.genes[2], @0, @(-[self.genes[2] integerValue]) ];
    }
    return _xOffsets;
}


- (NSArray *)yOffsets {
    if (!_yOffsets) {
        self.yOffsets = @[ self.genes[5], self.genes[4], self.genes[3], self.genes[4], self.genes[5], self.genes[6], self.genes[7], self.genes[6] ];
    }
    return _yOffsets;
}


- (void)setGenes:(NSArray *)genes {
    if (_genes != genes) {
        [_genes autorelease];
        _genes = [genes copy];
        
        self.xOffsets = nil;
        self.yOffsets = nil;
    }
}

@end
