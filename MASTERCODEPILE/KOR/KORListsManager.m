//
//  SetListsManager.m

//
//  Created by Bill Donner on 4/11/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORPathMappings.h"
#import "KORAppDelegate.h"
#import "ListItemInfo.h"
#import "ListInfo.h"

#pragma mark -
#pragma mark Public Class SetListsManager
#pragma mark -
@interface KORListsManager ()


+ (KORListsManager *) sharedInstance;


// setlist support

+(ListInfo *) findList:(NSString *)listName;

@property (nonatomic) NSInteger dummy;
@end
@implementation KORListsManager
@synthesize dummy;
+(void) setup
{
	[self sharedInstance].dummy = 1;
}
+ (KORListsManager *) sharedInstance;
{
	static KORListsManager *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[self alloc] init];
		
	}
	
	return SharedInstance;
}

#pragma mark Public Class Methods
+(void) dump;
{
	for (NSString *s in [[self class] makeSetlistsScan])
	{
		NSUInteger count = [[self class] itemCountForList:s];
		NSLog (@"LIST %@ count %d",s,count);
		if (count>0){
		
		NSDictionary *stuff = [self listOfTunes:s ascending:YES];
		NSLog (@"  STUFF %@",stuff);
		}
}
}

#pragma mark Function or Subroutine Based Methods

+(NSArray *)rewriteListOfListsSequenceNums: (NSArray *) inMemory;
{
		// Align the list in Core Data to have sequence numbers that correspond to the listin memopry
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager rewriteListOfListsSequenceNums"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *putb = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
	for (NSUInteger i=0; i<[fetchedObjects count]; i++)
		[putb addObject:[NSNumber numberWithShort:(32767-i)]];
	for (ListInfo *li in fetchedObjects)
	{
		NSUInteger index = [inMemory indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			NSString *s = (NSString *)[inMemory objectAtIndex:idx];
			if ([s isEqualToString:li.listName]) 
			{ 
				*stop = YES; 
				return YES;
			}
			return NO;
		}];	
			//NSLog (@"rewrite %@ is index %d",lii.title,index);
		li.sequence = [NSNumber  numberWithShort: ( 1+index)];	
		[putb replaceObjectAtIndex:index withObject:[NSNumber  numberWithShort: ( 1+index)]];
	}
	[[KORAppDelegate sharedInstance] saveContext:@"rewriteListOfListsSequenceNums"];
	
		//NSLog (@"new seqs are %@",putb);
	return putb;
	
}
+(NSMutableArray *) makeSetlistsScan
{	
	// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager makeSetlistsScan"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"makeSetlistsScan error %@",error);
		return nil;
	}
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity: [fetchedObjects count]];
	for (ListInfo *li in fetchedObjects)
		[putb	addObject:li.listName];
		//[putb sortUsingSelector:@selector(compare:)];
	return putb; // 042511 instruments made me do it
}
+(NSMutableArray *) makeSetlistsScanNoRecents;
{

	
	// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager makeSetlistsScanNoRecents"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"makeSetlistsScanNoRecents error %@",error);
		return nil;
	}
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity: [fetchedObjects count]];
	for (ListInfo *li in fetchedObjects)
		if (![li.listName isEqualToString:@"recents"])
			[putb	addObject:li.listName];
	
	[putb sortUsingSelector:@selector(compare:)];
	return putb; // 042511 instruments made me do it
}

+(NSMutableArray *) makeSetlistsScanNoRecentsOrFavorites;
{
	
	
		// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager makeSetlistsScanNoRecents"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"makeSetlistsScanNoRecents error %@",error);
		return nil;
	}
	NSMutableArray *putb = [[NSMutableArray alloc] initWithCapacity: [fetchedObjects count]];
	for (ListInfo *li in fetchedObjects)
		if (!([li.listName isEqualToString:@"recents"] ||[li.listName isEqualToString:@"favorites"]))
			[putb	addObject:li.listName];
	
	[putb sortUsingSelector:@selector(compare:)];
	return putb; // 042511 instruments made me do it
}

