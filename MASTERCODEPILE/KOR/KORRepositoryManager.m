	//
	//  KORRepositoryManager.m -----
	// BigStand
	//
	//  Created by bill donner on 2/22/11.
	//  Copyright 2011 ShovelReadyApps. All rights reserved.
	//
#import "KORAppDelegate.h"
#import "KORRepositoryManager.h"
#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "SnapshotInfo.h"
#import "DBInfo.h"
#import "KORRepositoryManager.h"
#import "KORListsManager.h"
#import "ArchiveInfo.h"
#import "ArchiveHeaderInfo.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORSettingsManager.h"


@interface  KORRepositoryManager ()


@property (nonatomic) NSInteger dummy;
@property (nonatomic, retain) NSString *lastTitle;

@property (nonatomic, retain) NSString *lastSquoze;

+ (KORRepositoryManager *) sharedRepository;

+(InstanceInfo *) findInstance: (NSString *)archive filePath: (NSString *)filepath forTune: (NSString *)tune;
+(ClumpInfo *) insertTune:(NSString *) tune lastArchive:(NSString *) lastarchive lastFilePath:(NSString *) lastfilepath;
+(InstanceInfo *) insertInstance:(NSString *)tune  archive:(NSString *)archive filePath:(NSString *)filepath;
+(void) addClumpInfo:(NSString *)title withLongPath:(NSString *)longpath;

+(ClumpInfo *) insertTuneUnique:(NSString *) tune lastArchive:(NSString *) lastarchive lastFilePath:(NSString *) lastfilepath;

+(NSArray *) allSnapshotInfos;



@end

@implementation KORRepositoryManager
@synthesize dummy,lastTitle,lastSquoze,otfarchive;

-(id) init
{
	self = [super init];
	if (self)
	{	
		lastTitle = nil;
        
		otfarchive = @"onthefly-archive" ;  ///////111211
	}
	return self;
}


+(void) setup
{
	[self sharedRepository].dummy = 1;
}
+ (KORRepositoryManager *) sharedRepository;
{
	static KORRepositoryManager *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[self alloc] init];
		
	}
	return SharedInstance;
}
+(NSString *)strippedTitle:(NSString *) tune
{
    NSString *title;
    NSArray *parts;
    
    if ([KORDataManager globalData].stripFirstTitleComponent)
    {
        parts = [tune componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*$"]];
        if ([parts count]>1)
            title=[[parts objectAtIndex:1]copy]; 
        else
            title=[[parts objectAtIndex:0]copy];
    }
    else title = [tune copy];
    return title;
}


+ (NSArray *) allTitles;
{
	
		/// returns an array of NSStrings, not managed objects
	
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allTitles"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ClumpInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
		/////////////
		////////////
	
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
	
	for (ClumpInfo *ti in fetchedObjects)
		if ([ti.title length]>0) //wld 12sep12
		[putb addObject:ti.title];
	
    [putb sortUsingSelector:@selector(compare:)];
	return putb;
}
+ (void) dump;
{
	NSArray *titles = [[self class] allTitles];
	for (NSString *title in titles)
	{
		
//			// Find similar titles by squeezing and checking against previous cannonical form
//		
//		NSString *lctitle = [title lowercaseString];
//		
//		NSString *squoze1= [lctitle stringByReplacingOccurrencesOfString:@"running" withString:@"runnin"];		
//		NSString *squoze2= [squoze1 stringByReplacingOccurrencesOfString:@"taking" withString:@"takin"];		
//		NSString *squoze3= [squoze2 stringByReplacingOccurrencesOfString:@"loving" withString:@"lovin"];			
//		NSString *squoze4= [squoze3 stringByReplacingOccurrencesOfString:@"moving" withString:@"movin"];		
//		NSString *squoze5 = [squoze4 stringByReplacingOccurrencesOfString:@"lying" withString:@"lyin"];
//		
//		NSString *squoze6 = [squoze5 stringByReplacingOccurrencesOfString:@"chords" withString:@""];
//		
//		NSString *squoze7 = [squoze6 stringByReplacingOccurrencesOfString:@"lyrics" withString:@""];
//		
//		NSString *squoze8 = [squoze7 stringByReplacingOccurrencesOfString:@"tab" withString:@""];
//		
//		NSString *squozel = [squoze8 stringByReplacingOccurrencesOfString:@"copy" withString:@""];
//		
//		NSString *squoze = [squozel stringByReplacingOccurrencesOfString:@" " withString:@""];
//		
//		if ([squoze isEqualToString:[self sharedRepository].lastSquoze]) {
//			NSLog (@"***TITLE: %@",title);
//			NSArray *variants = [[self class] allVariantsFromTitle:title];
//			for (InstanceInfo *ii in variants)
//			{
//				NSLog (@"				%@",ii.filePath);
//			}
//		}
//		else {

			NSLog (@">>>TITLE: %@",title);		NSArray *variants = [[self class] allVariantsFromTitle:title];
		for (InstanceInfo *ii in variants)
		{
			NSError *error;
			NSStringEncoding encoding;
				// Now build the full deal
			NSString *fullPath = [[KORPathMappings pathForSharedDocuments] stringByAppendingPathComponent:ii.filePath];
			
				//NSData *data =[NSData dataWithContentsOfURL: [NSURL fileURLWithPath: fullPath]];
			NSString *bodydata = [NSString stringWithContentsOfFile:fullPath usedEncoding:&encoding error: &error];
			if (error) {
				NSLog (@"Encoding error %d reading %@ %d %@",[bodydata length],ii.filePath,encoding,[error localizedDescription]);
				
				NSString *bodydata2 = [NSString stringWithContentsOfFile:fullPath encoding:NSASCIIStringEncoding error: &error];
				
				if (error) NSLog (@"Retry error %d reading %@  %@",[bodydata2 length],ii.filePath,[error localizedDescription]);
			}
			
			
			
//				return  [NSString stringWithFormat:@"<html>%@<body>Sorry, this tune can not be displayed.<p>%@</p></body></html>",headerdata, [error localizedDescription]];
		}
//		}
//		
//		[self sharedRepository].lastSquoze = squoze;
//			
		

	}
}
+ (NSUInteger) clumpCount;
{
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager clumpCount"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ClumpInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
		/////////////
		////////////
	
	return count;
}

+ (NSArray *) allTitlesFromArchive:(NSString *)archive;
{
		/// returns an array of NSStrings, not managed objects
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allTitlesFromArchive"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
    
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@", archive];
	[fetchRequest setPredicate:somePredicate];
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]] ;
    
	for (InstanceInfo *ii in fetchedObjects)
	{ 
		
        [putb addObject:ii.title];
	}
		// weed out dupes
	
	[putb sortUsingSelector:@selector(compare:)];
	
	NSMutableArray *putc = [[NSMutableArray alloc] initWithCapacity:[putb count]];
	for (NSUInteger i=0; i<[putb count]; i++)
	{
		NSString *o = [putb objectAtIndex:i];
        
		NSString *p = [putc lastObject];
		if (! [o isEqualToString: p]) 		[putc addObject:o];
	}
    
		// now that its sorted strip out the front matter, this is not quite yet right
	NSMutableArray *putd = [[NSMutableArray alloc] initWithCapacity:[putc count]];
    for (NSUInteger i=0; i<[putc count]; i++)
    {
        if ([KORDataManager globalData].stripFirstTitleComponent)
            [putd addObject: [self strippedTitle:[putc objectAtIndex:i]]]; 
        
		else [putd addObject:[putc objectAtIndex:i]];
    }
	
	return putd; //cleanedArray;
}
+ (NSArray *) allTitlesOrderedByFileSpec;
{
		/// returns an array of NSStrings, not managed objects
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allTitlesOrderedByFileSpec"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
    
//	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@", archive];
//	[fetchRequest setPredicate:somePredicate];
    
    
    
		// here's where you specify the sort
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"filePath" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]] ;
    
	for (InstanceInfo *ii in fetchedObjects)
	{ 
        [putb addObject:ii.title];
	}

    
    return putb;
}
+ (NSArray *) allVariantsFromTitle:(NSString *)title;
{
	
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allVariantsFromTitle"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" title == %@", title];
	[fetchRequest setPredicate:somePredicate];
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"allVariantsFromTitle error %@",error);
		return nil;
	}
	if ([fetchedObjects count]==0) return nil;
	
		//return [fetchedObjects autorelease];  // seemed to be leaking
    return fetchedObjects;
}
+(ClumpInfo *) findTune: (NSString *)tune
{
		//NSLog (@"KORRepositoryManager findTune");
	NSError *error=nil;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findTune"];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ClumpInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" title == %@", tune];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findTune error %@",error);
		return nil;
	}
	
		////	NSLog (@"======= TitleInfo fetched %d records from title== '%@' ",[fetchedObjects count],tune);
	
	if ([fetchedObjects count]>0) {
		return (ClumpInfo *)[fetchedObjects objectAtIndex:0];
	}
	
	return nil;
}
+(ClumpInfo *) findClump:(NSString *)tune;
{
	
		//Shadow into CoreData :::
	
	
	ClumpInfo *ti = [KORRepositoryManager findTune:tune];
		//if (ti==nil) 
		//		NSLog (@"findClumpInfo %@ failed",tune);
		//	
	
	return ti;
}

