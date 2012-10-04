//
//  DataManager.h
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#define UNKNOWN_COMMAND_TAG 999


#define INFOOVERLAY_COMMAND_TAG 300
#define ABOUT_COMMAND_TAG 302
#define PRINTER_COMMAND_TAG 304
#define WALLPAPER_COMMAND_TAG 308
#define INSTRUCTIONS_COMMAND_TAG 309

#define CONTACTUS_COMMAND_TAG 301
#define TELLAFRIEND_COMMAND_TAG 321

#define TITLE_COMMAND_TAG 324

#define AUTOSCROLLER_COMMAND_TAG 325
#define PERTUNEPREFS_COMMAND_TAG 327

#define METRONOME_COMMAND_TAG 326
#define METRONOMEPREFERENCES_COMMAND_TAG 328

#define SHOWFAVORITES_COMMAND_TAG 340
#define SHOWRECENTS_COMMAND_TAG 341
#define SHOWLISTS_COMMAND_TAG 342
#define SHOWARCHIVES_COMMAND_TAG 343

#define MANAGEFAVORITES_COMMAND_TAG 344
#define MANAGERECENTS_COMMAND_TAG 345
#define MANAGELISTS_COMMAND_TAG 346
#define MANAGEARCHIVES_COMMAND_TAG 347

#define SHOWWEBCAPTUE_COMMAND_TAG 348
#define SHOWPHOTOCAPTURE_COMMAND_TAG 349
 
#define  SHOWADDTOFAVORITES_COMMAND_TAG 350
#define SHOWADDTOLIST_COMMAND_TAG 351

#define SHOWSET1_COMMAND_TAG 352
#define SHOWSET2_COMMAND_TAG 353
#define SHOWSET3_COMMAND_TAG 354

#define TRAVERSING_COMMAND_TAG 355
#define ADDLIST_COMMAND_TAG 356
#define ADDARCHIVE_COMMAND_TAG 357
#define SHOW_PERSONALFILEMANAGER_TAG 358
#define IMPORT_ONTHEFLY_COMMAND_TAG 359


#define VARIANTS_COMMAND_TAG 329


#define RIGHTACTIONSHEET_COMMAND_TAG 303
#define LEFTACTIONSHEET_COMMAND_TAG 310


#define LEFTDETAILS_COMMAND_TAG 322
#define RIGHTDETAILS_COMMAND_TAG 323

#define LEFT_COMMAND_TAG 305
#define RIGHT_COMMAND_TAG 306

#define MAINMENU_COMMAND_TAG 307
#define ALTMENU_COMMAND_TAG 311
#define ALTMENUA_COMMAND_TAG 312
#define ALTMENUB_COMMAND_TAG 313
#define ALTMENUC_COMMAND_TAG 314
#define ALTMENUD_COMMAND_TAG 315
#define ALTMENUE_COMMAND_TAG 316
#define ALTMENUF_COMMAND_TAG 317
#define ALTMENUG_COMMAND_TAG 318
#define ALTMENUH_COMMAND_TAG 319
#define ALTMENUI_COMMAND_TAG 320


#define SHOWTHIS_COMMAND_TAG 330
#define SHOWNEXT_COMMAND_TAG 331
#define SHOWPREV_COMMAND_TAG 332


#define SEARCH_COMMAND_TAG 333
#define EXTENDEDSEARCH_COMMAND_TAG 360
#define SEARCHARCHIVESMENU_COMMAND_TAG 361
#define RUNDIAGNOSTICS_COMMAND_TAG 362
#define TESTHOOK_COMMAND_TAG 363
#define SHOWMP3PLAYER_COMMAND_TAG 364
#define FULLSCREEN_COMMAND_TAG 365
#define TITLELEFT_COMMAND_TAG 366

#define LEFTPLAIN_COMMAND_TAG 367
#define RIGHTPLAIN_COMMAND_TAG 368
#define ABOUTFULL_COMMAND_TAG 339
#define SHOWSETLISTSHARING_COMMAND_TAG 369
#define INTROOVERLAY_COMMAND_TAG 334
#define ALTOVERLAYA_COMMAND_TAG 334
#define ALTOVERLAYB_COMMAND_TAG 334
#define ALTOVERLAYC_COMMAND_TAG 334
#define ALTOVERLAYD_COMMAND_TAG 334

