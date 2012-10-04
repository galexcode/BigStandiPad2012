//
//  ClumpInfoController.m
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.

#import "KORClumpInfoController.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "ArchiveInfo.h"

#import "KORBarButtonItem.h"

@interface KORClumpInfoController()
<UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic,retain)	NSArray *listItems;
@property (nonatomic,retain)	NSString *tuneTitle;
@property (nonatomic,retain)	ClumpInfo *tuneInfo;
@property (nonatomic,retain)	UITableView *tableView;

@end

@implementation KORClumpInfoController
@synthesize listItems,tuneTitle,tuneInfo,tableView;

-(id) initWithTune : (NSString *) tune;
{
	self=[super init];
	if (self)
	{
		tuneInfo = [KORRepositoryManager findTune:tune];
        listItems = [KORRepositoryManager allVariantsFromTitle:tune];
        tuneTitle = [tune copy];
	}
	return self;	
}


- (void) loadView
{
	CGRect theframe = self.presentingViewController.view.bounds;
	UIView *oview = [[UIView alloc] initWithFrame: theframe ];
	oview.backgroundColor = [UIColor lightGrayColor];
	float fudge =0.f;// [DataManager navBarHeight];
	theframe.origin.y+=fudge;
	theframe.size.height-=fudge;
	
	// outer view installed just to get background colors right
	UITableView *tmpView = [[UITableView alloc] initWithFrame: theframe
                                                         style: UITableViewStylePlain] ;
	
	tmpView.tableHeaderView = nil;
	tmpView.backgroundColor =  [UIColor whiteColor]; 
	tmpView.opaque = YES;
	tmpView.backgroundView = nil;
    tmpView.dataSource = self;
    tmpView.delegate = self;
    tmpView.separatorColor = [UIColor lightGrayColor];
    tmpView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	self.navigationItem.title/*View*/ = [KORDataManager makeUnadornedTitleView:
                                     [NSString stringWithFormat:@"Open %@ in another app", self.tuneTitle ]];	

	
	[oview addSubview:tmpView];
	self.tableView = tmpView; // make everyone else happy too!
	self.view = oview;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem  
            buttonWithTitle:@"done" 
            style:UIBarButtonItemStyleBordered 
     completionBlock: ^(UIBarButtonItem *bbi){
         [presenter dismissViewControllerAnimated:YES  
                                                                            completion: ^(void) {/*  NSLog (@"done button hit"); */ }];                     
                                             }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
{
	//[self.tableView reloadData];
    [ self loadView] ; // rebuild whole UI
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
	return [self.listItems count];
}


#pragma mark UITableViewDelegate Methods

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    static NSString *CellIdentifier1 = @"ZipCell1";
    
    NSUInteger row = idxPath.row;
	
	
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: CellIdentifier1];
	
    if (!cell)
    {		
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier1];
    }
	
    //
    // Reset cell properties to default:
    //
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
	
	
	if (row < [ self.listItems count])
	{
		
		cell.accessoryType = UITableViewCellAccessoryNone;; //Indicator;
		
	    InstanceInfo *ii= [self.listItems objectAtIndex: row];
		
		NSString *longpath = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
		
		NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: [[KORPathMappings pathForSharedDocuments] 
																					   stringByAppendingPathComponent: longpath]
																			   error: NULL];
		NSDate *date = [attrs objectForKey:NSFileCreationDate];
		NSNumber *size = [attrs objectForKey:NSFileSize];
		unsigned long long ull = ([size unsignedLongLongValue]);
		double mb = (double)ull	; // make this a double
		mb = mb/(1024.f); // Convert to K
		// mark the most recent tune shown
		if ([self.tuneInfo.lastArchive isEqualToString:ii.archive]
			&& [self.tuneInfo.lastFilePath isEqualToString:ii.filePath])	
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		cell.textLabel.text = longpath;	
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];	
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fKB - visited %@ imported %@",mb,ii.lastVisited,date];
		cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:10];	
		cell.imageView.image =[KORRepositoryManager makeArchiveThumbnail: ii.archive ];
		
    }
    else cell = nil;
	
    return cell;
}


- (CGFloat) tableView: (UITableView *) tabView
heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	return [KORDataManager globalData].standardRowSize;
}


- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	InstanceInfo *ii= [self.listItems objectAtIndex: idxPath.row];
	NSString *upath = [NSString stringWithFormat:@"%@/%@",
					   [KORPathMappings pathForSharedDocuments],
					   ii.filePath];
	
    [KORDataManager docMenuForURL:[NSURL fileURLWithPath:upath isDirectory: NO] 
						inView:[tabView cellForRowAtIndexPath:idxPath].imageView];
	
	return;;
}
- (void) tableView: (UITableView *) tabView
   willDisplayCell: (UITableViewCell *) cell
 forRowAtIndexPath: (NSIndexPath *) idxPath
{
	//
	// Apple docs say to do this here rather than at cell creation time ...
	//
	cell.backgroundColor = [UIColor whiteColor];
}


/////

@end
