	//
	//  DataManager.m
	//  MCProvider //
	//  Created by Bill Donner on 4/11/11.
	//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
	//

#import <QuartzCore/QuartzCore.h>
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "KORNetBadgeView.h"
#import "KORMisConfigurationController.h"
#import "KORAppDelegate.h"
#import "KORSettingsManager.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORZipArchive.h"
#import "KORRepositoryManager.h"


@interface KORDataManager() 
@property (nonatomic, retain) NSMutableDictionary *thumbsCache; // UIImages are stuffed into this
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@property (nonatomic, retain) MPMusicPlayerController *appMusicPlayer;


@end
#pragma mark -
#pragma mark Public Class DataManager
#pragma mark -

@implementation KORDataManager
@synthesize singleTouchEnabled,gigStandEnabled,showFullWidth,disableTopTitle,startupWaitingImage, actionSets,sessionDisplayTransactionCount;
@synthesize adHocDistroToFriendsOnly,allowRotations,nullView;
@synthesize streamingSources,mp3PlayerView,starttime;
@synthesize settingsVersion,minswVersion;
@synthesize initialPileFilter,lastMenuPresentedPrefix;
@synthesize applicationName;
@synthesize applicationVersion;
@synthesize topBackgroundColor;
@synthesize performanceColor;
@synthesize appBackgroundColor;
@synthesize thumbsCache;
@synthesize openingAlert;
@synthesize URLMappings,userEnteredEmail,buttonHelp;

@synthesize myLocalIP;
@synthesize myLocalPort;
@synthesize docInteractionController;
@synthesize appMusicPlayer;
@synthesize singleTouchFrame,singleTouchFrameLandscape,inSim,stripFirstTitleComponent,disableFooter,disableAppleHeader,transparentFooter;
@synthesize xMonitorView;
@synthesize colorsDict,actionsDict;
@synthesize specialButtonBindings;

	// display properties
@synthesize statusBarHeight;
@synthesize standardRowSize;
@synthesize navBarHeight;
@synthesize searchBarHeight;
@synthesize fullScreenTaps,fullScreenAlerts,fullScreenTimeout;
@synthesize toolBarHeight;
@synthesize activeArchives;
@synthesize startInFullScreenMode,colorBehindHTMLPages;

	//@synthesize emailTo,emailSubject,emailBody,appBanner;
@synthesize startPushButton,startPageTitle,startPopUpTitle,wantsIntroOverlay;
@synthesize titlesForHiddenPages;
@synthesize systemBarButtonImageNames;
@synthesize currentMenuPrefix;
@synthesize dropdownSettings,xibMappings,emailSettings,cornerNavSettings,absoluteSettings;

@synthesize oneTouchSemaphore;
#pragma mark Public Class Methods
+ (void)disallowOneTouchBehaviors;
{
	[KORDataManager globalData].oneTouchSemaphore=1;
}
+ (void)allowOneTouchBehaviors;
{
	[KORDataManager globalData].oneTouchSemaphore=0;
	
}

+ (void) showParamsInLog

{
	
	
	
}


+(NSNumber *) actionToTag:(NSString *)s
{
	NSNumber *num =  [[KORDataManager globalData].actionsDict objectForKey: s];
	if (num == nil) NSLog (@"actionToTag of %@ returned nil",s);
	return num;
	
}

-(UIColor *) colorFor:(NSString *)plistOption plistOptions:(NSDictionary *)cvcDict  otherwise:(UIColor *)defaultColor;
{
	UIColor *bc = [self.colorsDict objectForKey: [cvcDict objectForKey:plistOption]];
	if (bc == nil) bc = defaultColor; 
	return bc;
}


