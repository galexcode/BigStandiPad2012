//
//  KORAbsAppDelegate.m
// BigStand
//
//  Created by Bill Donner on 3/4/11.
//

#import "KORAppDelegate.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORSettingsManager.h"
#import "KORRepositoryManager.h"
#import "KORLogManager.h"
#import "KORAlertView.h"
#import "KORExternalMonitorManager.h"
#import "KORMisConfigurationController.h"
#import "KORAbsFullSearchController.h"
#import "KORTouchCapturingWindow.h"
#import "KORHomeController.h"
#import "KORMP3PlayerView.h"
#import "KORRepositoryManager.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORZipArchive.h"
#import "KORTouchCapturingWindow.h"


#pragma mark -
#pragma mark Public Class AppDelegate
#pragma mark -

#pragma mark Internal Constants

@interface KORAppDelegate () 

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(NSString *)backtrace;
@property (nonatomic,retain) NSDictionary *optionsDict;

@end

@implementation KORAppDelegate
@synthesize optionsDict;

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

//
//- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event  {}
//- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {} 
//- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {}
//- (void) touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {}


// +initialize is invoked before the class receives any other messages, so it
// is a good place to set up application defaults

+ (void)initialize {
    
    if ([self class] == [KORAppDelegate class]) {
        
    }
}
#pragma mark Appearances - base case for whole system
-(void) setupAppearances;
{
    [[UINavigationBar appearance] setTintColor:[KORDataManager globalData].appBackgroundColor];// v5
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];// v5
															   //[[UINavigationBar appearance] setTranslucent:NO];// v5
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  
	  [UIFont boldSystemFontOfSize:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?14.f:14.0f],UITextAttributeFont,nil]];
    
    [[UISearchBar appearance] setTintColor:[KORDataManager globalData].topBackgroundColor];// v5
	
}

-(BOOL) setupForLaunch
{  	
	
	
	if (![KORDataManager globalData].singleTouchEnabled)
		
		self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
	else
		self.window = [[KORTouchCapturingWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
	
		UIViewController *launchcontroller  = [[KORHomeController alloc] init];
		
		if ([KORDataManager globalData].disableAppleHeader ==NO)
			
			launchcontroller = [[UINavigationController alloc] initWithRootViewController:launchcontroller ] ;  
		
			// make controller and give it the items   
		
		self.window.rootViewController = launchcontroller;
		[self.window makeKeyAndVisible];
		
		if ([KORDataManager globalData].singleTouchEnabled)
		{
			
				//gig.bigstand uses a full screen tap 
				//martoons, planb, etc, use a custom area
			CGRect pframe,lframe;
			if 
				([KORDataManager globalData].singleTouchFrame.size.width<10.f)  // if we have frame then
			{
					// figure out bottom bit (old method)
				CGRect bigframe = launchcontroller.view.frame;
				
				float lastline = bigframe.size.height -  [KORDataManager globalData].toolBarHeight;
					//float firstline = [KORDataManager globalData].navBarHeight;
				float chunkheight = 150.f;//(lastline-firstline)*.20; // sit below formsheet popup
				float startline = lastline - chunkheight;
				
				CGRect smallFrame = CGRectMake(0,startline,bigframe.size.width,chunkheight);
				pframe = lframe = smallFrame;
				
			} 
			else
			{
					// get if from the plist
				lframe = [KORDataManager globalData].singleTouchFrameLandscape;		
				pframe = [KORDataManager globalData].singleTouchFrame;
				
			}
			
			UIView *portraitTouchView = [[UIView alloc] initWithFrame:pframe];		
			UIView *landscapeTouchView = [[UIView alloc] initWithFrame:lframe];
			
			[(KORTouchCapturingWindow *)  self.window viewsForTouchPriority:portraitTouchView 
															  landscapeView:landscapeTouchView];
		}
		
			// setup and add a little subview
			//[KORDataManager globalData].mp3PlayerView = [[KORMP3PlayerView alloc] initWithFrame:CGRectMake(10,30, 216, 44)];
	return YES;
}



#pragma mark Public Instance Methods

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	return [self persistentStoreCoordinator:@"absAppDelegate"];
}
- (NSManagedObjectContext *)managedObjectContext
{
	
	return [self managedObjectContext:@"absAppDelegate"];
}

+ (KORAppDelegate *) sharedInstance
{
	static KORAppDelegate *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[KORAppDelegate alloc] init];
	}
	
	return SharedInstance;
}

- (void) dieFromMisconfiguration: (NSString *) msg
{
    //
    // Show fatal error message, usually because of misconfiguration:
    //
    
    if (self.window.rootViewController == nil)
    {
        
        // make dummy controller and put up window if we have nothing going yet
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[KORMisConfigurationController alloc]initWithError:msg] ] ;         
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        
    }
    else
        [KORAlertView alertWithTitle:@"Malformed plist" 
							 message:msg
                         buttonTitle:@"OK" 
                     ];  
	
		//exit (1);
}


