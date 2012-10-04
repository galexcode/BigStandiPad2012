	//
	//  KORStreamSelectorController.m
	//  MasterApp
	//
	//  Created by bill donner on 11/17/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "KORAudioStreamingController.h"
#import "KORBarButtonItem.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "KORRepositoryManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORHomeBaseProtocol.h"
#import "KORDataManager.h"
#import "KORMP3PlayerView.h"


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


@interface KORAudioStreamingController () < UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic,retain) NSArray *tuneblock;
@property (nonatomic,retain) NSArray *allminifests;

@property (nonatomic,retain) NSArray *allimages;

@property (nonatomic,retain) NSArray *allhighlightimages;

@property (nonatomic,retain) NSString *minifestpath;

@property (nonatomic,retain) NSString *remoteurl;

@property (nonatomic,retain) NSString *imageurl;
@property (nonatomic,retain)  NSDictionary *dict;

@property (nonatomic,retain) UILabel *tuneLabel,*albumLabel,*venueLabel,*dateLabel;
@property (nonatomic,retain) NSString *tunebundlename;
@property (nonatomic,retain) UIScrollView *sv;

@property (nonatomic,retain) UITableView *mv;

@property (nonatomic,retain) UIView *hv;


-(void) buttonpressed: (UIButton *) btn;

@end

@implementation KORAudioStreamingController

@synthesize hv,mv,sv,dict,allimages,allhighlightimages,tuneLabel,albumLabel,venueLabel,dateLabel,remoteurl,imageurl,tunebundlename,tuneblock,minifestpath,allminifests;