#pragma mark plist save and restore for favorites, recents, setlists 

+(ListItemInfo *) findListItem:(NSString *)title onList:(NSString *)listName;
{
	
	// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager findListItem"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ && title == %@ ",listName,title ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findListItem error %@",error);
		return nil;
	}
	if ([fetchedObjects count]>0) 
		return (ListItemInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
	
}
+(NSUInteger)  itemCountForList:(NSString * ) listName  ; 
{
	
	// with Core Data
	
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager itemCountForList"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];
	
	NSUInteger count = [context countForFetchRequest:fetchRequest error:&error];
	//[somePredicate release]; //042511 was now zombie 042311 instruments says leaking
;
	/////////////
	////////////
	
	return count;
}

+(NSDictionary *) listOfTunes: (NSString * ) listName  ascending:(BOOL) ascending; 
{
	// Do it with Core Data
	NSDictionary *d = [NSMutableDictionary dictionary];
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager listOfTunes"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];
	
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"listOfTunes error %@",error);
		return nil;
	}
	
	NSMutableArray *putb  = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
	
	NSMutableArray *putc  = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
	
	for (ListItemInfo *lii in fetchedObjects)
	{
		[putb addObject:lii.title];
		[putc addObject:lii.sequence];
	}
	[d setValue:putb forKey:@"tunes"];
	
	[d setValue:putc forKey:@"sequences"];
	
	
	
	return d;
}
+(NSString *) lastTuneOn: (NSString * ) listName  ascending:(BOOL) ascending;
{
		// wld 09/23/12 - added to find newest item on recents
	
		// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager lastTuneOn"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];
  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sequence" ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error)
			NSLog (@"listOfTunes error %@",error);
		return nil;
	}
	
	
	for (ListItemInfo *lii in fetchedObjects)
	{
		return lii.title;
	}
	return nil;
}

