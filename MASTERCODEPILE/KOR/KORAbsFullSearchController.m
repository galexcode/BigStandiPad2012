//
//  AllTunesViewController.m
//  MCProvider
//
//  Created by Bill Donner on 1/22/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "KORAbsFullSearchController.h"
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORViewerController.h"
#import "KORAbsContentTableController.h"
#import "KORBarButtonItem.h"



@interface MainTableView: UITableView <UITableViewDelegate,UITableViewDataSource,KORTuneControllerDismissedDelegate>
@property (nonatomic, retain) 
KORAbsFullSearchController *thisController;
-(id) initWithFrame:(CGRect)oframe style:(UITableViewStyle)ostyle controller:(KORAbsFullSearchController *)ocontroller;
@end

@interface SearchResultsTableView: UITableView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) 
KORAbsFullSearchController *thisController;
-(id) initWithFrame:(CGRect)oframe style:(UITableViewStyle)ostyle controller:(KORAbsFullSearchController *)ocontroller;
@end


@interface KORAbsFullSearchController () <UISearchBarDelegate>
@property (retain) UIView *hv;
@property(retain) UIView *overlayView;
@property (nonatomic, retain) NSArray *allTitleNames; // these get written into overlay table
@property (nonatomic, retain) NSArray *searchResults; // these get written into overlay table
@property (nonatomic, retain) NSMutableArray *tunesByLetter;

@property (nonatomic, retain)	NSString *navTitle; // the top nav title
@property (nonatomic, retain)	MainTableView *tableview;
@property (nonatomic, retain)	UISearchBar *searchbarview;
@property (nonatomic, retain)	SearchResultsTableView *searchresultstableview;	
@property (nonatomic, retain)   NSString *archive;
@property (nonatomic, retain)   UIView *outerView;

@property BOOL wassup;
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active;
-(NSInteger ) sectionNumberForTitle:(NSString *) title;
@end

#pragma mark SEARCH TABLE methods

@implementation SearchResultsTableView
@synthesize thisController;
-(id) initWithFrame:(CGRect)oframe style:(UITableViewStyle)ostyle controller:(KORAbsFullSearchController *)ocontroller;
{
	self=[super initWithFrame:oframe style:ostyle];
	if (self)
	{
		self.thisController = ocontroller;
	}
	return self;
}

#pragma mark UITableViewDataSource Methods



- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
	// The number of sections is just 1 in this view
    return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    
    static NSString *CellIdentifier1 = @"ZipCell1";
	//NSUInteger section = idxPath.section;
    NSUInteger row = idxPath.row;
	
	
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: CellIdentifier1];
	
    if (!cell)
    {
		
		cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier1];
		
    }
	
    //
    // Reset cell properties to default:
    //
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
	
	
	if (row < [ self.thisController.searchResults count])
	{
        
		
        NSString *tune = [self.thisController.searchResults objectAtIndex: row];   //// NOTE THIS IS DIFFERENT IN SEARCH
        
		
		cell.textLabel.text = tune;		
		cell.detailTextLabel.text = [KORDataManager makeBlurb:tune] ;
        //		}
        //		else cell = nil;
	}
	else
		cell = nil;
	
	
    return cell;
}

- (NSInteger) tableView: (UITableView *) tabView
  numberOfRowsInSection: (NSInteger) section
{
	
	
    return [self.thisController.searchResults count];
}
//
//@end
//
//@implementation SearchResultsTableViewDelegate


#pragma mark UITableViewDelegate Methods

//- (CGFloat) tableView: (UITableView *) tabView
//heightForRowAtIndexPath: (NSIndexPath *) idxPath
//{
//    return [DataManager standardRowSize];
//}

	// all subclasses come thru here 

- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	
	if (idxPath.row <[self.thisController.searchResults count])
	{
		NSString *tune  = [self.thisController.searchResults objectAtIndex: idxPath.row];
		
		NSString *listkind = [self.thisController.archive length]>0 ? @"archive": @"all";
		
		NSString *listname = [self.thisController.archive length]>0 ? //[KORRepositoryManager shortName:
																	   
		self.thisController.archive : @"tunes";
		
		
		[KORDataManager allowOneTouchBehaviors];
		
		if (self.thisController.tuneselectordelegate)
			[self.thisController.tuneselectordelegate actionItemChosen: idxPath.row label:tune newItems:self.thisController.allTitleNames listKind:listkind listName:listname];
			// self.thisController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self.thisController dismissViewControllerAnimated:YES completion:NULL];
		
	}
}
@end


