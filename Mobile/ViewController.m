//
//  ViewController.m
//  EvolutionMobile
//
//  Created by Todd Ditchendorf on 1/1/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

#import "ViewController.h"
#import "EvolutionRenderer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc {
    self.renderer = nil;
    [super dealloc];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (IBAction)reset:(id)sender {
    TDAssertMainThread();
    

    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Really Reset?", @"")
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                           otherButtonTitles:NSLocalizedString(@"Reset", @""), nil] autorelease];
    [alert show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)av clickedButtonAtIndex:(NSInteger)idx {
    if (1 == idx) {
        TDAssert(_renderer);
        [_renderer reset];
    }
}
@end