+(void) addClumpInfo:(NSString *)title withLongPath:(NSString *)longpath;
{
	if ([title length] > 0) {  //wld12sep12
		//Shadow into CoreData :::
	NSArray *parts = [longpath componentsSeparatedByString:@"/"];
	NSString *parchive = [parts objectAtIndex:0];
	NSString *pfilepath = longpath; //111111[parts objectAtIndex:1];//must change
	[self insertTuneUnique:title lastArchive:parchive lastFilePath:pfilepath];
	[self insertInstanceUnique:title  archive:parchive filePath:pfilepath];
	}
	
}	

+(ClumpInfo *) tuneInfo:(NSString *) tune;
{
	
	ClumpInfo *ti = [KORRepositoryManager findTune:tune];
	if (ti==nil) 
		NSLog (@"tuneInfo %@ failed",tune);
	
	NSAssert1 ((ti!=nil),@"Could not find tune %@ in ClumpInfo table",tune);
	
	return ti;
	
}
+(ClumpInfo *) insertTune:(NSString *) tune lastArchive:(NSString *) lastarchive lastFilePath:(NSString *) lastfilepath;
{
		//title names are possibly trimmed on the way into the db
    
	if ([tune length]==0)
		return nil;// wld 12sep12
    
    
    
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertTune"];
	ClumpInfo  *ti = [NSEntityDescription
					  insertNewObjectForEntityForName:@"ClumpInfo" 
					  inManagedObjectContext:context];
	
	ti.title = [self strippedTitle:tune];
	ti.lastArchive = lastarchive;
	ti.lastFilePath = lastfilepath;
	return ti;
}
+(ClumpInfo *) insertTuneUnique:(NSString *) tune lastArchive:(NSString *) lastarchive lastFilePath:(NSString *) lastfilepath;
{
	ClumpInfo *mo = [self findTune:tune];
	
	
	if (mo==nil) 
	{
			// if the tune wasnt found
		mo = [self insertTune:tune lastArchive:lastarchive lastFilePath:lastfilepath];
	}
	return mo;
}

+(BOOL) renameTune:(NSString *)fromtune toTune:(NSString *) totune;
{
    NSLog (@"KORRepositoryManager rename from %@ to %@", fromtune,totune);
    
		//
		// find all tunes in both ClumpInfo and InstanceInfo and change to new title
		// 
    NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager renameTune"];
    
    
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity2 = [NSEntityDescription 
                                    entityForName:@"ClumpInfo" inManagedObjectContext:context];
	
	NSPredicate *somePredicate2 = [NSPredicate predicateWithFormat:@"title == %@", fromtune ];
	[fetchRequest2 setPredicate:somePredicate2];
	
	
	[fetchRequest2 setEntity:entity2];
	NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest2 error:&error];
    for (ClumpInfo *ti in fetchedObjects2)
    {
        ti.title = totune; // change the title in each
    }
    BOOL saveok2 = [context save: &error];
    if (saveok2 == NO) NSLog (@"save to tuneinfo failed in renameTune %@", [error description]);
    
    
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@"title == %@", fromtune ];
	[fetchRequest setPredicate:somePredicate];
	
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (InstanceInfo *ii in fetchedObjects)
    {
        ii.title = totune; // change the title in each
    }
    BOOL saveok = [context save: &error];
    if (saveok == NO) NSLog (@"save to instanceinfo failed in renameTune %@", [error description]);
    
    
    
    return YES;
}