#pragma mark MAIN TABLE  Methods

@implementation MainTableView

@synthesize thisController;
-(id) initWithFrame:(CGRect)oframe style:(UITableViewStyle)ostyle controller:(KORAbsFullSearchController *)ocontroller;
{
	self=[super initWithFrame:oframe style:ostyle];
	if (self)
	{
		self.thisController = ocontroller;
	}
	return self;
}
//
//
//@end
//
//@implementation MainTableViewDataSource 

#pragma mark UITableViewDataSource Methods


/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSRange range;
	range.location = section; // use this as an index 
	range.length = 1;
	return [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#" substringWithRange:range];
	
	
}

-(NSInteger ) sectionNumberForTitle:(NSString *) title;
{
	NSInteger sectionNumber = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#" rangeOfString:[title  substringToIndex:1]].location;
	if ((sectionNumber <0)||(sectionNumber>26)) sectionNumber=26;	
	return sectionNumber;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
		return [NSArray arrayWithObjects: @"A",
            @"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
            @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",
            @"T",@"U",@"V",@"W",@"Y",@"Z",@"#",nil];
	
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
	NSInteger ret = index; //[self.thisController.collation sectionForSectionIndexTitleAtIndex:index];
	
	//	NSLog (@"returns %d", ret);
	
	return ret;
}


- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
	// The number of sections is the same as the number of titles in the collation.
    return 27;
}

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    
    return [self.thisController makeContentTableCellView:tabView cellForRowAtIndexPath:idxPath listItems:[ self.thisController.tunesByLetter objectAtIndex:idxPath.section]];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;// 3.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section       
{
    return nil;
}

- (NSInteger) tableView: (UITableView *) tabView
  numberOfRowsInSection: (NSInteger) section
{
	
   	NSArray *tunes = [ self.thisController.tunesByLetter objectAtIndex:section];
	
    return [tunes count];
}
//
//
//@end
//@implementation MainTableViewDelegate
#pragma mark UITableViewDelegate Methods

//- (CGFloat) tableView: (UITableView *) tabView
//heightForRowAtIndexPath: (NSIndexPath *) idxPath
//{
//    return [DataManager standardRowSize];
//}



- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    
	NSArray *tunes = [self.thisController.tunesByLetter objectAtIndex:idxPath.section];
	
	if (idxPath.row <[tunes count])
	{
		NSString *tune = [tunes objectAtIndex: idxPath.row];  // just get outer home controller to select tune 
		
		
		NSString *listkind = [self.thisController.archive length]>0 ? @"archive": @"all";
		
		NSString *listname = [self.thisController.archive length]>0 ? [KORRepositoryManager shortName:self.thisController.archive]: @"tunes";
		
		if (self.thisController.tuneselectordelegate)
			[self.thisController.tuneselectordelegate actionItemChosen: idxPath.row label:tune newItems:self.thisController.allTitleNames listKind:listkind listName:listname];
		
			//self.thisController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self.thisController dismissViewControllerAnimated:YES completion:NULL];
	}
}
		

            

#pragma mark otc Protocol gets us control back to blow away the controller we created

-(void) dismissOTCController;
{
    [self.thisController  dismissViewControllerAnimated:YES  completion: ^(void) { 
        //NSLog (@"%@ was dismissed",[self class]); 
    }];
}


@end


#pragma mark - ///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark MAIN CONTROLLER SearchableTunesViewController
#pragma mark -

@implementation KORAbsFullSearchController
@synthesize archive,outerView,searchbarview,searchresultstableview,navTitle,tableview,tunesByLetter,overlayView,searchResults,allTitleNames,hv,wassup;



#pragma mark -
#pragma mark Support of all sorts

-(NSInteger ) sectionNumberForTitle:(NSString *) title;
{
	
	NSInteger sectionNumber = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#" rangeOfString:[title  substringToIndex:1]].location;
	if ((sectionNumber <0)||(sectionNumber>26)) sectionNumber=26;	
	return sectionNumber;
}