- (void)didReceiveMemoryWarning
{
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		// Return YES for supported orientations
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark Private Instance Methods

- (void) reloadUserInfo;
{
    UITableView    *tabView = (UITableView *) self.mv;
    [tabView reloadData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
		//NSLog (@"scrollViewDidScroll %f",scrollView.contentOffset.x);
	
	
	
		//sv.contentOffset = CGPointMake([self.allimages count]*107/2,0);
}

- (UIView *) buildHeaderView
{
	NSUInteger lpos = 10;
	
	
		// the top 100px of header has objects in fixed places
	UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.presentingViewController.view.bounds.size.width,240)];
		//	UIImageView *iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dict objectForKey:@"ImageURL"]]];
		//	iview.frame = CGRectMake(0,0,100,100);
    albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(lpos,20,270,20)];
	albumLabel.text = [self.dict objectForKey:@"TuneBundleName"];
	albumLabel.font = [UIFont systemFontOfSize:18];
	albumLabel.textColor = [UIColor whiteColor];
	albumLabel.backgroundColor = [UIColor blackColor];
	[hview addSubview:albumLabel];
		//	tuneLabel = [[UILabel alloc] initWithFrame:CGRectMake(110,40,200,20)];
		//	tuneLabel.text = @"<please select tune>";
		//	tuneLabel.font = [UIFont systemFontOfSize:18];
		//	tuneLabel.textColor = [UIColor whiteColor];
		//	tuneLabel.backgroundColor = [UIColor blackColor];
		//	[hview addSubview:tuneLabel];
	venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(lpos,40,270,20)];
	venueLabel.text = [self.dict objectForKey:@"Notes"];
	venueLabel.font = [UIFont systemFontOfSize:18];
	venueLabel.textColor = [UIColor whiteColor];
	venueLabel.backgroundColor = [UIColor blackColor];
	[hview addSubview:venueLabel];
	dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(lpos,60,270,20)];
	dateLabel.text = [self.dict objectForKey:@"PerformanceDate"];
	dateLabel.font = [UIFont systemFontOfSize:18];
	dateLabel.textColor = [UIColor whiteColor];
	dateLabel.backgroundColor = [UIColor blackColor];
	[hview addSubview:dateLabel];
		//[hview addSubview:iview];
	[KORDataManager globalData].mp3PlayerView.center = CGPointMake(400,55);
	[hview addSubview:(UIView *)[KORDataManager globalData].mp3PlayerView];
	
	
		// now build a scrollview
	float width = self.view.frame.size.width;
	sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100,width, 100)]; //
	sv.contentSize = CGSizeMake([self.allimages count]*107, 100);
	sv.pagingEnabled = NO;
	sv.delegate = self;
	
		// the next 100px is a scrolling filmstrip of choices - tapping any replaces everthing on the page 
	NSUInteger pos = 0;
	NSUInteger tag = 1;
	NSUInteger idx = 0;
	for (NSString *name in self.allimages)
	{
		NSString *hightlightedname = [self.allhighlightimages objectAtIndex:idx];
		UIButton *iv =[UIButton buttonWithType:UIButtonTypeRoundedRect];// ;  [[UIButton alloc] initWithImage:[UIImage imageNamed:name]];
																		//UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
		iv.frame = CGRectMake(pos,0,100,100);//
		[iv setImage: [UIImage imageNamed:name] forState: UIControlStateNormal];
		
		[iv setImage: [UIImage imageNamed:hightlightedname] forState: UIControlStateSelected];
		
		[iv addTarget:self action:@selector(buttonpressed:) forControlEvents:UIControlEventAllTouchEvents];
		iv.tag = tag;
		
		if (idx == 0) {
			
			iv.selected = YES;
			iv.highlighted = YES;
		} 
		else
		{
			iv.selected = NO;
			iv.highlighted = NO;
		}
		pos +=107;
		tag +=1;
		idx +=1;
		
		[sv addSubview:iv];
	}
	
	[hview addSubview:sv];
	return hview;
}
-(UITableView *) buildMainView
{
	
	
	
		// finally, the actual tunes
	CGRect f =  [self.view bounds];
	f.origin.y = 240;
	CGFloat h = f.size.height -240;
	f.size.height =h;
    UITableView *tmpView = 
    [[UITableView alloc] initWithFrame: f style: UITableViewStyleGrouped];
    
	
	tmpView.backgroundColor =[UIColor blackColor]; 
    tmpView.opaque = YES;
    tmpView.backgroundView = nil;
    tmpView.dataSource = self;
    tmpView.delegate = self;
    tmpView.separatorColor = [UIColor grayColor];
    tmpView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	
		//tmpView.tableHeaderView = hview;
	
	self.navigationItem.title = @"Please Choose A Tune";	
	
	self.navigationItem.leftBarButtonItem =
	
	[KORBarButtonItem buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
									completionBlock: ^(UIBarButtonItem *bbi){
										[self.presentingViewController dismissViewControllerAnimated:YES  
																						  completion: ^(void) { //NSLog (@"KORStreamSelector done button hit"); 
																						  }];
									}];
	
	return tmpView;
}


-(void) refreshMainView
{
	albumLabel.text = [self.dict objectForKey:@"TuneBundleName"];
	
	venueLabel.text = [self.dict objectForKey:@"Notes"];
	
	dateLabel.text = [self.dict objectForKey:@"PerformanceDate"];
	[self reloadUserInfo];
}
#pragma mark Overridden UIViewController Methods