+(NSString *) parseLineToTile: (NSString *) aline
{
    // returns nil if it doesn't parse
    // strip comment lines
NSArray* components = 
    [aline componentsSeparatedByString:@"##"];
  //  NSLog (@"aline %@ components %@", aline,components);
    NSString *first = [components objectAtIndex:0]; 
    if ([first length]==0) return nil;
    // now strip optional prefix line number
    NSArray *comp2 = [first componentsSeparatedByString:@"."];
    NSString *rest = ( [comp2 count] == 1) ?
    [[comp2 objectAtIndex:0] copy]:
    [[comp2 objectAtIndex:1] copy];
    NSArray *comp3 = [rest componentsSeparatedByString:@"-"];
    NSString *rest2 = [comp3 objectAtIndex:0];
    
    
    NSString *stripped = [rest2  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return stripped; 
}

+(NSMutableArray *)listOfTunesFromFile: (NSString *) filePath;
{
    // read everything from text
    NSString* fileContents = 
    [NSString stringWithContentsOfFile:filePath 
                              encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* allLinedStrings = 
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *putb = [[NSMutableArray alloc] init ];
    //NSUInteger linecount = 0;
    
    for (NSString *aline in allLinedStrings)
    {
        NSString *oneline = [self parseLineToTile:aline];
        if (oneline) {
//        NSLog (@"line %-3d %@", ++linecount, oneline);
        [putb addObject: oneline];
        }
    }
    return putb;
}

+(ListItemInfo *) insertListItem:(NSString *)tune onList:(NSString *)listName top:(BOOL)onTop;
{
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager insertListItem"];
	
	
	ListItemInfo  *lii = [NSEntityDescription
						  insertNewObjectForEntityForName:@"ListItemInfo" 
						  inManagedObjectContext:context];
	
	lii.title = tune;
	lii.listName = listName;
	lii.insertTime = [NSDate date];
	lii.sequence = [NSNumber numberWithUnsignedShort:([KORListsManager itemCountForList:listName]+1)];
	
		// if top was set, this should go in at '1' and everything else can shuffle down
	
    
	[[KORAppDelegate sharedInstance] saveContext:@"insertListItem after"];
	return lii;
	
	
}
+(BOOL) removeOldestOnList:(NSString *)listName ;
{
    ListItemInfo *thislii = nil;
    NSDate *thisdate = [NSDate distantFuture];
    // Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager removeOldestOnList"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"insertTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"removeOldestOnList error %@",error);
		return NO;
	}
    for (ListItemInfo *lii in fetchedObjects)
        if ([lii.insertTime compare :  thisdate] < 0 )
        {
            thisdate = lii.insertTime;
            thislii = lii;
        }
    // ok delete this
    if (thislii == nil) return NO;
    
   // should remove loop above and replace with just this
   // thislii = fetchedObjects [0];
    
    [context deleteObject:thislii];
    
	[[KORAppDelegate sharedInstance] saveContext:@"removeOldestOnList"];
    return YES;
   
}
+(NSArray *)rewriteSetlistSequenceNums: (NSString *) listName inMemory:(NSArray *) inMemory;
{
		// Align the list in Core Data to have sequence numbers that correspond to the listin memopry
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager rewriteSequenceNums"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];	
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	NSMutableArray *putb = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
	for (NSUInteger i=0; i<[fetchedObjects count]; i++)
		[putb addObject:[NSNumber numberWithShort:(32767-i)]];
	for (ListItemInfo *lii in fetchedObjects)
        {
		 NSUInteger index = [inMemory indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
				NSString *s = (NSString *)[inMemory objectAtIndex:idx];
				if ([s isEqualToString:lii.title]) 
				{ 
					*stop = YES; 
					return YES;
				}
				return NO;
			}];	
				//NSLog (@"rewrite %@ is index %d",lii.title,index);
			lii.sequence = [NSNumber  numberWithShort: ( 1+index)];	
			[putb replaceObjectAtIndex:index withObject:[NSNumber  numberWithShort: ( 1+index)]];
        }
	[[KORAppDelegate sharedInstance] saveContext:@"rewriteSequenceNums"];
	
		//NSLog (@"new seqs are %@",putb);
	return putb;
	
}

+(void) updateTune:(NSString *)tune after: (NSString *) existing list: (NSString *) list;
{
  //  NSLog (@"updateTune %@ after %@ on list %@", tune,existing,list);
    ListItemInfo *liiafter = [self findListItem:existing onList:list];
    NSDate *d = liiafter.insertTime;
    NSDate *newdate = [d dateByAddingTimeInterval:(NSTimeInterval)1];
    ListItemInfo *lii = [self findListItem:tune onList:list];
    lii.insertTime = newdate; 
	[[KORAppDelegate sharedInstance] saveContext:@"updateTune after"];
}
+(void) updateTune:(NSString *)tune before: (NSString *) existing list: (NSString *) list;
{
  //  NSLog (@"updateTune %@ before %@ on list %@", tune,existing,list);
    ListItemInfo *liibefore = [self findListItem:existing onList:list];
    NSDate *d = liibefore.insertTime;
    NSDate *newdate = [d dateByAddingTimeInterval:(NSTimeInterval)-1];
    ListItemInfo *lii = [self findListItem:tune onList:list];
    lii.insertTime = newdate; 
    
	[[KORAppDelegate sharedInstance] saveContext:@"updateTune before"];
}

+(ListItemInfo *) insertListItemUnique:(NSString *)tune onList:(NSString *)listName top:(BOOL)onTop;
{
	ListItemInfo *lii = [self findListItem:tune onList:listName];
	if (!lii) 
	{
		// if the tune wasnt found
		lii =  [self insertListItem:tune onList: listName top:onTop];
	}
    
	[[KORAppDelegate sharedInstance] saveContext:@"insertListItemUnique before"];
	return lii;
}


