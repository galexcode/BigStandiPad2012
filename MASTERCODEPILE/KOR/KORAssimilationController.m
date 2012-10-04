	//
	//  AssimilationController.m
	//  MCProvider
	//
	//  Created by Bill Donner on 1/22/11.
	//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
	//

#import <MobileCoreServices/MobileCoreServices.h>
#import "KORAssimilationController.h"
#import "KORListsManager.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORZipArchive.h"
#import "KORRepositoryManager.h"
#import "KORAppDelegate.h"
#import "KORAlertView.h"
#import "KORBarButtonItem.h"
#import "ArchiveInfo.h"
#pragma mark -
#pragma mark Public Class AssimilationController
#pragma mark -
@interface KORAssimilationController ()
@property (nonatomic,retain) NSString *archiveName;
@property (nonatomic) NSUInteger errorCount;

-(void) processDirect:(UIColor *)backgroundColor textColor:(UIColor *)textColor label:(NSString *) static_label;
@end  
@implementation KORAssimilationController
@synthesize archiveName,errorCount;
@synthesize delegate, activityLabel,activityIndicator,activityImageView;
@synthesize dbrebuildFileCount,dbrebuildStartTime,countdown_group,background_queue;

- (id) initWithArchive:(NSString *)archiveNamex ; // not the short name
{
	self = [super init];
	
    if (self)
    {
		if ([archiveNamex length]==0) 
			archiveName = [KORRepositoryManager nameForOnTheFlyArchive];
		else
			archiveName = [archiveNamex copy];	
		
		   errorCount = 0;
		NSLog (@"KORAssimilationController initWithArchive:%@",archiveName);
    }
    return self;
}

	///////////////////////////////////////////////////



#pragma mark Public Instance Methods


-(void) doOneZip:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        
        KORZipArchive *za = [[KORZipArchive alloc] init];
        
        NSString *archive = [KORPathMappings pathForArchive:iname];
        
        if ([za UnzipOpenFile: incoming]) {
            BOOL ret = [za UnzipFileTo: archive overWrite: YES];
            if (ret)
                [za UnzipCloseFile];
            
            [KORDataManager  removeItemAtPath:incoming  error:NULL];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                NSUInteger count = [KORRepositoryManager convertDirectoryToArchive:iname ] ;// hope this works in the asynch oart
                NSLog (@"Assimilated %d entries into %@",count,iname);//NSLog (@" processed zip file fullpath %@", fname);
                ArchiveInfo *ai = [KORRepositoryManager findArchive:iname];
                if (ai) {
					if ([ai.logo length]>0)
                    self.activityImageView.image  = [UIImage imageWithContentsOfFile:[NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,ai.logo]  ];
				else
					self.activityImageView.image  = [UIImage imageNamed:@"gigstandxl72x72@2x.png"];
                self.activityLabel.text = [NSString stringWithFormat:@"%@ %d entries",iname,count];
                self.dbrebuildFileCount+=count;
				}
            });
            
        }
    });
	
}

-(void) doOneStl:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{	
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        NSArray *theseitems = [KORListsManager listOfTunesFromFile: incoming];
        
        [KORListsManager makeSetList:iname items:theseitems];
        [KORRepositoryManager copyFromInboxToOnTheFlyArchive:incoming ofType:type withName:iname];
        
        [KORDataManager removeItemAtPath:incoming  error:NULL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.activityLabel setText:[NSString stringWithFormat:@"added setlist %@",iname]];
            NSLog (@"added setlist %@ from %@ count %d",iname,incoming, [theseitems count]);  
            self.dbrebuildFileCount++;
        });
    });
    
}

-(void) doOneImage:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        UIImage *shot = [[UIImage alloc] initWithContentsOfFile:incoming];
        NSString *most = [[incoming lastPathComponent] stringByDeletingPathExtension];
        NSString *ext = [incoming  pathExtension];
        
        NSString *name = [KORDataManager generateUniqueTitle:[NSString stringWithFormat:@"%@-w%1.f-h%1.f.%@",most,shot.size.width,shot.size.height,ext]];
        
        [KORRepositoryManager copyFromInboxToOnTheFlyArchive:incoming ofType:type withName:name];
        
        [KORDataManager removeItemAtPath:incoming  error:NULL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog (@" processed doOneImage file %@", name);
            [self.activityLabel setText:[NSString stringWithFormat:@"added image %@",name]];
            self.dbrebuildFileCount++;
        });
    });
    
}
-(void) doOneOpaqueWebView:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname; 
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        
        [KORRepositoryManager copyFromInboxToOnTheFlyArchive:incoming ofType:type withName:iname];
        
        [KORDataManager removeItemAtPath:incoming  error:NULL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog (@" processed doOneOpaqueWebView file incoming %@", incoming);
            [self.activityLabel setText:[NSString stringWithFormat:@"added document %@",iname]];  
            self.dbrebuildFileCount++;
        });
    });
    
}

