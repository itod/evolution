//
//  ConchoMorph.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "ConchoMorph.h"

@implementation ConchoMorph

- (instancetype)init {
    self = [super init];
    if (self) {
        self.propertyNames = @[@"flare", @"verm", @"spire"];
    }
    return self;
}


#pragma mark -
#pragma mark Morph

- (void)renderInContext:(CGContextRef)ctx rect:(CGRect)r {
    
}

@end