//[SetListsManager removeTune:tune list:self->name];
+(BOOL) removeTune:(NSString *) tune list:(NSString *) list;
{
    NSLog (@"removeTune %@ from list %@", tune,list);
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager removeTune"];

    
    ListItemInfo *lii = [self findListItem:tune onList:list];
    if (lii==nil) return NO;
    [context deleteObject: lii];
    
	
	[[KORAppDelegate sharedInstance] saveContext:@"removeTune list"];
    return YES;
    
}
+(BOOL) renameTuneOnAllLists:(NSString *) oldTune newName:(NSString *) newTune;
{

	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager renameTuneOnAllLists"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" title == %@ ",oldTune ];
	[fetchRequest setPredicate:somePredicate];
    
	
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"renameTuneOnAllLists error %@",error);
		return NO;
	}
    for (ListItemInfo *lii in fetchedObjects)
			// fix these titles
        {
			lii.title = newTune;
        }

    
	[[KORAppDelegate sharedInstance] saveContext:@"renameTuneOnAllLists"];
    return YES;
	
	

}
+(ListInfo *) insertList:(NSString *)list;
{
	
	
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager insertListItemUnique"];
	
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSUInteger listscount = [[context executeFetchRequest:fetchRequest error:&error] count];

	ListInfo  *li = [NSEntityDescription
					 insertNewObjectForEntityForName:@"ListInfo" 
					 inManagedObjectContext:context];
	
	li.listName = list;
	li.creationTime = [NSDate date];
	li.sequence = [NSNumber numberWithShort:(listscount+1)];
    
    
	[[KORAppDelegate sharedInstance] saveContext:@"insertList list"];
	return li;
	
	
}
+(ListInfo *) findList:(NSString *)listName;
{
	
	// Do it with Core Data
	NSError *error;
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager findList"];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects == nil)
	{
		if (error) 
			NSLog (@"findList error %@",error);
		return nil;
	}
	if ([fetchedObjects count]>0) 
		return (ListInfo *)[fetchedObjects objectAtIndex:0];
	
	return nil;
	
}
+(ListInfo *) insertListUnique:(NSString *)list;
{
	ListInfo *li = [self findList:list];
	if (!li) 
	{
		// if the list wasnt found
		li =  [self insertList:list];
	}
    
    [[KORAppDelegate sharedInstance] saveContext:@"insertListUnique"];
	return li;
}

+(BOOL) deleteList:(NSString *)listName;
{
	NSManagedObjectContext *context =[[KORAppDelegate sharedInstance] managedObjectContext:@"SetListsManager deleteList"];
	
	ListInfo *li = [self findList:listName];
	if (li==nil) return NO;
	
	
	
	// delete with CASCADE
	
	
	NSError *error;	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"ListItemInfo" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	NSPredicate *somePredicate = [NSPredicate predicateWithFormat:@" listName == %@ ",listName ];
	[fetchRequest setPredicate:somePredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	for  (ListItemInfo *lii in fetchedObjects)
		[context deleteObject:lii];
	
	
	
	[context deleteObject:li];
    
    
    [[KORAppDelegate sharedInstance] saveContext:@"deleteList"];
	return YES;
}
+(NSString *) picSpecForList:(NSString *) listName;
{
	return @"setlistpic.jpg";
}
	
+(void) updateRecents:(NSString *)newtune;
{	
	// Do it with Core Data Instead
	ListItemInfo *lii = [self findListItem:newtune onList:@"recents"];
	if (lii==nil)
	{
		[self insertListItemUnique:newtune 
								 onList:@"recents" top:YES];
	}
	
	return;
	
} 
//[SetListsManager makeSetList: self->iname items:theseitems];
+(void) makeSetList :(NSString *)list items:(NSArray *) items;
{
    
    [self insertListUnique :list ];  // first shovel the list in there
    for (NSString *s in items)
    {
        [self insertListItemUnique:s onList:list top:NO];
    }
    
}

@end

