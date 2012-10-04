	//
	//  ContentMenuViewController.m
	// BigStand
	//
	//  Created by bill donner on 4/1/11.
	//  Copyright 2011 ShovelReadyApps. All rights reserved.
	//



#import <MobileCoreServices/MobileCoreServices.h>
#import "KORListsManager.h"
#import "KORBarButtonItem.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import	"KORLoggingViewController.h"
#import "KORSetlistsMenuController.h"
#import "KORRepositoryManager.h"
#import "KORSetlistsMenuController.h"
#import "KORAllTunesController.h"
#import "KORActionSheet.h"
#import "KORMultiProtocol.h"
#import "KORAlertView.h"
#pragma mark -
#pragma mark Public Class ContentMenuViewController
#pragma mark -

#pragma mark Internal Constants

	//
	// Table sections:
	//
enum
{
	
    SECTION_COUNT = 1
};

	//
	// Tail table section rows:
	//
enum
{
		//
    ABOUT_ROW_COUNT
};



@interface KORSetlistsMenuController () < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain)  NSMutableArray *listNames;
@property (nonatomic) BOOL listsAreFresh;  // set it to NO to get a refresh of constiuent parts

@property (nonatomic,retain)		NSArray *sequenceNums;
@property (nonatomic,retain)	KORActionSheet *toass;
@property (nonatomic) BOOL canEdit;  // set it to NO to get a refresh of constiuent parts
@property (nonatomic,retain) UITableView *tableView ;
@property (nonatomic,retain) NSString *traversingName;

@property (nonatomic,retain) NSString *traversingKind;

-(void) setBarButtonItems;
-(void) leaveEditMode;
-(void) enterEditMode;
-(void) leaveEditMode;


@end

@implementation KORSetlistsMenuController

@synthesize tableView,canEdit,toass,listNames,sequenceNums,dismissalTarget;
@synthesize trampolinedelegate,listsAreFresh,traversingKind,traversingName;

-(void) setBarButtonItems

{	
	
	self.navigationItem.leftBarButtonItem =
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
												  target:self 
												  action:@selector(enterEditMode)];
	
	if (self.canEdit)
	{
			//when editing, display the done button
		if (self.tableView.isEditing) {
			self.navigationItem.rightBarButtonItem =
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
														  target:self 
														  action:@selector(leaveEditMode)];
		}
		else {
			
				// cant edit create a standard action button
			
			self.navigationItem.rightBarButtonItem =
			
			[KORBarButtonItem buttonWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
			 
											completionBlock:^(UIBarButtonItem *x) {
												
												
												[self.trampolinedelegate trampoline:ADDLIST_COMMAND_TAG];
											}
			 
			 ];		 		
		}
	}
}
-(void) enterEditMode;
{
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[self.tableView setEditing:YES animated: YES];
	[self setBarButtonItems];
}
-(void) leaveEditMode;
{
	[self.tableView setEditing:NO animated:YES];
	[self setBarButtonItems];
		//[SetListsManager rewriteTuneList: self.listItems toPropertyList:self.plist];
}


-(CGSize) computeMenuSizeX
{
		// lets do a better job
    
    return CGSizeMake(240.f,
					  28.f+44.f*[self.listNames count]); // not same as iphone window
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
}


#pragma mark Private Instance Methods



-(void) makenewlists
{
    if (self.listsAreFresh == YES) return; // dont do this if unneeded, it is noticeably slow
	
	[self.listNames addObject:@"recents"];
	[self.listNames addObject:@"favorites"];
	for (NSString *s in [KORListsManager  makeSetlistsScanNoRecentsOrFavorites])
		[self.listNames addObject:s];
	
	self.listsAreFresh = YES;
    
}


- (void) reloadUserInfo;
{
    [self makenewlists];
	
    UITableView    *tabView = (UITableView *) self.view;
    [tabView reloadData];
}
- (void)becomeActive:(NSNotification *)notification {
	
    
    [self reloadUserInfo];
}
#pragma mark Overridden UIViewController Methods

- (void) didReceiveMemoryWarning
{
    tableView = nil;
    [super didReceiveMemoryWarning];
	
}

- (void) loadView
{
    
    [self makenewlists];
    listsAreFresh = YES;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
	
	frame.size = [self computeMenuSizeX];
    
	tableView =  [[UITableView alloc] initWithFrame: frame style: UITableViewStyleGrouped];
    tableView.backgroundColor =  [UIColor whiteColor];//[DataManager sharedInstance].headlineColor;
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor blackColor]; //was lightgray
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	
	
	self.navigationItem.title = [KORDataManager makeTitleView:@"setlists"] ;	    
	
	[self setBarButtonItems];
    
    self.view = self.tableView	;
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

- (void) viewWillAppear: (BOOL) animated
{
    
    [super viewWillAppear: animated];
    [self reloadUserInfo];
    
}

#pragma mark Overridden NSObject Methods