+(NSString *) lookupXib:(NSString *)xibPrefix;
{
	NSString *full = [[KORDataManager globalData].xibMappings objectForKey:xibPrefix ];					  
	return full;	
}
-(void) setupScreenwideOptions :(NSDictionary *)cvcDict barbuttons:(NSMutableDictionary *)barbuttonSystemItemsDict;
{
	
	
	
	
    if ([cvcDict objectForKey:@"OpeningAlert"] !=nil)
        self.openingAlert = [cvcDict objectForKey:@"OpeningAlert"] ;
	
    if ([cvcDict objectForKey:@"SettingsVersion"] !=nil)
        self.settingsVersion = [cvcDict objectForKey:@"SettingsVersion"] ;
	
    if ([cvcDict objectForKey:@"MinSwVersion"] !=nil)
        self.minswVersion = [cvcDict objectForKey:@"MinSwVersion"] ;
	if ([cvcDict objectForKey:@"AdHocDistroToFriendsOnly"] !=nil)
        self.adHocDistroToFriendsOnly = [[cvcDict objectForKey:@"AdHocDistroToFriendsOnly"] boolValue];
	
	if ([cvcDict objectForKey:@"StreamingSources"])
		self.streamingSources = [cvcDict objectForKey:@"StreamingSources"];
	
		// allow custom page titles in a dictionary
	if ([cvcDict objectForKey:@"TitlesForHiddenPages"])
		self.titlesForHiddenPages = [cvcDict objectForKey:@"TitlesForHiddenPages"];
	
	
	if ([cvcDict objectForKey:@"ActionSets"])
		self.actionSets = [cvcDict objectForKey:@"ActionSets"]; 
	else 
		self.actionSets =[NSDictionary dictionary]; // dummy it up if not supplied
	
	
	NSDictionary *appDict;
	
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))   
	{
		if ([cvcDict objectForKey:@"iPadAbsolutePositions"] !=nil)
			self.absoluteSettings = [cvcDict objectForKey:@"iPadAbsolutePositions"];
		
		if ([cvcDict objectForKey:@"iPadMenuSettings"] !=nil)
			self.dropdownSettings = [cvcDict objectForKey:@"iPadMenuSettings"];
		
		
		if ([cvcDict objectForKey:@"iPadCornerNavSettings"] !=nil)
			self.cornerNavSettings = [cvcDict objectForKey:@"iPadCornerNavSettings"];
		
		
		if ([cvcDict objectForKey:@"iPadSpecialButtonBindings"] !=nil)
			self.specialButtonBindings = [cvcDict objectForKey:@"iPadSpecialButtonBindings"];
		
		
		if ([cvcDict objectForKey:@"iPadXibs"] !=nil)
			self.xibMappings = [cvcDict objectForKey:@"iPadXibs"];
		
		if ([cvcDict objectForKey:@"iPadAppSettings"] !=nil)
			appDict = [cvcDict objectForKey:@"iPadAppSettings"];
		
	}	
	
	else
	{
		if ([cvcDict objectForKey:@"iPhoneMenuSettings"] !=nil)
			self.dropdownSettings = [cvcDict objectForKey:@"iPhoneMenuSettings"];
		if ([cvcDict objectForKey:@"iPhoneAbsolutePositions"] !=nil)
			self.absoluteSettings = [cvcDict objectForKey:@"iPhoneAbsolutePositions"];	
		if ([cvcDict objectForKey:@"iPhoneCornerNavSettings"] !=nil)
			self.cornerNavSettings = [cvcDict objectForKey:@"iPhoneCornerNavSettings"];
		if ([cvcDict objectForKey:@"iPhoneSpecialButtonBindings"] !=nil)
			self.specialButtonBindings = [cvcDict objectForKey:@"iPhoneSpecialButtonBindings"];		
		if ([cvcDict objectForKey:@"iPhoneXibs"] !=nil)
			self.xibMappings = [cvcDict objectForKey:@"iPhoneXibs"];		
		if ([cvcDict objectForKey:@"iPhoneAppSettings"] !=nil)
			appDict = [cvcDict objectForKey:@"iPhoneAppSettings"];
		
		
	}
	
	
    if ([cvcDict objectForKey:@"ButtonHelp"] !=nil)
        self.buttonHelp = [cvcDict objectForKey:@"ButtonHelp"];
	
    if ([cvcDict objectForKey:@"EmailSettings"] !=nil)
        self.emailSettings = [cvcDict objectForKey:@"EmailSettings"];
	
    if ([cvcDict objectForKey:@"URLMappings"] !=nil)
        self.URLMappings = [cvcDict objectForKey:@"URLMappings"];

	
	self.singleTouchEnabled = NO;
	
	NSDictionary *singleTouchDict;  
	CGRect frame;
	
    if ([appDict objectForKey:@"SingleTouchFrame"] !=nil)
	{
        singleTouchDict = [appDict objectForKey:@"SingleTouchFrame"];
		self.singleTouchEnabled = YES;
	}
	
	frame.size.width = [[singleTouchDict objectForKey:@"width"] floatValue];
	
	frame.size.height = [[singleTouchDict objectForKey:@"height"] floatValue];
	
	frame.origin.x = [[singleTouchDict objectForKey:@"x"] floatValue];
	
	frame.origin.y= [[singleTouchDict objectForKey:@"y"] floatValue];
	
	self.singleTouchFrame = frame;
	
    if ([appDict objectForKey:@"SingleTouchFrameLandscape"] !=nil)
	{
        singleTouchDict = [appDict objectForKey:@"SingleTouchFrameLandscape"];
		self.singleTouchEnabled = YES;
	}
	
	frame.size.width = [[singleTouchDict objectForKey:@"width"] floatValue];
	
	frame.size.height = [[singleTouchDict objectForKey:@"height"] floatValue];
	
	frame.origin.x = [[singleTouchDict objectForKey:@"x"] floatValue];
	
	frame.origin.y= [[singleTouchDict objectForKey:@"y"] floatValue];
	
	self.singleTouchFrameLandscape = frame;
	
    if ([appDict objectForKey:@"GigOrBigStand"] !=nil)
        self.gigStandEnabled = [[appDict objectForKey:@"GigOrBigStand"] boolValue];
	
	
    if ([appDict objectForKey:@"SingleTouch"] !=nil)
    [[appDict objectForKey:@"SingleTouch"] boolValue];

    if ([appDict objectForKey:@"StartupWaitingImage"] !=nil)
        self.startupWaitingImage = [appDict objectForKey:@"StartupWaitingImage"];
	
    if ([appDict objectForKey:@"ShowIntroOverlay"] !=nil)
        self.wantsIntroOverlay = [[appDict objectForKey:@"ShowIntroOverlay"] boolValue];
	
	
    if ([appDict objectForKey:@"ShowPhotosFullWidth"] !=nil)
        self.showFullWidth = [[appDict objectForKey:@"ShowPhotosFullWidth"] boolValue];
	
	
    if ([appDict objectForKey:@"DisableTopTitle"] !=nil)
        self.disableTopTitle = [[appDict objectForKey:@"DisableTopTitle"] boolValue];
	
	
    if ([appDict objectForKey:@"AllowRotations"] !=nil)
        self.allowRotations = [[appDict objectForKey:@"AllowRotations"] boolValue];
	
	
    if ([appDict objectForKey:@"InitialPileFilter"] !=nil)
        self.initialPileFilter = [appDict objectForKey:@"InitialPileFilter"] ;
	
		// would be nice to get colors sorted out
    
    self.xMonitorView.backgroundColor = [self colorFor: @"XmonColor" plistOptions: appDict 
											 otherwise:[colorsDict objectForKey:@"gsXmonColor"]
										 ];
	
	
	self.performanceColor = [self colorFor: @"PerformanceColor" plistOptions: appDict 
								 otherwise:[colorsDict objectForKey:@"gsPerformanceColor"]
							 ];
	
	self.topBackgroundColor = [self colorFor: @"TopBackgroundColor" plistOptions: appDict 
								   otherwise:[colorsDict objectForKey:@"gsEditingColor"]
							   ];
	
	
	self.appBackgroundColor = [self colorFor: @"AppBackgroundColor" plistOptions: appDict 
								   otherwise:[colorsDict objectForKey:@"gsHeadlineColor"]
							   ];
	
	self.colorBehindHTMLPages = [self colorFor: @"ColorBehindHTMLPages" plistOptions: appDict 
									 otherwise:[UIColor blackColor] 
								 ];
	
	if ([appDict objectForKey:@"StartPageTitle"] !=nil)
        self.startPageTitle = [appDict objectForKey:@"StartPageTitle"];
	
	
	if ([appDict objectForKey:@"StartPopUpTitle"] !=nil)
        self.startPopUpTitle = [appDict objectForKey:@"StartPopUpTitle"];
	
	if ([appDict objectForKey:@"StartPushButton"] !=nil)
        self.startPushButton = [appDict objectForKey:@"StartPushButton"];
	
	
	
	if ([[appDict objectForKey:@"TransparentFooter"] boolValue]==YES)
        self.transparentFooter = YES;  
    if ([[appDict objectForKey:@"DisableFooter"] boolValue]==YES)
        self.disableFooter = YES;
	if ([[appDict objectForKey:@"DisableAppleHeader"] boolValue]==YES)
        self.disableAppleHeader = YES;
    if ([[appDict objectForKey:@"StripFirstTitleComponent"] boolValue]==YES)
        self.stripFirstTitleComponent = YES;   // useful for NNN* prefixes on filenames for sort order preservation
    if ([[appDict objectForKey:@"StartInFullScreenMode"] boolValue]==YES)
        self.startInFullScreenMode = YES;    // screen comes up on fullscreen, nav appears after tap only
    if ([[appDict objectForKey:@"SearchBarHeight"] floatValue]>0)
        self.searchBarHeight = [[appDict objectForKey:@"SearchBarHeight"] floatValue]; // 	
	
    if (([[appDict objectForKey:@"FullScreenTaps"] unsignedIntValue]>1) && ([[appDict objectForKey:@"FullScreenTaps"] unsignedIntValue]<5))
        self.fullScreenTaps = [[appDict objectForKey:@"FullScreenTaps"] unsignedIntValue]; // obvious
	else self.fullScreenTaps = 3;
    
    if ([[appDict objectForKey:@"FullScreenTimeout"] floatValue]>0)
        self.fullScreenTimeout = [[appDict objectForKey:@"FullScreenTimeout"] floatValue]; // obvious
    else 
    {
        self. searchBarHeight=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?SEARCH_BAR_HEIGHT:
        ((UIDeviceOrientationIsLandscape ([UIDevice currentDevice].orientation))? 60.0f:60);
    }
    if ([[appDict objectForKey:@"FooterHeight"] floatValue]>44)
        self.toolBarHeight = [[appDict objectForKey:@"FooterHeight"] floatValue]; // obvious
    else 
    {        
        self.toolBarHeight=(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?NORMAL_TOOLBAR_HEIGHT:
        ((UIDeviceOrientationIsLandscape ([UIDevice currentDevice].orientation))? NARROW_TOOLBAR_HEIGHT:NORMAL_TOOLBAR_HEIGHT);
    }
    if ([[appDict objectForKey:@"RowHeight"] floatValue]>30)
        self.standardRowSize = [[appDict objectForKey:@"RowHeight"] floatValue]; // obvious
    else 
    {       
		self.standardRowSize=  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?LARGER_ROW_SIZE:STANDARD_ROW_SIZE;
    }
	
    self.statusBarHeight=STATUS_BAR_HEIGHT;
    
    self.navBarHeight= (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?NAV_BAR_HEIGHT:
    ((UIDeviceOrientationIsLandscape ([UIDevice currentDevice].orientation))? 32.0f:NAV_BAR_HEIGHT);
    
    self.applicationName = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"]];
    self.applicationVersion = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleVersion"]];
    self.starttime = [NSDate date];
	
}


-(void) setup:(NSMutableDictionary *)barbuttonSystemItemsDict
{
	
	NSString *p=[KORSettingsManager sharedInstance].plistForCustomSettings;  // comes from info.plist environment variables
	NSString *s = p ? p :@"fail";
	NSString     *cvcPath = [[NSBundle mainBundle] pathForResource: s ofType: @"plist" ];	
	NSDictionary *cvcDict = [NSDictionary dictionaryWithContentsOfFile: cvcPath];  
	
    if (cvcDict==nil) 
        [[KORAppDelegate sharedInstance ] dieFromMisconfiguration:[NSString stringWithFormat:@"No custom settings plist"]];
	
	NSArray *listNames = [cvcDict objectForKey: @"ZippedDataPiles"] ; // if any are real archives, take them out of the list
	
	if ([listNames count] == 0) 
	{
		[[KORAppDelegate sharedInstance ]  dieFromMisconfiguration:[NSString stringWithFormat:@"Empty custom settings plist"]];
		
	}
	else 
	{
		
		self.activeArchives = listNames ;
	}
	
	[self setupScreenwideOptions :(NSDictionary *)cvcDict  barbuttons:(NSMutableDictionary *)barbuttonSystemItemsDict]  ;
	
	
}


- (KORDataManager *) init
{
	self = [super init];
	if (self) 
	{
		nullView = [[UIView alloc] init]; // make minimal view we can put in lists, etc
		userEnteredEmail = @""; // doesnt like nil
		
		actionsDict = [NSDictionary dictionaryWithObjectsAndKeys: 
					   [NSNumber numberWithUnsignedInt: INFOOVERLAY_COMMAND_TAG],			@"OVERLAY-INFO" ,					   
					   [NSNumber numberWithUnsignedInt: INTROOVERLAY_COMMAND_TAG],			@"OVERLAY-INTRO" ,					   
					   [NSNumber numberWithUnsignedInt: ALTOVERLAYA_COMMAND_TAG],			@"OVERLAY-INTROA" ,						   
					   [NSNumber numberWithUnsignedInt: ALTOVERLAYB_COMMAND_TAG],			@"OVERLAY-INTROB" ,						   
					   [NSNumber numberWithUnsignedInt: ALTOVERLAYC_COMMAND_TAG],			@"OVERLAY-INTROC" ,						   
					   [NSNumber numberWithUnsignedInt: ALTOVERLAYD_COMMAND_TAG],			@"OVERLAY-INTROD" ,	
					   [NSNumber numberWithUnsignedInt: TRAVERSING_COMMAND_TAG],		    @"SHOW-TRAVERSING" ,
					   [NSNumber numberWithUnsignedInt: TITLE_COMMAND_TAG],					@"SHOW-MAINTITLE" ,
					   [NSNumber numberWithUnsignedInt: TITLELEFT_COMMAND_TAG],				@"SHOW-MAINTITLELEFT" ,
					   [NSNumber numberWithUnsignedInt: PRINTER_COMMAND_TAG],				@"SHOW-PRINTCHOOSER" ,
					   [NSNumber numberWithUnsignedInt: CONTACTUS_COMMAND_TAG],				@"SHOW-CONTACTUSEMAIL" ,
					   [NSNumber numberWithUnsignedInt: TELLAFRIEND_COMMAND_TAG],			@"SHOW-TELLAFRIENDEMAIL",
					   [NSNumber numberWithUnsignedInt: ABOUT_COMMAND_TAG],					@"SHOW-ABOUTPAGE",
					   [NSNumber numberWithUnsignedInt: ABOUTFULL_COMMAND_TAG],				@"SHOW-ABOUTPAGEFULL",
					   [NSNumber numberWithUnsignedInt: INSTRUCTIONS_COMMAND_TAG],			@"SHOW-INSTRUCTIONSPAGE" ,						   
					   [NSNumber numberWithUnsignedInt: PERTUNEPREFS_COMMAND_TAG],			@"SHOW-AUTOSCROLLERPREFERENCES" ,
					   [NSNumber numberWithUnsignedInt: METRONOMEPREFERENCES_COMMAND_TAG],	@"SHOW-METRONOMEPREFERENCES" ,
					   [NSNumber numberWithUnsignedInt: SHOWFAVORITES_COMMAND_TAG],			@"SHOW-FAVORITES" ,
					   [NSNumber numberWithUnsignedInt: SHOWRECENTS_COMMAND_TAG],			@"SHOW-RECENTS" ,
					   [NSNumber numberWithUnsignedInt: SHOWSET1_COMMAND_TAG],				@"SHOW-SET1" ,					   
					   [NSNumber numberWithUnsignedInt: SHOWSET2_COMMAND_TAG],				@"SHOW-SET2" ,					   
					   [NSNumber numberWithUnsignedInt: SHOWSET3_COMMAND_TAG],				@"SHOW-SET3" ,
					   [NSNumber numberWithUnsignedInt: SHOWLISTS_COMMAND_TAG],				@"SHOW-LISTS" ,
					   [NSNumber numberWithUnsignedInt: SHOWARCHIVES_COMMAND_TAG],			@"SHOW-ARCHIVES" ,
					   [NSNumber numberWithUnsignedInt: SHOWWEBCAPTUE_COMMAND_TAG],			@"SHOW-WEBCAPTUREPAGE" ,
					   [NSNumber numberWithUnsignedInt: SHOWPHOTOCAPTURE_COMMAND_TAG],		@"SHOW-PHOTOCAPTUREPAGE" ,			   
					   [NSNumber numberWithUnsignedInt: RUNDIAGNOSTICS_COMMAND_TAG],		@"SHOW-DIAGNOSTICSPAGE" ,
					   [NSNumber numberWithUnsignedInt: SEARCH_COMMAND_TAG],				@"SHOW-SEARCHPAGE" ,					   
					   [NSNumber numberWithUnsignedInt: WALLPAPER_COMMAND_TAG],				@"SET-WALLPAPER" ,					   
					   [NSNumber numberWithUnsignedInt: SHOWADDTOFAVORITES_COMMAND_TAG],	@"SHOW-ADDTOFAVORITES" ,
					   [NSNumber numberWithUnsignedInt: SHOWADDTOLIST_COMMAND_TAG],			@"SHOW-ADDTOLIST" ,
					   [NSNumber numberWithUnsignedInt: SEARCHARCHIVESMENU_COMMAND_TAG],	@"SHOW-ARCHIVECHOOSER" ,					   
					   [NSNumber numberWithUnsignedInt: SHOWTHIS_COMMAND_TAG],				@"SHOW-PROPSTHIS" ,
					   [NSNumber numberWithUnsignedInt: SHOWNEXT_COMMAND_TAG],				@"SHOW-PROPSNEXT",
					   [NSNumber numberWithUnsignedInt: SHOWPREV_COMMAND_TAG],				@"SHOW-PROPSPREV" ,					   
					   [NSNumber numberWithUnsignedInt: LEFTPLAIN_COMMAND_TAG],				@"PREV2LINE-BUTTON" ,
					   [NSNumber numberWithUnsignedInt: RIGHTPLAIN_COMMAND_TAG],			@"NEXT2LINE-BUTTON" ,
					   [NSNumber numberWithUnsignedInt: LEFTDETAILS_COMMAND_TAG],			@"PREVGS-BUTTON" ,
					   [NSNumber numberWithUnsignedInt: RIGHTDETAILS_COMMAND_TAG],			@"NEXTGS-BUTTON" ,
					   [NSNumber numberWithUnsignedInt: AUTOSCROLLER_COMMAND_TAG],			@"AUTOSCROLLER-BUTTON" ,
					   [NSNumber numberWithUnsignedInt: METRONOME_COMMAND_TAG],				@"METRONOME-BUTTON" ,					   
					   [NSNumber numberWithUnsignedInt: VARIANTS_COMMAND_TAG],				@"MUTIDOC-BUTTON" ,					   
					   [NSNumber numberWithUnsignedInt: MANAGEFAVORITES_COMMAND_TAG],		@"SHOW-FAVORITESMANAGER" ,	
					   [NSNumber numberWithUnsignedInt: MANAGERECENTS_COMMAND_TAG],			@"SHOW-RECENTSMANAGER" ,	
					   [NSNumber numberWithUnsignedInt: MANAGELISTS_COMMAND_TAG],			@"SHOW-LISTSMANAGER" ,
					   [NSNumber numberWithUnsignedInt: ADDLIST_COMMAND_TAG],				@"SHOW-ADDLIST" ,	
					   [NSNumber numberWithUnsignedInt: ADDARCHIVE_COMMAND_TAG],			@"SHOW-ADDARCHIVE" ,
					   [NSNumber numberWithUnsignedInt: SHOWSETLISTSHARING_COMMAND_TAG],	@"SHOW-SHARINGCHOICES" ,
					   [NSNumber numberWithUnsignedInt: MANAGEARCHIVES_COMMAND_TAG],		@"SHOW-ARCHIVESMANAGER" ,
					   [NSNumber numberWithUnsignedInt: SHOW_PERSONALFILEMANAGER_TAG],		@"SHOW-PERSONALFILEMANAGER" ,
					   [NSNumber numberWithUnsignedInt: LEFT_COMMAND_TAG],					@"ACTION-MOVETOPREV" ,
					   [NSNumber numberWithUnsignedInt: RIGHT_COMMAND_TAG],					@"ACTION-MOVETONEXT" ,						   
					   [NSNumber numberWithUnsignedInt: IMPORT_ONTHEFLY_COMMAND_TAG],		@"IMPORT-ONTHEFLYARCHIVE" ,	
					   [NSNumber numberWithUnsignedInt: MAINMENU_COMMAND_TAG],				@"MAINMENU-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENU_COMMAND_TAG],				@"ALTMENU-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUA_COMMAND_TAG],				@"ALTMENU-A-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUB_COMMAND_TAG],				@"ALTMENU-B-ACTION",
					   [NSNumber numberWithUnsignedInt: ALTMENUC_COMMAND_TAG],				@"ALTMENU-C-ACTION",
					   [NSNumber numberWithUnsignedInt: ALTMENUD_COMMAND_TAG],				@"ALTMENU-D-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUE_COMMAND_TAG],				@"ALTMENU-E-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUF_COMMAND_TAG],				@"ALTMENU-F-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUG_COMMAND_TAG],				@"ALTMENU-G-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUH_COMMAND_TAG],				@"ALTMENU-H-ACTION" ,
					   [NSNumber numberWithUnsignedInt: ALTMENUI_COMMAND_TAG],				@"ALTMENU-I-ACTION",					   
					   [NSNumber numberWithUnsignedInt: RIGHTACTIONSHEET_COMMAND_TAG],		@"SHOW-ACTIONSHEETRIGHT"	,
					   [NSNumber numberWithUnsignedInt: LEFTACTIONSHEET_COMMAND_TAG],		@"SHOW-ACTIONSHEETLEFT" ,
					   [NSNumber numberWithUnsignedInt: TESTHOOK_COMMAND_TAG],				@"TESTHOOK"	,
					   [NSNumber numberWithUnsignedInt: SHOWMP3PLAYER_COMMAND_TAG],			@"SHOW-MP3PLAYER" ,
					   [NSNumber numberWithUnsignedInt: FULLSCREEN_COMMAND_TAG],			@"GO-FULLSCREEN" ,					   
					   nil];
		
		
		
		systemBarButtonImageNames  = 
		[NSDictionary dictionaryWithObjectsAndKeys:
		 
		 [NSNumber numberWithInt:UIBarButtonSystemItemDone],@"UIBarButtonSystemItemDone",
		 [NSNumber numberWithInt:UIBarButtonSystemItemCancel],@"UIBarButtonSystemItemCancel",
		 [NSNumber numberWithInt:UIBarButtonSystemItemEdit],@"UIBarButtonSystemItemEdit",
		 [NSNumber numberWithInt:UIBarButtonSystemItemSave],@"UIBarButtonSystemItemSave",
		 [NSNumber numberWithInt:UIBarButtonSystemItemAdd],@"UIBarButtonSystemItemAdd",
		 [NSNumber numberWithInt:UIBarButtonSystemItemFlexibleSpace],@"UIBarButtonSystemItemFlexibleSpace",
		 [NSNumber numberWithInt:UIBarButtonSystemItemFixedSpace],@"UIBarButtonSystemItemFixedSpace",
		 [NSNumber numberWithInt:UIBarButtonSystemItemCompose],@"UIBarButtonSystemItemCompose",
		 [NSNumber numberWithInt:UIBarButtonSystemItemReply],@"UIBarButtonSystemItemReply",
		 [NSNumber numberWithInt:UIBarButtonSystemItemAction],@"UIBarButtonSystemItemAction",
		 [NSNumber numberWithInt:UIBarButtonSystemItemOrganize],@"UIBarButtonSystemItemOrganize",
		 [NSNumber numberWithInt:UIBarButtonSystemItemBookmarks],@"UIBarButtonSystemItemBookmarks",
		 [NSNumber numberWithInt:UIBarButtonSystemItemSearch],@"UIBarButtonSystemItemBookmarks",
		 [NSNumber numberWithInt:UIBarButtonSystemItemRefresh],@"UIBarButtonSystemItemRefresh",
		 [NSNumber numberWithInt:UIBarButtonSystemItemStop],@"UIBarButtonSystemItemStop",
		 [NSNumber numberWithInt:UIBarButtonSystemItemCamera],@"UIBarButtonSystemItemCamera",
		 [NSNumber numberWithInt:UIBarButtonSystemItemTrash],@"UIBarButtonSystemItemTrash",
		 [NSNumber numberWithInt:UIBarButtonSystemItemPlay],@"UIBarButtonSystemItemPlay",
		 [NSNumber numberWithInt:UIBarButtonSystemItemPause],@"UIBarButtonSystemItemPause",
		 [NSNumber numberWithInt:UIBarButtonSystemItemRewind],@"UIBarButtonSystemItemRewind",
		 [NSNumber numberWithInt:UIBarButtonSystemItemFastForward],@"UIBarButtonSystemItemFastForward",
		 [NSNumber numberWithInt:UIBarButtonSystemItemUndo],@"UIBarButtonSystemItemUndo",
		 [NSNumber numberWithInt:UIBarButtonSystemItemRedo],@"UIBarButtonSystemItemRedo",
		 [NSNumber numberWithInt:UIBarButtonSystemItemPageCurl],@"UIBarButtonSystemItemPageCurl", 
		 
		 nil];
		
		lastMenuPresentedPrefix = @"MAINMENU";
		
		currentMenuPrefix = lastMenuPresentedPrefix;
        
        thumbsCache = [[NSMutableDictionary alloc] init];
			//NSLog (@"DataManager started at %@",self->starttime);
			// this dict shud get released after setup is complete
		
		NSMutableDictionary *barbuttonSystemItemsDict = [NSMutableDictionary dictionary];
		
		
			// in addition to the system Colors, we explictily add some of our own that can be referenced from plist
		NSDictionary *colorsDictx = [NSDictionary dictionaryWithObjectsAndKeys: 
									 
									 [UIColor colorWithRed:(CGFloat).467f green:(CGFloat).125f blue:(CGFloat).129 alpha:(CGFloat).7f],@"gsHeadlineColor",
									 [UIColor colorWithRed:(CGFloat).92f green:(CGFloat).88f blue:(CGFloat).78 alpha:(CGFloat)1.f],@"gsEditingColor",			
									 [UIColor colorWithRed:110.f/256.f green:123.f/256.f blue:139.f/256.f alpha:.7f],@"gsPerformanceColor", 			
									 [UIColor redColor],@"gsXmonColor",	
									 [UIColor darkGrayColor] , @"darkGrayColor",									
									 [UIColor lightGrayColor] , @"lightGrayColor",
									 [UIColor whiteColor] , @"whiteColor",									
									 [UIColor blackColor] , @"blackColor",
									 [UIColor grayColor] , @"grayColor",
									 [UIColor redColor] , @"redColor",
									 [UIColor greenColor] , @"greenColor",
									 [UIColor blueColor] , @"blueColor",
									 [UIColor cyanColor] , @"cyanColor",
									 [UIColor yellowColor] , @"yellowColor",
									 [UIColor magentaColor] , @"magentaColor",
									 [UIColor orangeColor] , @"orangeColor",
									 [UIColor purpleColor] , @"purpleColor",
									 [UIColor brownColor] , @"brownColor",
									 [UIColor clearColor] , @"clearColor", // 0 white 0.0 alpha
									 
									 nil];
		self.colorsDict = colorsDictx; // keep this around
		[self setup:barbuttonSystemItemsDict];
		
	}
	return self;	
}