+(void) titlePurgeCheck:(NSString *)title;
{
	NSUInteger counter = [[self allVariantsFromTitle:title] count];
		//NSLog (@"%@ count %D", title, counter);
	
		// if there are no instances for the title record then delete it	
	if (counter ==0)
	{
		NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager titlePurgeCheck"];
		
		ClumpInfo *ti = [self findTune:title];
		if (ti!=nil) 
			[context deleteObject:ti];
	}	
}
+(InstanceInfo *) findInstance: (NSString *)archive filePath: (NSString *)filepath forTune: (NSString *)tune;
{
		//NSLog (@"KORRepositoryManager findInstance");
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findInstance"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" filePath == %@ && archive == %@ && title == %@", filepath, archive,tune ];
	[fetchRequest setPredicate:somePredicate];
	
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findInstance error %@",error);
		return nil;
	}
	
	
		////		NSLog (@"======= InstanceInfo fetched %d records from archive=='%@' AND filePath== '%@' ",[fetchedObjects count],archive, filepath);
	if ([fetchedObjects count]>0) 
		return (InstanceInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
}

+(InstanceInfo *) insertInstance:(NSString *)tune  archive:(NSString *)archive filePath:(NSString *)filepath;
{
		//NSLog (@"KORRepositoryManager insertInstance");
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertInstance"];
	InstanceInfo *ii = [NSEntityDescription
						insertNewObjectForEntityForName:@"InstanceInfo" 
						inManagedObjectContext:context];
    
    NSString *longpath = [KORDataManager deriveLongPath:filepath forArchive:archive];
    
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: [[KORPathMappings pathForSharedDocuments] 
                                                                                   stringByAppendingPathComponent: longpath]
                                                                           error: NULL];
    
	ii.lastVisited = [attrs objectForKey:NSFileCreationDate];
	ii.archive= archive;
	ii.filePath = filepath ;
	ii.title =[self strippedTitle:  tune ];
	
	return ii;
}

+(InstanceInfo *) insertInstanceUnique:(NSString *)tune  archive:(NSString *)archive filePath:(NSString *)filepath;
{
		//NSLog (@"KORRepositoryManager insertInstanceUnique");
	InstanceInfo *mo = [self findInstance:archive filePath:filepath forTune:tune];
	if (!mo) 
	{
			// if the tune wasnt found
		mo =  [self insertInstance:tune archive: archive filePath:filepath];
	}
	return mo;
}
+ (NSUInteger) instancesCount;
{
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager instancesCount"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
	
	
	return count;
}
+ (NSUInteger) snapshotCount;
{
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager snapshotCount"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"SnapshotInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
	
	
	return count;
    
}
+(SnapshotInfo *) findSnapshotInfo: (NSString *)tune;
{
		//NSLog (@"KORRepositoryManager findInstance");
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findSnapshotInfo"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"SnapshotInfo" inManagedObjectContext:context];
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" title == %@", tune ];
	[fetchRequest setPredicate:somePredicate];
	
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findSnapshotInfo error %@",error);
		return nil;
	}
	
	
		////		NSLog (@"======= InstanceInfo fetched %d records from archive=='%@' AND filePath== '%@' ",[fetchedObjects count],archive, filepath);
	if ([fetchedObjects count]>0) 
		return (SnapshotInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
}

+(NSArray *) allSnapshotInfos;
{	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findSnapshotInfo"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"SnapshotInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findSnapshotInfo error %@",error);
		return nil;
	}
	
    if ([fetchedObjects count]==0) return nil;
	
	return fetchedObjects;
    
}


+(void) insertSnapshotInfo:(NSString *)filepath title:(NSString *)titl;
{
    
	NSDate *now = [NSDate date];
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertSnapshotInfo"];
	
		// see if we already have stuff there
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"SnapshotInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil)
	{
		if (error) 
		{
			NSLog (@"insertSnapshotInfo error %@",error);
			return;
		}
	}
		//	else if ([fetchedObjects count]>0)
		//	{
		//		SnapshotInfo *gb = (SnapshotInfo *) [fetchedObjects lastObject];
		//
		//		gb.time = now;
		//	}
	else 
        
	{
			// no previous gigbase records, so insert one
		SnapshotInfo *gb = [NSEntityDescription
                            insertNewObjectForEntityForName:@"SnapshotInfo" 
                            inManagedObjectContext:context];
		gb.time = now;
        gb.filePath = filepath;
        gb.title = titl;		
	}
	
	[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"insertSnapshotInfo %@",titl]];
    
}


