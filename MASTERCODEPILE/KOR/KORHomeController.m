	//
	//  KioskHomeController.m
	//  // BigStand
	//
	//  Created by bill donner on 9/6/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "KORHomeController.h"
#import "KORBarButtonItem.h"
#import "KORDataManager.h"
#import "KORHomeBaseProtocol.h"
#import "KORRepositoryManager.h"
#import "KORListsManager.h"
#import "KORPathMappings.h"
#import "KORZipArchive.h"
#import "KORAlertView.h"
#import "KORViewerController.h"
#import "KORAppDelegate.h"

@interface KORHomeController()<UIPopoverControllerDelegate,KORHomeBaseDelegate>
@property (nonatomic,retain) NSArray *items;


@property (nonatomic,retain) UIView *activityIndicator;
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) UILabel *activityLabel ;
@property (nonatomic,retain) UIImageView *activityImageView ;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;



@property (nonatomic)   BOOL presentedAss;
@end

@implementation KORHomeController
@synthesize items,activityLabel,activityImageView,activityIndicator,label,indicator;
@synthesize presentedAss;


-(void) addActivityIndiator

{
		//
		// Add Activity indicator view:
		//
	
	
	
	self.activityIndicator= [[UIView alloc] init]; 
	CGRect frame =  self.view.bounds;
	
	
	self.activityIndicator.frame  =frame;
	self.activityIndicator.backgroundColor  = [UIColor clearColor] ;
	
	self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
		// Adjust the indicator so it is up a few pixels from the bottom of the alert
	self.indicator.center = CGPointMake(frame.size.width / 2.f, frame.size.height /2.f - 60.f);
	[self.indicator startAnimating];
	[self.activityIndicator addSubview:self.indicator];
	
		// display in non-offensive
		// manner
	
	[self.view addSubview:self.activityIndicator];
	
	
	self.activityImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
	self.activityImageView.center = CGPointMake(frame.size.width / 2.f, 90.f);
		//
		// Add Label just below indicator view:
		//
	
	self.activityLabel =  [[UILabel alloc] init];
	self.activityLabel.frame = CGRectMake (250.f,//frame.size.width/2.f - 150.f,
										   10.f,//frame.size.height /2.f + 130.f,
										   300.f, 30.f); // make some more space
	self.activityLabel.text = [NSString stringWithFormat:@"Loading media for %@...",[KORDataManager globalData].applicationName];
	self.activityLabel.textAlignment = UITextAlignmentLeft;
	self.activityLabel.textColor = [UIColor blueColor];
	self.activityLabel.backgroundColor = [UIColor clearColor];
	
	
		// add a static label up above
	label =  [[UILabel alloc] init];
	self.label.frame = CGRectMake (10.f,//frame.size.width/2.f - 150.f,
								   10.f//frame.size.height /2.f +80.f
								   
								   , 300.f, 30.f); // make some more space
	self.label.text = @"Once only, please wait...";
	self.label.textAlignment = UITextAlignmentLeft;
	self.label.font = [UIFont systemFontOfSize:12.f];
	self.label.textColor = [UIColor blueColor];
	self.label.backgroundColor = [UIColor clearColor];
	
		// display in non-offensive
		// manner
	
	[self.view addSubview: self.activityIndicator];
	[self.view addSubview: self.activityLabel];
	[self.view addSubview: self.activityImageView];
	[self.view addSubview: self.label];
	
}

-(BOOL) loadStartupDataPiles
{
	
	for ( NSString *archiveAsKiosk in  [KORDataManager globalData]. activeArchives)		
	{
		if ([archiveAsKiosk length] == 0)
		{
			NSLog (@"Archive list required for Kiosk apps");
			return NO;
		}
		
		NSLog (@"****KIOSK  archive -- %@ -- start ",archiveAsKiosk);
		
			// okay get the items if need be
		
		NSString *topath = [[KORPathMappings pathForTemporaryDocuments] stringByAppendingPathComponent:archiveAsKiosk];
		NSString *frompath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:archiveAsKiosk];
			//	ArchiveInfo *ai = [KORRepositoryManager findArchive:archiveAsKiosk];
			//if (!ai)
		{  
				// if we have a good archive name, copy in the corresponding resource and expand it
			NSLog (@"****KIOSK  archive --  copying resource  %@, from %@ to %@ ",archiveAsKiosk,frompath, topath);
            NSError *error = nil;
            [[NSFileManager defaultManager] 
             copyItemAtPath:frompath 
             toPath:topath
             error:&error];
            
            if (error)
			{ 
				NSLog (@"error copying resource %@ to %@ error %@",archiveAsKiosk,topath, [error description]); 
				return NO;
			}
			
            KORZipArchive *za = [[KORZipArchive alloc] init];
            
            NSString *archivePath =[NSString stringWithFormat:@"%@/%@", [KORPathMappings pathForSharedDocuments],archiveAsKiosk];
			if ([[NSFileManager defaultManager] fileExistsAtPath:topath] == NO)  
                
			{ 
				NSLog (@"****KIOSK Can't read file at %@", topath); 
				return NO;
			}
            
            
            NSLog (@"****KIOSK  archive -- %@ -- loading from file %@",archiveAsKiosk,topath);
            
            if ([za UnzipOpenFile: topath]) {
                BOOL ret = [za UnzipFileTo: archivePath overWrite: YES];
                if (ret)
                    [za UnzipCloseFile];
                
                [KORDataManager  removeItemAtPath:topath  error:NULL];
                
                NSUInteger count = [KORRepositoryManager convertDirectoryToArchive:archiveAsKiosk ] ;// hope this works in the asynch oart
                NSLog (@"****KIOSK  archive -- Assimilated %d entries into %@",count,archiveAsKiosk);
				if (count==0) return NO;
            }     		
		}		
	}	
	return YES;
}

