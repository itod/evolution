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

@implementation EvolutionRenderer

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)renderInView:(id)v {
    TDAssertMainThread();
    TDAssert(v);
    
    CGRect bounds = [v bounds];
    
    CGFloat w = round(NSWidth(bounds) / NUM_ROWS);
    CGFloat h = round(NSHeight(bounds) / NUM_COLS);
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextStrokeRect(ctx, bounds);

    CGContextSetLineWidth(ctx, 2.0);

    // horiz
    {
        CGFloat x = 0.0;
        for (NSInteger i = 0; i < NUM_ROWS-1; ++i) {
            x = round(x + w);
            CGContextMoveToPoint(ctx, x, round(NSMinY(bounds)));
            CGContextAddLineToPoint(ctx, x, round(NSMaxY(bounds)));
            CGContextStrokePath(ctx);
        }
    }
    
    // vert
    {
        CGFloat y = 0.0;
        for (NSInteger i = 0; i < NUM_COLS-1; ++i) {
            y = round(y + h);
            CGContextMoveToPoint(ctx, round(NSMinX(bounds)), y);
            CGContextAddLineToPoint(ctx, round(NSMaxX(bounds)), y);
            CGContextStrokePath(ctx);
        }
    }

    // draw morphs
    CGContextSaveGState(ctx); {
        // scale
        CGFloat sx = w / DEFAULT_EXTENT;
        CGFloat sy = h / DEFAULT_EXTENT;
        //NSLog(@"%@,%@", @(sx), @(sy));
        CGContextScaleCTM(ctx, sx, sy);

        for (NSInteger row = 0; row < NUM_ROWS; ++row) {
            for (NSInteger col = 0; col < NUM_COLS; ++col) {
                
                CGContextSaveGState(ctx); {
                    Morph *m = [[[BioMorph alloc] init] autorelease];
                    [m renderInContext:ctx rect:CGRectMake(DEFAULT_EXTENT*row, DEFAULT_EXTENT*col, DEFAULT_EXTENT, DEFAULT_EXTENT)];
                } CGContextRestoreGState(ctx);

            }
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
        
        CGFloat w = round(NSWidth(bounds) / NUM_ROWS);
        CGFloat h = round(NSHeight(bounds) / NUM_COLS);
        
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
    
    NSLog(@"%@,%@", @(row), @(col));
    
    TDAssert(_delegate);
    //[_delegate clickedRow:row column:col];
}

@end
