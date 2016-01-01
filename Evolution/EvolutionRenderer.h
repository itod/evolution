//
//  EvolutionRenderer.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Morph;
@class EvolutionRenderer;

@protocol EvolutionRendererDelegate <NSObject>
- (void)rendererDidReproduce:(EvolutionRenderer *)r;
@end

@interface EvolutionRenderer : NSObject

- (void)renderInView:(id)v dirtyRect:(CGRect)drect;
- (void)hitTest:(CGPoint)p inView:(id)v;

- (void)reproduce:(Morph *)m;

@property (nonatomic, assign) IBOutlet id <EvolutionRendererDelegate>delegate;

@property (nonatomic, retain) NSArray *children;
@end