+(NSString *) findAction:(NSUInteger) tagx
{
	NSString *result;
	__block typeof(result) bresult = result;

	[[KORDataManager globalData].actionsDict enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			//NSLog(@"%@ = %@", key, object);
		
		if ([object unsignedIntValue]==tagx) { *stop = YES; bresult = key; }
	}];
		//NSLog (@"findAction returns %@", bresult);
	return bresult;
}
-(void) flushCache;
{
		// called in low memory situations
	thumbsCache = nil;
	
	thumbsCache = [[NSMutableDictionary alloc] init];
	
	appMusicPlayer = nil;
	
	docInteractionController = nil;
	
	xMonitorView = nil;

}

#pragma mark Function or Subroutine Based Methods

+(NSString *) prettyPath:(NSString *) s;
{
    NSArray *listItems = [s componentsSeparatedByString:@"/DONOTDISTURB/"];
    if ([listItems count] == 1) {
		
		NSArray *tempItems = [s componentsSeparatedByString:@"/tmp/"];
		if ([tempItems count] != 1) return @".../tmp/...";
		
	return s;	
		
	}
    
    NSString  *tail = [listItems objectAtIndex:1];   
    return [NSString stringWithFormat:@"...%@",tail];
}
+(BOOL) removeItemAtPath:(NSString *) path error:(NSError **)error;
{
		// ALL FILE REMOVALS COME THRU HERE FOR TRACING
	
    if (![[NSFileManager defaultManager] removeItemAtPath:path error:error])
		
    {
        
        NSLog(@"****ERROR REMOVING %@",[[self class] prettyPath:path]);//,[*error description]);
		return NO;
        
    }
		//else
		
			//NSLog(@"****REMOVING %@",[[self class] prettyPath:path]);
	
	return YES;
	
}