+(BOOL) removeOldestSnapshot;
{
    SnapshotInfo *thislii = nil;
    NSDate *thisdate = [NSDate distantFuture];
    NSString *thispath;
		// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager removeOldestSnapshot"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"SnapshotInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
    
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"removeOldestSnapshot error %@",error);
		return NO;
	}
    for (SnapshotInfo *lii in fetchedObjects)
        if ([lii.time compare:  thisdate] < 0)
        {
            thisdate = lii.time;
            thislii = lii;
            thispath = lii.filePath;
        }
		// ok delete this
    if (thislii == nil) return NO;
		// delete the actual file from the file system 
    [KORDataManager  removeItemAtPath:thispath error: &error];
    if ([[NSFileManager defaultManager] fileExistsAtPath:thispath])
        NSLog (@"Error removing %@",thispath);
    [context deleteObject:thislii];
    
	[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"removeOldestSnapshot from %@",thisdate]];
    return YES;
    
}
+(DBInfo *) findDBInfo;
{	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findDBInfo"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"DBInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findDBInfo error %@",error);
		return nil;
	}
	
	if ([fetchedObjects count]>0) 
		return (DBInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
}
+(void) updateDBInfo;
{
	NSDate *now = [NSDate date];
	DBInfo *gb = [self findDBInfo];
	gb.dbPreviousStartTime = gb.dbStartTime;
	gb.dbStartTime = now;
	
	gb.dbUserEmail = [[KORDataManager globalData].userEnteredEmail  copy ];
//	NSLog (@"gbdb update - startTime:%@, previousTime: %@, dbversion: %@ user: %@",
//		   gb.dbStartTime,gb.dbPreviousStartTime,	gb.gigbaseVersion,gb.dbUserEmail);
	[[KORAppDelegate sharedInstance] saveContext:@"updateDBInfo"];
}
+(void) dumpDBInfo;
{
}
+(void) insertGBInfo;
{
	NSDate *now = [NSDate date];
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertDBInfo"];
	
		// see if we already have stuff there
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"DBInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil)
	{
		if (error) 
		{
			NSLog (@"findGigBase error %@",error);
			return;
		}
	}
	else if ([fetchedObjects count]>0)
	{
		DBInfo *gb = (DBInfo *) [fetchedObjects lastObject];
		gb.dbPreviousStartTime = gb.dbStartTime;
		gb.dbStartTime = now;
		gb.dbUserEmail = [[KORDataManager globalData].userEnteredEmail  copy ];
		
		gb.gigstandVersion = [KORDataManager globalData].applicationVersion;
//		NSLog (@"gbdb existing %d - startTime:%@, previousTime: %@, dbversion: %@ user %@",[fetchedObjects count],
//			   gb.dbStartTime,gb.dbPreviousStartTime,	gb.gigbaseVersion,gb.dbUserEmail);
	}
	else 
        
	{
			// no previous gigbase records, so insert one
		DBInfo *gb = [NSEntityDescription
					  insertNewObjectForEntityForName:@"DBInfo" 
					  inManagedObjectContext:context];
		gb.dbStartTime = now;
		gb.dbPreviousStartTime = [NSDate distantPast];
		gb.dbUserEmail = @"";
		gb.gigbaseVersion = [KORSettingsManager sharedInstance].dbVersionString;
		gb.gigstandVersion = [KORDataManager globalData].applicationVersion;
		gb.dbOperationalTime = [NSDate distantFuture]; // this should get reset 
													   //NSLog (@"gb - startTime:%@, previousTime: %@, dbversion: %@",gb.dbStartTime,gb.dbPreviousStartTime,	gb.gigbaseVersion);
		
		
//		NSLog (@"gbdb new database - startTime:%@, previousTime: %@, dbversion: %@",
//			   gb.dbStartTime,gb.dbPreviousStartTime,	gb.gigbaseVersion);

		
	}
	
	[[KORAppDelegate sharedInstance] saveContext:@"insertDBInfo"];
}

+(NSString *) lastTitle;
{
		// runs in memory
	return [self sharedRepository].lastTitle;
}
+(void) setLastTitle:(NSString *)title;
{
		// runs in memory
	[self sharedRepository].lastTitle=title;
}
	////////////


+ (NSArray *) allEnabledArchives;
{
		// just return list of names	
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allEnabledArchives"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat :@" enabled == TRUE"];
	
	[fetchRequest setPredicate:somePredicate];
	
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
	
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	 [fetchRequest setSortDescriptors:sortDescriptors];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
	for (ArchiveInfo *ai in fetchedObjects){
		
			//NSLog (@"allEnabledArchives  %@ sequence %d",ai.archive, [ai.sequence unsignedShortValue]);
		[putb	addObject:ai.archive];
	}
	
	
	return putb;
}
+ (NSMutableArray *) allArchives;
{
		// just return list of names	
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allArchives"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
	
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
		/////////////
		////////////
	
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
	for (ArchiveInfo *ai in fetchedObjects)
	{
		NSLog (@"allArchives  %@ sequence %d",ai.archive, [ai.sequence unsignedShortValue]);
		[putb	addObject:ai.archive];
	
	}
	
	
	return  putb;
}
+ (NSArray *) allArchivesObjs;
{
		// return actual managed objects
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager allArchivesObjs"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
	
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	
	
	for (ArchiveInfo *ai in fetchedObjects)
	{
		NSLog (@"allArchivesObjs  %@ sequence %d",ai.archive, [ai.sequence unsignedShortValue]);
	
		
	}
	
	if (fetchedObjects == nil)
	{
        if (error) 
            NSLog (@"Allobjs error %@",error);
		return nil;
	}
		/////////////
		////////////
	if ([fetchedObjects count]>0)
        return fetchedObjects;
	
	return nil;
}
+ (NSUInteger) archivesCount;
{
		// return just count (optimized)
		/////////////
		/////////////
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager archivesCount"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
    
	return count;
    
}


+(ArchiveInfo *) findArchive: (NSString *)archive 
{
	NSError *error=nil;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findArchive"];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@", archive];
	[fetchRequest setPredicate:somePredicate];
    
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil)
	{
        if (error) 
            NSLog (@"findArchive error %@",error);
		return nil;
	}	
	if ([fetchedObjects count]>0) {
		return (ArchiveInfo *)[fetchedObjects objectAtIndex:0];
	}
	
		//	NSLog (@"======= findArchive fetched %d records from archive== '%@' ",[fetchedObjects count],archive);
    
	return nil;
}

+(ArchiveInfo *) insertArchive:(NSString *) archive;
{
    NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertArchive"];
	ArchiveInfo  *ai = [NSEntityDescription
                        insertNewObjectForEntityForName:@"ArchiveInfo" 
                        inManagedObjectContext:context];
	
	ai.archive = archive;
	ai.logo = @"";	// set this to something non-nil
	ai.provenanceHTML = @""; // or core data will fail on actual flush
	ai.sequence = [NSNumber numberWithShort: ([KORRepositoryManager	archivesCount]+1)];
	return ai;
}


+(ArchiveInfo *) insertArchiveUnique:(NSString *) archive;
{
	ArchiveInfo *mo = [self findArchive:archive];
	if (mo==nil) 
	{
			// if the tune wasnt found
		mo= [self insertArchive:archive ];
	}
	return mo;
}

