//
//  LogManager.m
// BigStand
//
//  Created by bill donner on 3/17/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORLogManager.h"
#import "KORDataManager.h"
#define LOG_FILES 2

@implementation KORLogManager
@synthesize dummy,logfilespecs;

-(id) init
{
	self = [super init];
	if (self)
	{	
		if ([KORDataManager globalData].inSim == NO)
		{
		// get these just right
		logfilespecs = [[NSMutableArray alloc] initWithCapacity:LOG_FILES];
		NSString *path1 = [NSString stringWithFormat:@"%@/tmp/stderr%d.txt",NSHomeDirectory(),0];
		NSString *path2 = [NSString stringWithFormat:@"%@/tmp/stderr%d.txt",NSHomeDirectory(),1];
		NSDate* fileDate1;
		NSDictionary* attr1 = [[NSFileManager defaultManager] attributesOfItemAtPath:path1 error:NULL];
			fileDate1 = (NSDate*)[attr1 objectForKey:NSFileModificationDate];
			if( !fileDate1 ) 
			{
				fileDate1 = [NSDate distantPast];
			}
		NSDate* fileDate2;
		NSDictionary* attr2 = [[NSFileManager defaultManager] attributesOfItemAtPath:path2 error:NULL];
		fileDate2 = (NSDate*)[attr2 objectForKey:NSFileModificationDate];
		if( !fileDate2 ) 
		{
			fileDate2 = [NSDate distantPast];
		}
		
		if ([fileDate1 laterDate:fileDate2])
		{ 
			// path1 is oldest
			NSLog (@"%@ with date %@ has later date than %@ with date %@", 
				                                   path1,fileDate1,path2,fileDate2);
			[logfilespecs addObject:path2];
			[logfilespecs addObject:path1];
		}
		else 
		{
			//path 2 is oldests			
			NSLog (@"%@ with date %@ has earlier date than %@ with date %@", 
				                                    path1,fileDate1,path2,fileDate2);
			[logfilespecs addObject:path1];
			[logfilespecs addObject:path2];			
		}
		
		NSLog (@"Logs are init as %@",logfilespecs);
		
		NSString *temp = [logfilespecs lastObject];
		
		freopen([temp fileSystemRepresentation], "a+", stderr); // clear log
		}
	}
	return self;
}


+(void) setup
{
	[KORLogManager sharedInstance].dummy = 1;
}
+ (KORLogManager *) sharedInstance;
{
	static KORLogManager *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[KORLogManager alloc] init];		
	}	
	return SharedInstance;
}
+(NSString *) pathForCurrentLog
{
	if ([KORDataManager globalData].inSim == NO)
	return [[KORLogManager sharedInstance].logfilespecs objectAtIndex:0];
	else return nil;
}
+(NSString *) pathForPreviousLog
{
	if ([KORDataManager globalData].inSim == NO)
	return [[KORLogManager sharedInstance].logfilespecs objectAtIndex:1]; //  this is the 2nd to last
	else return nil;
}
+(void) clearCurrentLog
{
	if ([KORDataManager globalData].inSim == NO)
	[KORLogManager rotateLogs]; else
		return;
	//freopen([[LogManager pathForCurrentLog] fileSystemRepresentation], "w+", stderr); // clear log
}
+(void) rotateLogs
{
	//NSArray *old = [NSArray arrayWithArray:[LogManager sharedInstance].logfilespecs];
		if ([KORDataManager globalData].inSim == NO)
		{
	NSString *temp = [[KORLogManager sharedInstance].logfilespecs lastObject];	
	freopen([temp fileSystemRepresentation], "a+", stderr); // clear log
	[[KORLogManager sharedInstance].logfilespecs insertObject:temp atIndex:0];
	[[KORLogManager sharedInstance].logfilespecs removeLastObject];
		}
	//NSLog (@"Logs were %@ rotated to %@",old,[LogManager sharedInstance].logfilespecs);
}
@end
