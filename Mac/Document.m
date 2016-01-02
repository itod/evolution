//
//  Document.m
//  Evolution
//
//  Created by Todd Ditchendorf on 12/30/15.
//  Copyright © 2015 Todd Ditchendorf. All rights reserved.
//

#import "Document.h"
#import "EvolutionRenderer.h"
#import "Morph.h"

@interface Document ()
@property (nonatomic, retain) NSArray *tempMorphs;
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}


- (void)dealloc {
    self.renderer = nil;
    self.tempMorphs = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSDocument

- (void)windowControllerDidLoadNib:(NSWindowController *)wc {
    [super windowControllerDidLoadNib:wc];
    
    TDAssert(_renderer);
    
    if (_tempMorphs) {
        _renderer.children = _tempMorphs;
        self.tempMorphs = nil;
    }
}


#pragma mark -
#pragma mark Open/Save

+ (BOOL)autosavesInPlace {
    return YES;
}


- (NSString *)windowNibName {
    return @"Document";
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outErr {
    TDAssertMainThread();
    TDAssert(_renderer);

    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithCapacity:1];
    
    {
        NSMutableArray *morphPlists = [NSMutableArray arrayWithCapacity:[_renderer.children count]];
        for (Morph *m in _renderer.children) {
            id morphPlist = [m asPlist];
            [morphPlists addObject:morphPlist];
        }
        plist[@"morphs"] = morphPlists;
    }
    
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainers error:outErr];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outErr {
    TDAssertMainThread();
    TDAssert(data);
    
    id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:nil error:outErr];
    
    {
        NSArray *morphPlists = plist[@"morphs"];
        NSMutableArray *morphs = [NSMutableArray arrayWithCapacity:[morphPlists count]];
        
        for (id morphPlist in morphPlists) {
            Morph *m = [Morph fromPlist:morphPlist];
            [morphs addObject:m];
        }
        
        self.tempMorphs = morphs;
    }

    return YES;
}

@end
