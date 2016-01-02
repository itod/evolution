//
//  EvolutionView.m
//  Evolution
//
//  Created by Todd Ditchendorf on 1/1/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

#import "EvolutionView.h"
#import "EvolutionRenderer.h"

@implementation EvolutionView

- (void)dealloc {
    self.renderer = nil;
    self.genCountLabel = nil;
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
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [_renderer render:ctx inView:self dirtyRect:dirtyRect];
}


#pragma mark -
#pragma mark NSResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)evt {
    TDAssertMainThread();
    TDAssert(_renderer);
    TDAssert(_genCountLabel);
    
    CGPoint p = [[touches anyObject] locationInView:self];
    [_renderer hitTest:p inView:self];
    
    TDPerformOnMainThreadAfterDelay(0.0, ^{
        NSInteger c = _renderer.generation;
        [_genCountLabel setText:[NSString stringWithFormat:@"%@", @(c)]];
    });
}


#pragma mark -
#pragma mark EvolutionRendererDelegate

- (void)rendererDidReproduce:(EvolutionRenderer *)r {
    TDAssertMainThread();
    
    [self setNeedsDisplay];
}


- (id)undoManagerForRenderer:(EvolutionRenderer *)r {
    TDAssertMainThread();
    
    return [self undoManager];
}

@end
