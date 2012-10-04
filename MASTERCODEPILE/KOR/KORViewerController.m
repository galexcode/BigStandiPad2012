
#import "KORDataManager.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORClumpInfoController.h"
#import "KORMediaViewController.h"
#import "KORAppDelegate.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORMainWebView.h"
#import "KORTwoLineButtonLabelView.h"
#import "KORTunePrefsManager.h"
#import "KORAlertView.h"
#import "KORExternalMonitorManager.h"
#import "KORMultiButtonControl.h"
#import "KORHelpViewController.h"
#import "KORViewLineButtonLabelView.h"
#import "KORMenuController.h"
#import "KORImageMenuController.h"
#import "KORTableMenuController.h"
#import "KORListsManager.h"
#import "KORAbsContentTableController.h"
#import "KORLargeArchiveController.h"
#import "KORSmallArchiveController.h"
#import "KORAssimilationController.h"
#import "KORDiagnosticRigController.h"
#import "DBInfo.h"
#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "KORSetListControllerIpad.h"
#import "KORViewerController.h"
#import "KORViewerController+CommandSystem.h"
#import "KORViewerController+InXoOverlays.h"
#import "KORViewerController+PlugSubs.h"
#import "KORViewerController+AutoScroller.h"
#import "KORViewerController+Metronome.h"
#import "KORWebBrowserController.h"

#pragma mark Internal Constants

#define CONTENT_VIEW_EDGE_INSET      0.0f
#define ANIMATION_DURATION           0.3f
#define NORMAL_EDGE_INSET            20.0f
#define NARROW_EDGE_INSET            8.0f
#define ZERO_EDGE_INSET              0.0f

@class KORAutoScrollViewControl,KORMetronomeViewControl;
@interface KORViewerController ()
	// all properties evacuated to .h file on 16 oct 11 so that categories could access freely - the bloat in here is otherwise incredible
@end

@implementation KORViewerController

@synthesize infoWebView,fsGestureRecog,toass,first,flipFlop,pushedToWebBrowser,firstFooter,snapshotTimer,setListChooserControl;
@synthesize archive,metronomeControl,buttonCompletionBlock;
@synthesize footerToolbarView,headerToolbarView,variantItems,variantChooserText;
@synthesize listName,listKind,listIncoming,listItems,archivePathForFile;
@synthesize canPlay,fullScreen,fullScreenFadeoutTimer,skipRotate,clumpIsShowing;
@synthesize contentFrame,infoOverlayXib,propsOverlayXib;
@synthesize currentTuneTitle,currentListPosition,currentVariantPosition;
@synthesize bottomPressGestureRecognizer,rsGestureRecog,lsGestureRecog,prevToggleEnabledState,toggleEnabledState;
@synthesize tintColor, delegate,mainWebView,autoscrollControl,autoscrollTimer;
@synthesize rightActionSheet,leftActionSheet,menuController,altmenuController,photoPopOverController,popoverController;


-(void) longPress: (id) sender
{
	[self exec_command:PERTUNEPREFS_COMMAND_TAG];
}

-(void) makeOneTuneView;
{	
	[self.mainWebView removeFromSuperview]; // hopefully stops
	self.mainWebView = nil; // hopefully calls dealloc inside
	
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"glassesClock_160x160.jpg"];
	self.mainWebView = [[KORMainWebView alloc]
						initWithFrame:self.contentFrame
						fallbackPath:path
						controller:self];
}

-(id)init{
		// make sure never called at this entry point
    NSLog (@"KORViewerController init() incorrectly called by %@", [self class]);
    return nil;
}


-(void) scrollwebview:(NSUInteger) pixels;
{
    [self.mainWebView windowDotScrollBy:pixels];
}

-(KORViewerController *) initWithURL:(NSURL *)URL andWithTitle:(NSString *) titlex
						andWithItems:(NSArray *)items;
{
	
		//	NSLog (@"KORViewerController  title:%@ items:%@",titlex,items);
	self = [super init];
	
	if (self)
	{
		self.first = YES; // cleared in viewdidappear
		self.canPlay = NO;
		self.listIncoming = items; // this will never change but will get nulled when listItem changes
		self.listName = @"tunes";
		self.listKind = @"all";
		self.fullScreen = NO; // for now
		self.archivePathForFile = nil;
        self.view = nil; // force loadview to get called
        self.currentTuneTitle = titlex;// [titlex  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		self.toggleEnabledState = YES; // important or the toggling will go batty
		self.firstFooter = ![KORDataManager globalData].singleTouchEnabled;
		
		NSString *filter = [KORDataManager globalData].initialPileFilter; //@"L*"; // filter initial pile down to just the display items
		
		NSMutableArray *a = [NSMutableArray array];
		for (NSString *item in self.listIncoming)
		{
			
				// this could get slow
			
			ClumpInfo *ti = [KORRepositoryManager findTune:item];
			if (ti == nil) NSLog(@"could not clumpinfo %@",item);
			else
				if (ti.lastFilePath == nil) NSLog(@"lastfilepath is nil for %@",item);
				else
					if (filter == nil) [a addObject:item];
					else
						
						if ([self isPath:ti.lastFilePath filteredBy:filter])
							[a addObject:item];
		}
		
		self.listItems = [NSArray arrayWithArray:a];    // must apply this filter
		
		self.currentListPosition = 0;   // now match to the title - if its not in the filter set, just use the first
		for (NSUInteger i=0; i<[self.listItems count]; i++)
			if ([[self.listItems objectAtIndex:i] isEqualToString:titlex])
			{ self.currentListPosition = i; break; }
		
	}
    
	return self;
}

