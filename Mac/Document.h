//
//  Document.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EvolutionRenderer;

@interface Document : NSDocument

@property (nonatomic, assign) IBOutlet EvolutionRenderer *renderer;
@end