+(BOOL) deleteArchive:(NSString *)archive;
{
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager deleteArchive"];
	
	ArchiveInfo *arch = [self findArchive:archive];
	if (arch==nil) return NO;
	
		// delete with CASCADE
	NSUInteger filesadded = 0;
	
	
	NSError *error;	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@ ",archive ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableDictionary *titlesToCheck = [[NSMutableDictionary alloc] init] ;
	
	for  (InstanceInfo *ii in fetchedObjects)
	{
			// delete the actual file from the file system 
		NSString *path = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
		[KORDataManager  removeItemAtPath:path error: &error];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path])
			NSLog (@"Error removing %@",path);
        
		NSString *temp =[NSString stringWithFormat:@"%@",ii.title];
		
		[context deleteObject:ii];
			// add to the dictionary of all titles that might need purging
		[titlesToCheck setObject:temp forKey:temp];
			//else NSLog (@"deleted file %@",path);
		
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion at %d",filesadded]];
        
	}
	[context deleteObject:arch];
	
		// make sure titles still have instances, else purge them
		//NSLog (@"checking titles %@",titlesToCheck);
	
	for (NSString *title in titlesToCheck)
		
	{
		[KORRepositoryManager titlePurgeCheck: title];
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion from titles check at %d",filesadded]];
		
	}
	
	[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"deleteArchive %@",archive,nil]];
	
	return YES;
}

+(NSArray *)rewriteListOfArchivesSequenceNums: (NSArray *) inMemory;
{
		// Align the list in Core Data to have sequence numbers that correspond to the listin memopry
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"RepositoryManager rewriteListOfArchivesSequenceNums"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *putb = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
	for (NSUInteger i=0; i<[fetchedObjects count]; i++)
		[putb addObject:[NSNumber numberWithShort:(32767-i)]];
	
	for (ArchiveInfo *ai in fetchedObjects)
	{
		NSUInteger index = [inMemory indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			NSString *s = (NSString *)[inMemory objectAtIndex:idx];
			
			if ([s isEqualToString:ai.archive]) 
			{ 
				*stop = YES; 
				return YES;
			}
			return NO;
		}];	
		
		NSLog (@"idx %d archive %@",index,ai.archive);
		ai.sequence = [NSNumber  numberWithShort: ( 1+index)];	
		[putb replaceObjectAtIndex:index withObject:[NSNumber  numberWithShort: ( 1+index)]];
	}
	[[KORAppDelegate sharedInstance] saveContext:@"rewriteListOfArchivesSequenceNums"];
	return putb;
	
}

+(BOOL) deleteTune:(NSString *) tune fromArchive:(NSString *)archive;
{
		// this is almost exactly the same code as above, it just finds the one tune by title
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager deleteTune"];
	
	ArchiveInfo *arch = [self findArchive:archive];
	if (arch==nil) return NO;
    NSUInteger filesadded = 0;
	NSError *error;	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@ && title == %@",archive,tune ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableDictionary *titlesToCheck = [[NSMutableDictionary alloc] init];
	
	for  (InstanceInfo *ii in fetchedObjects)
	{
			// delete the actual file from the file system 
		NSString *ipath = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
        NSString *path = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@", ipath];
		[KORDataManager  removeItemAtPath:path error: &error];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path])
			NSLog (@"Error removing %@",path);
        
		NSString *temp =[NSString stringWithFormat:@"%@",ii.title];
		
		[context deleteObject:ii];
			// add to the dictionary of all titles that might need purging
		[titlesToCheck setObject:temp forKey:temp];
			//else NSLog (@"deleted file %@",path);
		
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion at %d",filesadded]];
        
	}
		// One big difference here is that we are not deleting the archive itself, no matter even if there are no tunes
    
	
		// make sure titles still have instances, else purge them
		//NSLog (@"checking titles %@",titlesToCheck);
	
	for (NSString *title in titlesToCheck)
		
	{
		[KORRepositoryManager titlePurgeCheck: title];
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion from titles check at %d",filesadded]];
		
	}
	
	[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"deleteTune %@",archive,nil]];
	
	return YES;
}

+(BOOL) deleteTuneFromAllArchives:(NSString *) tune;
{
		// this is almost exactly the same code as above, it just finds the one tune by title
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager deleteTuneFromAllArchives"];
    
    NSUInteger filesadded = 0;
	NSError *error;	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@"title == %@",tune ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableDictionary *titlesToCheck = [[NSMutableDictionary alloc] init];
	
	for  (InstanceInfo *ii in fetchedObjects)
	{
			// delete the actual file from the file system 
		NSString *ipath = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
        NSString *path = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@", ipath];
		[KORDataManager  removeItemAtPath:path error: &error];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path])
			NSLog (@"Error removing %@",path);
        
		NSString *temp =[NSString stringWithFormat:@"%@",ii.title];
		
		[context deleteObject:ii];
			// add to the dictionary of all titles that might need purging
		[titlesToCheck setObject:temp forKey:temp];
			//else NSLog (@"deleted file %@",path);
		
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion at %d",filesadded]];
        
	}
		// One big difference here is that we are not deleting the archive itself, no matter even if there are no tunes
    
	
		// make sure titles still have instances, else purge them
		//NSLog (@"checking titles %@",titlesToCheck);
	
	for (NSString *title in titlesToCheck)
		
	{
		[KORRepositoryManager titlePurgeCheck: title];
		
		filesadded++;	
		if ((filesadded/50)*50==filesadded)
			[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"small batch deletion from titles check at %d",filesadded]];
		
	}
	
	[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"deleteTuneFromAllArchives "]];
	
	return YES;
}

+(BOOL) moveTune:(NSString *)title fromarchive:(NSString *)fromarchive toarchive:(NSString *)toarchive ;
{
    
    NSLog (@"moveTune:%@  from:%@  to:%@",title , fromarchive, toarchive);
    
    
		// first fix the instances
    NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager moveTune"];
	
	ArchiveInfo *arch = [self findArchive:fromarchive];
	if (arch==nil) return NO;
    
	NSError *error;	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"InstanceInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@ && title == %@",fromarchive,title  ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	for  (InstanceInfo *ii in fetchedObjects)
	{
        
        ii.archive = toarchive;
    }
    
	NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity2 = [NSEntityDescription 
                                    entityForName:@"ClumpInfo" inManagedObjectContext:context];
	
	[fetchRequest2 setEntity:entity2];
	NSPredicate *somePredicate2 = [NSPredicate predicateWithFormat:@" lastArchive == %@ && title == %@",fromarchive,title  ];
	[fetchRequest2 setPredicate:somePredicate2];
	
	NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest2 error:&error]; //yikes !!!
	
	for  (ClumpInfo *ti in fetchedObjects2)
	{
        
        ti.lastArchive = toarchive;
    }
    
    [context save: &error];
    return YES;
    
}
+(ArchiveHeaderInfo *) findArchiveHeader: (NSString *)archive forType: (NSString *)type ;
{
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager findArchiveHeader"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ArchiveHeaderInfo" inManagedObjectContext:context];
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" archive == %@ && extension == %@",  archive,type ];
	[fetchRequest setPredicate:somePredicate];
	
	
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findArchiveHeader error %@",error);
		return nil;
	}
	
	if ([fetchedObjects count]>0) 
		return (ArchiveHeaderInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
}