- (NSString *) wrapWithHTML: (NSString *) ext ii: (InstanceInfo *) ii filename: (NSString *) filename
{
		// hallelujah = the fruits are fullsize thanks to the image height of 1004
    NSString *prebegin;
    NSString *preend;
    NSString *headerdata;	
	BOOL showFullWidth=[KORDataManager globalData].showFullWidth;
	NSString *dimension;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	if ((o==UIInterfaceOrientationLandscapeLeft )|| (o ==UIInterfaceOrientationLandscapeRight))
		dimension = (showFullWidth?@"width=1024":@"height=748");
	else dimension = (showFullWidth?@"width=768":@"height=1004");
	
		//NSString *spacer = showFullWidth?@"<div style='height:0px;'></div>":@"";
	
    if ([KORDataManager isFileWrappablePic:ext])
    {
			// wrap images
			// put a little html around the picture
        NSString *x = [NSString stringWithFormat:@"%@",[filename lastPathComponent]];
        return [NSString stringWithFormat: // was incorrectly max-device-width
                @"<html><head><meta name='viewport' content='initial-scale=1.0,maximum-scale=2.0,width=device-width'/><style>body,center,div,img {margin:0;padding:0;background:black;border-style:none;} </style></head><body><center><img %@ src='%@' alt='%@'/></center></body></html>",dimension,x,x];
		
    }
    else
    {
			// wrap htm and txt
			// if its any of these, look for a special header in the archiveheaders
			// if no header data then apply defaults
        headerdata = [KORRepositoryManager headerdataFromArchive:ii.archive type:ext];
        
        if (!headerdata)
        {
            float scale=1.1f;
            if ([ext isEqualToString:@"htm"])
            {
                scale =2.5f;
            }
            if ( [ext isEqualToString:@"txt"])
            {
                scale = 1.5f;
            }
            headerdata = [NSString stringWithFormat://content="initial-scale = 1.0,maximum-scale = 1.0"
                          @"<head><meta name='viewport' content='initial-scale=%1.1f ,maximum-scale=7.5, width=device-width '/><style>body,center,div,img {margin:0;padding:0;background:white;border-style:none;} </style></head>", scale];
        }
        
        if ([ext isEqualToString:@"txt"]) {
            prebegin = @"<pre>"; preend = @"</pre>";
        }
        else {
            prebegin = preend = @"";
        }
        
    }
    NSError *error;
    NSStringEncoding encoding;
		// Now build the full deal
    NSString *bodydata = [NSString stringWithContentsOfFile:filename usedEncoding:&encoding error: &error];
	if (error)
	{
		headerdata =
		@"<head><meta name='viewport' content='initial-scale = 1.0,maximum-scale = 1.0, width=device-width '/><style>body{color:#CCC;background:black} h3{color:#ff9933;}</style></head>";
		return  [NSString stringWithFormat:@"<html>%@<body><h3>Sorry, the tune %@ can not be displayed.</h3><p>Typically this is caused by some badly encoded characters in the source file.</p><p>To remedy, delete the tune and re-add a corrected file.</p></body></html>",headerdata, ii.title];
	}
	else
		
		return  [NSString stringWithFormat:@"<html>%@<body>%@%@%@</body></html>",headerdata,prebegin,bodydata,preend];
	
}
- (void) presentMedia: (NSString *) filename ii: (InstanceInfo *) ii
{    	
    NSURL    *url = [NSURL fileURLWithPath: filename isDirectory: NO];
	KORMediaViewController *mediaViewController = [[KORMediaViewController alloc] initWithURL: url andWithTune:ii.title] ;     [self.navigationController pushViewController:mediaViewController  animated:YES];    
}
- (void) presentScreen: (NSString *) filename ext: (NSString *) ext ii: (InstanceInfo *) ii
{
		// not media
    if ([KORDataManager isOpaque:filename] == NO) //
    {
        NSString *htmlstring = [self wrapWithHTML: ext ii: ii filename: filename];
        NSError *error;
			//  NSString *mainpath = [filename stringByDeletingLastPathComponent];
        
		NSLog (@"****WRAPPING %@",[KORDataManager prettyPath:filename]);
        
			// write this to a temp file and then display that
        NSString *tempfilepath = [[KORPathMappings pathForTemporaryDocuments] stringByAppendingPathComponent:@"/--htmlscratch--.html"]; //10/1/12
        
        [KORDataManager removeItemAtPath:tempfilepath error:&error];
        [htmlstring writeToFile:tempfilepath atomically:NO encoding:NSUTF8StringEncoding error:&error];
        
        NSURL    *docURL = [NSURL fileURLWithPath: tempfilepath isDirectory: NO];
        [mainWebView refreshWithURL: docURL];
			// [[ExternalMonitorManager sharedInstance] showDisplayHTML:[NSString stringWithFormat: @"<h3>presentScreen %@ not Opaque</h3>",docURL]];
			//[[KORExternalMonitorManager sharedInstance] showDisplayURL:docURL];
        
    }
    else
    {
			// Here for all those tunes that are totally opaque
        NSURL    *docURL = [NSURL fileURLWithPath: filename isDirectory: NO];
        [mainWebView refreshWithURL: docURL];
        
			//[[ExternalMonitorManager sharedInstance] showDisplayHTML:[NSString stringWithFormat: @"<h3>presentScreen %@ is Opaque</h3>", docURL]];
			//[[KORExternalMonitorManager sharedInstance] showDisplayURL:docURL];
    }   
}

- (void) presentErrorScreen: (NSString *) title  arg1:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3;
{	
	[KORAlertView alertWithTitle:title
						 message:[NSString stringWithFormat:@"%@ %@ %@",arg1,arg2,arg3]
					 buttonTitle:@"OK"];	
}


#pragma mark layout the whole bloody screen - displaytune is called on ff and rw
-(void) recordVisited:(InstanceInfo *)ii
{
    self.archive = ii.archive;
	ii.lastVisited = [NSDate date];
	ClumpInfo *ti = [KORRepositoryManager findTune:ii.title];
	ti.lastArchive = ii.archive;
	ti.lastFilePath = ii.filePath;
	
	[[KORAppDelegate sharedInstance ] saveContext:[NSString stringWithFormat:@"otv %@",ti.title]];
    
}

