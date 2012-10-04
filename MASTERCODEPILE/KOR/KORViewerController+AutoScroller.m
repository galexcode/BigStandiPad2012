	//
	//  KORViewerController+AutoScroller.m
	//  MasterApp
	//
	//  Created by william donner on 10/16/11.
	//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
	//
#import "KORBarButtonItem.h"
#import "KORViewerController+AutoScroller.h"

@implementation KORViewerController (AutoScroller)





-(void) scrollTimerFired: (id) ugh
{ 
    [self scrollwebview:2]; // not sure why this doesnt work with 1
							// instead of getting ios to handle the repeats we do it one at a time becuase autoscrollControl.duration may have been changed by the UI
    if ((self.autoscrollTimer != nil)&& self.autoscrollControl.scrollingOn) // will be nil when cancelled and we dont wnat to propogate
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoscrollControl.duration  
                                                                target:self selector:@selector(scrollTimerFired:)  userInfo:nil repeats:NO];  
}





@end