+(CGRect) busyOverlayFrame:(CGRect)frame;
{
	return frame;
}

+ (void) singleTapPulse
{
	[[NSNotificationCenter defaultCenter] postNotificationName:singleTapDidPulse object:nil];
}


+ (BOOL) isPDF:(NSString *)filespec;
{
	BOOL pdf = NO;
	NSRange range=[filespec rangeOfString:@".pdf" options:0 ];
	if(range.location<[filespec length])
	{
		pdf = YES;
	}
	NSRange range2=[filespec rangeOfString:@".PDF" options:0 ];
	if(range2.location<[filespec length])
	{
		pdf = YES;
	}
		//NSLog (@"isPDF:%@ is %d",filespec,pdf);
	return pdf;
}
+(BOOL) isOpaque:(NSString *)filename;
{
		// the only files we are going to mess with are htms and txt files
		// regular html will be treated like docs and pdf because some html is very fussy
		//
		// to get GigStand to manipulate html, start with an 'htm' extension
	
	NSString *type = [[filename pathExtension] lowercaseString];
	
	if (
		([@"htm" isEqualToString:type]) || 
        ([@"txt" isEqualToString:type] ) ||
		([@"jpg" isEqualToString:type]) ||
		([@"jpeg" isEqualToString:type]) ||
		([@"gif" isEqualToString:type]) ||
		([@"png" isEqualToString:type]) 
		)
		
        return NO;
    return YES;
    
}


