//
//  Utils.c
//  Evolution
//
//  Created by Todd Ditchendorf on 1/1/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

#include "Utils.h"

void TDPerformOnMainThread(void (^block)(void)) {
    //NSCAssert(block);
    dispatch_async(dispatch_get_main_queue(), block);
}


void TDPerformOnBackgroundThread(void (^block)(void)) {
    //NSCAssert(block);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}


void TDPerformOnMainThreadAfterDelay(double delay, void (^block)(void)) {
    //NSCAssert(block);
    //NSCAssert(delay >= 0.0);
    
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


void TDPerformOnBackgroundThreadAfterDelay(double delay, void (^block)(void)) {
    //NSCAssert(block);
    //NSCAssert(delay >= 0.0);
    
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