+(ArchiveHeaderInfo *) insertArchiveHeader:(NSString *)archive headerHTML:(NSString *)headerHTML forType:(NSString *)extension ;
{
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"KORRepositoryManager insertArchiveHeader"];
	ArchiveHeaderInfo *ahi = [NSEntityDescription
                              insertNewObjectForEntityForName:@"ArchiveHeaderInfo" 
                              inManagedObjectContext:context];
	
	
	ahi.archive = archive;
	ahi.extension = extension;
	ahi.headerHTML = headerHTML;
    
	return ahi;
}
	////// these came from Archives Helper
#pragma mark Function or Subroutine Based Methods

+(NSString *)nameForOnTheFlyArchive
{
	return [self sharedRepository].otfarchive;
}


+(NSString *) shortName: (NSString * ) s
{
	NSArray *arr = [s componentsSeparatedByString:@"-"] ;//042511 removed it again 042311 added autorelease
    
	NSString *ss = (NSString *)[arr objectAtIndex:0]; // just take first component
	
	NSUInteger shortlen = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)? 9: 12;
	if ([ss length]<=shortlen) return ss;	
	return	[ss substringToIndex:shortlen];
	
}
+(NSString *) headerdataFromArchive: (NSString *) archive type: (NSString *) extension;
{
	ArchiveHeaderInfo *ahi = [self findArchiveHeader:archive forType:extension];
	return ahi.headerHTML;
}

+(double) fileSize: (NSString *) archive;
{		//MUST MODIFY FOR COREDATA
	
	ArchiveInfo *ai = [self findArchive:archive];
	unsigned long long ull = ([ai.size unsignedLongLongValue]);
	
	double mb = (double)ull	; // make this a double
	
	mb = mb/(1024.f*1024.f); // Convert to MB
	
	return mb;
}

+(BOOL) isArchiveEnabled: (NSString *) archive;
{			
	ArchiveInfo *ai = [self findArchive:archive];
	NSNumber *booly = ai.enabled ;
	return [booly boolValue];
	
}
+(void) setArchiveEnabled:(BOOL) b forArchiveName: (NSString *) archive;
{		
	ArchiveInfo *ai = [self findArchive:archive];
	NSNumber *booly2 = [NSNumber numberWithBool:b];
	ai.enabled = booly2;
	
}
+(NSUInteger ) fileCount: (NSString *) archive;
{
	
	ArchiveInfo *ai = [self findArchive:archive];
	return [ai.fileCount intValue];
}
+(void ) bumpFileCount: (NSString *) archive;
{
	
	ArchiveInfo *ai = [self findArchive:archive];
    
	NSUInteger newcount =  [ai.fileCount intValue] + 1;
    
    ai.fileCount = [NSNumber numberWithUnsignedInteger:    newcount];
    
}
+(NSString *) archiveThumbnailSpec :(NSString *) archive
{
	
	ArchiveInfo *ai = [self findArchive:archive];
	return ai.logo;
	
}

+(UIImage *) makeArchiveThumbnail:(NSString *) archive;
{
	
	ArchiveInfo *ai = [self findArchive:archive];
	
	if ( [ai.logo length] > 5 ) // make sure there's something real in there
	{
		NSString *fullPathToMainImage = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,ai.logo] ;
		
		return [KORDataManager makeThumbFromFullPathOrResource:fullPathToMainImage  forMenu:@"MAINMENU"
														  ];
	}
	else {
		
		
		return     [KORDataManager makeThumbFromFullPathOrResource:
					@"MusicStand_72x72.png" forMenu:@"MAINMENU"// make sure this fails
															  ];
	}
}
#pragma mark Object Based Methods
+(NSString *) extractTitle:(NSString*) longtitle
{	// an actual source file
	NSArray *arr = [NSArray arrayWithObject: longtitle];										
	NSString *htitle = (NSString *)[arr objectAtIndex:0]; // just take first component
														  // expand hungarian
	NSString *ptitle =[KORDataManager cleanupIncomingTitle:htitle];
		// //// ignore everythig after first dash -- this seems to be working well
	NSArray *arr2 = [ptitle componentsSeparatedByString:@"-"];
	NSString *title0 = (NSString *)[arr2 objectAtIndex:0];
	return title0;
}

+(void) parseAndAdd: (NSString *)pathtoremember title:(NSString *)longtitle
{
	
		//trim
	
	
	
	NSString *title0 = [self extractTitle:longtitle ];
    
    
	
	if ([title0 length]>0) // make sure there's really something there
	{
		NSArray *parts = [pathtoremember componentsSeparatedByString:@"/"];
		NSString *parchive = [parts objectAtIndex:0];
		NSString *pfilepath = pathtoremember;//111111 [parts objectAtIndex:1];//must change
		
			// Just add this right in							
		
		[KORRepositoryManager insertTuneUnique: title0 lastArchive:parchive lastFilePath:pfilepath];
			// even if that was a dupe, add an instance record
		
		[KORRepositoryManager insertInstanceUnique :title0  archive: parchive filePath:pfilepath];	
	}
}


