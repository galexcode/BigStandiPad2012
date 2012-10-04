	//
	//  DiagnosticRigController.m
	// BigStand
	//
	//  Created by bill donner on 7/15/11.
	//  Copyright 2011 ShovelReadyApps. All rights reserved.
	//
#import "KORBarButtonItem.h"
#import "KORAlertView.h"
#import "KORAppDelegate.h"
#import "KORDiagnosticRigController.h"
#import "KORRepositoryManager.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "ArchiveInfo.h"
#import "InstanceInfo.h"
#import "ClumpInfo.h"

#pragma mark -
#pragma mark Public Class DiagnosticRigController
#pragma mark -



@interface KORDiagnosticRigController ()
@property (nonatomic) NSUInteger errorCount;
-(void) processDirect:(UIColor *)backgroundColor textColor:(UIColor *)textColor label:(NSString *) static_label;
@end  




@implementation KORDiagnosticRigController
@synthesize errorCount,delegate, activityLabel,activityIndicator,activityImageView;
@synthesize dbrebuildFileCount,dbrebuildStartTime,countdown_group,background_queue;


	////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
			// Initialization code here.
        errorCount = 0;
    }
    
    return self;
}
#pragma mark Public Instance Methods
-(void) testCoreData
{
    dispatch_group_async(self.countdown_group,self.background_queue, ^{ 
			// at this point the code is running in the background, so run some tests
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.activityLabel setText:[NSString stringWithFormat:@"First Core Data Consistency Tests...Then Full Data Store Check"]];   
        });      
    });
}


- (void) doOneFile:(NSString *)type incoming:(NSString *)incoming iname:(NSString *)iname;
{
		//dispatch_group_async(self.countdown_group,self.background_queue, ^{   
			// test this file in various ways and count errors
    
        NSError *error = nil;
        NSError *dataerror = nil;
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:incoming];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: incoming error:&error];
        NSData *data = [NSData dataWithContentsOfFile: incoming options: NSDataReadingUncached error: &dataerror];

		// dispatch_sync(dispatch_get_main_queue(), ^{
            BOOL anyErrors = NO;
				// should display background fall thru I hope
            if (!fileExists) 
            {
                NSLog (@" diagnostic - err processing incoming %@ iname %@ does not exist", incoming,iname);
                anyErrors = YES;
            } else
				if (error != nil) 
				{
					NSLog (@" diagnostic - err reading file attributes incoming %@ iname %@ err %@", incoming,iname,[error description]);
					anyErrors = YES;
				} else
					if (!(attrs && [[attrs fileType] isEqualToString: NSFileTypeRegular]))
					{
						NSLog (@" diagnostic - err processing incoming %@ iname %@ exists %d attrs %@", incoming,iname,fileExists,attrs);
						anyErrors = YES;
					} else
						
						if (dataerror != nil) 
						{
							NSLog (@" diagnostic - err reading file data incoming %@ iname %@ err %@", incoming,iname,[dataerror description]);
							anyErrors = YES;
						}
			
            [self.activityLabel setText:[NSString stringWithFormat:@"%8d bytes file %@ type %@",[data length], iname,type]];   
            self.dbrebuildFileCount++;
            if (anyErrors) 
            {
                self.errorCount ++; 
            }
        //});
		//});
}

-(void) processAndTestEachFile;
{
		// go thru every file by going thru each archive
    NSArray *archives = [KORRepositoryManager allArchives];
    
    [archives enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
     {
         
         dispatch_group_async(self.countdown_group,self.background_queue, ^{  
             
             NSString *archive  = (NSString *)obj;
             
             
             NSArray *tunes = [KORRepositoryManager allTitlesFromArchive:archive];
             
             for (NSString *tune in tunes)
             {
                 BOOL anyErrors = NO;
                 ClumpInfo *ti  = [KORRepositoryManager findTune:tune];
                 
                 if (!ti){
                     
                     anyErrors = YES;
                     NSLog (@" diagnostic - tune in supposedly in archive %@ but not found %@", archive,tune);	
                 }
                 
                 if (ti) {
                     
                     NSArray *variants = [KORRepositoryManager allVariantsFromTitle: tune];
                     NSUInteger variantsInCorrectArchive = 0;
                     
                     for (InstanceInfo *ii in variants)
                     {
                         if ([ii.archive  isEqualToString: archive])
                         {  
                             variantsInCorrectArchive++;
                             
                             
                             NSString *ipath = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
                             NSString *fullpath = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@", ipath];
								 // [self.toProcess addObject:path];
                             
                             
                             NSString *filetype = [[fullpath pathExtension] lowercaseString];  // returns @"zip"
                             NSString *filename = [fullpath lastPathComponent]; 
                             
                             [self doOneFile:filetype incoming:fullpath iname:filename];
                             
                             
                         }
                         
                         
                     }
                     
                     
                     if (variantsInCorrectArchive==0) 
                     {
                         anyErrors = YES;
                         NSLog (@" diagnostic - tune in archive %@ but variant not found %@", archive,tune);	
                         
                     }
                     
                 }
					 //                // if (anyErrors) self.errorCount ++;
					 //                 dispatch_sync(dispatch_get_main_queue(), ^{
					 //                     [self.activityLabel setText:[NSString stringWithFormat:@"queued archive %@ files %d",archive,[tunes count]]];  
                 
					 //                });
                 
             }
             
         });// asynch
     }
     ]; //enumerate
    
}




-(void) viewDidLoad

{
	self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem
     buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     completionBlock: ^(UIBarButtonItem *bbi){
         
         [self.presentingViewController dismissViewControllerAnimated:YES  
									   completion: ^(void) { NSLog (@"Dianostic Rig Controller cancel button hit"); }];
     }];
    [self processDirect:[UIColor blackColor] textColor:[UIColor whiteColor] label:@"Full Read of Every File in All Archives"];
}



-(void) startPhases:(NSTimer *)timer;
{
		// should display background fall thru I hope
    NSLog (@"PHASE_I Core Data consistency processing commencing...");    
    [self testCoreData];
		// wait for that group of tasks to finish
    dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
		
		NSLog (@"PHASE_II Process and Test each file...");
		
		
		[self processAndTestEachFile]; // puts up alert while working 
		
		
		dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
            
				// wait for PHASE_II
            
            NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
            
				// Get the elapsed time in milliseconds
            NSTimeInterval elapsedTime = (endTime - self.dbrebuildStartTime) * 1000;
            
            float perdoc = elapsedTime/self.dbrebuildFileCount;
            if (self.dbrebuildFileCount>0){
                
				NSLog (@"PHASE_II assimilation finished...,%@",[NSString stringWithFormat:@" %d docs at %3.2f ms/doc",self.dbrebuildFileCount,  perdoc]);
				[self.activityLabel 
				 
				 setText:[NSString stringWithFormat:
						  
						  @"settings %@ minsw %@ app %@", [KORDataManager globalData].settingsVersion,[KORDataManager globalData].minswVersion,
						  [KORDataManager globalData].applicationVersion
						  ]];  
            }
            else
			{
				NSLog (@"PHASE_II NO FILES PROCESSED");
				[self.activityLabel setText:[NSString stringWithFormat:@"No files were processed"]];
			}
			
			[KORAlertView alertWithTitle: [NSString stringWithFormat:@"processed %d files %d errors",self.dbrebuildFileCount,self.errorCount]
								 message:@"Diagnostic Complete"  
							 buttonTitle:@"OK"];
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"Diagnostic complete"]];
			
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
    self.activityLabel.text = @"Commencing Processing";
    
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

- (void) loadView
{
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
