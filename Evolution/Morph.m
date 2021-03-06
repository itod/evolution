//
//  Morph.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "Morph.h"

@implementation Morph

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    self.propertyNames = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Serializable

+ (instancetype)fromPlist:(NSDictionary *)plist {
    NSString *className = plist[@"className"];
    Class cls = NSClassFromString(className);
    TDAssert(cls);

    NSDictionary *props = plist[@"properties"];
    
    Morph *gen = [[[cls alloc] init] autorelease];
    for (NSString *key in props) {
        id val = props[key];
        
        [gen setValue:val forKey:key];
    }
    
    return gen;
}


- (NSMutableDictionary *)asPlist {
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithCapacity:2];

    // class name
    {
        NSString *className = NSStringFromClass([self class]);
        TDAssert([className length]);
        
        plist[@"className"] = className;
    }

    // properties
    {
        NSArray *propNames = self.propertyNames;
        NSMutableDictionary *props = [NSMutableDictionary dictionaryWithCapacity:[propNames count]];
        for (NSString *key in propNames) {
            id val = [self valueForKey:key];
            TDAssert(val);
            props[key] = val;
        }
        
        plist[@"properties"] = props;
    }
    
    return plist;
}


#pragma mark -
#pragma mark Morph

- (NSArray *)reproduce:(NSUInteger)count {
    TDAssertMainThread();
    NSMutableArray *v = [NSMutableArray arrayWithCapacity:count+1];
    
    NSUInteger half = round(count * 0.5);
    for (NSUInteger i = 0; i < count; ++i) {
        if (half == i) {
            [v addObject:self];
        }

        Morph *m = [self mutate];
        TDAssert(m);
        [v addObject:m];
    }
    
    TDAssert(count+1 == [v count]);
    return v;
}


- (Morph *)mutate {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)renderInContext:(CGContextRef)ctx rect:(CGRect)r {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
