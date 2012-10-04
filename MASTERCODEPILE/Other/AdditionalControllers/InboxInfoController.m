//
//  SongsViewController.m
// BigStand
//
//  Created by bill donner on 12/25/10.
//  Copyright 2010 // BigStand.net. All rights reserved.

#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORInboxInfoController.h"
#import "KORBarButtonItem.h"

@interface KORInboxInfoController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) NSMutableArray *listItems;
@property (nonatomic,retain) NSString *tuneTitle;
@property (nonatomic) BOOL canEdit;
@property (nonatomic,retain) UITableView *tableView;
@end

@implementation KORInboxInfoController
@synthesize listItems,tuneTitle,tableView,canEdit;


-(void) setBarButtonItems
{
	BOOL settingsCanEdit = [RPSSettingsManager sharedInstance].normalMode;
	
	if (self.canEdit)
	{
		//when editing, display the done button
		//when not, only display edit if listItems exist
		if (self.tableView.isEditing){
			self.navigationItem.rightBarButtonItem =
			[KORBarButtonItem   buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
             completionBlock:^(UIBarButtonItem *bbi) {
                 [self.tableView setEditing:NO animated:YES];
                 [self setBarButtonItems];
             }];
		}
		else {
			
			self.navigationItem.rightBarButtonItem = ([self.listItems count] && settingsCanEdit) ? 
            [KORBarButtonItem   buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                              completionBlock:^(UIBarButtonItem *bbi) {
                                                  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                                                  [self.tableView setEditing:YES animated: YES];
                                                  [self setBarButtonItems];
                                              }]
			: nil;
		}
	}
	
}


-(id) init
{
	self=[super init];
	if (self)
	{
	self.listItems = [KORDataManager  makeInboxDocsList];
		self.canEdit = YES; // for now
	
	}
	return self;
	
}


- (void) loadView
{
	CGRect theframe = self.presentingViewController.view.bounds;
	//UIView *oview = [[[UIView alloc] initWithFrame: theframe ] autorelease];
	//oview.backgroundColor = [UIColor clearColor];
	float fudge = [KORDataManager globalData].navBarHeight;
	theframe.origin.y+=fudge;
	theframe.size.height-=fudge;
	
	// outer view installed just to get background colors right
	UITableView *tmpView = [[UITableView alloc] initWithFrame: theframe
														 style: UITableViewStylePlain];
	
	tmpView.tableHeaderView = nil;
	tmpView.backgroundColor =  [UIColor clearColor]; //12345
	tmpView.opaque = YES;
	tmpView.backgroundView = nil;
    tmpView.dataSource = self;
    tmpView.delegate = self;
    tmpView.separatorColor = [UIColor lightGrayColor];
    tmpView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	
	
	

	self.navigationItem.title/*View*/ = [KORDataManager makeUnadornedTitleView:@"iTunes File Sharing" ];	

	[self setBarButtonItems];
	
	self.tableView = tmpView; // make everyone else happy too!
	
	
	self.view = tmpView;
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

    self.navigationItem.leftBarButtonItem =     [KORBarButtonItem  
                                                 buttonWithTitle:NSLocalizedString(@"done",@"")
                                                 style:UIBarButtonItemStyleBordered 
                                                 completionBlock: ^(UIBarButtonItem *bbi){
                                                     
                                                     [presenter dismissViewControllerAnimated:YES  
                                                                                                         completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
                                                     
                                                 }];
	
	
	//self.navigationItem.hidesBackButton = NO; 
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
{
	[self loadView]; // rebuild everything
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void) viewDidUnload
{
    // dealloc may never get called
    
    [KORDataManager singleTapPulse];
    [super viewDidUnload];
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
#pragma mark UITableViewDataSource Methods

-(void) tableView: (UITableView *)aTableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// DELETE An INBOX FILE
		
		NSString *sspath = [self.listItems objectAtIndex:indexPath.row];
		
		// actually delete this item from the listItems array
		[self.listItems removeObjectAtIndex:indexPath.row];	// make this persistent by actually deleting the particular plist
		NSString *path = [NSString stringWithFormat:@"%@/%@",[KORPathMappings pathForItunesInbox ],sspath];
		//Remove any file at the destination path
		NSError *moveError = nil;
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			[KORDataManager  removeItemAtPath:path error:&moveError];
			if (moveError) {
					
				NSLog(@"file Error on inbox file delete is %@",moveError);
			}
		}
		[self.tableView reloadData];
		[self setBarButtonItems];
	}
}