#pragma mark  Once Only Startup Code for Building In Memory Stuctures
+(void) saveImageToOnTheFlyArchive:  (UIImage *) image title:(NSString *)title0;
{	
	NSDate *datenow = [NSDate date];
	NSString *dateString = [datenow description];
		// this **dateString** string will have **"yyyy-MM-dd HH:mm:ss +0530"**
	NSArray *arr = [dateString componentsSeparatedByString:@" "];
	NSString *date = [arr objectAtIndex:0];
	NSString *time = [arr objectAtIndex:1];
	
	NSString *hh = [time substringToIndex:2];
	NSString *mm = [[time substringFromIndex:3]substringToIndex:2];
	NSString *ss = [[time substringFromIndex:6]substringToIndex:2];
	
		// arr will have [0] -> yyyy-MM-dd, [1] -> HH:mm:ss, [2] -> +0530 (time zone)
		// 111111 changed to include the archive in the filepath
	NSString *filepath = [NSString stringWithFormat:  @"%@/%@%@%@-screenshot-%@-%4.0f-%4.0f.png", [KORRepositoryManager nameForOnTheFlyArchive],
						  hh,mm,ss,date,image.size.width,image.size.height];
	NSString *topath= [[KORPathMappings pathForSharedDocuments] stringByAppendingPathComponent:filepath];
	
	NSData *imageData = UIImagePNGRepresentation(image);
	if (imageData != nil) {
		
		[imageData writeToFile:topath atomically:YES];		
		
		[KORRepositoryManager insertTuneUnique: title0 lastArchive:[self nameForOnTheFlyArchive] lastFilePath:filepath];//must change
			// even if that was a dupe, add an instance record
		[KORRepositoryManager insertInstanceUnique :title0  archive:[self nameForOnTheFlyArchive] filePath:filepath];//must change
        [self bumpFileCount:@"onthefly-archive"];
		[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"saveImageToOnTheFlyArchive %@",title0,nil]];
		
	}
	
}
+(void) copyFromInboxToOnTheFlyArchive: (NSString *) path  ofType:(NSString *) ttt withName:(NSString *) xname;
{
	NSError *error;
    NSString *name = [xname stringByDeletingPathExtension];
	
	NSString *xxname = [NSString stringWithFormat:@"%@/%@",[KORRepositoryManager nameForOnTheFlyArchive],xname];
	NSString *topath = [[KORPathMappings pathForOnTheFlyArchive] 
						stringByAppendingPathComponent:xname];
	BOOL success = [[NSFileManager defaultManager] copyItemAtPath:path
														   toPath:topath
															error:&error];
	if (!success) 
		NSLog (@"copyFromInboxToOnTheFlyArchive %@ returns %@", xxname,error.localizedDescription);
	
	else {
			//		NSString *longtitle   = [[path  stringByDeletingPathExtension] lastPathComponent];
			//		
			//		NSString *title0 = [self extractTitle:longtitle];
		
		[KORRepositoryManager insertTuneUnique: name lastArchive:[self nameForOnTheFlyArchive] lastFilePath:xxname];//must change
			// even if that was a dupe, add an instance record
		[KORRepositoryManager insertInstanceUnique :name  archive:[self nameForOnTheFlyArchive] filePath:xxname];	//must change
        
        [self bumpFileCount:@"onthefly-archive"];
		
		[[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"copyFromInboxToOnTheFlyArchive %@",xxname,nil]];
		
	}
}


+(NSUInteger) convertDirectoryToArchive:(NSString *) archive ;
{
	[self insertArchiveUnique: archive];///////111211 -- merge archives with identical names
	
	ArchiveInfo *ai = [self findArchive:archive];
	ai.enabled = [NSNumber numberWithBool:YES]; 
	ai.logo = @""; 
	ai.fileCount = [NSNumber numberWithUnsignedInt:0]; 
	ai.size = [NSNumber numberWithUnsignedLongLong:0];
	ai.provenanceHTML = @"";
	
	
	NSString *file;
	NSString *bigpath;
	NSUInteger filesadded = 0;
	unsigned long long size=0;
	
	bigpath = [KORPathMappings pathForArchive: archive];
    NSLog (@"*********convertDirectoryToArchive %@ bigpath %@",archive,bigpath);
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: bigpath];
	
		// segregate the files
	while ((file = [dirEnum nextObject]))
	{
		NSArray *parts = [file componentsSeparatedByString:@"/"];
			// skip these stinky MCOS directories that show up when jpgs are present
		
		NSDictionary *attrs = [dirEnum fileAttributes];
			//    	NSString *bigpathfile = [NSString stringWithFormat:@"%@/%@",bigpath, file];
		NSString *pathtoremember = [NSString stringWithFormat:@"%@/%@",archive, file];
			//		
			// count total size of all files scanned
		NSNumber *fs = [attrs objectForKey:@"NSFileSize"];		
		NSString *ftype = [attrs objectForKey:@"NSFileType"]; 
		
			//	NSLog (@"expandir %@ type %@",pathtoremember, ftype);
		if ([NSFileTypeRegular isEqualToString:ftype]&&([parts count] ==1 ))
		{
				// if the file starts with a ., like .DS_Store, just skip it
			if (!  ([@"." isEqualToString:[file substringToIndex:1]] || [@"_plist" isEqualToString:[file substringToIndex:6]] 
					|| [@"Inbox" isEqualToString:[file substringToIndex:5]]))
			{
				NSRange range = [file rangeOfString:@"-thumbnail.png"];// our own inserted thumbnail?
				if (range.location == NSNotFound)
				{
						//seems good to go
					size += [fs longLongValue];
					NSString *longtitle   = [[file stringByDeletingPathExtension] lastPathComponent]; 
						// if it's a special file then handle tharchiveat
					if ([@"--logo--" isEqualToString:longtitle])
					{
							// only remember the last of these
						NSString *logopath = [NSString stringWithFormat:@"%@/%@",archive, file];
							// just stash the filespec for anyone who wants it// assume no logo							
						ai.logo = logopath;		
					}
					else 
						if ([@"--header--" isEqualToString:longtitle])
						{
								// remember all of these 
							NSString *filetype = [file pathExtension];
							NSString *fullpath = [NSString stringWithFormat:@"%@/%@/%@",[KORPathMappings pathForSharedDocuments], archive, file];
								// just stash  the contents of this for anyone who wants it
							NSError *error=nil;
							NSStringEncoding encoding;
								//	NSLog (@"reading header %@", fullpath);
							NSString *headerdata = [NSString stringWithContentsOfFile: fullpath usedEncoding:&encoding error: &error ];
							if (error)
							{
								NSLog (@"archiveheader path %@  error %@",fullpath,  [error localizedDescription]);
							}
							else 
							{
								if([headerdata length]>10) // ensure some heft
									
									[self insertArchiveHeader:archive  headerHTML:headerdata forType:filetype];
							}
						}
						else 	if ([@"--info--" isEqualToString:longtitle])
						{
								// remember all of these 
							NSString *xfullpath = [NSString stringWithFormat:@"%@/%@/%@",[KORPathMappings pathForSharedDocuments], archive, file];
							NSError *xerror=nil;
							NSStringEncoding xencoding;
								//	NSLog (@"reading header %@", fullpath);
							NSString *infopagedata = [NSString stringWithContentsOfFile: xfullpath usedEncoding:&xencoding error: &xerror ];
							if (xerror)
							{
								NSLog (@"archiveinfopage path %@  error %@",xfullpath, [xerror localizedDescription]);
								
							}
							else {
								ai.provenanceHTML = infopagedata;
								if  ([infopagedata length]>10) // ensure some heft
									ai.provenanceHTML = infopagedata;
							}
						}
						else 
						{
								// a normal file, just gets added
                            
                            NSString *pathextension = [pathtoremember pathExtension];
							NSUInteger parts1 = [[pathtoremember componentsSeparatedByString:@"-thumb.png"] count];
                            NSUInteger parts2 = [[pathtoremember componentsSeparatedByString:@"-thumbvideo.png"] count];
                            NSUInteger parts3 = [[pathtoremember componentsSeparatedByString:@"-thumbweb.png"] count];
							NSUInteger parts4 = [[pathtoremember componentsSeparatedByString:@"-fallback.png"] count];
                            
                            
                            if(
							   (parts1!=1)||(parts2!=1)||(parts3!=1)||(parts4!=1)
							   
							   )
                            { 
									// SKIP:dont add thumbnails into main index
                            }
                            else
                                if ([@"ihtml" isEqualToString:pathextension]){ 
										// SKIP: dont add ihtml files either
                                }
                            
                                else
                                {
									
										//NSLog (@"***********parseAndAdd:%@ title:%@",pathtoremember,longtitle);
                                    [self parseAndAdd:pathtoremember title:longtitle];
                                    
                                    filesadded++;	
                                    if ((filesadded/50)*50==filesadded)
                                        [[KORAppDelegate sharedInstance] saveContext:[NSString stringWithFormat:@"Small Batch Assimilation at %d",filesadded]];
                                }
						}
					
				}	
			}
		}
	}	
	
	ai.fileCount = [NSNumber numberWithUnsignedInt:filesadded];
	ai.size = [NSNumber numberWithUnsignedLongLong:size];	
	return filesadded; 
}