#define singleTapDidPulse  @"singleTapDidPulse"

#define  TITLE_WIDTH 140.0f
#define  STANDARD_NAV_HEIGHT 44.0f
#define  TOP_TOOBAR_HEIGHT 44.0f
#define  ADDRESS_BAR_HEIGHT 44.0f
#define  STATUS_BAR_HEIGHT 20.0f


#define NAV_BAR_HEIGHT 44.f
#define SEARCH_BAR_HEIGHT 50.f
#define STANDARD_THUMB_SIZE 60.f
#define LARGER_THUMB_SIZE  60.f
#define STANDARD_ROW_SIZE 66.f
#define LARGER_ROW_SIZE 66.f

#define INFO_ROW_SIZE 40.f


#define NORMAL_TOOLBAR_HEIGHT        44.0f
#define NARROW_TOOLBAR_HEIGHT       44.0f

#if defined (APP_STORE_FINAL)
#define CONSOLE_LOG(format, ...)
#else
#define CONSOLE_LOG(format, ...) CFShow ([NSString stringWithFormat: format, ## __VA_ARGS__]);
#endif

#if !ENABLE_APD_LOGGING
#define APD_LOG(format, ...)
#else
#define APD_LOG(format, ...)         CONSOLE_LOG (format, ## __VA_ARGS__)
#endif


#if !ENABLE_LLC_LOGGING
#define LLC_LOG(format, ...)
#else
#define LLC_LOG(format, ...)         CONSOLE_LOG (format, ## __VA_ARGS__)
#endif


//singleton datamanager

@class KORMP3PlayerView;

@interface KORDataManager : NSObject 

	// these are all computed and settled by the time startup or recovery is completed
@property  BOOL showFullWidth;
@property  BOOL inSim;
@property  (nonatomic, retain) 	UIView *nullView;
@property (nonatomic) NSUInteger sessionDisplayTransactionCount;
@property (nonatomic) NSUInteger oneTouchSemaphore;
@property (nonatomic) NSUInteger myLocalPort;  // set by bonjourmanager
@property (nonatomic, retain) NSString *myLocalIP; // read by the bonjourmanager
@property (nonatomic, retain) NSDate *starttime; // when we got going
@property (nonatomic, retain) NSDictionary *colorsDict; // named colors
@property (nonatomic, retain) NSDictionary *actionsDict;
@property (nonatomic, retain) NSArray * activeArchives;
@property (nonatomic, retain) UIView *xMonitorView;
@property (nonatomic, retain) NSString *applicationName;
@property (nonatomic, retain) NSString *applicationVersion;

@property (nonatomic, retain) NSString *userEnteredEmail;

@property (nonatomic, retain) NSString *openingAlert;
@property (nonatomic, retain) NSString *settingsVersion;
@property (nonatomic, retain) NSString *minswVersion;
@property (nonatomic, retain) NSString *startupWaitingImage;
@property (nonatomic) CGRect singleTouchFrame;
@property (nonatomic) CGRect singleTouchFrameLandscape;
@property (nonatomic,retain) KORMP3PlayerView *mp3PlayerView;


// the properties below this line are mostly settable thru plists


// these entries in the plist apply to the whole interface

@property (nonatomic) BOOL disableTopTitle;
@property (nonatomic) BOOL gigStandEnabled;

@property (nonatomic) BOOL singleTouchEnabled;
@property (nonatomic, retain) NSArray	*streamingSources;
@property (nonatomic, retain) NSString *startPageTitle;
@property (nonatomic, retain) NSString *startPopUpTitle;

@property (nonatomic, retain) NSString *startPushButton;


@property (nonatomic, retain) UIColor *topBackgroundColor;
@property (nonatomic, retain) UIColor *appBackgroundColor;
@property (nonatomic, retain) UIColor *performanceColor;
@property (nonatomic, retain) UIColor *colorBehindHTMLPages;


@property BOOL allowRotations;
@property BOOL adHocDistroToFriendsOnly;
@property BOOL stripFirstTitleComponent;
@property BOOL disableFooter;
@property BOOL transparentFooter;
@property BOOL disableAppleHeader;
@property BOOL startInFullScreenMode;