-(void) fadeToFullScreen:(id) idx
{
	if (self.fullScreenFadeoutTimer !=nil) // real?
		if (self.fullScreen==NO) // if not in fullScreenMode
		{	NSUInteger alertcount = [KORDataManager globalData].fullScreenAlerts;
			if ((alertcount < 3)&&(![KORDataManager globalData].singleTouchEnabled))
			{
				NSString *t = @"Tap to restore controls";
				
				if ([KORDataManager globalData].fullScreenTaps == 2)
					
					t= @"Double-tap to restore controls";
				else
					
					if ([KORDataManager globalData].fullScreenTaps == 3)
						
						t= @"Triple-tap to restore controls";
				
				[KORAlertView alertWithTitle:t message:@"or swipe and pinch" buttonTitle:@"OK"];
				
			}
			[self.popoverController dismissPopoverAnimated:YES];
			[self toggleFullRestartFadeout:idx]; // oh yeah
			[KORDataManager globalData].fullScreenAlerts =  alertcount + 1;
		}
	
}
-(void) startFadeoutTimer
{
		// cancel any outstanding nav fadeout timer
	
	[self.fullScreenFadeoutTimer invalidate];
	self.fullScreenFadeoutTimer =nil;
	
		// set new timer
	if (self.fullScreen==NO) // if not in fullScreenMode
	{
		self.fullScreenFadeoutTimer =
		[NSTimer
		 scheduledTimerWithTimeInterval:[KORDataManager globalData].fullScreenTimeout
		 target:self
		 selector: @selector(fadeToFullScreen:)
		 userInfo:NULL
		 repeats:NO];
			//NSLog (@"!!!!! startFadeoutTimer NO fullscreen %3.1f secs !!!!!",[KORDataManager globalData].fullScreenTimeout );
	}
	
}

-(void)loadPrefsForCurrentTune
{
		// set various properties for the scroller and metronome, these will be needed by the footer
	NSUInteger bpm = [KORTunePrefsManager prefUnsignedIntValueForKey:@"BeatsPerMinute" forTune:self.currentTuneTitle];
    if (bpm==0) bpm=kDefaultBPM;
	self.metronomeControl.bpm = bpm;
    NSUInteger numerator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigNumerator" forTune:self.currentTuneTitle];
    if (numerator==0) numerator=4;
	self.metronomeControl.numerator = numerator;
    NSUInteger denominator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigDenominator" forTune:self.currentTuneTitle];
    if (denominator==0) denominator=4;
	self.metronomeControl.denominator = denominator;
    
    NSUInteger pps = [KORTunePrefsManager prefUnsignedIntValueForKey:@"PixelsPerSecond" forTune:self.currentTuneTitle];
    if (pps==0) pps=kDefaultPPS;
	self.autoscrollControl.pps  = pps;
    BOOL scrollingOn = [KORTunePrefsManager prefBoolValueForKey:@"AutoScrollOn" forTune:self.currentTuneTitle];
	self.autoscrollControl.scrollingOn = scrollingOn;
	
}

-(void) tuneContext
{
		//NSLog (@">>>>DT %@ %@ %@",titlex,filePath,archivex);
	
	[self invalidateSnapshotTimer];		
	self.toggleEnabledState = YES; // allow fullscreen behaviors now that we are coming up fresh	
	[self startFadeoutTimer];	
	[KORDataManager globalData].sessionDisplayTransactionCount++;
	
		// put the new tune on display
	
	[KORDataManager globalData].currentMenuPrefix = [KORDataManager globalData].lastMenuPresentedPrefix; // this will be more accurate for presenting alternate menus
	
	[KORRepositoryManager setLastTitle:self.currentTuneTitle];
		//[[BonJourManager sharedInstance ] publishTXTFromLastTitle];
	
    self.canPlay = [KORDataManager canPlayTune:self.currentTuneTitle];
	
}


-(void) displayTuneByInstance:(InstanceInfo *)ii;
{
	NSAssert ([self.currentTuneTitle length]>0,@"currentTuneTitle not set");
	NSAssert ([self.variantItems count]>0,@"no variants is wierd ");
		//NSLog (@"displayTuneByInstance >> %@",ii);
	
		// called externally by variants command, also called  below
	
	[self tuneContext];

		self.navigationItem.title = [KORDataManager globalData].disableTopTitle ?@" ":
		[KORDataManager makeTitleView:self.currentTuneTitle] ;

		// replaced filename with direct referenc
	NSString *ext = [ii.filePath pathExtension];
	[self.metronomeControl stopSound];
    [self makeOneTuneView];  // setup for the refreshWithURL calls below
	
	[self.view  addSubview:mainWebView];
		
	NSString *filename = [[KORPathMappings pathForSharedDocuments] stringByAppendingPathComponent:  ii.filePath]; // make it real
	
	BOOL toplay = ([KORDataManager isFileMusic:ext]||[KORDataManager isFileVideo:ext]);
	if (toplay)
		
		[self presentMedia: filename ii: ii];
	else		
		[self presentScreen: filename ext: ext ii: ii];
	
	if (self.fullScreen==NO)
	{
		[self setupViewerHeaderAndFooter]; //adds self to background		
		[self loadPrefsForCurrentTune]; // now customize on current tune
		
	}
	[self recordVisited: ii]; // say we got there	
	[self startSnapshotTimer]; // take a snapshot if this has been up long enough	
	[self setupGestureRecognizers]; // moved down here
	return;
}
-(void) displayTuneByArchivePath;
{
	
		//	NSLog (@"displayTuneByArchivePath >> %@",self.archivePathForFile);
		///
		// find the best possible index here
	NSString *pfilepath =self.archivePathForFile;//111111 [parts objectAtIndex:1];//must change
	NSAssert ([pfilepath length]>0,@"displayTuneByArchivePath");
	
	ClumpInfo *tn = [KORRepositoryManager findTune: self.currentTuneTitle];
    if (tn)
    {
		self.variantItems= [KORRepositoryManager allVariantsFromTitle:tn.title];
        for (InstanceInfo *ii in self.variantItems)
            if  ([pfilepath isEqualToString:ii.filePath])
			{
				[self displayTuneByInstance:(InstanceInfo *)ii];
				return;
			}
	}
		// if currentTune cant be found, or if it has no instances, we are essentially broken
	
	[self setupViewerHeaderAndFooter]; //adds self to background
    [self presentErrorScreen:  self.currentTuneTitle
                        arg1: self.archivePathForFile
                        arg2: @"is no longer on this device"
                        arg3: self.archivePathForFile];
}



