    //
//  LoggingViewController.m
// BigStand
//
//  Created by bill donner on 12/26/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.
//

#import "KORLoggingViewController.h"
#import "KORDataManager.h"
#import "KORLogManager.h"
#import "KORBarButtonItem.h"

@interface KORLoggingViewController ()
-(void) loadView;
@end

@implementation KORLoggingViewController

-(id) init;
{
	self = [super init];
	if (self) 
	{
		
	}
	return self;
}

-(void) loadView
{
	CGRect frame = self.presentingViewController.view.bounds; //[[UIScreen mainScreen] applicationFrame];
//	frame.size.height -= [DataManager navBarHeight]; //NAV_BAR_HEIGHT;
//	frame.origin.y += [DataManager navBarHeight];
	self.view = [[UIView alloc] initWithFrame: frame]; //0611
	self.view.backgroundColor =  [KORDataManager globalData].appBackgroundColor ;
	self.navigationItem.title/*View*/ = [KORDataManager makeUnadornedTitleView:@"Trace"];
	self.navigationItem.rightBarButtonItem = [KORBarButtonItem buttonWithTitle:@"Clear" style:UIBarButtonItemStyleBordered 
                                                               
                                                               completionBlock:^(UIBarButtonItem *bbi) {
        [KORLogManager clearCurrentLog];
        [self loadView]; // build it again, check leakage
    }];
	NSError *error;
	NSStringEncoding encoding;
	NSString *contents = [NSString stringWithContentsOfFile:[KORLogManager pathForCurrentLog]
											   usedEncoding:&encoding error: &error];

	UITextView *ltv = [[UITextView alloc] initWithFrame: frame] ;
	ltv.editable = NO;
//	if (![contents isEqualToString:ltv.text ])
//	{
	[ltv setText:contents];

		ltv.contentOffset = CGPointMake(0.0f, 
										MAX(ltv.contentSize.height - ltv.frame.size.height, 0.0f));
		
//	}
	
	[self.view 	addSubview: ltv];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog (@"TRC didRotateFromInterfaceOrientation");
	[self loadView]; // build it again, check leakage
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