+(BOOL) docMenuForURL: (NSURL *) fileURL barButton: (UIBarButtonItem *) vew;
{
	if ([self globalData].docInteractionController == nil)
	{
		[self globalData].docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
		[self globalData].docInteractionController.delegate = nil; // no thanks
	}	
	else 
	{
			// just keep reusing the one we already have
		[self globalData].docInteractionController.URL = fileURL;
	}
	
	BOOL didPaint = [[self globalData].docInteractionController presentOptionsMenuFromBarButtonItem:vew
																						   animated:YES];
    
    NSLog (@"DataManager docMenuForURL presented external menu with %d choices",didPaint);
	return didPaint;
}

+(BOOL) docMenuForURL: (NSURL *) fileURL inView: (UIView *) vew;
{
	if ([self globalData].docInteractionController == nil)
	{
		[self globalData].docInteractionController = 
		[UIDocumentInteractionController interactionControllerWithURL:fileURL];
		[self globalData].docInteractionController.delegate = nil; // no thanks
	}
	
	else 
	{
			// just keep reusing the one we already have
		[self globalData].docInteractionController.URL = fileURL;
	}
	
	BOOL didPaint = [[self globalData].docInteractionController 
                     presentOptionsMenuFromRect:vew.frame inView:vew 
                     animated:YES];
    
	return didPaint;
}