-(void) displayTuneByTitle: (NSString *)titlex;
{
		//NSLog (@"displayTuneByTitle >> %@ ",titlex);
		
		// ** Display Tune By Title Only	
		// ** If no title (very first time) then use last on most recent list	
		// ** If no most recent list then use very first item on the current list
	
	if ([titlex length] ==0)
	{
		titlex = [KORListsManager lastTuneOn:@"recents" ascending:NO];
		
		if ([titlex length] ==0)
			titlex = [self.listItems objectAtIndex:0];
	}
	
	self.currentVariantPosition = 0;
    self.currentTuneTitle = [titlex copy]; // with arc why do we need this?
	
	ClumpInfo *ti = [KORRepositoryManager       findTune:self.currentTuneTitle];
	self.archivePathForFile = [KORDataManager deriveLongPath:ti.lastFilePath forArchive:ti.lastArchive];
	
		// [self scanUntilMatch:self.currentTuneTitle];
		
    NSInteger startpos = self.currentListPosition;
    do
    {
        self.currentListPosition++;// advances cursor until we find a match
        if (abs(self.currentListPosition)>=[self.listItems count]) self.currentListPosition= 0;
        
		NSString *t = [self.listItems objectAtIndex:self.currentListPosition];		
        if ([t isEqualToString:self.currentTuneTitle]) break;

    } while (startpos != self.currentListPosition);
		
	NSAssert ([self.archivePathForFile length]>0,@"displayTuneByTitle");
		
	[self displayTuneByArchivePath];
}


-(void) displayTuneByTitleArchive: (NSString *)titlex archive:(NSString *)archivex;
{
		//NSLog (@"displayTuneByTitleArchive >> %@  %@",titlex,archivex);
	
	self.currentTuneTitle = titlex;	
	self.archivePathForFile = @"";
	self.currentVariantPosition = 0;
	
	for (InstanceInfo *ii in [KORRepositoryManager allVariantsFromTitle:titlex])
	{
		if ([ii.archive isEqualToString:archivex])
		{
			self.archivePathForFile = [KORDataManager deriveLongPath:ii.filePath forArchive:ii.archive] ;
			[self displayTuneByArchivePath];
			return;
		}
		self.currentVariantPosition++; // adjust
	}
	
		// if we find nothing, try again with just the title
		//	NSAssert ([self.archivePathForFile length]>0,@"displayTuneByTitleArchive title not found");
	
	[self displayTuneByTitle: titlex];	
}

-(void) buildFullView:(UIInterfaceOrientation) fromOrient fullScreen:(BOOL) fullScreenStart
{
	
		//
		//
		// there are 3 views:
		//
		// the outer view is self.view - it is set to black
		// oneTuneView - is most of basicView (or all in fullscreen mode) except the footer
		// footerToolbarView - is the footer
		//
		//
	
    [self.mainWebView removeFromSuperview];
    [self.footerToolbarView removeFromSuperview];
	[self.headerToolbarView removeFromSuperview]; // only relevant if no navbar
    self.mainWebView = nil; // prevent any mistakes
    
    self.fullScreen = fullScreenStart;
	self.footerToolbarView.hidden = self.fullScreen;
	self.headerToolbarView.hidden = self.fullScreen;
	
	if ([KORDataManager globalData].disableAppleHeader == NO)
	{
		self.navigationController.navigationBarHidden = self.fullScreen;
		self.navigationController.wantsFullScreenLayout = self.fullScreen; //??
	}
	
		//
		//basicView
		//
    
	CGRect tmpFrame  = CGRectStandardize ([UIScreen mainScreen].bounds);// this better be rock solid
	if ((fromOrient == UIInterfaceOrientationPortrait) || (fromOrient == UIInterfaceOrientationPortraitUpsideDown))
	{
		CGFloat temp = tmpFrame.size.width;
		tmpFrame.size.width = tmpFrame.size.height;
		tmpFrame.size.height = temp;
	}
	
    CGFloat height = tmpFrame.size.height - [KORDataManager globalData].statusBarHeight;// - [KORDataManager globalData].toolBarHeight;
	tmpFrame.size.height = height;
	
    CGRect t2 = tmpFrame ; //self.basicView.frame;  //was bounds
						   //t2.size.height = height;
    self.contentFrame = t2;
		//
		//NSLog (@"BuildFullView  orient  %d  contentframe %3.fwx%3.fh",fromOrient,t2.size.width,t2.size.height);
}

#pragma mark Overridden UIViewController Methods
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
	if (self.firstFooter)// dont allow rotation until we are fully setup
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	
	else
		if ([KORDataManager globalData].allowRotations)
			return YES;
	
		else return (interfaceOrientation == UIInterfaceOrientationPortrait) ;
	
}


-(void) viewDidUnload
{
    [super viewDidUnload];
    
    if (self.delegate)
        [self.delegate dismissOTCController];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
	[self.metronomeControl stopSound];// stopMetronome:animated];	
    [self.autoscrollTimer invalidate]; // cancel timer - activated in category
    [super viewDidDisappear:animated];
}