// override to present a different and simpler display for each
-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	//change the data as we move stuff around, -- thanks Erica Sadun
	
	NSString *path = [self.listItems objectAtIndex:oldPath.row] ;
	[self.listItems removeObjectAtIndex:oldPath.row];
	[self.listItems insertObject: path atIndex:newPath.row];
	[self setBarButtonItems];
	
	
}

#pragma mark UITableViewDelegate Methods

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    static NSString *CellIdentifier1 = @"ZipCell1";
//	NSUInteger section = idxPath.section;
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = nil;
	
	
	if (row < [ self.listItems count])
	{
		
		cell.accessoryType = UITableViewCellAccessoryNone;; //Indicator;
		NSString *name = [self.listItems objectAtIndex: row];
	    NSString *path= [[KORPathMappings pathForItunesInbox] 
						 stringByAppendingPathComponent:name ];
		
		NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: path  error: NULL];
		NSDate *date = [attrs objectForKey:NSFileCreationDate];
		NSNumber *size = [attrs objectForKey:NSFileSize];
		
		unsigned long long ull = ([size unsignedLongLongValue]);
		double mb = (double)ull	; // make this a double
		mb = mb/(1024.f); // Convert to K
		
		
		NSString *ext = [[path pathExtension] lowercaseString];
		NSString *blurb;
		
		if ([@"zip" isEqualToString:ext])
			blurb = @" will be assimilated as a new archive";
		else 
			if ([@"stl" isEqualToString:ext])
				blurb = @" will be assimilated as a new setlist";	
			else 
					if ([@"jpg" isEqualToString:ext] 
						|| [@"jpeg" isEqualToString:ext]
						|| [@"png" isEqualToString:ext]
						|| [@"gif" isEqualToString:ext]
						)
						blurb = @" will be assimilated as a new image in the on-the-fly archive";
		
			 
			else 
				if (   [@"pdf" isEqualToString:ext] 
					|| [@"html" isEqualToString:ext]
					|| [@"doc" isEqualToString:ext]
                    || [@"docx" isEqualToString:ext]
					|| [@"rtf" isEqualToString:ext]
					|| [@"mp3" isEqualToString:ext]
					|| [@"m4v" isEqualToString:ext]
					)
					blurb = @" will be assimilated as a new file in the on-the-fly archive";
		
				else 
					if ([@"txt" isEqualToString:ext] 
						|| [@"htm" isEqualToString:ext]
						)
						blurb = @" will be shredded and rebuilt as a new file in the on-the-fly archive";
		
		
					else 
					{
						// set selection color - DOESNT WORK despite stackoverflow
						UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
						myBackView.backgroundColor = [UIColor whiteColor];
						cell.selectedBackgroundView = myBackView;
						blurb = @" is completely unknown and will be ignored";
					}
		
		
		cell.textLabel.text = name;	
		
		//cell.textLabel.font = [UIFont boldSystemFontOfSize:12];	
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fKB %@ - created %@",mb,blurb, date];

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
	NSString *path= [self.listItems objectAtIndex: idxPath.row];
	
	NSString *upath = [NSString stringWithFormat:@"%@/%@",
					   
					   [KORPathMappings pathForSharedDocuments],
					   path];
	
	
	
	//+(BOOL) docMenuForURL: (NSURL *) fileURL inView: (UIView *) vew;
	
    [KORDataManager docMenuForURL:[NSURL fileURLWithPath:upath isDirectory: NO] inView:[tabView cellForRowAtIndexPath:idxPath].textLabel];
	
	//NSLog (@"Menu for %@ didPaint=%D", upath, didPaint);
	
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

@end
