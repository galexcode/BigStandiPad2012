//
//  SongsViewController.m
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.
//
#import "KORAllTunesController.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "KORHelpPanelView.h"
#import "KORBarButtonItem.h"
#import "KORViewerController.h"
#import "KORMultiProtocol.h"
#import "KORLargeArchiveController.h"
#import "KORSmallArchiveController.h"


@interface KORAllTunesController()<UIPopoverControllerDelegate>
@property (nonatomic,retain) UIPopoverController *popcon;
@end
@implementation KORAllTunesController
@synthesize popcon;

-(void) dealloc
{
	
}

-(id) init; 
{
    
    CGRect frame = CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width,60.f);
    
    KORHelpPanelView *hhv = [KORHelpPanelView panelWithFrame:frame
                                                leftTextLines:[NSArray arrayWithObjects:@"Search All Documents",nil]
                                               rightTextLines:[NSArray arrayWithObjects:@"Enter Title in search box, or",
                                                               @"Go directly to any letter",
                                                               @"Scroll up or down", nil]
                                                     leftFont:[UIFont boldSystemFontOfSize:18.f ]
                                                    rightFont:[UIFont systemFontOfSize:14.f ]
                                                        color:[UIColor grayColor]
                                                  dismissable:YES];
    
    
	self = [super  initWithArray:[KORRepositoryManager allTitles] 
                        andTitle:@"All Titles" andArchive:@"All Titles" 
                        helpView: hhv 
            ];
	
    if (self) {
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (toggleHeaderView:)] ;
        tgr.numberOfTapsRequired = 1;
        [hhv addGestureRecognizer: tgr];
        self.view = nil;
    }
    
	
	return self;
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

    [super viewDidLoad];
	self.navigationItem.title = [KORDataManager makeTitleView:@"Search All Documents"] ;	    
	self.navigationItem.leftBarButtonItem =  [KORBarButtonItem  
											  buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											  completionBlock: ^(UIBarButtonItem *bbi){
												  [KORDataManager allowOneTouchBehaviors];
													[ presenter dismissViewControllerAnimated:YES  
																				   completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
												}];
	
	
	
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
