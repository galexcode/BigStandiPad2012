    //
//  SongsViewController.m
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.
//

#import "KORLargeArchiveController.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "KORBarButtonItem.h"
#import "KORHelpPanelView.h"
#import "KORViewerController.h"

@implementation KORLargeArchiveController
-(void) dealloc 
{
}

-(id) initWithArchive :(NSString *)archive ;
{	
	//NSLog (@"AVC large archive %@ initialization starting",archive);
	
	NSMutableArray *archiveItems =   [[NSMutableArray alloc ] init ] ;// will leak without autorelease
	
	// poor man's cache - check cache dictionary for existence of archive entry and with valid timestamp - use that in preference to
	// this: which reloads everything thru sqlite
	[archiveItems	addObjectsFromArray:[KORRepositoryManager allTitlesFromArchive: archive]];
	[archiveItems sortUsingSelector:@selector(compare:)];
	
    CGRect frame = CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width,60.f);
    
    KORHelpPanelView *hhv = [KORHelpPanelView  panelWithFrame:frame
                                                leftTextLines:[NSArray arrayWithObjects:[KORRepositoryManager shortName:archive],nil]
                                               rightTextLines:[NSArray arrayWithObjects:@"Enter Tune in search box, or",
                                                               @"Go directly to any letter",
                                                               @"Scroll until you find your tune", nil]
                                                     leftFont:[UIFont boldSystemFontOfSize:18.f ]
                                                    rightFont:[UIFont systemFontOfSize:14.f ]
                                                        color:[UIColor grayColor]
                                            dismissable:YES];
    
    
    
	self = [super  initWithArray:archiveItems  
						andTitle:[NSString stringWithFormat:@"Search '%@' Archive",[KORRepositoryManager shortName:archive]] 
					  andArchive:archive 
						helpView:hhv		
			];
	
    if (self) {
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (toggleHeaderView:)];
        tgr.numberOfTapsRequired = 1;
        [hhv addGestureRecognizer: tgr];
		self.thisArchive = [archive copy];
    }
	return self;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    //[super viewDidLoad];
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here
	self.navigationItem.leftBarButtonItem = [KORBarButtonItem 
											  buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                             completionBlock:^(UIBarButtonItem *bbi){
												 
												 [KORDataManager allowOneTouchBehaviors]; // release this
                                                 [presenter dismissViewControllerAnimated:YES  
																			   completion: ^(void) {
															/*  NSLog (@"done button hit"); */ 
																			   }
												  ];
                                             }] ; 
	
//	self.navigationItem.rightBarButtonItem = [KORBarButtonItem 
//											 buttonWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
//                                             completionBlock:^(UIBarButtonItem *bbi){
//												 
//												 [self.importDelegate importIntoArchive:self.thisArchive];
//													 // if import is pressed, invoke the delegate\							 
//												 
//												 
//												 [KORDataManager allowOneTouchBehaviors]; // release this
//                                                 [presenter dismissViewControllerAnimated:YES  
//																			   completion: ^(void) {
//																				   /*  NSLog (@"add button hit"); */ 
//																			   }
//												  ];
//                                             }] ; 
	
	[self makeSearchNavHeaders];
	
	[KORDataManager disallowOneTouchBehaviors];
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
