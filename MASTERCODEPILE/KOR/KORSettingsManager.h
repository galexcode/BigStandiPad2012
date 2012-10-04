//
//  CommonSettingsManager.h
//  
//
//  Created by bill donner on 7/20/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//



@interface KORSettingsManager : NSObject
{
@private
    
    __unsafe_unretained NSDictionary   *bundleInfo_;
    NSDictionary   *environment_;//
    __unsafe_unretained NSUserDefaults *userDefaults_;
}

@property (nonatomic, assign, readonly) NSDictionary   *bundleInfo;
@property (nonatomic, retain, readonly) NSDictionary   *environment;
@property (nonatomic, assign, readonly) NSUserDefaults *userDefaults;

@property (nonatomic, assign, readonly)  BOOL            disableMediaPlayer;
@property (nonatomic, assign, readonly)  BOOL            debugTrace;

@property (nonatomic, assign, readonly) NSString        *plistForCustomSettings;




+ (KORSettingsManager *) sharedInstance;


- (NSDictionary *) readOnlySettingsDictionary;

- (NSDictionary *) readWriteSettingsDictionary;

- (void) synchronizeReadWriteSettings;

- (BOOL) disableMediaPlayer;

- (NSString *) dbVersionString;
@end
