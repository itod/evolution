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

- (void)dealloc {
    self.renderer = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSView

- (BOOL)isFlipped {
    return YES;
}


- (void)drawRect:(CGRect)dirtyRect {
    TDAssertMainThread();
    TDAssert(_renderer);
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];

    [_renderer render:ctx inView:self dirtyRect:dirtyRect];
}


#pragma mark -
#pragma mark NSResponder

- (void)mouseDown:(NSEvent *)evt {
    TDAssertMainThread();
    TDAssert(_renderer);
    
    CGPoint p = [self convertPoint:[evt locationInWindow] fromView:nil];
    [_renderer hitTest:p inView:self];
}


#pragma mark -
#pragma mark EvolutionRendererDelegate

- (void)rendererDidReproduce:(EvolutionRenderer *)r {
    TDAssertMainThread();
    
    [self setNeedsDisplay:YES];
}


- (id)undoManagerForRenderer:(EvolutionRenderer *)r {
    TDAssertMainThread();

    return [self undoManager];
}

@end
