	//
	//  ContentMenuViewController.m
	// BigStand
	//
	//  Created by bill donner on 4/1/11.
	//  Copyright 2011 ShovelReadyApps. All rights reserved.
	//


#import "ClumpInfo.h"
#import "InstanceInfo.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "KORRepositoryManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORTableMenuController.h"
#import "KORHomeBaseProtocol.h"
#import "KORDataManager.h"


#pragma mark -
#pragma mark Public Class ContentMenuViewController
#pragma mark -

#pragma mark Internal Constants

	//
	// Table sections:
	//
enum
{
    LISTS_SECTION ,     // Will Have All the Lists including Favorites and Recents  
    SECTION_COUNT
};


@interface KORTableMenuController () < UITableViewDataSource, UITableViewDelegate>

@end

@implementation KORTableMenuController

@synthesize rowSize,menuName,tuneselectordelegate,backgroundColor;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(CGSize) computeMenuSize
{
    NSUInteger rowsize = self.rowSize;
    float twidth =320;
    float theight = rowsize *[self.itemDetail count]+20;
		// trim this down
	if (theight>900) theight = 900;
    return CGSizeMake(twidth,theight); 
}

#pragma mark Private Instance Methods

- (void) reloadUserInfo;
{
    UITableView    *tabView = (UITableView *) self.view;
    [tabView reloadData];
}

#pragma mark Overridden UIViewController Methods

- (void) didReceiveMemoryWarning
{
    NSLog (@"KORTableMenuController didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

- (void) loadView
{
    [super loadView];
	
    self.menuSize = [self computeMenuSize];
    UITableView *tmpView = 
    [[UITableView alloc] initWithFrame: CGRectMake(0,0,self.menuSize.width,self.menuSize.height) style: UITableViewStyleGrouped];
    
	
	tmpView.backgroundColor = self.backgroundColor; 
    tmpView.opaque = YES;
    tmpView.backgroundView = nil;
    tmpView.dataSource = self;
    tmpView.delegate = self;
    tmpView.separatorColor = [UIColor blackColor];
    tmpView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	if (self.menuTitle !=nil)
	{
		
		if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))   {
			//  if title was specified make it a label and assign as header view
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,24)];
		label.text = self.menuTitle;
		label.textColor = self.titleColor;
		label.backgroundColor = self.titleBackgroundColor;
		tmpView.tableHeaderView = label;
	} else
	{
			// on the iphone poke the top title
			// already done
	}
	}
	
    self.view = tmpView	;
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}


#pragma mark Overridden NSObject Methods

-(KORTableMenuController *) initWithItems:(NSArray *)items 
							   filteredBy:(NSString *) pileFilter 
									style:(NSUInteger) mode 
						  backgroundColor:(UIColor *) bgColor
							  titleColor :(UIColor *) tcColor
							  titleBackgroundColor :(UIColor *) tcbColor
							   textColor :(UIColor *) textColor
					 textBackgroundColor :(UIColor *) textBackgroundColor
							thumbnailSize:(NSUInteger) thumbsize 
						  imageBorderSize:(NSUInteger) imageborderSize 
							  columnCount:(NSUInteger) columnCount
								  tagBase:(NSUInteger) base 	
								 menuName:(NSString *) name
								menuTitle:(NSString *) title;
{
    
    self = [super initWithItems:(NSArray *)items filteredBy: (NSString *) pileFilter 
						  style:(NSUInteger) mode 
				backgroundColor:(UIColor *) bgColor 
					titleColor :(UIColor *) tcColor	
		  titleBackgroundColor :(UIColor *) tcbColor	
					 textColor :(UIColor *) textColor
		   textBackgroundColor :(UIColor *) textBackgroundColor
				  thumbnailSize:(NSUInteger) thumbsize 
				imageBorderSize:(NSUInteger) imageborderSize 
					columnCount:(NSUInteger) columnCount
						tagBase:(NSUInteger) base 	 
					   menuName:(NSString *) name 
					  menuTitle:(NSString *) title];
    if (self) 
    {
		
		
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
    NSUInteger secount = SECTION_COUNT;
    
    return secount;
}

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
    static NSString *CellIdentifier0 = @"AAInfoCell0";
  
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: CellIdentifier0];
    
    if (!cell)
    {
        switch (idxPath.section)
        {
			case LISTS_SECTION:
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle 
											reuseIdentifier: CellIdentifier0];
                break;          
            default :
                break;
        }
    }
    
		//
		// Reset cell properties to default:
		//
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    
    switch (idxPath.section)
    {    
        case LISTS_SECTION:
        {  
            if (idxPath.row < [self.itemDetail count]) 
            {   
                NSString *clumpTitle = [ self.itemDetail objectAtIndex:idxPath.row];   
                
                ClumpInfo  *tn = [KORRepositoryManager findClump:clumpTitle];
                if (tn) // item might have disappeared
                {
                    
                    for (InstanceInfo *ii in [KORRepositoryManager allVariantsFromTitle:tn.title]) // only executed for the first variant	
                    { 
                        cell.textLabel.text = clumpTitle;	
						cell.textLabel.textColor = self.textColor;
						cell.backgroundColor = self.textBackgroundColor;
						
                        
							// get path 
                        
							//  NSString *path = [NSString stringWithFormat:@"%@/%@",ii.archive,ii.filePath];//must change
                        cell.imageView.image = [KORDataManager makeThumbnailImage:ii.filePath] ; //111111
                        break;
                    }
                }
            }
            
        }
    }
    return cell;
}

- (NSInteger) tableView: (UITableView *) tabView numberOfRowsInSection: (NSInteger) sect
{
		//   SettingsManager *settings = self.appDelegate.settingsManager;
    
    switch (sect)
    {
            
			
        case LISTS_SECTION:
        {
            NSUInteger count = [self.itemDetail count];
            return count;
        }
			
        default :
            return 0;
    }
}

#pragma mark footer stuff

#pragma mark UITableViewDelegate Methods


- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	return ( self.rowSize );
}

- (void) tableView: (UITableView *) tabView didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    switch (idxPath.section)
    {	
            
        case LISTS_SECTION:
        {
            NSUInteger count = [self.itemDetail  count];
            
            if (idxPath.row < count)
            {
                NSString *name = [ self.itemDetail  objectAtIndex:idxPath.row];
                if (!name)
                {
                    NSLog(@"no name found for item at row %d", idxPath.row);
                    return;
                }
				
                if (self.tuneselectordelegate)
					[self.tuneselectordelegate actionItemChosen: idxPath.row label:name newItems:nil listKind:@"" listName:@""];
                
            }
            break;
        }
            
    }
}
@end
