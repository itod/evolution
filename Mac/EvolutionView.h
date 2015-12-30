//
//  EvolutionView.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EvolutionRenderer;
@class EvolutionView;

@protocol EvolutionRendererDelegate <NSObject>

@end

@interface EvolutionView : NSView <EvolutionRendererDelegate>

@property (nonatomic, assign) IBOutlet EvolutionRenderer *renderer;
@end
