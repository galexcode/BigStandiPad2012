//
//  CommonSettingsManager.m
//  
//
//  Created by bill donner on 7/20/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//
#import "KORDictionaryAdditions.h"
#import "KORSettingsManager.h"


#pragma mark Internal Constants

//
// Keys for read/write NSUserDefaults settings:
//

//
// Keys for read-only Info.plist (LSEnvironment) settings:
//
#define DEBUG_TRACE_KEY					@"DebugTrace"
#define DISABLE_MEDIA_PLAYER_KEY        @"DisableMediaPlayer"

//
// Keys for read-only Info.plist settings:
//
#define BUNDLE_DISPLAY_NAME_KEY         @"CFBundleDisplayName"
#define BUNDLE_NAME_KEY                 @"CFBundleName"
#define BUNDLE_VERSION_KEY              @"CFBundleVersion"
#define ENVIRONMENT_VARIABLES_KEY       @"LSEnvironment"


#define CUSTOM_SETTINGS_KEY				@"CustomAppSettingsPlist"

#define DB_VERSION_KEY	 @"DBVersionKey"

@interface KORSettingsManager()


@end

@implementation KORSettingsManager

@synthesize bundleInfo               = bundleInfo_;

@synthesize userDefaults             = userDefaults_;
@dynamic disableMediaPlayer;

@dynamic plistForCustomSettings;

@dynamic debugTrace;
+ (KORSettingsManager *) sharedInstance
{
        static KORSettingsManager *SharedInstance;
    //    
        if (!SharedInstance)
           SharedInstance = [[self alloc] init];
       
        return SharedInstance;
    
}
- (BOOL) debugTrace
{
    return [self.environment boolForKey: DEBUG_TRACE_KEY];
}

- (BOOL) disableMediaPlayer;
{
    return [self.environment boolForKey: DISABLE_MEDIA_PLAYER_KEY];
}
- (NSDictionary *) readOnlySettingsDictionary
{
    return [NSDictionary dictionaryWithDictionary: self.environment];
}

- (NSDictionary *) readWriteSettingsDictionary
{
    return [self.userDefaults dictionaryRepresentation];
}

- (void) synchronizeReadWriteSettings
{
	[self.userDefaults synchronize];
}

- (NSDictionary *) environment
{
    if (!self->environment_)
    {
        self->environment_ = [self.bundleInfo dictionaryForKey: ENVIRONMENT_VARIABLES_KEY];
		
        if (!self->environment_)
            self->environment_ = [[NSDictionary alloc] init];
    }
	
    return self->environment_;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        self->bundleInfo_ = [[NSBundle mainBundle] infoDictionary];
        self->userDefaults_ = [NSUserDefaults standardUserDefaults];
        
    
    }
    return self;
}

- (NSString *) plistForCustomSettings
{
    NSString *s = [self.environment stringForKey: CUSTOM_SETTINGS_KEY];
	return s;
}
- (NSString *) dbVersionString
{
    NSString *s = [self.environment stringForKey: DB_VERSION_KEY];
	return s;
}


@end
