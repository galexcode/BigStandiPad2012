	//
	//  TouchCapturingWindow.m
	//  WTSWTSTM
	//
	//  Created by Bruno Nadeau on 10-10-21.
	//  Copyright 2010 Wyld Collective Ltd. All rights reserved.
	//

#import "KORTouchCapturingWindow.h"
#import "KORDataManager.h"

@implementation KORTouchCapturingWindow

//-(void) tester;
//{
//	NSUInteger counter;
//	if (views == nil) counter = 0;
//	else counter = [views count];
//	NSLog (@"TouchCapturingWindow is monitoring %d views",counter);
//}
- (void)dealloc {
		//   if ( views ) [views release];
		//   [super dealloc];
	views = nil;
}
- (void)viewsForTouchPriority:(UIView*)portraitView  landscapeView:(UIView*)landscapeView;
{
	
		//NSLog (@"addViewForTouchPriority %@",view);
	
    if ( !views ) 
		views = [[NSMutableArray alloc] initWithCapacity:2];
    [views addObject:portraitView];
	[views addObject:landscapeView];
	
}


- (void)sendEvent:(UIEvent *)event {
		//we need to send the message to the super for the
		//text overlay to work (holding touch to show copy/paste)
    [super sendEvent:event];
	
		//get a touch
    UITouch *touch = [[event allTouches] anyObject];
	
		//check which phase the touch is at, and process it
    if (touch.phase == UITouchPhaseBegan) {
		
		UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
		
		UIView *view = ((o==UIInterfaceOrientationLandscapeLeft )|| (o ==UIInterfaceOrientationLandscapeRight)) ? [views objectAtIndex:1]:[views objectAtIndex:0];
		
		 {
			CGPoint point = [touch locationInView:[view superview]];
			 
			 BOOL contained = CGRectContainsPoint(view.frame,point);	
				 //NSLog (@"orientation %d RESULT=%d CGRect (%.f ,%.f, %.f,%.f) containsPoint(%.f,%.f) ",
				
				 //	o,contained,view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height,
				 //	 point.x,point.y );
			 
			if ( contained) {
					//if ([KORDataManager globalData].oneTouchSemaphore == 0)
				{
					touchView = view;
					[KORDataManager singleTapPulse]; 
					return;
				}
				
			}
		}  // pass all evenbts out as well
		
		if ( touchView ) {
			[touchView touchesBegan:[event allTouches] withEvent:event];
			return;
		}
		
    }
	else if (touch.phase == UITouchPhaseMoved) {
		if ( touchView ) {
			[touchView touchesMoved:[event allTouches] withEvent:event];
			return;
		}
	}
	else if (touch.phase == UITouchPhaseCancelled) {
		if ( touchView ) {
			[touchView touchesCancelled:[event allTouches] withEvent:event];
			touchView = nil;
			return;
		}
	}
	else if (touch.phase == UITouchPhaseEnded) {
		if ( touchView ) {
			[touchView touchesEnded:[event allTouches] withEvent:event];
			touchView = nil;
			return;
		}
    }
}

@end