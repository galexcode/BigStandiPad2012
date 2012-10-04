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
#import "KORArchivesMenuController.h"
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
	ARCHIVES_SECTION =0 ,	// Then Comes All The Archives - must be last - is now optional
	
    SECTION_COUNT
};

	//
	// Tail table section rows:
	//
enum
{
		//
    ABOUT_ROW_COUNT
};



@interface KORArchivesMenuController () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,retain) NSArray *sequenceNums;
@property (nonatomic,retain)  NSMutableArray *archiveNames;
@property (nonatomic) NSUInteger lclumpCount;
@property (nonatomic) NSUInteger licount;
@property (nonatomic) NSUInteger aicount;
@property (nonatomic) BOOL listsAreFresh;  // set it to NO to get a refresh of constiuent parts

@property (nonatomic,retain) NSString *traversingName;

@property (nonatomic,retain) NSString *traversingKind;

@property (nonatomic,retain)	KORActionSheet *toass;
@property (nonatomic) BOOL canEdit;  // set it to NO to get a refresh of constiuent parts
@property (nonatomic,retain) UITableView *tableView ;


-(void) setBarButtonItems;
-(void) leaveEditMode;
-(void) enterEditMode;
-(void) leaveEditMode;


@end

@implementation KORArchivesMenuController

@synthesize tableView,canEdit,toass,archiveNames,dismissalTarget,traversingKind,traversingName;
@synthesize archivedelegate,trampolinedelegate,lclumpCount,licount,aicount,listsAreFresh,sequenceNums;

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
												
												
												[self.trampolinedelegate trampoline:ADDARCHIVE_COMMAND_TAG];
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
    
    NSUInteger count = [[KORRepositoryManager allEnabledArchives] count];//+[[KORListsManager makeSetlistsScan] count] + 2;
    float height = count * ([KORDataManager globalData].standardRowSize) +24.f;
		//	
		//    BOOL settingsCanEdit = [RPSSettingsManager sharedInstance].normalMode;
		//    
		//    if (settingsCanEdit ) height +=68.f;
    return CGSizeMake(240.f,height); // not same as iphone window
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
}


#pragma mark Private Instance Methods



-(void) makenewlists
{
    if (listsAreFresh == YES) return; // dont do this if unneeded, it is noticeably slow
    
		// load these values like a little cache    
    self.lclumpCount = [KORRepositoryManager clumpCount];
    self.licount = [KORRepositoryManager instancesCount];
    self.aicount = [KORRepositoryManager archivesCount];
    self.archiveNames = [KORDataManager list:[KORRepositoryManager allEnabledArchives] 
								  bringToTop:[NSArray arrayWithObjects:[KORRepositoryManager nameForOnTheFlyArchive],nil]] ;
    
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
	
	
	self.navigationItem.title = [KORDataManager makeTitleView:@"archives"] ;	    
	
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
        self.archiveNames = nil;
        self.dismissalTarget = otc;
		self.canEdit = YES;
		self.traversingKind = tk;
		self.traversingName = tn;
		self.sequenceNums = [NSArray array];
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
    static NSString *CellIdentifier1 = @"InfoCell1";
    NSString        *cellIdentifier;
    
    switch (idxPath.section)
    {
            
			
			
        case ARCHIVES_SECTION :
        default:
        {
            cellIdentifier = CellIdentifier1; // this section will have images
            break;
            
        }
    }
    
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (!cell)
    {
        switch (idxPath.section)
        {
                
            case ARCHIVES_SECTION :
                
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
											  reuseIdentifier: cellIdentifier];
                
                break;
                
            default :
                break;
        }
    }
    
		//
		// Reset cell properties to default:
		//
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    
    switch (idxPath.section)
    {
            
			
            
        case ARCHIVES_SECTION :
        {
            
            if ((idxPath.row <  [self.archiveNames count]))
            {	
					//[KORRepositoryManager dump];
                
                NSString *archive = [self.archiveNames objectAtIndex:idxPath.row];	
                
                NSString *shortname = [KORRepositoryManager shortName:archive];
				
				if ([self.traversingKind isEqualToString:  @"archive"] && [self.traversingName isEqualToString:shortname])
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				
                cell.textLabel.text =  shortname;
                
				cell.imageView.image =[KORRepositoryManager makeArchiveThumbnail: archive];
                
                {
					if ([archive isEqualToString:[KORRepositoryManager nameForOnTheFlyArchive]])
						cell.textLabel.textColor = [UIColor darkGrayColor];
                }
            }
            else
                cell = nil;
            
            break;
        }
            
        default :
            cell = nil;
            break;
    }
    return cell;
}

