//
//  EvolutionView.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "EvolutionView.h"
#import "EvolutionRenderer.h"

@implementation EvolutionView

#pragma mark -
#pragma mark NSView

- (BOOL)isFlipped {
    return YES;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    TDAssertMainThread();
    TDAssert(_renderer);
    
    [_renderer renderInView:self];
}


#pragma mark -
#pragma mark NSResponder

- (void)mouseDown:(NSEvent *)evt {
    TDAssertMainThread();
    TDAssert(_renderer);
    
    CGPoint p = [self convertPoint:[evt locationInWindow] fromView:nil];
    [_renderer hitTest:p inView:self];
}

@end
