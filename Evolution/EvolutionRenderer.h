//
//  EvolutionRenderer.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol EvolutionRendererDelegate;

@interface EvolutionRenderer : NSObject

- (void)renderInView:(id)v;
- (void)hitTest:(CGPoint)p inView:(id)v;

@property (nonatomic, assign) IBOutlet id <EvolutionRendererDelegate>delegate;
@end