- (void) doOneAssembledWebView:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        
        [KORRepositoryManager copyFromInboxToOnTheFlyArchive:incoming ofType:type withName:iname];
        [KORDataManager removeItemAtPath:incoming  error:NULL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog (@" processed doOneAssembledWebView file incoming %@", incoming);		
            [self.activityLabel setText:[NSString stringWithFormat:@"added document %@",iname]];   
            self.dbrebuildFileCount++;
        });
    });
}

- (void) doUnknownFile:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{  
        
        [KORDataManager removeItemAtPath:incoming  error:NULL];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog (@" processed doUnknownFile incoming %@", incoming);		
            [self.activityLabel setText:[NSString stringWithFormat:@"unknown file %@ type %@",iname,type]];   
            self.dbrebuildFileCount++;
        });
    });
}

-(void) processIncomingFromInbox;
{
		// determine which files to process
    NSMutableArray *toProcess = [NSMutableArray array];
    NSError *error;
	NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[KORPathMappings pathForItunesInbox]  error: NULL];
	if (paths)
	{	
		for (NSString *path in paths)
			if (![path isEqualToString:@".DS_Store"])
			{
				NSString *fullpath = [[KORPathMappings pathForItunesInbox] stringByAppendingPathComponent: path];			
				NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: fullpath error:&error];
				if (attrs && [[attrs fileType] isEqualToString: NSFileTypeRegular])
				{  
					[toProcess addObject:fullpath];
                    
                }
            }
    }
    
		// now enumerate, allowing gcd to parallelize
    
    [toProcess enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
     {
         
         NSString *fullpath = (NSString *)obj;
         NSString *filetype = [[fullpath pathExtension] lowercaseString];  // returns @"zip"
         NSString *filename = [fullpath lastPathComponent]; 
         
         if ([@"zip" isEqualToString:filetype])
         {
             [self doOneZip: filetype  incoming:fullpath iname:filename];
         }
         
         else 
             if ([@"stl" isEqualToString:filetype])
                 
					 //case @"stl":
             {
                 [self doOneStl:filetype   incoming:fullpath iname:filename];
                 
             }
             else 
                 if ([@"jpg" isEqualToString:filetype] 
                     || [@"jpeg" isEqualToString:filetype]
                     || [@"png" isEqualToString:filetype]
                     || [@"gif" isEqualToString:filetype]								
                     || [@"mp3" isEqualToString:filetype]
                     || [@"m4v" isEqualToString:filetype]
                     )
                     
                 {
                     [self doOneImage:filetype   incoming:fullpath iname:filename];
                 }
                 else 
                     if ([@"pdf" isEqualToString:filetype] 
                         || [@"html" isEqualToString:filetype]
                         || [@"doc" isEqualToString:filetype]
                         || [@"docx" isEqualToString:filetype]
                         || [@"rtf" isEqualToString:filetype]
                         )
                         
                     {
                         [self doOneOpaqueWebView:filetype   incoming:fullpath iname:filename];
                         
                     }
                     else 
                         if ([@"txt" isEqualToString:filetype] 
                             || [@"htm" isEqualToString:filetype]
                             )
                         {
                             [self doOneAssembledWebView:filetype  incoming:fullpath iname:filename];
                             
                         }
                         else [self doUnknownFile:filetype incoming:fullpath iname:filename];
         
     } ]; // per item enumeration block ends here
}



