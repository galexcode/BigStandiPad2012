//
//  AllSetListsController.m
//  MusicStand
//
//  Created by bill donner on 11/9/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//

#import "KORListsEditorController.h"
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORAlertView.h"
#import "KORMultiProtocol.h"


enum
{
    SECTION_COUNT = 1  // MUST be kept in display order ...
    
};

@interface KORListsEditorController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) UIView *overlayXib;
@property (nonatomic,retain) KORActionSheet *toass;
@property (nonatomic,retain) UIImageView     *logoView;
@property (nonatomic,retain) NSMutableArray *listItems;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,assign) BOOL canEdit;
@property (nonatomic,assign) BOOL canReorder; // canEdit must be YES for this to matter

-(NSUInteger ) itemCount;
-(void) setBarButtonItems;
-(void) repaintUI;

@end


@implementation  KORListsEditorController
@synthesize trampolinedelegate,overlayXib,toass,logoView,listItems,name,tableView,canEdit,canReorder;

- (void) dealloc
{	
    [KORDataManager singleTapPulse];
}

-(NSUInteger ) itemCount;
{
	return [self.listItems count];
}


#pragma mark Overridden UIViewController Methods


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)||
    (UIDeviceOrientationIsPortrait ([UIDevice currentDevice].orientation));
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (self.canEdit)		{
		
        return UITableViewCellEditingStyleDelete;
		
    } else {
		
        return UITableViewCellEditingStyleNone;
		
    }
	
}

#pragma mark UITableViewDataSource Methods


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

#pragma mark Public Instance Methods
#pragma mark Private Instance Methods
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [ (UIView *) [self.overlayXib viewWithTag:901] resignFirstResponder];
    [ (UIView *) [self.overlayXib viewWithTag:900] resignFirstResponder];
    return YES;
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	BOOL unique = YES;
    
    
    //[textField resignFirstResponder];
	
	// check for duplicates
	for (NSString *s in self.listItems)
	{
		if ([s isEqualToString: textField.text])
		{
			unique = NO;	
			break;
		}
	}
	if (unique == YES)
	{
		
		[KORListsManager insertList:textField.text]; // new list
		
		[KORAlertView alertWithTitle:@"Created a new Setlist: "
                             message:textField.text buttonTitle:@"OK" ];
        [self repaintUI];
		
	}
	else {
        
        [KORAlertView alertWithTitle:@"Sorry, there is already a list with that name"
                             message:@"Make sure your name is unique and try again"
                         buttonTitle:@"OK"];
	}
    
    
    UIView *theview = (UIView *) [self.overlayXib viewWithTag:900];
    [theview removeFromSuperview];
    return YES;
}

-(void) addPressed;
{	
    
		//    self.overlayXib = [[[NSBundle mainBundle] loadNibNamed:[KORDataManager lookupXib:@"SetList"]
		//  owner:self options:NULL] lastObject];//0612
																						  //
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

	// put up an overlay subview which will have a textfield
    
    UIView *theview = (UIView *) [self.overlayXib viewWithTag:900];
    UITextField *field1 = (UITextField *)[theview viewWithTag:901];
    field1.delegate = self;
    [self.view addSubview:theview];
    // change the title bar
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem
     buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     completionBlock: ^(UIBarButtonItem *bbi){
         
         [presenter dismissViewControllerAnimated:YES completion: ^(void) { NSLog (@"cancel button hit"); }];
     }];
    
}

-(void) actionPressed
{
	
	
    __block typeof(self) bself = self;
	self.toass = [[KORActionSheet alloc] initWithTitle: NSLocalizedString (@"Options", @"")];	
	[self.toass addButtonWithTitle:NSLocalizedString (@"Add Setlist", @"") completionBlock: ^(void){
		[bself.trampolinedelegate trampoline:ADDLIST_COMMAND_TAG];
	}];
	
	if (self.canEdit)	
		
		[self.toass addButtonWithTitle:NSLocalizedString (@"Edit", @"") completionBlock: ^(void){
            [bself.tableView deselectRowAtIndexPath:[bself.tableView indexPathForSelectedRow] animated:YES];
            [bself.tableView setEditing:YES animated: YES];
            [bself setBarButtonItems];
        }];
    
	[self.toass showFromBarButtonItem: self.navigationItem.rightBarButtonItem animated: YES];
}


-(void) setBarButtonItems
{
	if (self.canEdit)
	{
		//when editing, display the done button
		//when not, only display edit if listItems exist
		if (self.tableView.isEditing){
			self.navigationItem.rightBarButtonItem =
			[KORBarButtonItem buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                            completionBlock:^(UIBarButtonItem *bbi){
                                                [self.tableView setEditing:NO animated:YES];
                                                [self setBarButtonItems];
                                                [self repaintUI];
                                                
                                            }];
		}
		else {
			self.navigationItem.rightBarButtonItem = 
			[KORBarButtonItem
             buttonWithBarButtonSystemItem:UIBarButtonSystemItemAction
             completionBlock:^(UIBarButtonItem *bbi){
                 [self actionPressed];
             }];
		}
	}
}

