	// this may no longer be needed now that search has been moved to its own tab

	//  SetListViewController.m
	//  MusicStand
	//
	//  Created by bill donner on 11/5/11.
	//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
	//

#import "KORSetListControllerIpad.h"
#import "KORRepositoryManager.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORListsManager.h"
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "KORViewerController.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORAttributedLabel.h"
#import "KORMultiProtocol.h"


@interface KORSetListControllerIpad()
<UITableViewDataSource, UITableViewDelegate,KORTuneControllerDismissedDelegate> 


@property (nonatomic,retain)		KORActionSheet *toass;
@property (nonatomic,retain)		MFMailComposeViewController* controller;
@property (nonatomic,retain)		NSMutableArray *listItems;
@property (nonatomic,retain)		NSString *currentTitle;
@property (nonatomic,retain)		NSArray *sequenceNums;
@property (nonatomic,retain)		NSString *name;
@property (nonatomic,retain)		NSString *plist;
@property (nonatomic,retain)		UITableView *tableView;
@property (nonatomic)	BOOL canEdit;
@property (nonatomic)	BOOL canReorder; // canEdit must be YES for this to matter
@property (nonatomic)	NSUInteger tag;
@property (nonatomic)	BOOL canShare;
@property (nonatomic) BOOL wassup;


-(NSUInteger ) itemCount;

-(void) setBarButtonItems;
-(void) leaveEditMode;-(void) enterEditMode;
-(void) leaveEditMode;
@end

@implementation KORSetListControllerIpad
@synthesize tuneselectordelegate,trampolinedelegate,toass,controller,listItems,sequenceNums,
name,plist,tableView,canEdit,canReorder,currentTitle,tag,canShare,wassup;

- (UITableViewCell *)makeCellView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    

    
    NSInteger row = [indexPath row];

    NSString *displayOne;
    NSString *displayTwo;
    NSString *displayThree;
    
	static NSString *CellIdentifier = @"xdddyzzyCell";
    
		//  NSString *rightHandImage;
    NSString *tune = [self.listItems objectAtIndex:row];
	NSUInteger seq = [[self.sequenceNums objectAtIndex:row] unsignedShortValue];
    ClumpInfo  *tn = [KORRepositoryManager findClump:tune];
    if (!tn)
    {
        displayThree = tune;	displayTwo = @"";
        displayOne = @"--not found on this device--";
			// rightHandImage =  @"";
        
    }
    else 
    {
        
        displayOne = tn.title;
		displayThree = [NSString stringWithFormat:@"%d - ",seq ];
		displayTwo = @"";
        
    }
    
    
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
			//
			// Create the cell.
			//
		cell =
        [[UITableViewCell alloc]
		 initWithStyle:UITableViewCellStyleValue1
		 reuseIdentifier:CellIdentifier];
        
	} 
	cell.textLabel.text = displayOne;
		//cell.detailTextLabel.text = displayThree;
	if ([self.currentTitle isEqualToString:  tn.title])
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		
		cell.accessoryType = UITableViewCellAccessoryNone;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
	return cell;
}



- (void)dealloc 


{
	[self.toass dismissWithClickedButtonIndex:-1 animated:NO];// TALK TO JOHN ABOUT THIS
	
}



-(id) initWithName:(NSString *) namex edit:(BOOL) editx currentTitle:(NSString *) ctitle;
{
	
	self = [super init];
	if (self)
	{
		if ([[namex substringToIndex:1 ] isEqualToString:@"@"])
		{
			
			
				// if special get list of all setlists
			
			NSString *key = [namex substringFromIndex:1];
			
			NSArray *lists  = [KORListsManager makeSetlistsScanNoRecentsOrFavorites]; //locallistItems;
			NSUInteger lc = [lists count];
			
			NSString *set1 = lc>0?[lists objectAtIndex:0]:nil;
			NSString *set2 = lc>1?[lists objectAtIndex:1]:nil;
			NSString *set3 = lc>2?[lists objectAtIndex:2]:nil;
			
			if ([key isEqualToString:@"set1"]) self.name = set1; else
				
				if ([key isEqualToString:@"set2"]) self.name = set2; else
					
					if ([key isEqualToString:@"set3"]) self.name = set3; else
						self.name = namex;
			
		}
		else
		self.name = namex  ;
		self.canEdit = editx;
		self.canReorder = YES;
		self.tag = 1;
		self.plist = namex;
        self.wassup = YES;
		NSDictionary *d = [KORListsManager listOfTunes:self.name ascending:YES];  // should return in sequence number order]]
		self.listItems = [d objectForKey:@"tunes"];
		self.sequenceNums = [d objectForKey:@"sequences"];
		self.currentTitle = ctitle;
		
	}
	return self;
}



-(void) actionPressed
{
	[self.trampolinedelegate trampolineOneArg:SHOWSETLISTSHARING_COMMAND_TAG arg:self.plist]; 
}


#pragma mark  stuff inserted from former SUPER

-(NSUInteger ) itemCount;
{
	return [self.listItems count];
}

-(void) setBarButtonItems



{	
	
	BOOL showit =  [self.name length]>0;
	
		// cant edit create a standard action button
	if (showit)
	{
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
												 target:self
												 action:@selector(enterEditMode)];
	
	
		// cant edit create a standard action button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
											  target:self
											  action:@selector(actionPressed)];
	
	
	if (self.canEdit)
	{
			//when editing, display the done button
		if (self.tableView.isEditing) {
			self.navigationItem.rightBarButtonItem =
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
														  target:self 
														  action:@selector(leaveEditMode)];
		}
		
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


#pragma mark Overridden UIViewController Methods

-(void) viewDidAppear:(BOOL)animated
{
    wassup = NO;
}