-(KORHomeController *) init; //initWithItems:(NSArray *)itemsss title:(NSString *)title
{
    self = [super init ];
    if (self)
    {
        self.view = nil;        // decide which archive, or if none is found then just die
        self.items = nil;		
    }
    return self;
}

- (void) finishViewDidLoad:(id)arg
{
	BOOL
	retval = [self loadStartupDataPiles];
	if (retval) 
		self.items = [KORRepositoryManager allTitles ];//OrderedByFileSpec];
	else {
		
		NSLog (@"dataPile did not load");
		
        [[KORAppDelegate sharedInstance] 
		                 dieFromMisconfiguration:@"dataPile loading did not work"];
		
	}
	
	NSString *s = [KORListsManager lastTuneOn:@"recents" ascending:YES];
	
	
	
	if ([s length]==0) // if no page set
		s=[self.items objectAtIndex:0];
	
	[self.activityIndicator removeFromSuperview];
	[self.activityLabel removeFromSuperview];
	[self.activityImageView removeFromSuperview];
	[self.label removeFromSuperview];
	

	
	KORViewerController *korViewerController = [[KORViewerController alloc] 
												initWithURL:[NSURL URLWithString:s] 
												andWithTitle:s 
												andWithItems:self.items];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:korViewerController];
	
	[self presentViewController:nav animated:YES completion:NULL ];
}

-(void) loadView
{
		// see if we already are loaded or if we have to do a full file scan
	
	self.items = [KORRepositoryManager allTitles ];//]OrderedByFileSpec];
	
	if ([self.items count]>0)
	{
		NSString *s = [KORDataManager globalData].startPageTitle;
		if ([s length]==0) // if no page set
			s=[self.items objectAtIndex:0];
		
		self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		self.view.backgroundColor = [UIColor clearColor];
		
		KORViewerController *korViewerController = [[KORViewerController alloc] 
													initWithURL:[NSURL URLWithString:s] 
													andWithTitle:s 
													andWithItems:self.items];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:korViewerController];
		
		[self presentViewController:nav animated:YES completion:NULL ];
		
		
	}
	
	else
	{
			// ok load files, it will be slow so tell the user and schedule it
		
		
		if ([KORDataManager globalData].startupWaitingImage )
		{
			UIImage *p = [UIImage imageNamed:[KORDataManager globalData].startupWaitingImage];
			if (p)
			self.view = [[UIImageView alloc] initWithImage:p];
			else
				
				self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
			self.view.backgroundColor = [UIColor clearColor];
		}
		else
		{
			self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
			self.view.backgroundColor = [UIColor clearColor];
		}
		
		
		self.navigationController.navigationBarHidden = YES;
			//self.view.backgroundColor = [UIColor blueColor];
		
		[self addActivityIndiator]; // get this going and force to screen
		
		[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector (finishViewDidLoad:) userInfo:nil repeats:NO];
		
	}
	
}
- (void)viewDidLoad
{
	
    [super viewDidLoad]; 
	
	
}

- (void)didReceiveMemoryWarning
{
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc that aren't in use.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{	
//	if ([KORDataManager globalData].allowRotations)
//	return YES;
//	
//else
	
	return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
}


#pragma mark HomeBase Protocol - believe unusewd

	//-(void) presentNavController:(UINavigationController *)navv;
	//{
	//    [self presentViewController:nav animated:YES completion: ^(void){
	//        
	//        NSLog (@"presentNavController completed"); }];
	//}

-(void) dismissController;
{
    NSLog (@"%@ calling dismissViewControllerAnimated",[super class]);
    [self dismissViewControllerAnimated:YES  completion: ^(void) { 
        NSLog (@"%@ finished dismissViewControllerAnimated",[super class]); 
    }]; 
    
}





@end