- (NSInteger) tableView: (UITableView *) tabView numberOfRowsInSection: (NSInteger) sect
{
		//   SettingsManager *settings = self.appDelegate.settingsManager;
    
    switch (sect)
    {
            
        case ARCHIVES_SECTION :
            return  [self.archiveNames count];
			
            
        default :
            return 0;
    }
}

#pragma mark footer stuff




#pragma mark UITableViewDelegate Methods


- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	
    
    return [KORDataManager globalData].standardRowSize;
}

- (void) tableView: (UITableView *) tabView didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    switch (idxPath.section)
    {	
			
        case ARCHIVES_SECTION :
        {
            
            NSString *archive = [self.archiveNames objectAtIndex:idxPath.row];	
			
				//NSLog (@"Touched %@ in KORContentMenuController",archive);
			if (self.dismissalTarget)
				[self.dismissalTarget archiveChosen:archive];
			
			
            
            break;
			
		}
	}
	
}



#pragma mark UITableViewDelegate Methods

	// table methods for setlist, these are specialized here
-(void) tableView: (UITableView *)aTableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
			// DELETE A SINGLE TUNE FROM THE SETLIST
		
			// actually delete this item from the listItems array
			//        NSString *tune = 
			//		[self.archiveNames objectAtIndex:indexPath.row];
			//		
			// make this persistent
		NSString *thisArchive  = [self.archiveNames objectAtIndex:indexPath.row];
		if (![thisArchive isEqualToString:@"onthefly-archive"])
		{
			
			[KORAlertView alertWithTitle:@"Are you sure you want to delete this archive?"
								 message:@"This can't be undone" cancelTitle:@"Cancel" 
							 cancelBlock:^{
								 
							 } 
							  otherTitle:@"Delete" 
							  otherBlock:^{
								 
								 [KORRepositoryManager deleteArchive:[self.archiveNames objectAtIndex:indexPath.row]];
								 
								 [self.archiveNames removeObjectAtIndex:indexPath.row];
								  
								self.sequenceNums =    [KORRepositoryManager rewriteListOfArchivesSequenceNums: (NSArray *) self.archiveNames];

								 [self.tableView reloadData];
								 [self setBarButtonItems];
								 
							 }];
		}
		else
			[KORAlertView alertWithTitle:@"You can't delete the OnTheFly Archive"
								 message:@"it is builtin" buttonTitle:@"OK"];
	}
}


-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    NSUInteger oldrow = oldPath.row;
    NSUInteger newrow = newPath.row;
		//change the data as we move stuff around, -- thanks Erica Sadun
	NSString *oldname = [self.archiveNames objectAtIndex:oldrow];
	
    
	NSString *newname = [self.archiveNames objectAtIndex:newrow];
    
    NSString *rn= oldname ;
    
	if (!([newname isEqualToString:@"onthefly-archive"]||[oldname isEqualToString:@"onthefly-archive"])) {
    
	[self.archiveNames removeObjectAtIndex:oldPath.row];
	
	[self.archiveNames insertObject: rn atIndex:newPath.row];
    
    if (oldrow > newrow)
    {
		
		NSLog (@"Insert oldrow %d oldname %@ BEFORE newrow %d newname %@",oldrow,oldname,newrow,newname);
		
    }
    else
        
    {
        
        NSLog (@"Insert oldrow %d oldname %@ AFTER newrow %d newname %@",oldrow,oldname,newrow,newname);
        
    }
    
	self.sequenceNums =    [KORRepositoryManager rewriteListOfArchivesSequenceNums: (NSArray *) self.archiveNames];
	
	}
	else
		
		[KORAlertView alertWithTitle:@"You can't move the OnTheFly Archive"
							 message:@"it is always on top" buttonTitle:@"OK"];
	
		// repaint, even if we are disallowing the movement
	
	
	[self.tableView reloadData];
	[self setBarButtonItems];
	
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