- (id) initWithViewController:(KORViewerController *) otc traversingName:(NSString *) tn traversingKind:(NSString *) tk;
{
    self = [super init];
    if (self) 
    {
        self.listsAreFresh = NO;
        self.listNames = [NSMutableArray array];
		self.sequenceNums = [NSMutableArray array];
        self.dismissalTarget = otc;
		self.canEdit = YES;
		self.traversingKind = tk;
		self.traversingName = tn;
		
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
	
	return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    static NSString *CellIdentifier1 = @"SetlistCell1";
    
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: CellIdentifier1];
    
    if (!cell)
    {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
									  reuseIdentifier: CellIdentifier1];
		
    }
    
		//
		// Reset cell properties to default:
		//
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    
	
	if ((idxPath.row <  [self.listNames count]))
	{	
		
		NSString *name = [self.listNames objectAtIndex:idxPath.row];	
		
		if ([self.traversingKind isEqualToString:@"setlist"] && [self.traversingName isEqualToString:name])
			cell.accessoryType =UITableViewCellAccessoryCheckmark;
		
		if (idxPath.row<1)
		{
			cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
			
			cell.textLabel.textColor = [UIColor darkGrayColor];
			
		}
		
		else
		if (idxPath.row<2)
		{
			cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
			
			cell.textLabel.textColor = [UIColor darkGrayColor];
			
		}
		else 
			if (idxPath.row<5)
			{
				cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
				
					//cell.detailTextLabel.text = [NSString stringWithFormat:@"%C",9312+idxPath.row-2];
				
			}
			else
				cell.textLabel.text =[NSString stringWithFormat:@"%@",name];
		
	}
	else
		cell = nil;
	
	return cell;
}

- (NSInteger) tableView: (UITableView *) tabView numberOfRowsInSection: (NSInteger) sect
{
	
	return  [self.listNames count];
}

#pragma mark footer stuff




#pragma mark UITableViewDelegate Methods


- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	
	return 44.f;// [KORDataManager globalData].standardRowSize;
}

- (void) tableView: (UITableView *) tabView didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	
	NSString *name = [self.listNames objectAtIndex:idxPath.row];	
	if (self.dismissalTarget)
		[self.dismissalTarget setlistChosen:name];
	
	
}





#pragma mark UITableViewDelegate Methods

	// table methods for setlist, these are specialized here
-(void) tableView: (UITableView *)aTableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
			// DELETE A SETLIST
		
        NSString *which = 
		[self.listNames objectAtIndex:indexPath.row];
		
		if ([which isEqualToString:@"recents"] || [which isEqualToString:@"favorites"])
			
			[KORAlertView alertWithTitle:@"sorry that list can not be deleted" message:@"" buttonTitle:@"OK"];
		else {
		
			// make this persistent
		
        [KORListsManager deleteList:which];
		
		[self.listNames removeObjectAtIndex:indexPath.row];

		
		
			// persist change in core data by tweaking the timestamp   TBD
		
		
		
		self.sequenceNums = [KORListsManager rewriteListOfListsSequenceNums: self.listNames ];
		
		
		[self.tableView reloadData];
			[self setBarButtonItems];
		}
	}
}


-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	NSUInteger oldrow = oldPath.row;
	NSUInteger newrow = newPath.row;
		//change the data as we move stuff around, -- thanks Erica Sadun
	NSString *oldname = [self.listNames objectAtIndex:oldrow];
	NSString *newname = [self.listNames objectAtIndex:newrow];
	
	NSString *rn= oldname ;
	
	if (([oldname isEqualToString:@"recents"] || [oldname isEqualToString:@"favorites"])
		||([newname isEqualToString:@"recents"] || [newname isEqualToString:@"favorites"]))
	{
		
		[KORAlertView alertWithTitle:@"sorry that list can not be moved" message:@"" buttonTitle:@"OK"];
		
		
		[self.tableView reloadData];
		
		[self setBarButtonItems];
	}
	else 
	{
	[self.listNames removeObjectAtIndex:oldPath.row];
	
	[self.listNames insertObject: rn atIndex:newPath.row];
	
	if (oldrow > newrow)
	{
		
		NSLog (@"Insert oldrow %d oldname %@ BEFORE newrow %d newname %@",oldrow,oldname,newrow,newname);

	}
	else
		
	{
		
		NSLog (@"Insert oldrow %d oldname %@ AFTER newrow %d newname %@",oldrow,oldname,newrow,newname);
		
	}
	
		// persist change in core data by tweaking the timestamp   TBD
	
	
	
	self.sequenceNums = [KORListsManager rewriteListOfListsSequenceNums: self.listNames ];
	
	
	[self.tableView reloadData];
	[self setBarButtonItems];
	}
	
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (self.canEdit)		{
		
		
		
        return UITableViewCellEditingStyleDelete;
		
    } else {
		
        return UITableViewCellEditingStyleNone;
		
    }
	
}


@end