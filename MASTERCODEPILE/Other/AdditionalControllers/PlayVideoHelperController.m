//
//  PlayVideoHelperController.m
//  gigstand
//
//  Created by bill donner on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayVideoHelperController.h"


#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "ArchiveInfo.h"
#import "KORAbsAppDelegate.h"
#import "KORRepositoryManager.h"

#import "KORBarButtonItem.h"

@interface PlayVideoHelperController () <UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic,retain)   NSMutableArray *listNames;
  @property (nonatomic,retain)  NSMutableArray *listURLs;
      @property (nonatomic,retain)  UITableView *tableView;
@end
@implementation PlayVideoHelperController
    @synthesize listNames,listURLs,tableView;
    



- (void) presentVideo:(NSString *) url
{
    MPMoviePlayerViewController* theMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString: url]]; //leaking i think
    theMoviePlayer.view.frame = self.view.frame;
    [self presentMoviePlayerViewControllerAnimated:theMoviePlayer];
}



-(id) init
{
	self=[super init];
	if (self)
	{
		NSString *p = [ [RPSSettingsManager sharedInstance] plistForVideoHelperSet];
        
		NSString *s = p ? p :@"fail";
        
		NSString     *cvcPath = [[NSBundle mainBundle] pathForResource: s ofType: @"plist" ];	
		NSDictionary *cvcDict = [NSDictionary dictionaryWithContentsOfFile: cvcPath];

		listNames = [[NSMutableArray alloc] init];
		listURLs = [[NSMutableArray alloc] init];
		
		for (NSString *name in [cvcDict objectForKey: @"VideoHelperNames"]) // if any are real archives, take them out of the list
				[listNames addObject:name];
        
		for (NSString *url in [cvcDict objectForKey: @"VideoHelperURLs"]) // if any are real archives, take them out of the list
				[listURLs addObject:url];
        self.view = nil;
	}
	return self;
	
}
-(UIView *) buildUI
{
	self.navigationItem.title/*View*/ = [KORDataManager makeUnadornedTitleView :@"Video" ];	

    NSArray *views = [self buildAdminUIViews:self 
                               leftTextLines:[NSArray arrayWithObjects:@"Video Tutorials",nil]
                              rightTextLines:[NSArray arrayWithObjects:@"Check Back Periodically For New Videos",@"Or Visit Us at http://gigstand.net",nil]
                                    leftfont:[UIFont boldSystemFontOfSize:18.f ]
                                   rightfont:[UIFont systemFontOfSize:14.f ]
                      ];
    
	
	self.tableView = [views objectAtIndex:1]; // make everyone else happy too!
	return [views objectAtIndex:0];
}

- (void) loadView
{
	self.view = [self buildUI];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

    self.navigationItem.leftBarButtonItem =     [KORBarButtonItem  
                                                 buttonWithTitle:@"cancel" 
                                                 style:UIBarButtonItemStyleBordered 
                                                 completionBlock: ^(UIBarButtonItem *bbi){ 
                                                     [presenter dismissViewControllerAnimated:YES  
                                                                                                         completion: ^(void) { NSLog (@"cancel button hit"); }];  
                                                 }];

	
	
	
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
{
	//NSLog (@"SAM didRotateFromInterfaceOrientation");
	
	[self.tableView reloadData];
	self.view = [self buildUI]; // there must be leakage here
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
	
}


- (void)viewDidUnload {
	// dealloc may not get called here


	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	
	//section should always be 1
	
	return [self.listNames count];
	
}
#pragma mark UITableViewDataSource Methods


#pragma mark UITableViewDelegate Methods

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    

    NSUInteger row = idxPath.row;
    
    NSString *name= [self.listNames objectAtIndex: row];		
    NSString *url= [self.listURLs objectAtIndex: row];
    
    return [super
            makeAdminTableCellView:tabView cellForRowAtIndexPath:idxPath text:name detail:url image:nil];
    

}



- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	//NSError *error;
	///NSStringEncoding encoding;
	//NSString *path= [self.listItems objectAtIndex: idxPath.row];
	
	NSString *url = [self.listURLs objectAtIndex:idxPath.row];
    
    [self presentVideo:url];

	return;
}


@end