#pragma mark UIApplicationDelegate Methods

-(void) finishSetup
{
	//[[GigStandAppDelegate sharedInstance] dump:@"from finishSetup"];
	
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
	// The incoming URL must be manipulated to produce a similar URL in the top level Documents directory
	//  The URL is copied over literally
	NSString *v = [NSString stringWithFormat:@"%@",url ];
	
	NSString *filePath = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(__bridge CFStringRef)v,CFSTR(""),kCFStringEncodingUTF8);
	NSString *ext = [filePath pathExtension];
	NSString *name = [[filePath stringByDeletingPathExtension] lastPathComponent];
	NSError *error; 
	NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
	NSString *dest =  [[KORPathMappings pathForItunesInbox] stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",name,ext]];
	[data writeToFile: dest atomically:NO];
	
	[[NSFileManager defaultManager] removeItemAtURL: url error: &error]; // get rid of incoming file once its been copied
	
	NSLog (@"openURLfrom %@ copied incoming to %@ len %d",  sourceApplication,  dest, [data length]);//,[error localizedDescription]);
	
	return NO;
}

- (BOOL) startupFromLaunchOptions: (UIApplication *) app options: (NSDictionary *) options
{
    //
    // broken out as a completely separate case, these behaviors will be made even more different
    //
	// at this point there is no reason to do anything here, since openURL seems to get called in every case 	
    return NO;
}


-(void) contextObjectsDidChangeNotification: (NSNotification *)notification
{
	//NSLog (@"contextObjectsDidChangeNotification %@",notification); //too much changed
}
-(void) contextWillSaveNotification: (NSNotification *)notification
{
	//NSLog (@"contextWillSaveNotification %@",notification); // %D", [[[notification.userInfo] objectForKey:@"inserted" ]count]);
}
-(void) contextDidSaveNotification: (NSNotification *)notification
{
	NSLog (@"contextDidSaveNotification");//,notification);// [[[notification.userInfo] objectForKey:@"inserted" ] count]);
}


- (BOOL) application: (UIApplication *) app didFinishLaunchingWithOptions: (NSDictionary *) options
{
    
    
	
		//	BOOL debugtrace  = [[KORSettingsManager sharedInstance] debugTrace];
    BOOL sim;
    
#if TARGET_IPHONE_SIMULATOR		
    sim=YES;
#else
    sim=NO;
#endif
    [KORDataManager globalData].inSim = sim; 
	
    
    
	
// 
//    if ((sim == NO) && (debugtrace==NO))
//    {	 
//        NSLog (@"<<<<<<<<<<<Redirecting Device Trace to inapp display...>>>>>>>>>>>>>>>");			
//        freopen([[KORLogManager pathForCurrentLog] fileSystemRepresentation], "a", stderr); // dont wipe out
//    }
//    [KORLogManager rotateLogs];
	
	
    [self setupAppearances];
	
    [app setStatusBarStyle: UIStatusBarStyleBlackOpaque];  // start as black if run straight up

    [KORRepositoryManager setup]; // very important, must pass in by property
    
    
//    NSString *version = [[[UIDevice currentDevice] systemVersion] substringToIndex:2];      // Your iOS 5.0-compatible code here
//    
//    if ([@"5." isEqualToString:version])  // only do external monitors if version 5
//	[KORExternalMonitorManager setup];
    
    NSLog(@"Build %@ CoreData SQLite DB has %d archives with %d clumps from %d files",[KORDataManager globalData].applicationVersion,
		  [KORRepositoryManager archivesCount], [KORRepositoryManager clumpCount],[KORRepositoryManager instancesCount]);
    
    if ([KORRepositoryManager archivesCount]==0 )
	{
        // if we've got nothing in the db then build a new one
        [KORRepositoryManager buildNewDB];
		[KORDataManager globalData].userEnteredEmail = @"";
		
	}
    
    else 
        
        [KORRepositoryManager updateDBInfo]; // otherwise just flip around some times
	
	
	[ self setupForLaunch];

	
		// show our operational parameters
		
	
	[KORDataManager showParamsInLog];

    return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //	NSLog(@"/////////////////////////GSA applicationDidBecomeActive on %@:%d  psc=%@ /////////////////////////",
    //		  [KORDataManager globalData].myLocalIP,
    //		  [KORDataManager globalData].myLocalPort,
    //		  __persistentStoreCoordinator);
	
    //	BOOL wifiwebserver  = [[MusicStandSettingsManager sharedInstance] wifiWebserver];	
    //	BOOL collabfeatures = [[MusicStandSettingsManager sharedInstance] collabFeatures];
	
}

