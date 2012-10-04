//
//  TunePrefsManager.m
// BigStand
//
//  Created by bill donner on 6/25/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

//
// hold things here temporarily in advance of moving to iCloud soon

#import "KORTunePrefsManager.h"
#import "KORPathMappings.h"

@interface KORTunePrefsManager()
@property (nonatomic,retain) NSMutableDictionary *dict;
@property (nonatomic,retain) NSString *dictFilePath;
@end
@implementation KORTunePrefsManager
@synthesize dict,dictFilePath;


+ (NSUInteger) prefUnsignedIntValueForKey:(NSString *) key forTune:(NSString *)tune;
{
    id obj = [[self cloudInstance].dict 
              valueForKey:[NSString stringWithFormat:@"%@--%@",tune,key]] ;
    if (obj == nil) return 0;
    return [obj unsignedIntValue];
}

+(void) addPref: (NSString *) key valueWithUnsignedInt:(NSUInteger) value forTune:(NSString *)tune;
{
    [[self cloudInstance].dict setObject:[NSNumber numberWithUnsignedInt: value] 
                                 forKey:[NSString stringWithFormat:@"%@--%@",tune,key]];
    
    [[self cloudInstance].dict writeToFile: [self cloudInstance].dictFilePath atomically:NO];
}

+ (BOOL) prefBoolValueForKey:(NSString *) key forTune:(NSString *)tune;
{
    id obj = [[self cloudInstance].dict 
              valueForKey:[NSString stringWithFormat:@"%@--%@",tune,key]] ;
    if (obj == nil) return NO;
    return [obj boolValue];
}

+(void) addPref: (NSString *) key valueWithBool:(BOOL) value forTune:(NSString *)tune;
{
    [[self cloudInstance].dict setObject:[NSNumber numberWithBool: value] 
                                 forKey:[NSString stringWithFormat:@"%@--%@",tune,key]];
    
   // NSError *error;
    
    [[self cloudInstance].dict writeToFile:[self cloudInstance].dictFilePath atomically:NO];
                              //  atomically:NO encoding:NSUTF8StringEncoding error:&error];
}

+ (KORTunePrefsManager *) cloudInstance;
{
	static KORTunePrefsManager *CloudInstance;
	
	if (!CloudInstance)
	{
		CloudInstance = [[self alloc] init];
		
	}
	
	return CloudInstance;
}
-(id) init
{
	self = [super init];
	if (self)
	{	
        
        dictFilePath = [[KORPathMappings pathForSharedDocuments] stringByAppendingString:@"/TunePrefs.plist"];
       
       
        
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:dictFilePath];
        if (dict==nil) 
        {
            // doesnt exist, so create one
      
                dict = [[NSMutableDictionary alloc] init];
                [dict writeToFile:dictFilePath atomically:YES];
                NSLog (@"wrote empty tuneprefs.plist is %@",dictFilePath);
        }
//        }
//        else
//             NSLog (@"location of tuneprefs.plist is %@ content %@",dictFilePath,dict );
       
	}
	return self;
}

@end