@property BOOL wantsIntroOverlay;

@property (readwrite) float statusBarHeight;
@property (readwrite) float standardRowSize;
@property (readwrite) float navBarHeight;
@property (readwrite) float searchBarHeight;
@property (readwrite) float toolBarHeight;
@property (readwrite) float fullScreenTimeout;

@property (readwrite) NSUInteger fullScreenTaps;

@property (readwrite) NSUInteger fullScreenAlerts;

	// these menu entries are completely specified in the plist 

@property (nonatomic, retain)  NSDictionary *titlesForHiddenPages;

@property (nonatomic, retain) NSMutableDictionary *cornerNavSettings;
@property (nonatomic, retain) NSMutableDictionary *emailSettings;
@property (nonatomic, retain) NSMutableDictionary *dropdownSettings;
@property (nonatomic, retain) NSMutableDictionary *absoluteSettings;

@property (nonatomic, retain) NSString *initialPileFilter;

@property (nonatomic, retain) NSString *lastMenuPresentedPrefix;
@property (nonatomic, retain) NSString *currentMenuPrefix;
@property (nonatomic, retain) NSDictionary *systemBarButtonImageNames;

@property (nonatomic, retain) NSDictionary *specialButtonBindings;
@property (nonatomic, retain) NSDictionary *actionSets;
@property (nonatomic, retain) NSDictionary *xibMappings;
@property (nonatomic, retain) NSDictionary *URLMappings;

@property (nonatomic, retain) NSDictionary *buttonHelp;

+ (KORDataManager *) globalData;

-(void) flushCache;

+(NSString *) findAction:(NSUInteger) tagx;
+(NSNumber *) actionToTag:(NSString *)s;
+(NSString *) prettyPath:(NSString *) s;
+(UIImage *) captureView:(UIView *)view;
+(NSString *) cleanupIncomingTitle:(NSString *)htitle;

// painting the screen

+(NSString *) makeUnadornedTitleView:(NSString *)titletext;
+(NSString  *) makeTitleView:(NSString *)titletext;
+(NSString *) generateUniqueTitle:(NSString *) suffix;
+(CGRect) busyOverlayFrame:(CGRect)frame;

// thumbnail makers
+(UIImage *)makeThumbFromFullPathOrResource:(NSString *) pathOrResource  forMenu:(NSString *) menu; 
+(UIImage *)makeThumbnailFS:(NSString *)pathOrResource ofSize:(float) length;
+(UIImage *) makeThumbnailImage:(NSString *)path; // includes -thumbs features

// document properties
+(BOOL) isPDF:(NSString *)filespec;
+(BOOL) isOpaque:(NSString *)filename;
+(BOOL) isFileMusic :(NSString *)stype;
+(BOOL) isFileVideo :(NSString *)stype;
+(BOOL) isFileWrappablePic :(NSString *)stype;

// filesystem

+(float)getTotalDiskSpaceInBytes;
+(BOOL) removeItemAtPath:(NSString *) path error:(NSError **)error;

// menus for opening documents in other programs

+(BOOL) docMenuForURL: (NSURL *) fileURL barButton: (UIBarButtonItem *) vew;
+(BOOL) docMenuForURL: (NSURL *) fileURL inView: (UIView *) vew;
// inbox is the conceptual merge of emails, iTunes, and any samples

+(NSUInteger) incomingInboxDocsCount;
+(NSMutableArray *) makeInboxDocsList;

// audio playback, currently limited to iPod player
+(void) playMusic:(NSString *)title;
+(BOOL) canPlayTune:(NSString *)s;
//

+(NSString *) makeBlurb:(NSString *)title;
+(NSDictionary *) fetchBlurbs:(NSString *)title;
+(NSString *) deriveLongPath:(NSString *)filePath forArchive:(NSString *)archive;
+(void) singleTapPulse;
+(NSMutableArray *) list:(NSArray *) list bringToTop:(NSArray *) special;

+ (void) showParamsInLog;


+(NSString *) lookupXib:(NSString *)xibPrefix;

+ (void)disallowOneTouchBehaviors;
+ (void)allowOneTouchBehaviors;

@end
