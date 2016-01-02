//
//  EvolutionRenderer.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "EvolutionRenderer.h"
#import "BioMorph.h"

#define NUM_ROWS 3
#define NUM_COLS 3

#define CHILD_COUNT 8

#define DEFAULT_EXTENT 200.0
#define MARGIN 100.0

@implementation EvolutionRenderer

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    self.children = nil;
    [super dealloc];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    TDPerformOnMainThreadAfterDelay(0.0, ^{
        [self reset];
    });
}


#pragma mark -
#pragma mark Public

- (void)reset {
    TDAssertMainThread();
    TDAssert(_delegate);
    
    self.generation = -1;
    
    Morph *m = [[[BioMorph alloc] init] autorelease];
    [self reproduce:m];
}


- (void)render:(CGContextRef)ctx inView:(id)v dirtyRect:(CGRect)drect {
    TDAssertMainThread();
    TDAssert(v);
    
    CGRect bounds = [v bounds];
    
    CGFloat w = round(CGRectGetWidth(bounds) / NUM_ROWS);
    CGFloat h = round(CGRectGetHeight(bounds) / NUM_COLS);
    
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextStrokeRect(ctx, bounds);

    CGContextSetLineWidth(ctx, 2.0);

    // horiz
    {
        CGFloat x = 0.0;
        for (NSInteger i = 0; i < NUM_ROWS-1; ++i) {
            x = round(x + w);
            CGContextMoveToPoint(ctx, x, round(CGRectGetMinY(bounds)));
            CGContextAddLineToPoint(ctx, x, round(CGRectGetMaxY(bounds)));
            CGContextStrokePath(ctx);
        }
    }
    
    // vert
    {
        CGFloat y = 0.0;
        for (NSInteger i = 0; i < NUM_COLS-1; ++i) {
            y = round(y + h);
            CGContextMoveToPoint(ctx, round(CGRectGetMinX(bounds)), y);
            CGContextAddLineToPoint(ctx, round(CGRectGetMaxX(bounds)), y);
            CGContextStrokePath(ctx);
        }
    }
    
    if (![_children count]) return;

    // draw morphs
    CGContextSaveGState(ctx); {
        // scale
        CGFloat sx = w / (DEFAULT_EXTENT + MARGIN*2.0);
        CGFloat sy = h / (DEFAULT_EXTENT + MARGIN*2.0);
        //NSLog(@"%@,%@", @(sx), @(sy));
        CGContextScaleCTM(ctx, sx, sy);

        TDAssert([_children count] == NUM_ROWS*NUM_COLS);
        
        NSUInteger idx = 0;
        CGFloat marginY = 0.0;
        for (NSInteger col = 0; col < NUM_ROWS; ++col) {
            CGFloat marginX = 0.0;
            for (NSInteger row = 0; row < NUM_COLS; ++row) {
                
                CGContextSaveGState(ctx); {
                    TDAssert(idx < [_children count]);
                    Morph *m = _children[idx++];
                    [m renderInContext:ctx rect:CGRectMake(round((DEFAULT_EXTENT*row)+marginX+MARGIN), round((DEFAULT_EXTENT*col)+marginY+MARGIN), DEFAULT_EXTENT, DEFAULT_EXTENT)];
                } CGContextRestoreGState(ctx);

                marginX += MARGIN*2.0;
            }
            marginY += MARGIN*2.0;
        }
    } CGContextRestoreGState(ctx);
}


- (void)hitTest:(CGPoint)p inView:(id)v {
    TDAssertMainThread();
    //NSLog(@"%@", NSStringFromPoint(p));
    
    NSInteger row = -1, col = -1;
    
    // find row, col
    {
        CGRect bounds = [v bounds];
        
        CGFloat w = round(CGRectGetWidth(bounds) / NUM_ROWS);
        CGFloat h = round(CGRectGetHeight(bounds) / NUM_COLS);
        
        CGFloat x = 0.0;
        for (NSInteger i = 0; i < NUM_ROWS; ++i) {
            CGFloat y = 0.0;
            for (NSInteger j = 0; j < NUM_COLS; ++j) {
                CGRect r = CGRectMake(x, y, w, h);
                //NSLog(@"%@", NSStringFromRect(r));
                if (CGRectContainsPoint(r, p)) {
                    row = i, col = j;
                    break;
                }
                y = round(y + h);
            }
            x = round(x + w);
        }
    }
    
    NSInteger idx = lrint(col*3.0 + row);
    TDAssert(idx < [_children count]);

    //NSLog(@"%@,%@ : %@", @(row), @(col), @(idx));

    Morph *m = _children[idx];

    [self reproduce:m];
}


- (void)reproduce:(Morph *)m {
    TDAssertMainThread();
    TDAssert(m);
    
    [self setChildren:[m reproduce:CHILD_COUNT] forGeneration:_generation+1];

    TDAssert([_children count] == CHILD_COUNT+1);
    TDAssert([_children count] == NUM_ROWS*NUM_COLS);
    
    TDAssert(m == _children[4]);
}


#pragma mark -
#pragma mark Private

- (void)setChildren:(NSArray *)newChildren forGeneration:(NSInteger)newGen {
    TDAssertMainThread();
    TDAssert(_delegate);
    
    if (_children) {
        id mgr = [_delegate undoManagerForRenderer:self];
        TDAssert(mgr);
        [[mgr prepareWithInvocationTarget:self] setChildren:_children forGeneration:_generation];
    }

    [_children autorelease];
    _children = [newChildren copy];
    
    self.generation = newGen;

    [_delegate rendererDidReproduce:self];
}

@end