#pragma mark Overridden UIViewController Methods


-(void) viewDidUnload
{
    // dealloc may never get called
    
	//[self invalidateTimer];
    [KORDataManager singleTapPulse];
    [super viewDidUnload];
}

- (void) repaintUI;
{
	self.listItems = nil;
	self.listItems = [KORListsManager makeSetlistsScan]; //locallistItems;
	[self.tableView reloadData];
}


- (void) viewDidLoad
{
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here
	[super viewDidLoad];
    self.navigationItem.leftBarButtonItem =     [KORBarButtonItem  buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel                                                  completionBlock: ^(UIBarButtonItem *bbi){
		[KORDataManager allowOneTouchBehaviors];
                                                     [presenter dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];                                                 
                                                 }];
	[self makeSearchNavHeaders];
    [self repaintUI];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    // get overlays in case we need them    
    self.overlayXib = [[[NSBundle mainBundle] loadNibNamed:[KORDataManager lookupXib:@"SetList"]
                                                     owner:self options:NULL] lastObject];//0612
    
    NSArray *views = [self buildAdminUIViews:self 
                               leftTextLines:[NSArray arrayWithObjects:@"Tips On SetLists",nil]
                              rightTextLines:[NSArray arrayWithObjects:
                                              @"Use SetLists To Organize Performances",
                                              @"Add and Remove SetLists Here",
                                              @"Must linger for 20 seconds to Add to Recents",
                                              nil]
                                    leftfont:[UIFont boldSystemFontOfSize:18.f ]
                                   rightfont:[UIFont systemFontOfSize:14.f ]
                      ];
    
    
    self.tableView = [views objectAtIndex:1];
    self.view = [views objectAtIndex:0];
    
    self.listItems = [KORListsManager makeSetlistsScanNoRecentsOrFavorites] ; 
	[self setBarButtonItems];
	self.navigationItem.hidesBackButton = NO; 
	self.navigationItem.rightBarButtonItem = [KORBarButtonItem
                                              buttonWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                              completionBlock:^(UIBarButtonItem *bbi){
                                                  [self actionPressed];
                                              }];
	self.navigationItem.title = [KORDataManager makeUnadornedTitleView:@"Manage Lists"] ;		

	[KORDataManager disallowOneTouchBehaviors];
	
}



#pragma mark Overridden NSObject Methods

- (id) init 
{
    self = [super init];
    if (self)
    {
        
        listItems = [KORListsManager makeSetlistsScanNoRecentsOrFavorites]; //locallistItems;
        name = @"Manage Lists";
        canEdit = YES;
        canReorder = YES;
    }
	return self;
}
#pragma mark UITableViewDataSource Methods

-(void) tableView: (UITableView *)aTableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	NSString *listname = [self.listItems objectAtIndex:indexPath.row];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ((![listname isEqualToString: @"recents"])
            && (![listname isEqualToString: @"favorites"])
            )
        {
            // DELETE A SETLIST
            
            
            // actually delete this item from the listItems array
            [self.listItems removeObjectAtIndex:indexPath.row];
            // make this persistent by actually deleting the particular plist
            [KORListsManager deleteList:listname];		// repaint the UI
            [self.tableView reloadData];
            [self setBarButtonItems];
        }
		else
		{ 
            [KORAlertView alertWithTitle:@"You can't delete that list" message:@"It is built into GigStand"
                             cancelTitle:@"OK" 
                             cancelBlock:^(void) { 
                                 
                             }
                              otherTitle:nil
                              otherBlock:^(void) { 
                                  
                              }];
            
            
		}
	}
}



// override to present a different and simpler display for each
-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	//change the data as we move stuff around, -- thanks Erica Sadun
	
	NSString *path = [self.listItems objectAtIndex:oldPath.row];
	[self.listItems removeObjectAtIndex:oldPath.row];
	[self.listItems insertObject: path atIndex:newPath.row];
	[self setBarButtonItems];

}
- (UITableViewCell *) tableView: (UITableView *) tabView
		  cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
	NSUInteger row = idxPath.row;
    NSString *listName =  [ self.listItems objectAtIndex:row];
    
    return 
    [super 
     makeAdminTableCellView:(UITableView *)tabView cellForRowAtIndexPath:(NSIndexPath *)idxPath 
     text:listName
     detail:[NSString stringWithFormat:@"%d tunes", [KORListsManager itemCountForList:listName]] 
     image: (UIImage *) [KORDataManager makeThumbFromFullPathOrResource:[KORListsManager picSpecForList:listName] forMenu:@"MAINMENU"]
	 ];
    
    
}

- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
	
}


@end
