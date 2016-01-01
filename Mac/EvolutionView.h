//
//  EvolutionView.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "EvolutionRenderer.h"

@class EvolutionView;

@interface EvolutionView : NSView <EvolutionRendererDelegate>

@property (nonatomic, assign) IBOutlet EvolutionRenderer *renderer;
@end