+(UIImage *)captureView:(UIView *)view;
{ 
    CGRect screenRect = CGRectMake(0,0,view.frame.size.width,view.frame.size.height);
	
	UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0);//(screenRect.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    
    [[UIColor blackColor] set]; 
    
    CGContextFillRect(ctx, screenRect);
	
	[view.layer renderInContext:ctx];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage; 
}

+(NSString *) saveImageToSnapshotsGallery:  (UIImage *) image tune: (NSString *) tune;
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
	
	NSString *filepath = [NSString stringWithFormat:  @"%@%@%@-snapshotthumb-%@-%@.png", hh,mm,ss,date,tune];
	NSString *topath = [[KORPathMappings pathForThumbnails] 
						stringByAppendingPathComponent:filepath];
	
	NSData *imageData = UIImagePNGRepresentation(image);
	if (imageData != nil) {
		
		[imageData writeToFile:topath atomically:YES];		
			//
	}
	return topath;
}
#pragma mark MPMediaQuery to play Audio from iPod
+ (void) playMusic:(NSString *)title;
{
	
	if ([[KORSettingsManager sharedInstance] disableMediaPlayer]==NO && [self globalData].inSim == NO)
	{
		
			/// PLAY MUSIC ONLY ON REAL DEVICE
		
		MPMediaQuery *iTunesQuery = [[MPMediaQuery alloc] init];	
		MPMediaPropertyPredicate *p = [MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle];
		[iTunesQuery addFilterPredicate:p];
		if  ( [ [iTunesQuery items] count] > 0) 
		{
			if (! [self globalData].appMusicPlayer ){
				
				[self globalData].appMusicPlayer =[MPMusicPlayerController applicationMusicPlayer];
			}
			[[self globalData].appMusicPlayer setShuffleMode: MPMusicShuffleModeOff];
			[[self globalData].appMusicPlayer setRepeatMode: MPMusicRepeatModeNone];
			[[self globalData].appMusicPlayer setQueueWithQuery:iTunesQuery];
			[[self globalData].appMusicPlayer play];
		}
	}
	
}
+(BOOL) canPlayTune:(NSString *)s;
{
	
	if ([[KORSettingsManager sharedInstance] disableMediaPlayer]==YES || [self globalData].inSim == YES) return NO;
	
	MPMediaQuery *iTunesQuery = [[MPMediaQuery alloc] init];	
	MPMediaPropertyPredicate *p = [MPMediaPropertyPredicate predicateWithValue:s forProperty:MPMediaItemPropertyTitle];
	[iTunesQuery addFilterPredicate:p];
	return  ( [ [iTunesQuery items] count] > 0) ;
}

+(NSString *) deriveLongPath:(NSString *)filePath forArchive:(NSString *)archive;
{
		// changed to just return the filePath on 11/11/11 
		//NSString *s = [[NSString alloc] initWithFormat:@"%@/%@",archive,filePath];
    return filePath;
}

+(NSString  *)makeTitleView:(NSString *)titletext;
{
    return titletext;
}
+(NSString  *)makeUnadornedTitleView:(NSString *)titletext;
{
	return titletext;
}

+(NSString *) generateUniqueTitle:(NSString *) suffix;
{
    
		// <strong>Output ->  Date: 10/29/2008 08:29PM</strong>    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
		//[dateFormat release];
    NSString *title =[NSString stringWithFormat:@"%@ %@",dateString,suffix];
    return title;
}

	//RIGHTACTIONS

+(UIImage *)makeThumbnailFS:(NSString *)pathOrResource ofSize:(float) length;

{
	
		//NSLog(@"makeThumbFS %@ size %.f",pathOrResource,length);
	
    UIImage *thumbnailFromCache = [[self globalData].thumbsCache valueForKey:pathOrResource];
    
	if ( thumbnailFromCache == nil) // shovel it into the cache
		
	{
		UIImage *mainImage;
		if ([[NSFileManager defaultManager] fileExistsAtPath:pathOrResource] == NO) 
			mainImage = [UIImage imageNamed:pathOrResource];
		else 
			mainImage = [UIImage imageWithContentsOfFile:pathOrResource];
		
		UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
		BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
		float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
		CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
			//creating a square context the size of the final image which we will then
			// manipulate and transform before drawing in the original image
		UIGraphicsBeginImageContext(CGSizeMake(length, length));
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
		CGContextClipToRect( currentContext, clippedRect);
		CGFloat scaleFactor = length/sideFull;
		if (widthGreaterThanHeight) {
				//a landscape image – make context shift the original image to the left when drawn into the context
			CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) / 2) * scaleFactor, 0);
		}
		else {
				//a portfolio image – make context shift the original image upwards when drawn into the context
			CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) / 2) * scaleFactor);
		}
			//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
		CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
		[mainImageView.layer renderInContext:currentContext];
		UIImage *tempthumbnail = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		NSData *imageData = UIImagePNGRepresentation(tempthumbnail);
			//		[imageData writeToFile:fullPathToThumbImage atomically:YES];
		
        UIImage *thumbToCache = [UIImage imageWithData: imageData];
        
        [[self globalData].thumbsCache setValue:thumbToCache forKey:pathOrResource]; // shovel it into the cache
        
        return thumbToCache; // and give it back
	}
    
	else {
        return thumbnailFromCache;
	}
}

+(UIImage *)makeThumbFromFullPathOrResource:(NSString *) pathOrResource  forMenu:(NSString *) menu; // could use view caching for more snap
{
	float lengthOfSide;
	NSDictionary *ddset = [[KORDataManager globalData].dropdownSettings objectForKey:menu];
	id tns =  [ddset objectForKey:@"ThumbNailSize"];
	
	if (tns == nil)  lengthOfSide =50.f;
	
	else lengthOfSide = [tns floatValue];
	
	return([KORDataManager makeThumbnailFS: pathOrResource ofSize:lengthOfSide ]);
}
+(NSString *) cleanupIncomingTitle:(NSString *)htitle
{
	const char *foo = [htitle UTF8String];
	char obuf[1000];
	NSUInteger opos = 0;
	NSUInteger len = strlen(foo);
	if (len>1000) len=1000;
	char tab = '\t';
	BOOL spaces = NO;
	char keyChar = '*';
	BOOL lastKey =NO;
	BOOL firstx = YES; // 
	for (NSUInteger index = 0; index<len; index++)
	{
		char o = foo[index];
		if(! ((o=='"')||(o=='\'')) )
		{
			if ((o==' ')||(o==tab)||(o=='_')) // space or tab? just note it
			{	
				spaces = YES;
			}
			else 
			{
				
					// anything else gets copied
				if (YES==spaces)
				{	
					
					obuf[opos]=' '; // insert a space
					opos++;
					
				}
				else //if (NO==spaces) // can get changed in above conditional
				{
					
					
					if (((o>='A')&&(o<='Z')) && lastKey==NO)// make each cap generate a new word
					{	
						if(NO==firstx)
						{
							obuf[opos]=' '; // insert a space
							opos++;
						}
					}
					firstx = NO;
					lastKey=(o==keyChar) ;
					
				}
				
				spaces = NO; // not in a space anymore
							 // in all cases if not a space then copy it over
				obuf[opos]=o;
				opos++;
			}
		}
	}
	obuf[opos]='\0';
		// squeeze out beginning ending and extra blanks
		//	
	NSString* newStringq = [[[NSString stringWithUTF8String:obuf] 
							 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] 
							capitalizedString];
	
	return newStringq;
}