-(NSMutableArray *)  findSearchResultsForKey: (NSString *)match;
{
	// this isnt very efficient it is pure brute force, it would be better to keep an intermediary list which was winnowed
	NSMutableArray *results = [[NSMutableArray alloc] init];
	NSUInteger matchlen = [match length];
	if (matchlen==0) return results;
	
	for (NSString *longname in allTitleNames) 
	{	
		if (matchlen <= [longname length]) 
		{
			NSString *trial =[longname substringToIndex:matchlen];
			if ([match caseInsensitiveCompare: trial ] == NSOrderedSame) 
			{
				[results addObject:longname]; // we want an array of strings
				
			}
		}
	}
	
	return results;
}
-(void) configureSections
{
    // Now that all the data's in place, each section array needs to be sorted.
	
	NSUInteger sectionTitlesCount = 27; 
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount] ;
	
	// Set up the sections array: elements are mutable arrays that will contain the object for that section.
	
	for (NSUInteger index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		
		[newSectionsArray addObject:array];
		
		//[array release];
		
	}
	
	
	for (NSString *tune  in allTitleNames)
	{
        
		NSInteger sectionNumber = [self sectionNumberForTitle: tune];
		
		// put this in the correct bucket in the sections array of arrays
		
		NSMutableArray *sections = [newSectionsArray objectAtIndex:sectionNumber];
        
		[sections addObject:tune];
	}
	//sor each of these 
	for (NSUInteger index = 0; index < sectionTitlesCount; index++)
	{
		NSMutableArray *tunes = [newSectionsArray objectAtIndex:index];
		
		[tunes sortUsingSelector:@selector(compare:)];  
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:tunes];
		//[na release]; //??
		
	}
	
	
	self.tunesByLetter = [newSectionsArray copy];	//050811
    // [newSectionsArray release];
	
}



#pragma mark Overridden UIViewController Methods

- (UIView *) makeSearchUI
{
	
	UIView *outer = [super buildContentBackground];//0612 remove retain, let it be autoreleased
    
    CGRect pframe = outer.frame;
    
	
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(pframe.origin.x, pframe.origin.y+ 0,//[DataManager navBarHeight], 
                                                                           pframe.size.width, [KORDataManager globalData].searchBarHeight)];  // do not autorelease
	searchBar.alpha = 1.000f;
	searchBar.autoresizesSubviews = NO;
	//searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	searchBar.barStyle = UIBarStyleBlackOpaque;
	searchBar.clearsContextBeforeDrawing = YES;
	searchBar.clipsToBounds = NO;
	//searchBar.contentMode = UIViewContentModeRedraw;
	searchBar.contentStretch = CGRectFromString(@"{{0, 0}, {1, 1}}");
	searchBar.hidden = NO;
	searchBar.multipleTouchEnabled = YES;
	searchBar.opaque = YES; // just changed
	searchBar.placeholder =@"Enter the name of the tune you are looking for...";
	searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
								   @"Chords"
								   , nil];
	searchBar.showsBookmarkButton = NO;
	searchBar.showsCancelButton = NO;
	searchBar.showsScopeBar = NO;
	searchBar.showsSearchResultsButton = NO;
	searchBar.tag = 0;
	searchBar.userInteractionEnabled = YES;
	searchBar.backgroundColor = [UIColor clearColor];
	searchBar.delegate = self;
	
	// the main table
	
	pframe.origin.y =[KORDataManager globalData].searchBarHeight+0;//[DataManager navBarHeight];
	pframe.size.height = outer.frame.size.height-pframe.origin.y;//- 64.0;// hack to proper length
	
    MainTableView *mainTableView = [[MainTableView alloc] initWithFrame: pframe
                                                                  style: UITableViewStylePlain controller:self];
	mainTableView.rowHeight = 60.f; // maintain consisency
	mainTableView.backgroundColor = [UIColor clearColor];
	mainTableView.opaque = NO;
	mainTableView.backgroundView = nil;
    mainTableView.dataSource = mainTableView;
    mainTableView.delegate = mainTableView;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mainTableView.tableHeaderView = hv;
    
    
    
    // NSLog (@"Adding searchBar origin %f height is %f",searchBar.frame.origin.y,searchBar.frame.size.height);
   	[outer addSubview:searchBar];
    
    // NSLog (@"Adding mainTableView origin %f height is %f",mainTableView.frame.origin.y,mainTableView.frame.size.height);
    [outer addSubview:mainTableView];
    
    
	
	// the overlay, with search results has a table of its own built right in
	
	CGRect oframe =  CGRectMake(0,[KORDataManager globalData].searchBarHeight+0,//[DataManager navBarHeight],
                                self.presentingViewController.view.bounds.size.width,
                                self.presentingViewController.view.bounds.size.height
								-[KORDataManager globalData].searchBarHeight-0);//[DataManager navBarHeight]);
	self.overlayView = [[UIView alloc]initWithFrame:oframe];
	self.overlayView.backgroundColor=[UIColor clearColor];
    self.overlayView.alpha = 0;
	
    // NSLog (@"overlayView origin %f height is %f",overlayView.frame.origin.y,overlayView.frame.size.height);
    
	oframe = CGRectMake(0,0,
                        self.presentingViewController.view.bounds.size.width,
                        self.presentingViewController.view.bounds.size.height-[KORDataManager globalData].navBarHeight -[KORDataManager globalData].searchBarHeight);
	SearchResultsTableView *oView = [[SearchResultsTableView alloc] initWithFrame: oframe
                                                                            style: UITableViewStylePlain controller:self];
	
	oView.backgroundColor = [UIColor whiteColor];
    oView.dataSource = oView;
    oView.delegate = oView;
    oView.separatorColor = [UIColor lightGrayColor];
    oView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    oView.tableHeaderView = nil; 
    
    // NSLog (@"Adding SearchResultsTableView origin %f height is %f",oView.frame.origin.y,oView.frame.size.height);
	
	[self.overlayView addSubview:oView];
	
	// do not add the overlay in here yet, only when we have search results
    
	self.navigationItem.title/*View*/ = [KORDataManager makeTitleView:navTitle] ;

    
	self.tableview = mainTableView;
	self.searchbarview = searchBar;
	self.searchresultstableview = oView;
    
    
	return outer;
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