- (void) loadView
{		// have uttlerly failed to make navigationBar  work with the UIAppearance Protocol
		// Just lets go to black here
		// NSLog (@"AbstractTuneController(%@) activated for %@",[self class],self.currentTuneTitle);
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
		// translucent makes it barf
	self.navigationController.navigationBar.tintColor = [UIColor blackColor]; //
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack ;
    
	
		//	if ([KORDataManager globalData].startPageTitle)
		//self.currentTuneTitle = [[KORDataManager globalData].startPageTitle copy]; // with arc why do we need this?
		//self.currentTuneTitle = [titlex copy]; // with arc why do we need this?
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	if ((o==UIInterfaceOrientationLandscapeLeft )|| (o ==UIInterfaceOrientationLandscapeRight)) o = UIInterfaceOrientationPortrait;
	else o = UIInterfaceOrientationLandscapeLeft;
	
    [self buildFullView:o fullScreen:[KORDataManager globalData].startInFullScreenMode ]; // flip polarity	
	[self displayTuneByTitle:@""]; // in LOADVIEW, ONLY ONCE
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(toggleFullRestartFadeout:)
												 name:singleTapDidPulse
											   object:nil];
	

    
}
-(void) pushTheButton:(id)o
{
	NSNumber *thistag = [KORDataManager actionToTag:[KORDataManager globalData].startPushButton];
	[self exec_command:[thistag unsignedIntValue]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	if (self.pushedToWebBrowser)
	{
		self.pushedToWebBrowser = NO;  //untoggle
		[self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait]; // the orientation is ignored, full screen repaint
	}
	else
		if (self.first)
	{
			// put out an opening alert
		if ([[KORDataManager globalData].openingAlert length] > 0)
			[KORAlertView alertWithTitle:[KORDataManager globalData].openingAlert
								 message:nil
							 buttonTitle:@"OK"];
		
			// do something if requested
		if ([[KORDataManager globalData].startPushButton length] > 0)
		{
				// let it the controller unwind before the actual push
			[NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector (pushTheButton:)  userInfo:NULL repeats:NO];
				//		NSLog (@"viewercontroller with timer %@",timer);
		}		
		else			
		{
			
		}
		self.first = NO;
	}
	
	
	
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromOrient
{
	
    if (self.skipRotate == NO)
	{
		UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
		if ((o==UIInterfaceOrientationLandscapeLeft )|| (o ==UIInterfaceOrientationLandscapeRight)) o = UIInterfaceOrientationPortrait;
		else o = UIInterfaceOrientationLandscapeLeft;
		
		[self buildFullView:o fullScreen:self.fullScreen]; // flip polarity  but leave fullscreen alone
		[self displayTuneByArchivePath];
		
	}
    self.skipRotate = NO;
    
}

#pragma mark
#pragma mark Categories (were in OneTuneCategories)
#pragma mark


-(void) specialButtonBindingHit:(UITapGestureRecognizer *) ooo;
{
		//NSLog (@"specialButtonBindingHit %d",ooo.view.tag);
	[self exec_command:ooo.view.tag];
}
-(NSString *) onoffLabel:(BOOL) b;
{
    if (b) return @"ON";
    else return @"OFF";
}


-(BOOL) isPath:(NSString *)s filteredBy:(NSString *)filter
{
        // risk business but locate the "L*" or similar pattern
    
    if ((filter == nil) || (s==nil)){
        NSLog (@"misconfiguration of filterpiles - check your pList");
        [[KORAppDelegate sharedInstance] dieFromMisconfiguration:@"pile filters are not set correctly"];
		return NO;
    }
    if ([s rangeOfString:filter].location == NSNotFound) {
			//NSLog(@"isItem %@ does not contain %@",s,filter);
        return NO;
    } else {
			//NSLog(@"isItem %@ contains %@!",s,filter);
        return YES;
    }
}


- (void) presentMenuWithFilter:(NSString *) filter
						 style:(NSUInteger) mode
			   backgroundColor:(UIColor *) bgColor
					titleColor:(UIColor *) tcColor
		  titleBackgroundColor: (UIColor *) tcbColor //textColor: tx textBackgroundColor: txb
					 textColor:(UIColor *) txColor
		   textBackgroundColor: (UIColor *) txbColor
				 thumbnailSize:(NSUInteger) thumbsize
			   imageBorderSize:(NSUInteger) imageborderSize
				   columnCount:(NSUInteger) columnCount
					   tagBase:(NSUInteger) base
					  menuName:(NSString *) name
					 menuTitle:(NSString *) title
					  fromRect:(CGRect) presentingRect;
{
	
	
		//	NSLog (@"presentMenuWithFilter %@ style: %d thumbnailSize: %d imageBorderSize: %d columnCount: %d tagBase:%d menuName: %@ menuTitle: %@",
		//		   filter,mode,thumbsize,imageborderSize,columnCount,base,name,title);
		//
	self.altmenuController = nil;
	[KORDataManager globalData].lastMenuPresentedPrefix = name;  // this gets moved into currentMenuPrefix when page is displayed
	
		// moving filtering to the creator who allocs this menu controller
	
	NSMutableArray *a = [NSMutableArray array];
	for (NSString *item in self.listIncoming)
	{
		
			// this could get slow
		
		ClumpInfo *ti = [KORRepositoryManager findTune:item];
		if (ti == nil) NSLog(@"could not clumpinfo %@",item);
		else
			if (ti.lastFilePath == nil) NSLog(@"lastfilepath is nil for %@",item);
		
            else
				
				if ([self isPath:ti.lastFilePath filteredBy:filter])
					[a addObject:item];
	}
	
	self.listItems = [NSArray arrayWithArray:a];    // must apply this filter
	self.currentListPosition = 0; // point to the first [WITHOUT THIS WE CRASH WHEN MOVING TO SHORTER LIST]
	
	if (mode==1)
	{
		self.altmenuController =
		
		[[KORImageMenuController alloc] initWithItems:self.listItems
										   filteredBy:filter  // now ignored
												style:(NSUInteger) mode
									  backgroundColor: (UIColor  *) bgColor
										   titleColor: (UIColor  *) tcColor
								 titleBackgroundColor: (UIColor *) tcbColor
											textColor:(UIColor *) txColor
								  textBackgroundColor: (UIColor *) txbColor
										thumbnailSize: (NSUInteger) thumbsize
									  imageBorderSize: (NSUInteger) imageborderSize
										  columnCount: (NSUInteger) columnCount
											  tagBase:(NSUInteger) base
											 menuName:(NSString *) name
											menuTitle:(NSString *) title ];
		
	}
	else 	if (mode==2)
	{
		self.altmenuController =
		
		[[KORTableMenuController alloc] initWithItems:self.listItems
										   filteredBy:filter
												style:(NSUInteger) mode
									  backgroundColor: (UIColor *) bgColor
										   titleColor: (UIColor  *) tcColor
								 titleBackgroundColor: (UIColor *) tcbColor
											textColor:(UIColor *) txColor
								  textBackgroundColor: (UIColor *) txbColor
										thumbnailSize: (NSUInteger) thumbsize
									  imageBorderSize: (NSUInteger) imageborderSize
										  columnCount: (NSUInteger) columnCount
											  tagBase:(NSUInteger) base
											 menuName:(NSString *) name
											menuTitle:(NSString *) title ];
	}
	self.altmenuController.tuneselectordelegate = self;
	
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
		if (self.popoverController)
        {
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil; // prevent troubles
        }
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController: self.altmenuController] ;
        self.popoverController.popoverContentSize = self.altmenuController.menuSize;
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:presentingRect
												inView:self.view
							  permittedArrowDirections: UIPopoverArrowDirectionUp
											  animated: YES];
    }
    else
    {
        KORMenuController *mc =self.altmenuController;
		
		if ([KORDataManager globalData].disableAppleHeader == NO)
			[self.navigationController pushViewController:mc animated:YES];
		else
		{
			
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mc];
			[self presentViewController:nav animated:YES completion:NULL];
			
		}
    }
}

	// uipopover delegate comes here
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController

