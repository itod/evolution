//
//  EvolutionView.h
//  Evolution
//
//  Created by Todd Ditchendorf on 1/1/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

@import UIKit;

#import "EvolutionRenderer.h"

@class EvolutionView;

@interface EvolutionView : UIView <EvolutionRendererDelegate>

@property (nonatomic, assign) IBOutlet EvolutionRenderer *renderer;
@end