-(void) startPhases:(NSTimer *)timer;
{
    
    NSLog (@"PHASE_I assimilation processing and unzipping commencing...");
    [self processIncomingFromInbox]; // puts up alert while working 
	
	
		// wait for that group of tasks to finish
    dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
		
		NSLog (@"PHASE_II assimilation core data setup commencing...");
		
		[KORRepositoryManager setupDB];
		
		
		dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
            
				// wait for PHASE_II
            
            NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
            
				// Get the elapsed time in milliseconds
            NSTimeInterval elapsedTime = (endTime - self.dbrebuildStartTime) * 1000;
            
            float perdoc = elapsedTime/self.dbrebuildFileCount;
            if (self.dbrebuildFileCount>0){
                
				NSLog (@"PHASE_II assimilation finished...,%@",[NSString stringWithFormat:@" %d docs at %3.2f ms/doc",self.dbrebuildFileCount,  perdoc]);
				
				
				[self.activityLabel setText:[NSString stringWithFormat:@"processed %d files %d errors",self.dbrebuildFileCount,self.errorCount]];  
				
				
				
            }
            else
			{
				NSLog (@"PHASE_II NO FILES PROCESSED");
				[self.activityLabel setText:[NSString stringWithFormat:@"No files were processed"]];
			}
			
			[KORAlertView alertWithTitle: [NSString stringWithFormat:@"processed %d files %d errors",self.dbrebuildFileCount,self.errorCount]
								 message:@"Assimilation Complete"  
							 buttonTitle:@"OK"];
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"Assimilation complete"]];
			
            self.navigationController.navigationBarHidden = NO;
            if (self.activityIndicator) 
            {
                [self.activityIndicator removeFromSuperview];
                self.activityIndicator = nil;
            }
			if (self.delegate) 
            {
                NSLog (@"PHASE_III complete calling assimilationComplete delegate");
                [self.delegate assimilationComplete:YES];
            }
			
            
		});
        
	});
}

-(void) processDirect:(UIColor *)backgroundColor textColor:(UIColor *)textColor label:(NSString *) static_label;
{	
	
	self.view.backgroundColor =  backgroundColor;//[UIColor clearColor]; 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
		//
		// Add Activity indicator view:
		//
    self.activityIndicator= [[UIImageView alloc] init]; 
    CGRect frame = self.view.bounds; // inset this a little bit
	
	frame = [KORDataManager busyOverlayFrame:frame];
    
	
	self.activityIndicator.frame  =frame;
	self.activityIndicator.backgroundColor  = backgroundColor ;
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
		// Adjust the indicator so it is up a few pixels from the bottom of the alert
	indicator.center = CGPointMake(frame.size.width / 2.f, frame.size.height /2.f - 60.f);
	[indicator startAnimating];
	[self.activityIndicator addSubview:indicator];
	
		// display in non-offensive
		// manner
	
    [self.view addSubview: self.activityIndicator];
    self.activityImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
    self.activityImageView.center = CGPointMake(frame.size.width / 2.f, 90.f);
		//
		// Add Label just below indicator view:
		//
    self.activityLabel =  [[UILabel alloc] init];
    self.activityLabel.frame = CGRectMake (frame.size.width/2.f - 150.f, 
                                           frame.size.height /2.f + 130.f,
                                           300.f, 30.f); // make some more space
    self.activityLabel.text = @"Import Starting";
    
    self.activityLabel.textAlignment = UITextAlignmentCenter;
    self.activityLabel.textColor = textColor;
    self.activityLabel.backgroundColor = [UIColor clearColor];
    
    
		// add a static label up above
    UILabel *label =  [[UILabel alloc] init];
	label.frame = CGRectMake (frame.size.width/2.f - 150.f, frame.size.height /2.f +80.f, 300.f, 20.f); // make some more space
    label.text = static_label;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.f];
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    
		// display in non-offensive
		// manner
	
    [self.view addSubview: self.activityIndicator];
    [self.view addSubview: self.activityLabel];
    [self.view addSubview:self.activityImageView];
    [self.view addSubview: label];
    
		// at this point the titleDictionary and variant structure has been rebuilt either thru expandFiles or by the reload of the TitlesSection
	
    
	self.background_queue = dispatch_queue_create("com.gigstand.background", 0);
	self.countdown_group = dispatch_group_create();
    self.dbrebuildStartTime = [NSDate timeIntervalSinceReferenceDate];
    self.dbrebuildFileCount = 0;
    
    [self startPhases:nil];
	
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidLoad

{
	self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem
     buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     completionBlock: ^(UIBarButtonItem *bbi){
         
         [self.presentingViewController dismissViewControllerAnimated:YES  
														   completion: ^(void) {
															   NSLog (@"KORAssimilationController cancel button hit"); }];
     }];
    [self processDirect:[UIColor blackColor] textColor:[UIColor whiteColor] label:@"Processing Incoming Content, Please Be Patient."];
}
- (void) loadView
{
	NSLog (@"KORAssimilationController loadView");
    CGRect theframe = 
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 
	CGRectMake(0,0,540,576+44):
	[[UIScreen mainScreen] bounds];
    UIView *tmpView = [[UIView alloc] initWithFrame: theframe ] ;
	tmpView.opaque = YES;
		//turn off the nav for now
	self.navigationController.navigationBarHidden = YES;
	
	self.view = tmpView	;
}

@end