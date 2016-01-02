//
//  ViewController.h
//  EvolutionMobile
//
//  Created by Todd Ditchendorf on 1/1/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EvolutionRenderer;

@interface ViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)reset:(id)sender;

@property (nonatomic, assign) IBOutlet EvolutionRenderer *renderer;
@end