{
	return YES;
	
}

#pragma mark main dispatcher for command processing
#pragma mark ItemChosenProtocol

-(void) actionItemChosen:(NSUInteger) itemIndex label:(NSString *)tune newItems:(NSArray *)newItems listKind:(NSString *)listkind listName:(NSString *)listname
{
	if ((UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)) // minor hack to throw this out
		[self.navigationController popViewControllerAnimated:YES];
	else
	{
		if (self.popoverController)
        {
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil; // prevent troubles
        }
	}
	if (newItems != nil) // only reset context if told
	{
		self.listItems = nil; self.listIncoming = nil;
		self.listItems = newItems; // hoping
	}
	self.listKind = listkind;
	self.listName = listname;
	
    self.currentTuneTitle = tune; // with arc why do we need this?
	
	if ([self.listKind isEqualToString:@"archive"])
	{
		self.listName = [KORRepositoryManager shortName:listname];

		[self displayTuneByTitleArchive:tune archive:listname]; // use long name of archjive
	}
	
	else	
    [self displayTuneByTitle:tune];
	
		// OK, the backgroundcolor is touchy - to remove white flicker we must use clearColor but this causes many webpages to come out with a black background
		// because they are lacking a bit of css ala body {background-color:white;}
		// SO, just use this if we are in KIOSK mode
		//if ([DataManager sharedInstance].isKioskMode == YES)
    self.mainWebView.backgroundColor = [UIColor clearColor];
		//else
		//self.oneTuneView.backgroundColor = [UIColor blackColor]; // this is the color of the "Flicker" between document transitions
    
		// change info page
    if (self.clumpIsShowing) [self showInfoOverlay]; // change page if its up
}


#pragma mark otc Protocol gets us control back to blow away the controller we created

-(void) dismissOTCController;
{
    [self dismissViewControllerAnimated:YES  completion: ^(void) {
			//NSLog (@"%@ was dismissed",[self class]);
    }];
}

	//  PANEL HANDLING FOR METRONOME

#pragma mark
#pragma mark PANEL HANDLING FOR METRONOME
#pragma mark



	//  PANEL HANDLING FOR AUTOSCROLL
#pragma mark
#pragma mark  PANEL HANDLING FOR AUTOSCROLL
#pragma mark



#pragma mark
#pragma mark GESTURE STUFF
#pragma mark


#pragma mark gesture delegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	
    return YES;
}


#pragma mark screen presentations  end up vectoring thru here


	// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
	// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
		//
		//	if ((otherGestureRecognizer == fsGestureRecog) || (gestureRecognizer == fsGestureRecog))
		//		return NO;
	
	return YES;
}

-(void) setupGestureRecognizers;
{
		// if gsEnabled then swipes work whether nav is up or not, otherwise only in full screen mode
    [self.mainWebView removeGestureRecognizer: rsGestureRecog];
    rsGestureRecog = nil;
    [self.mainWebView removeGestureRecognizer: lsGestureRecog];
    lsGestureRecog = nil;
	[self.mainWebView removeGestureRecognizer: fsGestureRecog];
    fsGestureRecog = nil;
	
	if (![KORDataManager globalData].singleTouchEnabled)
	{
		
			//if (self.fullScreen) - wld 12sep12 - always allow taps to fullscreen
			//{
		fsGestureRecog = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (toggleFullScreen:)];
		fsGestureRecog.numberOfTapsRequired =[KORDataManager globalData].fullScreenTaps;
			//		NSLog (@"full screen taps %d",[KORDataManager globalData].fullScreenTaps);
		[self.mainWebView addGestureRecognizer: fsGestureRecog];
			//}
		
        rsGestureRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)] ;
        rsGestureRecog.numberOfTouchesRequired = 1;
		
        rsGestureRecog.delegate = self;
        rsGestureRecog.direction = UISwipeGestureRecognizerDirectionRight;
        [self.mainWebView addGestureRecognizer:rsGestureRecog];
        
        lsGestureRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        lsGestureRecog.numberOfTouchesRequired = 1;
        lsGestureRecog.delegate = self;
        lsGestureRecog.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.mainWebView addGestureRecognizer:lsGestureRecog];
		
	}
	else
	{
			// non gigstand programs dont have gestures except in fullscreen mode
		if (self.fullScreen) {
			rsGestureRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)] ;
			rsGestureRecog.numberOfTouchesRequired = 1;
			rsGestureRecog.delegate = self;
			rsGestureRecog.direction = UISwipeGestureRecognizerDirectionRight;
			[self.mainWebView addGestureRecognizer:rsGestureRecog];
			lsGestureRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
			lsGestureRecog.numberOfTouchesRequired = 1;
			lsGestureRecog.delegate = self;
			lsGestureRecog.direction = UISwipeGestureRecognizerDirectionLeft;
			[self.mainWebView addGestureRecognizer:lsGestureRecog];
		}
	}
    
}
#pragma mark special gesture for full screen toggle

