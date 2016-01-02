//
//  EvolutionRenderer.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

@class Morph;
@class EvolutionRenderer;

@protocol EvolutionRendererDelegate <NSObject>
- (void)rendererDidReproduce:(EvolutionRenderer *)r;
- (id)undoManagerForRenderer:(EvolutionRenderer *)r;
@end

@interface EvolutionRenderer : NSObject

- (void)render:(CGContextRef)ctx inView:(id)v dirtyRect:(CGRect)drect;
- (void)hitTest:(CGPoint)p inView:(id)v;

- (void)reproduce:(Morph *)m;

@property (nonatomic, assign) IBOutlet id <EvolutionRendererDelegate>delegate;

@property (nonatomic, copy) NSArray *children;
@property (nonatomic, assign) NSInteger generation;
@end