#pragma mark KORRepositoryManager
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	
	/*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	NSLog(@"applicationDidEnterBackground saving managed object context......");
    [self saveContext:@"applicationDidEnterBackground"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	NSLog(@"applicationWillEnterForeground restarting......");
	//[[BonJourManager sharedInstance] publishTXTFromLastTitle];
    // get the UI repainted
    //[KORDataManager singleTapPulse];
	
	[KORDataManager globalData].sessionDisplayTransactionCount=0; // put up initial screen on restart
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate saveContext");
    [self saveContext:@"applicationWillTerminate"];
}


- (void)saveContext:(NSString *)backtrace {
    
	//NSLog (@"saveContext called....");
    NSError *error;//arc = nil;
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext:backtrace];
    if (managedObjectContext != nil) {
		//[managedObjectContext processPendingChanges];  // worth a shot
		//      if ([managedObjectContext hasChanges] == YES) 
		//			NSLog(@"saveContext called from %@ with no changes",backtrace);
		//		//else
		{
			
			BOOL saveok;
            saveok = [managedObjectContext save:&error] ;
			if (saveok==NO)
			{
				
				NSLog(@">>>>>>>>>Error in saveContext from %@ is %@, %@", backtrace,error, [error localizedDescription]);
				//abort();
			} 
			else {
				
				//NSLog(@"save: completed ok from %@",backtrace);
                
                
			}
			
		}
    }
	
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext:(NSString *)backtrace;
{
    
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator:@"from managedObjectContext"];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
		
    }
	
	//NSLog (@"managedObjectContext is created from: %@",backtrace);
    return __managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
	}
	//	
    NSURL *modelURL = [[NSBundle mainBundle] 
					   URLForResource:@"GigStand" 
					   withExtension:@"momd"];
	
    __managedObjectModel = [[NSManagedObjectModel alloc] 
                            initWithContentsOfURL:modelURL];  
	
	
    return __managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(NSString *)backtrace
{
    if (__persistentStoreCoordinator != nil) {
		
        //	NSLog (@"persistentStoreCoordinator %@ probed and exists exists with %@",backtrace,__persistentStoreCoordinator);
		
        return __persistentStoreCoordinator;
    }
	//	how can we ever get here multiple times
	
	NSError *error;
	NSString *dndDir = [KORPathMappings pathForSharedDocuments];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:dndDir]==NO) 
	{
        //	NSLog (@"persistentStoreCoordinator %@ creating dnd directory",backtrace);
		[[NSFileManager defaultManager] createDirectoryAtPath:dndDir
								  withIntermediateDirectories:YES attributes:nil error:nil]; // multilevel
		if (![[NSFileManager defaultManager] fileExistsAtPath:dndDir])
		{
			NSLog (@"persistentStoreCoordinator %@ could not create directory %@",backtrace,dndDir);
			abort();
		}
	}
	//	else
	//		NSLog (@"persistentStoreCoordinator dnd directory existed");
	// setup sqlite db	
	NSURL *dndurl =  [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
	NSURL *storeURL = [dndurl  URLByAppendingPathComponent:@"/Private Documents/DONOTDISTURB/GigBase.sqlite"];
	
	error = nil;
	//NSLog (@"prior to NSPersistentStoreCoordinator alloc %@",persistentStoreCoordinator_);
	__persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	//NSLog (@"post NSPersistentStoreCoordinator alloc %@",persistentStoreCoordinator_);
	//NSMutableDictionary *pragmaOptions = [NSMutableDictionary dictionary];
	//	[pragmaOptions setObject:@"FULL" forKey:@"synchronous"]; // also try full
	//	[pragmaOptions setObject:@"1" forKey:@"fullfsync"];
	
	NSDictionary *storeOptions =nil;
	//  [NSDictionary dictionaryWithObject:pragmaOptions forKey:NSSQLitePragmasOption];
	if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                    configuration:nil 
                                                              URL:storeURL 
                                                          options:storeOptions 
                                                            error:&error])
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
		 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
		 
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
		 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
		 NSMigratePersistentStoresAutomaticallyOption, 
		 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		 
		 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
		 
		 */
		NSLog(@"Error setting up sqlite  %@, %@", error, [error localizedFailureReason]);
		
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		
        [self  dieFromMisconfiguration: @"sqlite open failure"];
        return nil;
		
	}
	//NSLog (@"created new persistentStoreCoordinator %@ %@ for db %@",backtrace,__persistentStoreCoordinator,storeURL);
	return __persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
//- (NSURL *)applicationDocumentsDirectory {
//	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	 */
	
	[[KORDataManager globalData]  flushCache];
	NSLog (@"**************KORAbsAppDelegate flushed all image views ***********");
	
		// [KORExternalMonitorManager flush];
	
}

-(void) dump:(NSString *) tag;
{
	NSLog (@"%@ psc %@",tag,[self persistentStoreCoordinator:@"dmp"]);
}

// appearances - this is the default case, but can be overriden by subclass

#pragma mark -




@end

