//
//  SongsViewController.m
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.

#import "KORSmallArchiveController.h"


#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORRepositoryManager.h"
#import "KORViewerController.h"
#import "KORAbsContentTableController.h"
#import "KORBarButtonItem.h"

#import "InstanceInfo.h"
#import "ClumpInfo.h"

@interface KORSmallArchiveController()
<UITableViewDataSource, UITableViewDelegate,KORTuneControllerDismissedDelegate> 
@property (nonatomic,retain)	NSString *archive;
@property (nonatomic,retain)	NSMutableArray *listItems;
@property (nonatomic,retain)	NSString *listName;	
@property (nonatomic,retain)	UITableView *tableView;
@property BOOL wassup;
@end

@implementation KORSmallArchiveController
@synthesize archive,listName,listItems,tableView,wassup;

-(void) dealloc
{
}

-(id) initWithArchive: (NSString *)archiv;
{
    self = [super init];
    if (self)
    {
        wassup = YES;
        archive = [archiv copy];
        NSString *shortie = [KORRepositoryManager shortName:archiv];
        
        // dynamically build the array of items  of RefNodesin this archiv
        
        NSMutableArray *archiveItems =   [[NSMutableArray alloc]init];
        [archiveItems	addObjectsFromArray:[KORRepositoryManager allTitlesFromArchive: archiv]];	
        [archiveItems sortUsingSelector:@selector(compare:)];
        
        listItems = archiveItems ;
        listName = [NSString stringWithFormat:@"%@",shortie];
        self.view = nil;
        
	}
	return self;
	
	
}
-(id) initWithArchiveReversed: (NSString *)archiv;
{
    self = [super init];
    if (self)
    {
		
        wassup = YES;
        archive = [archiv copy];
		listItems = [NSMutableArray array];
		
        listName = [KORRepositoryManager shortName:archiv];
        
        // dynamically build the array of items  of RefNodesin this archiv
        NSEnumerator *enumerator = [[KORRepositoryManager allTitlesFromArchive: archiv] reverseObjectEnumerator];
		for (NSString *s in enumerator)
		{
			[self.listItems addObject: s];
		}
		
      
        
        self.view = nil; // force loadView to be called
        
    }
	return self;
	
}
- (void) loadView 
{
		//  NSLog (@"SAC LoadView");
}

-(UIView *) buildUI
{
    NSArray *views = [self buildContentUIViews:self 
					  
                                 leftTextLines:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:@"%@ Archive",self.listName]
                                                ,nil]
					  
                                rightTextLines:[NSArray arrayWithObjects:
                                                [NSString stringWithFormat:@"This Archive has %d files",[self.listItems count]],
                                                @"You can add more archives thru iTunes",
                                                @"You can add more files to this archive from 'Manage Archives'",
                                                nil]
                                      leftfont:[UIFont boldSystemFontOfSize:18.f ]
                                     rightfont:[UIFont systemFontOfSize:14.f ]
                      ];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Search '%@' Archive",self.listName ];

	self.tableView = [views objectAtIndex:1];	
	self.tableView.rowHeight = 60.f; // maintain consisency
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

	return [views objectAtIndex:0];
}
//92 88 78

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem  
     buttonWithTitle:NSLocalizedString(@"done",@"")
     style:UIBarButtonItemStyleBordered 
     completionBlock: ^(UIBarButtonItem *bbi){
         
         [presenter dismissViewControllerAnimated:YES  
									   completion: ^(void) { //NSLog (@"SAC done button hit");
															 }];
		 
		 [KORDataManager allowOneTouchBehaviors];
         
     }];
	
//	self.navigationItem.rightBarButtonItem = [KORBarButtonItem 
//											  buttonWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
//											  completionBlock:^(UIBarButtonItem *bbi){
//												  
//												  [self.importDelegate importIntoArchive:self.archive];
//													  // if import is pressed, invoke the delegate\							 
//												  
//												  
//												  [KORDataManager allowOneTouchBehaviors]; // release this
//												  [presenter dismissViewControllerAnimated:YES  
//																				completion: ^(void) {
//																					/*  NSLog (@"add button hit"); */ 
//																				}
//												   ];
//											  }] ; 
    
	[self makeSearchNavHeaders];
	
    self.view = [self buildUI]; // needed for version 5, it doesnt call didRotate anymore on start
	
	[KORDataManager disallowOneTouchBehaviors];
    
}
//- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
//{
//	
//	self.view = [self buildUI];
//	
//	[self.tableView reloadData];
//}
-(void) viewDidAppear:(BOOL)animated
{
    wassup = NO;
}

- (void)didReceiveMemoryWarning {
	
	NSLog (@"SAC didReceiveMemoryWarning will blow self away");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
    // Release any cached data, images, etc. that aren't in use.
}



/*
 Section-related methods: Retrieve the section titles and section index titles
 */



- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
	return 1;
}

- (NSInteger) tableView: (UITableView *) tabView
  numberOfRowsInSection: (NSInteger) section
{
	return [self.listItems count];
	
}


#pragma mark UITableViewDelegate Methods

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    
    return [super makeContentTableCellView:tabView cellForRowAtIndexPath:idxPath listItems:self.listItems];
}



- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    
	
		NSString *tune = [self.listItems objectAtIndex: idxPath.row];  // just get outer home controller to select tune 
	
		[KORDataManager allowOneTouchBehaviors];
		
		if (self.tuneselectordelegate)
			[self.tuneselectordelegate actionItemChosen: idxPath.row label:tune newItems:self.listItems listKind:@"archive" listName:
			 //[KORRepositoryManager shortName:
			  self.listName];
		
		[self dismissViewControllerAnimated:YES completion:NULL];
	}



#pragma mark otc Protocol gets us control back to blow away the controller we created

-(void) dismissOTCController;
{
    [self dismissViewControllerAnimated:YES  completion: ^(void) { 
        //NSLog (@"%@ was dismissed",[self class]); 
    }];
}
@end