+(UIImage *) makeThumbnailImage:(NSString *)path;
{
	
	NSString *fullPathToThumbnail;
    NSString *type = [path pathExtension];
    UIImage *myimage=nil;
    NSString *thumbnailfodder;
		// Look for an explicit picture in all cases
	
	
	thumbnailfodder =[NSString stringWithFormat:@"%@-thumb.png", [path stringByDeletingPathExtension]];
	fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];
	if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToThumbnail])
		myimage  =  [KORDataManager makeThumbFromFullPathOrResource: fullPathToThumbnail forMenu:@"MAINMENU"];
	if (myimage == nil)
	{
		
		thumbnailfodder =[NSString stringWithFormat:@"%@-thumbvideo.png", [path stringByDeletingPathExtension]];
		fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];
		if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToThumbnail])
			myimage  =  [KORDataManager makeThumbFromFullPathOrResource: fullPathToThumbnail forMenu:@"MAINMENU"];
		if (myimage == nil)
		{
			
			thumbnailfodder =[NSString stringWithFormat:@"%@-thumbweb.png", [path stringByDeletingPathExtension]];
			fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];			
			if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToThumbnail])
				myimage  =  [KORDataManager makeThumbFromFullPathOrResource: fullPathToThumbnail forMenu:@"MAINMENU"];
			
		}
	}
	
	if (myimage == nil) // failing all that
	{
		if ([KORDataManager isFileWrappablePic:type]) // if its a picture type
		{
			thumbnailfodder = path ; // make thumb from the picture
			fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];			
			myimage  =  [KORDataManager makeThumbFromFullPathOrResource: fullPathToThumbnail forMenu:@"MAINMENU"];
		}
		else
		{
				// not a picture type, and no thumb was supplied what to do?
			myimage = [KORDataManager makeThumbFromFullPathOrResource: @"eyedropper.png" forMenu:@"MAINMENU"];
		}
	}
    
    return myimage;
}
+(BOOL) isFileWrappablePic :(NSString *)stype;
{
	NSString *type = [stype lowercaseString];
	if(
	   
	   ([@"jpg" isEqualToString:type]) ||
	   ([@"jpeg" isEqualToString:type]) ||
	   ([@"gif" isEqualToString:type]) ||
	   ([@"png" isEqualToString:type]) )
		return YES;
	return NO;
}
+(BOOL) isFileTypeProcessedByUS :(NSString *)stype;
{
	NSString *type = [stype lowercaseString];
	if(
	   ([@"zip" isEqualToString:type]) ||
	   ([@"stl" isEqualToString:type]) ||
	   ([@"pdf" isEqualToString:type]) ||	   
	   ([@"txt" isEqualToString:type]) ||
	   ([@"htm" isEqualToString:type]) ||
	   ([@"html" isEqualToString:type]) ||
	   ([@"doc" isEqualToString:type]) ||
       ([@"docx" isEqualToString:type]) ||
	   ([@"rtf" isEqualToString:type]) ||
	   ([@"mp3" isEqualToString:type]) ||
	   ([@"m4v" isEqualToString:type]) ||
	   ([@"jpg" isEqualToString:type]) ||
	   ([@"jpeg" isEqualToString:type]) ||
	   ([@"gif" isEqualToString:type]) ||
	   ([@"png" isEqualToString:type]) )
		return YES;
	return NO;
}
+(BOOL) isFileMusic :(NSString *)stype;
{
	NSString *type = [stype lowercaseString];
	if(([@"mp3" isEqualToString:type])) 
		
		return YES;
	return NO;
}
+(BOOL) isFileVideo :(NSString *)stype;
{
	NSString *type = [stype lowercaseString];
	if
		(
		 ([@"m4v" isEqualToString:type]) 
		 )
		return YES;
	return NO;
}



+(NSString *) prettyRowForTitle:(NSString *)title;

{
    
	NSString * rightHandImage = @"btn_song.png";
    for (InstanceInfo *ii in [KORRepositoryManager allVariantsFromTitle:title ])
        if ([self isFileWrappablePic:[ii.filePath pathExtension]])
            rightHandImage = @"btn_image.png";
    return rightHandImage;
}


+(NSUInteger) incomingInboxDocsCount;
{
	NSUInteger zipcount=0;
	NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[KORPathMappings pathForItunesInbox]  error: NULL];
	if (paths){
		for (NSString *path in paths)
			if (![path isEqualToString:@".DS_Store"])
			{
				NSString *fpath = [[KORPathMappings pathForItunesInbox] stringByAppendingPathComponent: path];
				NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:fpath 
																					   error: NULL];
				if (attrs && [[attrs fileType] isEqualToString: NSFileTypeRegular])
				{					
					NSString *ext = [fpath pathExtension]; //
					if ([self isFileTypeProcessedByUS:ext]==YES) zipcount++;			
				}
			}
	}
	return zipcount;
}

+(NSMutableArray *) makeInboxDocsList;
{
		//BOOL any = NO;
		//	NSUInteger zipcount=0;
	NSMutableArray *results = [[NSMutableArray alloc] init];
	NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[KORPathMappings pathForItunesInbox]  error: NULL];
	if (paths){
		for (NSString *path in paths)
			if (![path isEqualToString:@".DS_Store"])
			{
				NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: [[KORPathMappings pathForItunesInbox] 
																							   stringByAppendingPathComponent: path]
																					   error: NULL];
				if (attrs && [[attrs fileType] isEqualToString: NSFileTypeRegular])
				{
					[results addObject:path];
				}
			}
	}
	return results;
}

+ (KORDataManager *) globalData
{
	static KORDataManager *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[self alloc] init];
	}
	
	return SharedInstance;
}

