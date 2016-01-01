//
//  Morph.h
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "Serializable.h"

@interface Morph : NSObject <Serializable>

- (NSArray *)reproduce:(NSUInteger)count;

- (void)renderInContext:(CGContextRef)ctx rect:(CGRect)r;

@property (nonatomic, retain) NSArray *propertyNames;
@end
