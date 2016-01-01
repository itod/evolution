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
#define GENE_MUTATION_DELTA 2

static BOOL EVOIsGeneValueInRange(NSUInteger geneIndex, NSInteger geneValue) {
    static NSInteger GENE_RANGE_DIMENSION[2] = {-9, 9};
    static NSInteger GENE_RANGE_DEPTH[2] = {3, 9};
    
    if (geneIndex < GENE_MAX_INDEX ) {
        return geneValue >= GENE_RANGE_DIMENSION[0] && geneValue <= GENE_RANGE_DIMENSION[1];
    } else if (GENE_MAX_INDEX == geneIndex) {
        return geneValue >= GENE_RANGE_DEPTH[0] && geneValue <= GENE_RANGE_DEPTH[1];
    } else {
        return NO;
    }
}

static NSInteger EVORandom(low, high) {
    double r = (double)rand() / (double)RAND_MAX;
    return low + floor(r * (high - low));
}

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
        //self.genes = @[ @1, @(-2), @3, @4, @(-5), @1, @(-2), @(-3), @8 ]; // bug
        self.genes = [[@[ @(-2), @(-6), @(-1), @2, @(-5), @(-5), @(-1), @(-3), @7 ] mutableCopy] autorelease]; // antlers
        
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
#pragma mark Morph

- (Morph *)mutate {
    BioMorph *bm = [[[BioMorph alloc] init] autorelease];
    bm.genes = self.genes;
    [bm mutateGene];
    return bm;
}


- (void)mutateGene {
    NSUInteger geneIndex = 0;
    NSInteger newValue = 0;

    do {
        // Ensure a small change the genes
        NSInteger mutationOffset = 0;
        do {
            mutationOffset = EVORandom(-GENE_MUTATION_DELTA, GENE_MUTATION_DELTA);
        } while (0 == mutationOffset);
        
        geneIndex = EVORandom(0, GENE_MAX_INDEX);
        newValue = [_genes[geneIndex] integerValue] + mutationOffset;
        
    } while (!EVOIsGeneValueInRange(geneIndex, newValue));
    
    _genes[geneIndex] = @(newValue);
}


- (void)renderInContext:(CGContextRef)ctx rect:(CGRect)r {
    TDAssertMainThread();
    CGPoint p = CGPointMake(NSMidX(r), NSMidY(r));
    [self tree:ctx location:p depth:[self.genes[GENE_MAX_INDEX] integerValue] geneIndex:2];
}


#pragma mark -
#pragma mark Private

- (void)tree:(CGContextRef)ctx location:(CGPoint)p1 depth:(NSInteger)depth geneIndex:(NSInteger)geneIdx {
    CGFloat x2 = p1.x + depth * [self.xOffsets[geneIdx] integerValue];
    CGFloat y2 = p1.y + depth * [self.yOffsets[geneIdx] integerValue];
    
    CGPoint p2 = CGPointMake(x2, y2);

    [self renderLine:ctx from:p1 to:p2];
    [self trackDimensionsFrom:p1 to:p2];

    if (depth > 0) {
        [self tree:ctx location:p2 depth:depth-1 geneIndex:(geneIdx + (GENE_MAX_INDEX-1)) % GENE_MAX_INDEX];
        [self tree:ctx location:p2 depth:depth-1 geneIndex:(geneIdx+1) % GENE_MAX_INDEX];
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
    if (p1.x < _xMin) {
        self.xMin = p1.x;
    }
    
    if (p2.x < _xMin) {
        self.xMin = p2.x;
    }
    
    if (p1.x > _xMax) {
        self.xMax = p1.x;
    }
    
    if (p2.x > _xMax) {
        self.xMax = p2.x;
    }
    
    if (p1.y < _yMin) {
        self.yMin = p1.y;
    }
    
    if (p2.y < _yMin) {
        self.yMin = p2.y;
    }
    
    if (p1.y > _yMax) {
        self.yMax = p1.y;
    }
    
    if (p2.y > _yMax) {
        self.yMax = p2.y;
    }
}


- (CGFloat)centerY {
    return (_yMax + _yMin) * 0.5;
}


- (NSArray *)xOffsets {
    if (!_xOffsets) {
        self.xOffsets = @[ @(-[_genes[1] integerValue]), @(-[_genes[0] integerValue]), @0, _genes[0], _genes[1], _genes[2], @0, @(-[_genes[2] integerValue]) ];
    }
    return _xOffsets;
}


- (NSArray *)yOffsets {
    if (!_yOffsets) {
        self.yOffsets = @[ _genes[5], _genes[4], _genes[3], _genes[4], _genes[5], _genes[6], _genes[7], _genes[6] ];
    }
    return _yOffsets;
}


- (void)setGenes:(NSArray *)genes {
    if (_genes != genes) {
        [_genes autorelease];
        _genes = [genes mutableCopy];
        
        self.xOffsets = nil;
        self.yOffsets = nil;
    }
}

@end