+(float)getTotalDiskSpaceInBytes;
{
    float totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
	
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining File System Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
	
    return totalSpace;
} 
+ (NSString *) makeBlurb:(NSString *)title;
{
	NSArray *variants = [KORRepositoryManager allVariantsFromTitle:title] ;
	
	NSMutableString *result = [NSMutableString stringWithString:@""];	/// removed a retain here    042111
	NSUInteger varsCount = [variants count];
	NSMutableArray *blurbs = [[NSMutableArray alloc] initWithCapacity:varsCount] ;
	int blurbCounters [varsCount];
	NSUInteger blurbCount = 0; // must always be less
	NSUInteger musicCount = 0;
	NSUInteger plainCount = 0;
	NSUInteger videoCount = 0;
	for (NSUInteger i=0; i<varsCount; i++) blurbCounters[i]=0;
	for (InstanceInfo *ii in variants) 
	{
		NSString *ext = [ii.filePath pathExtension];
		
		if ([self isFileMusic:ext]) musicCount++;
		else 
			
			if ([self isFileVideo:ext]) videoCount++;
			else plainCount++;
		
		
			//	NSLog(@"--matching %@",sn);
		NSUInteger matched = NSNotFound;
		NSUInteger matchcount = 0;
		
			//up to the first slash to get the archive part of the filepath;
		NSString *s = [ii.archive stringByDeletingPathExtension];
		
		
		for (NSString *foo in blurbs) 
		{
				//NSLog(@"--isequal-- %@ -- %@",foo,s);
			if ([foo isEqualToString:s]) 
			{ 
				matched = matchcount; break;
			} 
			else matchcount++;
		}
		
		if (matched==NSNotFound)
		{
			[blurbs addObject:s]; // full names here
			blurbCounters[blurbCount]=1;
			blurbCount++;
				//NSLog (@"makeBlurb %@ count %d",s,blurbCount);
		}
		else 
		{
				//int jj = 
			blurbCounters[matched]++;
				//NSLog(@"--matched  %@ %d %d",
				//				  sn,matched, jj);
		}
	}
	
		//	if(videoCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x02AD]] ;
		//if(musicCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x266C]] ;
		//if(plainCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x0298]] ;
	
	for (NSUInteger i=0; i<blurbCount; i++)
	{	
		NSString	*sn = [KORRepositoryManager shortName:[blurbs objectAtIndex:i]];		
		NSUInteger bc = blurbCounters[i];
		
		if(bc<=1)
			
			[ result appendString:[NSString stringWithFormat: @" %@ ",sn]];
		
		else 
			
			[ result appendString: [NSString stringWithFormat:@" %@(%d) ",sn,bc ]];
		
	}
	
	return result; // some viewcontrollers fail if this [result autorelease];
}



+ (NSDictionary *) fetchBlurbs:(NSString *)title;
{
		// get extra details
    ClumpInfo *ti = [KORRepositoryManager findTune:title];
    NSMutableString *prefix = [NSMutableString stringWithString:@""];
    if ((ti == nil)||(ti.lastFilePath==nil)||([ti.lastFilePath isEqualToString:@""])) [prefix appendString: @"(never played)"];
	
	NSArray *variants = [KORRepositoryManager allVariantsFromTitle:title] ;
	
	NSMutableString *result = [NSMutableString stringWithString:@""];	/// removed a retain here    042111
	NSUInteger varsCount = [variants count];
	NSMutableArray *blurbs = [[NSMutableArray alloc] initWithCapacity:varsCount] ;
	int blurbCounters [varsCount];
	NSUInteger blurbCount = 0; // must always be less
	NSUInteger musicCount = 0;
	NSUInteger plainCount = 0;
	NSUInteger videoCount = 0;
	for (NSUInteger i=0; i<varsCount; i++) blurbCounters[i]=0;
	for (InstanceInfo *ii in variants) 
	{
        if (([ii.filePath isEqualToString:ti.lastFilePath]) && ([ii.archive isEqualToString: ti.lastArchive])) //mustchange, not sure we need second test
            
        { // on the precise match add to the prefix
			
            NSString *longpath = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive];
            
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: [[KORPathMappings pathForSharedDocuments] 
                                                                                           stringByAppendingPathComponent: longpath]
                                                                                   error: NULL];
            NSDate *date = [attrs objectForKey:NSFileCreationDate];
            NSNumber *size = [attrs objectForKey:NSFileSize];
            unsigned long long ull = ([size unsignedLongLongValue]);
            double mb = (double)ull	; // make this a double
            mb = mb/(1024.f); // Convert to K
			
				// <strong>Output ->  Date: 10/29/2008 08:29PM</strong>    
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MMM-dd HH:mm"];
            if ([ii.lastVisited isEqualToDate:date])
            {
					// never played
                
                NSString *dateString = [dateFormat stringFromDate:date];
                
                [prefix appendFormat:@"imported %@ (%.2fKB)", dateString,mb];
            }
            else
            {
					// played
				
				NSString *dateString = [dateFormat stringFromDate:ii.lastVisited];
				
				[prefix appendFormat:@"last played from %@ on %@ (%.2fKB)", [KORRepositoryManager shortName:ii.archive],dateString,mb];
                
			}
			
            
        }
		NSString *ext = [ii.filePath pathExtension];
		
		if ([self isFileMusic:ext]) musicCount++;
		else 
			
			if ([self isFileVideo:ext]) videoCount++;
			else plainCount++;
		
		
			//	NSLog(@"--matching %@",sn);
		NSUInteger matched = NSNotFound;
		NSUInteger matchcount = 0;
		
			//up to the first slash to get the archive part of the filepath;
		NSString *s = [ii.archive stringByDeletingPathExtension];
        
		
		for (NSString *foo in blurbs) 
		{
				//NSLog(@"--isequal-- %@ -- %@",foo,s);
			if ([foo isEqualToString:s]) 
			{ 
				matched = matchcount; break;
			} 
			else matchcount++;
		}
		
		if (matched==NSNotFound)
		{
			[blurbs addObject:s]; // full names here
			blurbCounters[blurbCount]=1;
			blurbCount++;
				//NSLog (@"makeBlurb %@ count %d",s,blurbCount);
		}
		else 
		{
				//int jj = 
			blurbCounters[matched]++;
				//NSLog(@"--matched  %@ %d %d",
				//				  sn,matched, jj);
		}
	}
	
		//	if(videoCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x02AD]] ;
		//	if(musicCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x266C]] ;
		//	if(plainCount>0) [result appendString:[NSString stringWithFormat:@"%C ",0x0298]] ;
	
	for (NSUInteger i=0; i<blurbCount; i++)
	{	
		NSString	*sn = [KORRepositoryManager shortName:[blurbs objectAtIndex:i]];		
		NSUInteger bc = blurbCounters[i];
		
		if(bc<=1)
			
			[ result appendString:[NSString stringWithFormat: @" %@ ",sn]];
		
		else 
			
			[ result appendString: [NSString stringWithFormat:@" %@(%d) ",sn,bc ]];
		
	}
	
		// [prefix appendString:result]; // some viewcontrollers fail if this [result autorelease];
    
    NSDictionary *bls = [NSDictionary dictionaryWithObjectsAndKeys:prefix,@"last-played",result,@"variants-blurb", nil];
    
    return bls;
}
+(NSMutableArray *) list:(NSArray *) list bringToTop:(NSArray *) special;
{
		// build a new list from list while bringing the specials to the top
	NSMutableArray *newlist = [[NSMutableArray alloc] init];
	for (NSString *s in list)
	{
		BOOL found=NO;
		
		for (NSString *t in special)
		{
			if ([t isEqualToString:s]) 
			{
				found = YES;
				break;
			}
		}
		
		if (found == NO)
		{
			[newlist addObject:s];
		}
	}
		// DO NOT sort the mutable arry
		//[newlist sortUsingSelector:@selector(compare:)];
	
		// now produce final merge with special items at the front
	
	NSMutableArray *final = [[NSMutableArray alloc] init];
	
	for (NSString *t in special) [final addObject:t];
	for (NSString *s in newlist) [final addObject:s];
	
	
	return final;
}
@end