- (void) loadView
{
	
    self.view = [[UIView alloc] initWithFrame:self.parentViewController.view.bounds];
	self.view.backgroundColor = [UIColor blackColor];
	self.mv =  [self buildMainView];
	self.hv = [self buildHeaderView];
	[self.view addSubview:self.mv];
	[self.view addSubview:self.hv];
    
}
-(void) loadfromMinifest
{
	NSString     *cvcPath = [[NSBundle mainBundle] pathForResource:self.minifestpath ofType: @"plist" ];	
	
		//	NSLog (@"loading from minifest %@",cvcPath);
	self.dict  = [NSDictionary dictionaryWithContentsOfFile:cvcPath];
	if (self.dict)
	{
		self.tuneblock = [dict objectForKey:@"Tunes"];
		self.remoteurl = [dict objectForKey:@"RemoteURL"];
			// make an array of all the images from each minfest
		NSMutableArray *imgs = [NSMutableArray array];
		NSMutableArray *himgs = [NSMutableArray array];
		for (NSString *mfpath in self.allminifests)
		{
			NSString     *path = [[NSBundle mainBundle] pathForResource:mfpath ofType: @"plist" ];	
			NSDictionary *dictx = [NSDictionary dictionaryWithContentsOfFile:path];
			if (dictx) {
				[imgs addObject:  [dictx objectForKey:@"ImageURL"]];
				
				[himgs addObject:  [dictx objectForKey:@"HighlightedImageURL"]];
			}
		}
		self.allimages = [NSArray arrayWithArray:imgs];
		self.allhighlightimages = [NSArray arrayWithArray: himgs];
	}
	else 
		NSLog (@"dictionary not found");
		//NSLog (@"done loading from minifest %@",cvcPath);
}

-(void) buttonpressed: (UIButton *) btn
{
	NSUInteger idx  = btn.tag-1;
	if (idx < [self.allminifests count])
	{
			// re run a mini reload
		self .minifestpath = [self.allminifests objectAtIndex:idx];
		[self loadfromMinifest];
		[self refreshMainView];
		
		for (NSUInteger i = 0; i<[self.allminifests count]; i++)
		{
			UIButton *b = (UIButton *)[ self.view viewWithTag:i+1 ];
			b.selected = NO;
			b.highlighted = NO;
		}
		btn.selected = YES;
		btn.highlighted = YES;
	}
	
	
	
	sv.contentOffset = CGPointMake(idx*107,0);
}


#pragma mark Overridden NSObject Methods

-(KORAudioStreamingController *) initWithMiniFests:(NSArray *)minifests
{
    
		//	NSLog (@"initWithMiniFest %@", minifests);
	self =[super init];
	if (self) 
    {
		
		self.allminifests = [minifests copy];
		self.minifestpath = [minifests objectAtIndex:0];
		[self loadfromMinifest]; // load first
		
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
    static NSString *CellIdentifier0 = @"ZVInfoCell0";
	
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier: CellIdentifier0];
    
    if (!cell)
    {
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: CellIdentifier0];
		
    }
    
		//
		// Reset cell properties to default:
		//
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = nil;    
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.backgroundColor = [UIColor blackColor];
	
	if (idxPath.row < [self.tuneblock count]) 
	{   
		NSDictionary *entry = [ self.tuneblock objectAtIndex:idxPath.row];  
		NSString *name = [entry objectForKey:@"Name"];
		cell.textLabel.text = name;	
	}
	
	
    return cell;
}

- (NSInteger) tableView: (UITableView *) tabView numberOfRowsInSection: (NSInteger) sect
{
	NSUInteger count = [self.tuneblock count];
	return count;
	
}

#pragma mark footer stuff

#pragma mark UITableViewDelegate Methods

- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath: (NSIndexPath *) idxPath
{
	return ( 44 );
}

- (void) tableView: (UITableView *) tabView didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    
	NSUInteger count = [self.tuneblock  count];
	
	if (idxPath.row < count)
	{
		NSDictionary *entry = [ self.tuneblock objectAtIndex:idxPath.row];  
		NSString *name = [entry objectForKey:@"Name"];
		NSString *url = [remoteurl stringByAppendingString: [entry objectForKey:@"URL"]];
		[[KORDataManager globalData].mp3PlayerView 
		 loadMP3Tune:[NSDictionary dictionaryWithObject:name  forKey:@"TuneLabel"] 
		 atURL:url ];
		self.tuneLabel.text = name;
		self.navigationItem.title = [NSString stringWithFormat:@"streaming planB: %@ - %@",   name,albumLabel.text];	
	}
    
}
@end