- (void) viewDidLoad
{
	[super viewDidLoad];
		//	[self makeSearchNavHeaders];
}	
- (void) viewDidUnload

{
    [super viewDidUnload];	
}

- (void) loadView
{
	
	BOOL showit =  [self.name length]>0;//[self.listItems count]>0;
	
		//   UIViewController *presenter = [self presentingViewController]; // get this reliably out here
	
	self.canShare =  ([MFMailComposeViewController canSendMail]);
    
   
	
	
	CGRect theframe = 
	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 
	CGRectMake(0,0,
			   240,
			58.f+44.f*[self.listItems count]):[[UIScreen mainScreen] bounds];
	
	
		//	
		//    UIView *compositeview  = [[UIView alloc] initWithFrame: theframe];
		//	
		//    compositeview.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
	
	UITableView *tb = [[UITableView alloc] initWithFrame: theframe
												   style: UITableViewStyleGrouped];
	
	
    
		// [compositeview addSubview:tb];
	
	
    tb.backgroundColor =  [UIColor whiteColor];//[DataManager sharedInstance].headlineColor;
    tb.opaque = YES;
    tb.backgroundView = nil;
    tb.dataSource = self;
    tb.delegate = self;
    tb.separatorColor = [UIColor blackColor]; //was lightgray
    tb.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.navigationItem.title =[KORDataManager makeTitleView:( showit? [NSString stringWithFormat:@"%@",self.name]: @"please add a setlist")];
	
    self.tableView = tb;
    self.view = tb;
	 [self setBarButtonItems];
}
#pragma mark Overridden NSObject Methods


- (void) didReceiveMemoryWarning
{	
    [super didReceiveMemoryWarning];
}
#pragma mark UITableViewDataSource Methods


/*
 Section-related methods: Retrieve the section titles and section index titles
 */
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if ([self.listItems count] == 0) 
	{
		UILabel *label =[[UILabel alloc] initWithFrame :CGRectMake(0,0,190,40)];//
		if([self.name length]>0)
		label.text = [NSString stringWithFormat:@"   no tunes on %@",self.name];
		else 
			label.text = @"   add setlists via '+'";
		label.font = [UIFont systemFontOfSize:12];
		label.backgroundColor  = [UIColor whiteColor];
		return label;
	}
	else return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (self.canEdit)		{
		
		NSString *titlestring = [self.listItems objectAtIndex:indexPath.row];
		if ([@"recents" isEqualToString:titlestring])  return UITableViewCellEditingStyleNone;
		
		
        return UITableViewCellEditingStyleDelete;
		
    } else {
		
        return UITableViewCellEditingStyleNone;
		
    }
	
}

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

	// table methods for setlist, these are specialized here
-(void) tableView: (UITableView *)aTableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
			// DELETE A SINGLE TUNE FROM THE SETLIST
		
			// actually delete this item from the listItems array
        NSString *tune = 
		[self.listItems objectAtIndex:indexPath.row];
		
			// make this persistent
		
        [KORListsManager removeTune:tune list:self.name];
		
		[self.listItems removeObjectAtIndex:indexPath.row];
		
		
		self.sequenceNums = [KORListsManager rewriteSetlistSequenceNums: (NSString *) self.name inMemory:(NSArray *) self.listItems ];
		
		
		[self.tableView reloadData];
		[self setBarButtonItems];
	}
}


-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    NSUInteger oldrow = oldPath.row;
    NSUInteger newrow = newPath.row;
		//change the data as we move stuff around, -- thanks Erica Sadun
	NSString *oldname = [self.listItems objectAtIndex:oldrow];
	
	NSString *newname = [self.listItems objectAtIndex:newrow];
    
    NSString *rn= oldname ;
    
    
	[self.listItems removeObjectAtIndex:oldPath.row];  
	[self.listItems insertObject: rn atIndex:newPath.row];
    
    if (oldrow > newrow)
    {
		
		NSLog (@"Insert oldrow %d oldname %@ BEFORE newrow %d newname %@",oldrow,oldname,newrow,newname);
		
			// [KORListsManager updateTune: oldname before: newname   list: self.name];
		
    }
    else
        
    {
        
        NSLog (@"Insert oldrow %d oldname %@ AFTER newrow %d newname %@",oldrow,oldname,newrow,newname);
        
			// [KORListsManager updateTune: oldname after: newname   list: self.name];
    }
    
		// persist change in core data
	
	
	self.sequenceNums = [KORListsManager rewriteSetlistSequenceNums: (NSString *) self.name inMemory:(NSArray *) self.listItems ];
	
	[self.tableView reloadData];
	[self setBarButtonItems];
}

- (UITableViewCell *) tableView: (UITableView *) tabView
		  cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    return [self  makeCellView:tabView cellForRowAtIndexPath:idxPath];
}

- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	
    
    return 44.;//[KORDataManager globalData].standardRowSize;
}

- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	
		// section should always be 1
	
	
	NSUInteger count = [self.listItems  count];
	
	if (idxPath.row < count)
	{
		
		NSString *tune = [ self.listItems  objectAtIndex:idxPath.row];	
		
		
		if (self.tuneselectordelegate)
			[self.tuneselectordelegate actionItemChosen: idxPath.row label:tune newItems:self.listItems listKind:@"setlist" listName:self.name];
		
		
		[self dismissViewControllerAnimated:YES completion:NULL];
	}
}

#pragma mark otc Protocol gets us control back to blow away the controller we created

-(void) dismissOTCController;
{
    [self dismissViewControllerAnimated:YES  completion: ^(void) { 
			//NSLog (@"%@ was dismissed",[self class]);
    }];
}


@end