- (void) toggleFullScreen: (id)abt
{
	if(self.toggleEnabledState == YES)
	{
		BOOL wasFullScreen = self.fullScreen;
			// everylast thing was set up in init
		self.fullScreen = ! (self.fullScreen);
		self.navigationController.navigationBarHidden = self.fullScreen;
		self.footerToolbarView.hidden = self.fullScreen;
		self.headerToolbarView.hidden = self.fullScreen;
			//	if (wasFullScreen == NO)
		[self setupGestureRecognizers]; // reset gesture recognizers		
		if (wasFullScreen == YES)
		{
			[self setupViewerHeaderAndFooter]; // rebuild			
			[self startFadeoutTimer]; // and restart timer
		}
	}
}

-(void) toggleFullRestartFadeout:(id)abt
{
		//NSLog (@"!!!! toggleFullRestartFadeout !!!!");
	if(self.toggleEnabledState == YES)
	{
		[self toggleFullScreen:abt];
		if (self.fullScreen == NO)
		{
			[self startFadeoutTimer]; // and restart timer
		}
	}
}


#pragma mark special gesture for left right hand sweep to next or previous tune

-(void) rewindTune;
{	
	InstanceInfo *ii = [self.variantItems objectAtIndex:self.currentVariantPosition];	
		// called on swiping and on direct tap
	NSString *ti = [self goBackOnList];
	self.currentVariantPosition = 0;
	[self displayTuneByTitleArchive:ti archive:ii.archive];
}
-(void) fastforwardTune;
{	
	InstanceInfo *ii = [self.variantItems objectAtIndex:self.currentVariantPosition];	
		// called on swiping and on direct tap
	NSString *ti = [self goForwardOnList];
	self.currentVariantPosition = 0;
	[self displayTuneByTitleArchive:ti archive:ii.archive];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)//||(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self fastforwardTune];
    }
    else
        if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)//||(recognizer.direction == UISwipeGestureRecognizerDirectionDown)
        {
            [self rewindTune];
        }
    
		// ignore up and down swipes
}
#pragma mark snapshot
-(void) invalidateSnapshotTimer;
{
	if (snapshotTimer!=nil)
	{
		[snapshotTimer invalidate];
		snapshotTimer = nil;
	}
}
- (void) startSnapshotTimer;
{
	[self invalidateSnapshotTimer];
    snapshotTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                     target:self
												   selector:@selector(takeSnapShot:)
												   userInfo:nil
													repeats:NO];
}

- (void) expandSnapShotPile
{
    SnapshotInfo *ssi = [KORRepositoryManager findSnapshotInfo:self.currentTuneTitle];
    if (ssi == nil) {
			// if this is not in the pile, then add it
        ClumpInfo *ti = [KORRepositoryManager findTune:self.currentTuneTitle];
        NSString *fullpath = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@/%@",ti.lastArchive,ti.lastFilePath];
        [KORRepositoryManager insertSnapshotInfo:fullpath title:ti.title];
			//  NSLog (@"snapshots added %@ filepath %@",ti.title ,ti.lastFilePath);
        NSUInteger counter = [KORRepositoryManager snapshotCount];
        if (counter > 99) [KORRepositoryManager removeOldestSnapshot];
    }
}
-(void) takeSnapShot:(NSTimer *)timer {
    
    [self invalidateSnapshotTimer];
	[KORListsManager updateRecents: self.currentTuneTitle];  // this is where we add to recents
    NSUInteger count = [KORListsManager itemCountForList:@"recents"];
    if (count>25)
        [KORListsManager removeOldestOnList:@"recents"];
	
    [self expandSnapShotPile];
    
}

#pragma mark UIImagePickerDelegate


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *shot = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *titl = [KORDataManager generateUniqueTitle:[NSString stringWithFormat:@" %1.fx%1.f",shot.size.width,shot.size.height]];
    [KORRepositoryManager saveImageToOnTheFlyArchive:shot title:titl ];
    
    [KORAlertView alertWithTitle:@"Stored in OnTheFlyArchive"
                         message:@"" buttonTitle:@"OK"];
    
		// NSLog (@"Media info for %@ is %@",titl,info);
	
    
		// [[self presentingViewController] dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
	
	[self.photoPopOverController dismissPopoverAnimated:YES];
		//  [self dismissModalViewControllerAnimated:YES ];// completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
}

#pragma mark Import or Diagnostic Rig Complete
#pragma mark AssimilationComplete Protocol Methods

-(void)assimilationComplete:(BOOL)success
{
	
	NSLog (@"DiagnosticRigController signaled assimilationComplete to KORViewerController");
}
#pragma mark Set List Support including delegate
-(void) choseSetList :(NSDictionary *) dict
{
	[KORListsManager insertListItemUnique: [dict objectForKey:@"tune"]
                                   onList:[dict objectForKey:@"list"] top:NO];
    self.setListChooserControl = nil; // make it disappear itself
	[KORAlertView alertWithTitle:[NSString stringWithFormat:@"Added %@ to",[dict objectForKey:@"tune"]]
						 message:[dict objectForKey:@"list"]  buttonTitle:@"Ok"];
}

#pragma mark New Archive Selected

-(void)archiveChosen: (NSString *) newarchive;

