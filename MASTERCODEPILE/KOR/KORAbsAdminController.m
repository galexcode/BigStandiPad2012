//
//  AdminAbstractController.m
//  
//
//  Created by bill donner on 6/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORAbsAdminController.h"



@implementation KORAbsAdminController

-(UIView *) buildAdminBackground;
{
    
    CGRect theframe = 
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? CGRectMake(0,0,540,576):[[UIScreen mainScreen] bounds];
    return [super buildModalSizedBackgroundWithImageNamed:@"admin-gradientBackground.png" frame:theframe];
    
    
}

// this should keep most all of the admin controller hierarchy in portrait mode for now
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;// (UIDeviceOrientationIsPortrait ([UIDevice currentDevice].orientation));
}
-(id)init{
		// make sure never called at this entry point
//    NSLog (@"KORAbsAdminController init() incorrectly called by %@", [self class]);
//    return nil;
	
	self = [super init];
	return self;
} 

@end