#pragma mark database initialization and recovery
+(void) setupDB;
{
	
	[KORRepositoryManager insertGBInfo]; // push initial values in there 
	ArchiveInfo *ai = [self insertArchiveUnique: [self nameForOnTheFlyArchive]];
	NSString *logopath = [NSString stringWithFormat:@"%@/%@",[self nameForOnTheFlyArchive], @"--logo--.jpg"];
//		// just stash the filespec for anyone who wants it// assume no logo	
//    
	ai.logo = logopath;	
	ai.provenanceHTML = @"";
	
	[KORListsManager insertListUnique:@"favorites"];
	[KORListsManager insertListUnique:@"recents"];
    [self bumpFileCount:[self nameForOnTheFlyArchive]];	
	[[KORAppDelegate sharedInstance] saveContext:@"setupDB"];
	
}
+(void)setupFS
{
		// the primary directory is created in the appdelegate as part of booting up the sqlite db for CoreData
	
	NSString *otfDir = [KORPathMappings pathForOnTheFlyArchive];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:otfDir])
	{
		NSLog (@"Creating %@ directory",otfDir);
		[[NSFileManager defaultManager] createDirectoryAtPath:[KORPathMappings pathForOnTheFlyArchive] withIntermediateDirectories:NO attributes:nil error:nil];
		if (![[NSFileManager defaultManager] fileExistsAtPath:[KORPathMappings pathForOnTheFlyArchive]])
			NSLog (@"Could not create %@ directory",otfDir);
		else
		{
            NSLog (@"Created %@ directory",otfDir);
            
            
//            NSString *readmesrc = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"readme.html"];
//			NSString *readmedest = [[KORPathMappings pathForOnTheFlyArchive] stringByAppendingPathComponent:@"readme.html"];
			NSString *logosrc = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"onthefly.jpg"] ;
			NSString *logodest = [[KORPathMappings pathForOnTheFlyArchive] stringByAppendingPathComponent:@"--logo--.jpg"];
            
//            NSData *readmebytes = [[NSFileManager defaultManager] contentsAtPath:readmesrc ];
//            
//            [[NSFileManager defaultManager] createFileAtPath:readmedest contents:readmebytes attributes:nil];
//            if (![[NSFileManager defaultManager] fileExistsAtPath:readmedest])
//                NSLog (@"Could not create dest readme at %@",readmedest);
            
            NSData *logobytes = [[NSFileManager defaultManager ] contentsAtPath:logosrc];
            
            [[NSFileManager defaultManager] createFileAtPath:logodest contents:logobytes attributes:nil];
            if (![[NSFileManager defaultManager] fileExistsAtPath:logodest])
                NSLog (@"Could not create dest logo at %@",logodest);
            
			
		}
	}
	else NSLog (@"Not Creating %@ directory",otfDir);
	
	NSString *tp = [KORPathMappings pathForThumbnails];
	if (![[NSFileManager defaultManager] fileExistsAtPath:tp]) {
		
		NSLog (@"Creating %@ directory",tp);
		[[NSFileManager defaultManager] createDirectoryAtPath:tp
								  withIntermediateDirectories:NO attributes:nil error:nil];
		if (![[NSFileManager defaultManager] fileExistsAtPath:tp])
			NSLog (@"Could not create %@ directory",tp);
		
	}
	else  NSLog (@"Not Creating %@ directory",tp);
	
}

+(void) buildNewDB;

{	
    
	
	NSLog (@"setupFS commencing..."); 
	[self setupFS];	
	NSLog (@"setupFS finished...");
	
	NSLog (@"setupDB commencing...");
	[self setupDB]; 
	NSLog (@"setupDB finished...");
	
    
}

+(unsigned long long) totalFileSystemSize;
{
	unsigned long long totalsize = 0;
	
	for (ArchiveInfo *ai in [self allArchivesObjs	])
	{	
		totalsize += [ai.size unsignedLongLongValue];		
	}	
	return totalsize;
	
}



@end