{
		//NSLog (@"picked %@",newarchive);
		//if (self.popcon) [self.popcon dismissPopoverAnimated:YES];
	if (self.popoverController) [self.popoverController dismissPopoverAnimated:YES];
	NSArray *items = [KORRepositoryManager allTitlesFromArchive:newarchive];
	
	KORAbsContentTableController *viewcontroller;
	
	if ([items count] > 30) viewcontroller = [[KORLargeArchiveController alloc] initWithArchive:newarchive];
	else viewcontroller = [[KORSmallArchiveController alloc] initWithArchive:newarchive];
	viewcontroller.tuneselectordelegate = self;
	viewcontroller.importDelegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
	nav.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:nav animated:YES completion:NULL];
	
}
#pragma mark display a setlist
-(void) presentListController:(NSString *) s
{
	
	KORSetListControllerIpad *atvc = [[KORSetListControllerIpad alloc] initWithName:s edit:YES currentTitle:self.currentTuneTitle];
	
	atvc.tuneselectordelegate = self;
	
	atvc.trampolinedelegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:atvc];
	
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
	{
		if (self.popoverController)
		{
			[self.popoverController dismissPopoverAnimated:YES];
			self.popoverController = nil; // prevent troubles
		}
		self.popoverController = [[UIPopoverController alloc] initWithContentViewController: nav] ;
		CGRect frame = atvc.view.frame;
		
		
		self.popoverController.popoverContentSize = frame.size;
		self.popoverController.delegate = self;
		[self.popoverController presentPopoverFromRect:(CGRectMake(0,0,1,1)) inView:self.view
							  permittedArrowDirections: UIPopoverArrowDirectionUp
											  animated: YES];
	}
	else
		[self presentViewController:nav animated:YES completion:NULL];
}

-(void)setlistChosen: (NSString *) newlist;
{
	[self presentListController:newlist];	
}

#pragma mark import
-(void)startImport :(NSTimer *)timer {
	
	NSDictionary *uInfo = [timer userInfo];
	NSString *aname = [uInfo objectForKey:@"archive"];
	
	KORAssimilationController *kac = [[KORAssimilationController alloc] initWithArchive: aname];
	kac.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
	nav.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:nav animated:YES
					 completion: ^(void){
						 NSLog (@"KORAssimilationController presentViewController completion");
						 
					 }];
	
}
-(void)importIntoArchive: (NSString *) newarchive;
{
	if (self.popoverController) [self.popoverController dismissPopoverAnimated:YES];
	else [self dismissModalViewControllerAnimated:NO];
	
		//
	[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector (startImport:)
								   userInfo:[NSDictionary dictionaryWithObject:newarchive forKey:@"archive"] repeats:NO];
	
	
}
#pragma mark make lists  here -not in use now
-(void)makeNewList: (NSString *) newlist;
{
	if (self.popoverController) [self.popoverController dismissPopoverAnimated:YES];
}

#pragma mark Commands Get Launched From Other Controllers here
-(void) trampoline:(NSUInteger) commandtag;
{
		// first rid self of whomever is calling us might be called from a popover, maybe not
	
	if (self.popoverController) [self.popoverController dismissPopoverAnimated:YES];
	else
		[self dismissViewControllerAnimated:YES completion: ^(void) {
			NSLog (@"dismissing in middle of trampoline with tag %d",commandtag);
		}];
	
	[self exec_command:commandtag];
}
-(void) trampolineOneArg:(NSUInteger) commandtag arg:(id)obj;
{
		// first rid self of whomever is calling us might be called from a popover, maybe not
	
	if (self.popoverController) [self.popoverController dismissPopoverAnimated:YES];
	else
		[self dismissViewControllerAnimated:YES completion: ^(void) {
			NSLog (@"dismissing in middle of trampoline with tag %d",commandtag);
		}];
	
	[self exec_command_one_arg:commandtag arg: obj];
}
#pragma mark autoscroll timer comes back to here
-(void) scrollTimerFired: (id) ugh
{
    [self scrollwebview:2]; // not sure why this doesnt work with 1
							// instead of getting ios to handle the repeats we do it one at a time becuase autoscrollControl.duration may have been changed by the UI
    if ((self.autoscrollTimer != nil)&& self.autoscrollControl.scrollingOn) // will be nil when cancelled and we dont wnat to propogate
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoscrollControl.duration
                                                                target:self selector:@selector(scrollTimerFired:)  userInfo:nil repeats:NO];
}


#pragma mark webview delegate is for Info and Intro Overylays only


- (void) webViewDidFinishLoad: (UIWebView *) webView;
{
	NSLog (@" info overlay webViewDidFinishLoad");
		//[self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView*)webViewx shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *URL = [request URL];
	
	NSLog (@"info overlay shouldStartLoadWithRequest  %@",[URL absoluteString]);
		//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];
			//		if ([[URL scheme] isEqualToString:@"http"]) {
			//				//addressBar.text = [URL absoluteString];
			//			[self gotoAddress:[URL absoluteString]];
			//		}
			//		else if  (![URL scheme]|| [[URL scheme] isEqualToString:@""]) {
			//				//addressBar.text = [NSString stringWithFormat:@"http://%@",[URL absoluteString] ];
			//			[self gotoAddress:self.pageURL];
			//		}
        NSLog (@"info overlay pushing to %@",[URL absoluteString]);
		
		self.pushedToWebBrowser = YES; // set flag so we know how to behave when coming back to viewdidappear
		KORWebBrowserController *kac = [[KORWebBrowserController alloc]
										initWithURL:[URL absoluteString]
										andTitle:[URL absoluteString]
										snapShotControl:NO]
		;
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
		[self  presentViewController:nav animated:YES
						  completion: ^(void){
								  // NSLog (@"WebCaptureController presentViewController completion");
							  
						  }];
		return NO;
	}
	return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webViewx {
		//[activityIndicatorView startAnimating];
	NSLog (@"info overlay webviewdidstartload");
}

-(void) webView:(UIWebView *)webViewx didFailLoadWithError:(NSError *)error
{
    NSLog (@" info overlay -- didFailLoadWithError %@",[error description]);
}
@end