-(void) loadView
{
	
    self.outerView  = [self makeSearchUI] ;
    self.view = self.outerView; // rebuild whole UI
	 
	
}

-(void) viewDidAppear:(BOOL)animated
{
    wassup = NO;
}



-(id) initWithArray:(NSArray *) a andTitle:(NSString *)titl andArchive:(NSString *)archiv helpView:(UIView *) hvx 
 ;
{
	//NSLog (@"STV initWithArray");
	self=[super init];
	if (self)
	{
		allTitleNames = a;
		navTitle = titl;
		archive = archiv;
        hv = hvx;
        wassup = YES;
        
        [self configureSections];
        
	}
	return self;
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
{
    
    //[self.outerView release];
    self.outerView  = [self makeSearchUI] ;
    self.view = self.outerView; // rebuild whole UI
}
#pragma mark Overridden NSObject Methods
-(void) didReceiveMemoryWarning
{
	
	NSLog (@"KORAbsFullSearchController didReceiveMemoryWarning will terminate self");
    
	[super didReceiveMemoryWarning];
	
	
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}
-(void) viewDidUnload
{
	//NSLog (@"STV viewDidUnload");
	// views already released 
	[super viewDidUnload];
    
	self.tableview = nil;
	self.searchbarview = nil;
	self.searchresultstableview=nil;
	
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
	// We don't want to do anything until the user clicks 
	// the 'Search' button.
	// If you wanted to display results as the user types 
	// you would do that here.
	//   NSArray *results = [SomeService doSearch:searchBar.text];
	
	//if (self.searchResults) [self.searchResults release];
	
	// [self searchBar:searchBar activate:NO];
	
    //	NSLog (@"Now searching for %@", searchBar.text);
	
	self.searchResults = [self findSearchResultsForKey: searchBar.text];  // findSearchResultsForKey 
	
	
	[self.searchresultstableview reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever 
    // focus is given to the UISearchBar
    // call our activate method so that we can do some 
    // additional things when the UISearchBar shows.
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the 
    // UISearchBar loses focus
    // We set't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
    searchBar.text=@"";
    [self searchBar:searchBar activate:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}

// We call this when we want to activate/deactivate the UISearchBar
// Depending on active (YES/NO) we disable/enable selection and 
// scrolling on the UITableView
// Show/Hide the UISearchBar Cancel button
// Fade the screen In/Out with the overlayView and 
// simple Animations

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active
{	
	self.tableview.allowsSelection = !active;
    self.tableview.scrollEnabled = !active;
    if (!active) {
        [overlayView removeFromSuperview];
        [searchBar resignFirstResponder];
    } else {
        self.overlayView.alpha = 0;
        [self.view addSubview:self.overlayView];
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5f];
        self.overlayView.alpha = 0.8f;
        [UIView commitAnimations];
		
        // probably not needed if you have a details view since you 
        // will go there on selection
        NSIndexPath *selected = [self.tableview
								 indexPathForSelectedRow];
        if (selected) {
            [self.tableview deselectRowAtIndexPath:selected 
                                          animated:NO];
        }
    }
    [searchBar setShowsCancelButton:active animated:YES];
}


@end
