	//
	//  KORViewerController+CommandSystem.m
	//  MasterApp
	//
	//  Created by bill donner on 10/16/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "KORWebBrowserController.h"
#import "KORALertView.h"
#import "KORAssimilationController.h"
#import "KORDiagnosticRigController.h"
#import "KORRepositoryManager.h"
#import "KORPathMappings.h"
#import "KORActionSheet.h"
#import "KORAutoScrollViewControl.h"
#import "KORAlertView.h"
#import "KORDataManager.h"
#import "KORMultiButtonControl.h"
#import "KORTableMenuController.h"
#import "KORImageMenuController.h"
#import "KORTwoLineButtonLabelView.h"
#import "KORMetronomeViewControl.h"
#import "KORAutoscrollViewControl.h"
#import "KORViewLineButtonLabelView.h"
#import "KORRepositoryManager.h"
#import "KORViewerController+CommandSystem.h"
#import "KORViewerController+InXoOverlays.h"
#import "KORViewerController+PlugSubs.h"
#import "KORViewerController+AutoScroller.h"
#import "KORViewerController+Metronome.h"
#import "KORViewerController+PropsOverlays.h"
#import "KORListsManager.h"
#import "KORSetListControllerIpad.h"
#import "KORListChooserControl.h"
#import "KORSetlistsMenuController.h"
#import "KORListMakerController.h"
#import "KORAllTunesController.h"
#import "KORMisConfigurationController.h"
#import "KORArchivesMenuController.h"
#import "KORMetronomePrefsController.h"
#import "KORPerTunePrefsController.h"

#import "KORAudioStreamingController.h"
#import "KORTunePrefsManager.h"
#import "KORMultiSegmentControl.h"
#import "KORWebBrowserController.h"

@implementation KORViewerController (CommandSystem)
#pragma mark Forward/Backward on General Lists

-(NSString *) goBackOnList;
{	
	self.currentListPosition--;
	if (self.currentListPosition<0) self.currentListPosition= [self.listItems count]-1;
	NSString *t = [self.listItems objectAtIndex:self.currentListPosition];
		//	NSLog (@">>gobackto %d %@",self.currentListPosition,t);
	return t;
}

-(NSString *) goForwardOnList;
{
	
	self.currentListPosition++;
	if (abs(self.currentListPosition)>=[self.listItems count]) self.currentListPosition= 0;
	NSString *t = [self.listItems objectAtIndex:self.currentListPosition];
		//	NSLog (@">>gofwdto %d %@",self.currentListPosition,t);
	return t;
}

-(NSString *) previousOnList
{	
		// does not change the cursor
	NSInteger pos = self.currentListPosition-1;
	if (pos<0) pos = [self.listItems count]-1;
	NSString *t = [self.listItems objectAtIndex:pos];
	return t;
}

-(NSString *) nextOnList
{
	NSInteger pos = self.currentListPosition+1;
	if (abs(pos)>=[self.listItems count]) pos= 0;
	NSString *t = [self.listItems objectAtIndex:pos];
	return t;
}


-(void) makeMenu:(NSString *)namePrefix

{
	
	NSDictionary *ddset = [[KORDataManager globalData].dropdownSettings objectForKey:namePrefix];
	
	CGRect lpos =   CGRectMake(1,1,1,1);
	
	CGRect rpos = CGRectMake(767,1,1,1);
	
	UIColor *bc, *tc, *tcb, *tx, *txb;
	
	bc = [[KORDataManager globalData].colorsDict objectForKey: 
		  [ddset objectForKey:@"BackgroundColor"]];
	
	if (bc == nil) {	
			//NSLog (@"no background color for %@ using white",namePrefix);
		bc = [UIColor whiteColor];	
	}
	tc = [[KORDataManager globalData].colorsDict objectForKey: 
		  [ddset objectForKey:@"TitleColor"]];
	
	if (tc == nil) {	
			//NSLog (@"no title color for %@ using gray",namePrefix);
		tc = [UIColor blackColor];	
	}
	
	tcb = [[KORDataManager globalData].colorsDict objectForKey: 
		   [ddset objectForKey:@"TitleBackgroundColor"]];
	
	if (tcb == nil) {	
			//NSLog (@"no title background color for %@ using gray",namePrefix);
		tcb = [UIColor whiteColor];	
	}
	
	tx = [[KORDataManager globalData].colorsDict objectForKey: 
		  [ddset objectForKey:@"TextColor"]];
	
	if (tx == nil) {	
			//NSLog (@"no text color for %@ using black",namePrefix);
		tx = [UIColor blackColor];	
	}
	
	txb = [[KORDataManager globalData].colorsDict objectForKey: 
		   [ddset objectForKey:@"TextBackgroundColor"]];
	
	if (txb == nil) {	
			//NSLog (@"no text background color for %@ using white",namePrefix);
		txb = [UIColor whiteColor];	
	}
	
	[self presentMenuWithFilter: [ddset
								  objectForKey: @"PileFilter"]	
						  style: [[ddset 
								   objectForKey:@"MenuStyle"]
								  intValue]
				backgroundColor: bc titleColor: tc titleBackgroundColor: tcb textColor: tx textBackgroundColor: txb
				  thumbnailSize: [[ddset 
								   objectForKey: @"ThumbNailSize"]	intValue]
				imageBorderSize: [[ddset 
								   objectForKey:@"ImageBorderSize"]	intValue]
					columnCount: [[ddset 
								   objectForKey:@"ColumnCount"]	intValue]
						tagBase: [[ddset 
								   objectForKey:@"TagBase"]	intValue]
					   menuName:namePrefix 
					  menuTitle:[ddset 
								 objectForKey:@"MainTitle"]
	 
					   fromRect: ([[ddset 
									objectForKey:@"RightHanded"]	boolValue])? rpos:lpos 
	 
	 ];
}

-(void) setupActionSheet:(KORActionSheet *) sheet named:(NSString *)sheetname  
{

	NSString *namePrefix = [KORDataManager globalData].currentMenuPrefix;
	
	NSDictionary *ddset = [[KORDataManager globalData].dropdownSettings objectForKey:namePrefix];
		
	__block typeof(self) bself = self;
	
	NSString *s = [ddset   objectForKey:sheetname];
	
	NSDictionary *dict = [[KORDataManager globalData].actionSets objectForKey:s];
	
	
	NSMutableDictionary *rm =[NSMutableDictionary dictionaryWithDictionary: dict];
	
	
	sheet = [sheet initWithTitle:[rm objectForKey:@"Title"]];
	
	
	NSMutableArray *ractionMenuTags = [NSMutableArray array];
	for (NSString *s in [rm objectForKey:@"ActionMenuActions"]){
		[ractionMenuTags addObject:[KORDataManager actionToTag:s]];
	}
	NSArray *rtags = [NSArray arrayWithArray:ractionMenuTags];
	[rm setObject:rtags forKey:@"ActionMenuTags"];
	
	NSUInteger count = [[rm objectForKey:@"ActionMenuActions"]   count];
	
	for (NSUInteger i=0; i<count; i++)
	{
		NSString *title = [[rm objectForKey:@"ActionMenuLabels"]objectAtIndex:i];
		
		NSNumber *tag = [[rm objectForKey:@"ActionMenuTags"] objectAtIndex:i];
		
		
		[sheet addButtonWithTitle: title //image:image
				  completionBlock: ^(void){
					  [bself exec_command:[tag unsignedIntValue]];
				  }];
	}
}

-(NSArray *) makeToolbarItems:(NSString *)navname alignment:(UITextAlignment)alignment 
{
	NSDictionary *masterdict = [KORDataManager globalData].cornerNavSettings;
	
	NSDictionary *dict;
	NSArray *labels;
	NSArray *icons;
	NSArray *actions;
	UIView *vvv = nil;
	
	dict =  [masterdict objectForKey:navname]; // open appropriate dictionary
	
		//NSLog (@"%@ is %@",navname, dict);
	
	labels =  [dict objectForKey:@"MenuLabels"];
	icons = [dict objectForKey:@"MenuIcons"];
	actions = [dict objectForKey:@"MenuActions"];
	
	NSMutableArray *tags =[NSMutableArray array];	
	NSMutableArray *views = [NSMutableArray array];
	
	for (NSString *actionname in actions)
	{
		NSNumber *thistag = [KORDataManager actionToTag:actionname];
		vvv = [self buildView : [thistag unsignedIntValue]];
		if (vvv ==nil) 
			vvv=[KORDataManager globalData].nullView; // flesh it out
		
		[tags addObject:thistag];
		[views addObject:vvv ]; // flesh it out		else
		
	} // end inner loop 

	int viewscount = [views count];
	int tagcount = [tags count];
	int labelscount = [labels count];
	int iconscount = [icons count];
	
	if ( (tagcount !=viewscount) ||
		(tagcount !=labelscount) ||
		(tagcount !=iconscount)  ||
		(iconscount != labelscount)
		)
	{
		NSString *why = [NSString stringWithFormat:@" - mismatched action vectors in %@; check your plist", navname];
		NSLog (@"KORViewController %@",why);

		return [NSArray array];
	}
	
	id control;
	
	if ([dict objectForKey:@"SegmentedControl"])
		
	{
		
		// learn howto put in segmented controller
	control = [KORMultiSegmentControl	multiSegmentWithTitles: labels
													  images:icons
													 tags:tags
												  navname:(NSString *)navname
										  completionBlock:
			  ^(NSUInteger thistag){
				  [self exec_command:thistag];
			  }
			  ];
		
		return 	[NSArray arrayWithObject: [KORBarButtonItem buttonWithCustomView:control completionBlock:NULL] ] ;
	}
	
	else {
		control = [KORMultiButtonControl	multibuttonWithTitles: labels
												   images: icons				 
													views: views
													 tags:tags
												  navname:(NSString *)navname
												alignment:(UITextAlignment)alignment
										  completionBlock:
			  ^(NSUInteger thistag){
				  [self exec_command:thistag];
			  }
			  ];
	
	return 	[NSArray arrayWithObject: control ] ;	
	}
}

-(KORTwoLineButtonLabelView *) makeNowViewingView
{
	KORTwoLineButtonLabelView *title = [[KORTwoLineButtonLabelView alloc] initWithFrame:CGRectMake(0,0,140,44)];
	title.line2Label.text = self.currentTuneTitle;	
	title.line2Label.textColor = [UIColor yellowColor];  
	title.line1Label.text = @"viewing";
	title.line1Label.textColor = [UIColor grayColor];

	title.line1Label.textAlignment = UITextAlignmentRight;
	title.line2Label.textAlignment = UITextAlignmentRight;
	return title;	
}
-(KORTwoLineButtonLabelView *) makeNowViewingLeftView
{
	KORTwoLineButtonLabelView *title = [[KORTwoLineButtonLabelView alloc] initWithFrame:CGRectMake(0,0,300,44)];
	title.line2Label.text = self.currentTuneTitle;	
	title.line2Label.textColor = [UIColor yellowColor];  
	title.line1Label.text = @"planB 10708";
	title.line1Label.textColor = [UIColor grayColor];
	
	title.line1Label.textAlignment = UITextAlignmentRight;
	title.line2Label.textAlignment = UITextAlignmentRight;
	
	return title;	
}
-(KORTwoLineButtonLabelView *) makeNowTraversingView
{
	KORTwoLineButtonLabelView *title = [[KORTwoLineButtonLabelView alloc] initWithFrame:CGRectMake(0,0,60,44)];
	title.line2Label.text = self.listName;
	title.line1Label.text = self.listKind;
	title.line1Label.textAlignment = UITextAlignmentLeft;
	title.line2Label.textAlignment = UITextAlignmentLeft;
	title.line2Label.font = [UIFont boldSystemFontOfSize: 12];
	return title;	
}

-(KORViewLineButtonLabelView *) makeFastforwardDetailsView;
{
	float wid;
	
	if(  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
		wid = 130.f;
	else
		wid = 200.f;
	
		// NEXT ON LIST BUTTON
	
	KORViewLineButtonLabelView *nv = [[KORViewLineButtonLabelView alloc] 
									  initWithFrame:CGRectMake(0,0,wid,42) 
									  imageNamed:@"icon-arrowRight-20x20"
									  whichSide:NO];
	nv.line2Label.textAlignment = UITextAlignmentRight;	
	nv.line2Label.backgroundColor  = [UIColor clearColor];
	nv.line2Label.text = [[self nextOnList] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	
	NSString *email;
	if ([[KORDataManager globalData].userEnteredEmail length]>0) 
		email= [KORDataManager globalData].userEnteredEmail; 
	else email = @"<ShovelReadyApps off>";
	nv.sideLabel.text = [NSString stringWithFormat:@"%@",email];
	
	return nv;
	
}

-(KORViewLineButtonLabelView *) makeFastforwardPlainView;
{
	float wid;
	
	if(  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
		wid = 130.f;
	else
		wid = 200.f;
	
		// NEXT ON LIST BUTTON
	
	KORViewLineButtonLabelView *nv = [[KORViewLineButtonLabelView alloc] 
									  initWithFrame:CGRectMake(0,0,wid,42) 
									  imageNamed:@"icon-arrowRight-20x20"
									  whichSide:NO];
	nv.line2Label.textAlignment = UITextAlignmentRight;	
	nv.line2Label.backgroundColor  = [UIColor clearColor];
	nv.line2Label.text = [[self nextOnList] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	
	return nv;
	
}

-(KORViewLineButtonLabelView *) makeRewindDetailsView;
{
	float wid;
	
	if(  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
		wid = 130.f;
	else
		wid = 200.f;
	
		// NEXT ON LIST BUTTON
	
	KORViewLineButtonLabelView *nv = [[KORViewLineButtonLabelView alloc] 
									  initWithFrame:CGRectMake(0,0,wid,42) 
									  imageNamed:@"icon-arrowLeft-20x20"
									  whichSide:YES];
	
	nv.line2Label.textAlignment = UITextAlignmentLeft;	
	nv.line2Label.backgroundColor  = [UIColor clearColor];
	nv.line2Label.text = [[self previousOnList] 
						  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	nv.sideLabel.text = [NSString stringWithFormat:@"%@ %@",[KORDataManager globalData].applicationName,[KORDataManager globalData].applicationVersion];
	
	return nv;
	
}
-(KORViewLineButtonLabelView *) makeRewindPlainView;
{
	float wid;
	
	if(  UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
		wid = 130.f;
	else
		wid = 200.f;
	
		// NEXT ON LIST BUTTON
	
	KORViewLineButtonLabelView *nv = [[KORViewLineButtonLabelView alloc] 
									  initWithFrame:CGRectMake(0,0,wid,42) 
									  imageNamed:@"icon-arrowLeft-20x20"
									  whichSide:YES];
	
	nv.line2Label.textAlignment = UITextAlignmentLeft;	
	nv.line2Label.backgroundColor  = [UIColor clearColor];
	nv.line2Label.text = [[self previousOnList] 
						  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	

	
	return nv;
	
}

-(KORAutoScrollViewControl *) makeAutoScrollerButtonView
{

		//if (!self.autoscrollControl)// dont cache, it retains previous settings
	
	InstanceInfo *ii = [self.variantItems objectAtIndex:self.currentVariantPosition];
	
	BOOL isPDF= [KORDataManager isPDF:ii.filePath];

	self.autoscrollControl = [[KORAutoScrollViewControl alloc] initWithFrame:
							  CGRectMake(0,0,(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)?40:60,40) isPDF: isPDF];	
	
	NSUInteger pps = [KORTunePrefsManager prefUnsignedIntValueForKey:@"PixelsPerSecond" forTune:self.currentTuneTitle];
	self.autoscrollControl.pps  = pps;
	BOOL scrollingOn = [KORTunePrefsManager prefBoolValueForKey:@"AutoScrollOn" forTune:self.currentTuneTitle];
	self.autoscrollControl.scrollingOn = scrollingOn;
	[self.autoscrollControl refreshAutoScrollButtonLabel];
	return self.autoscrollControl;
	
}


-(KORMetronomeViewControl *) makeMetronomeButtonView
{
		//if (!self.metronomeControl)//dont cache
		
	self.metronomeControl =  [[KORMetronomeViewControl alloc] initWithFrame:CGRectMake(0,0,60,40)];
	NSUInteger bpm = [KORTunePrefsManager prefUnsignedIntValueForKey:@"BeatsPerMinute" forTune:self.currentTuneTitle];
	self.metronomeControl.bpm = bpm;
	NSUInteger numerator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigNumerator" forTune:self.currentTuneTitle];
	self.metronomeControl.numerator = numerator;
	NSUInteger denominator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigDenominator" forTune:self.currentTuneTitle];
	self.metronomeControl.denominator = denominator;
	[self.metronomeControl refreshMetronomeButtonLabel];
	return self.metronomeControl;
}



-(KORTwoLineButtonLabelView *) makeVariantsButtonView
{
    KORTwoLineButtonLabelView *vv = [[KORTwoLineButtonLabelView alloc] 
									 initWithFrame:CGRectMake(0,0,(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)?60:60,40)];
	NSUInteger variantCount = [self.variantItems count];
	if (variantCount>1){
        vv.line1Label.textColor = [UIColor yellowColor];
        vv.line2Label.textColor = [UIColor yellowColor];  
	}
	
	InstanceInfo *ii = [self.variantItems objectAtIndex:self.currentVariantPosition];
	NSString *typeLabel = [ii.filePath pathExtension];
	
    vv.line2Label.text = (variantCount>1?[NSString stringWithFormat:@"%@(%1d)",typeLabel,variantCount]:[NSString stringWithFormat:@"%@",typeLabel]);
	vv.line2Label.font = [UIFont boldSystemFontOfSize: 12];
	vv.line1Label.text = [KORRepositoryManager shortName:ii.archive];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		vv.line1Label.font = [UIFont boldSystemFontOfSize: 12];
	return vv;
}





-(UIView *) buildView:(NSUInteger) tag
{// these are the dynamic button faces 
	
	
		//	NSLog (@"buildView %d",tag);
	switch (tag) {
			
		case LEFTDETAILS_COMMAND_TAG: return [self makeRewindDetailsView];
		case RIGHTDETAILS_COMMAND_TAG: return [self makeFastforwardDetailsView];
			
			
		case LEFTPLAIN_COMMAND_TAG: return [self makeRewindPlainView];
		case RIGHTPLAIN_COMMAND_TAG: return [self makeFastforwardPlainView];
			
			
		case TITLE_COMMAND_TAG: return [self makeNowViewingView];
			
		case TITLELEFT_COMMAND_TAG: return [self makeNowViewingLeftView];
		case TRAVERSING_COMMAND_TAG: return [self makeNowTraversingView];
		case AUTOSCROLLER_COMMAND_TAG: return [self makeAutoScrollerButtonView];
		case METRONOME_COMMAND_TAG: return [self makeMetronomeButtonView];
		case VARIANTS_COMMAND_TAG: return [self makeVariantsButtonView];
	}
	
		//NSLog (@"buildView no match");
	return nil;
}
-(NSArray *) setupLeft:(NSString *) left 
				center:(NSString *) center 
				 right:(NSString *) right;
{
	
		/// really need to do some checking on the plist entries before we get too trusting in here which will crash us
	NSMutableArray *items = [NSMutableArray array];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL] ;
	
	[items addObjectsFromArray: [self makeToolbarItems:left alignment:(UITextAlignment)UITextAlignmentLeft ]];
	
	[items addObject:flexSpace];
	
		//********* NOT SURE WHY BUT MUST FUDGE CENTER ALIGNMENT *********
	
	[items addObjectsFromArray: [self makeToolbarItems:center alignment:(UITextAlignment)UITextAlignmentCenter ]];
	
	
		UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: NULL] ;
		fixedSpace.width = 37.f;
		[items addObject:fixedSpace]; 
		//	
		//********* END NOT SURE WHY BUT MUST FUDGE *********
	
	
	[items addObject:flexSpace];
	
	[items addObjectsFromArray: [self makeToolbarItems:right alignment:(UITextAlignment)UITextAlignmentRight ]];	
	return items;	
}

#pragma
#pragma mark HEADER SETUP FOR NO NAVBAR
#pragma
-(NSArray *) setupHeaders;
{	return [self setupLeft:@"TopLeftNav" 
					center:@"TopCenterNav" 
					 right:@"TopRightNav"];
	
}
-(void) headerSetup;
{
		// make a totally fresh toolbar, account for whether we have a navbar or not
	
	[self.headerToolbarView removeFromSuperview];
	self.headerToolbarView =nil;
		//	float delta =[KORDataManager globalData].disableAppleHeader?0:   [KORDataManager globalData].navBarHeight ;
	CGRect tmpFrame  = CGRectStandardize ([UIScreen mainScreen].bounds);
	CGFloat height = tmpFrame.size.height - [KORDataManager globalData].statusBarHeight;
	tmpFrame.size.height = height;
	tmpFrame.origin.y = 0;//(tmpFrame.size.height - delta - [KORDataManager globalData].toolBarHeight);
	tmpFrame.size.height = [KORDataManager globalData].toolBarHeight;
	if ([KORDataManager  globalData].transparentFooter)
		
		self.headerToolbarView = [[TransparentToolbar alloc] initWithFrame:tmpFrame];	
	else
		self.headerToolbarView = [[WhispyToolbar alloc] initWithFrame:tmpFrame];	

		// blend all this together
	
		//NSMutableArray *headerToolbarItems = [NSMutableArray arrayWithArray:[self setupHeaders]];
	
	self.headerToolbarView.items = [self setupHeaders]; // 050711
	
		// NOW add the toolbor to the basic view, thats all we can do
	
	[self.view  addSubview:self.headerToolbarView];
	
}
-(NSArray *) setupFooter;
{
	return [self setupLeft:@"BottomLeftNav" 
					center:@"BottomCenterNav" 
					 right:@"BottomRightNav"];
	
}

-(void) footerSetup;
{
		// make a totally fresh toolbar, account for whether we have a navbar or not
	
	[self.footerToolbarView removeFromSuperview];
	self.footerToolbarView = nil;
		//	float delta =[KORDataManager globalData].disableAppleHeader?0:   [KORDataManager globalData].navBarHeight ;

	float delta;
	
	if (self.firstFooter) delta = [KORDataManager globalData].navBarHeight;
	else
		 delta = 0;
	self.firstFooter = NO; // turn this off
	CGRect bounds = self.view.bounds;
	CGRect tmpFrame  = CGRectMake(0,bounds.size.height-44,bounds.size.width,44);
	tmpFrame.origin.y = self.view.frame.size.height -  [KORDataManager globalData].toolBarHeight- delta;		
	tmpFrame.size.height = [KORDataManager globalData].toolBarHeight;
	
	if ([KORDataManager  globalData].transparentFooter)
		self.footerToolbarView = [[TransparentToolbar alloc] initWithFrame:tmpFrame];	
	else
		self.footerToolbarView = [[WhispyToolbar alloc] initWithFrame:tmpFrame];	

	self.footerToolbarView.items = [self setupFooter]; // 050711
	
	// NOW add the toolbar to the basic view, thats all we can do
//	if ([KORDataManager globalData].gigStandEnabled ){
//			// add a long press gesture
//	
//	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
//										  initWithTarget:self 
//										  action:@selector(longPress:)];
//	
//	
//	[self.footerToolbarView addGestureRecognizer:lpgr];
//		}
	
		// NSLog (@"RAW SIZE IS %.0f FOOTER IS %.0f %.0f",self.view.frame.size.height, tmpFrame.origin.y,tmpFrame.size.height);
	
	[self.view  addSubview:self.footerToolbarView];

}

-(void) setupViewerHeaderAndFooter;
{
	NSArray *leftItems = [self makeToolbarItems:@"TopLeftNav" alignment:(UITextAlignment)UITextAlignmentLeft ];
	NSArray *rightItems = [self makeToolbarItems:@"TopRightNav" alignment:(UITextAlignment)UITextAlignmentRight];
	
	if ([KORDataManager globalData].disableAppleHeader ==NO)
	{
		self.navigationItem.leftBarButtonItem = 		[leftItems objectAtIndex:0];
		
		self.navigationItem.rightBarButtonItem = 	     [rightItems objectAtIndex:0];
		
	}
	else
	{
		[self  headerSetup];
	}
	
		//	if ([KORDataManager globalData].disableFooter == NO)
		
		[self footerSetup]; // now setup up Footer
	
}

-(void) clump_dispatcher:(NSUInteger) tagx
{
	NSString *helpHTML;
	if (tagx == 999)
	{
		
		helpHTML= nil;
	}
	else
	{
	NSString *actionName = [KORDataManager findAction: tagx];
	 helpHTML= [[KORDataManager globalData].buttonHelp objectForKey:actionName];
	}
	if (helpHTML == nil) helpHTML = [[KORDataManager globalData].buttonHelp objectForKey:@"DEFAULT"];

		if (!self.infoOverlayXib) self.infoOverlayXib = 
			[self standardPanel: [KORDataManager lookupXib:@"InfoOverlay"]];
		
		UIView *theview= self.infoOverlayXib;
		[self showPanel: theview
		   dismissBlock: ^(void){
			   [self.infoOverlayXib removeFromSuperview];
			   self.clumpIsShowing = NO;
			   self.infoOverlayXib = nil;
			   
		   }];
		
	
		NSString *fullHTML = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='initial-scale=1.0'><style>body,center,div,img {margin:0;padding:0;background:black;color:white;border-style:none;} a {text-decoration:none; color:gray}</style></head><body><div style='margin:3px; padding: 3px; font-family:Arial; font-size:2.4em;'>%@</div></body></html>",helpHTML ];
		
		UIView *v = (UIWebView *)[self.infoOverlayXib viewWithTag:897]; //fix up the webview
		[v removeFromSuperview]; //take this offscreen
	
		UIWebView *wv = (UIWebView *)[self.infoOverlayXib viewWithTag:898]; //fix up the webview
			//
		wv.delegate = self; // arrange for callback on hyperlink
		wv.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		wv.scalesPageToFit = YES;
		[wv loadHTMLString: fullHTML baseURL: nil];
		
		[self.view addSubview:theview];
		
		self.clumpIsShowing = YES;

}

-(void) exec_command_one_arg:(NSUInteger) tagx arg:(id)obj;
{
	
	switch (tagx)
	{
		case SHOWSETLISTSHARING_COMMAND_TAG:
		{
			NSString *setlist = (NSString *) obj;
			
			__block typeof(self) bself = self;
			self.toass = [[KORActionSheet alloc] initWithTitle: [NSString stringWithFormat:@"%@ - Setlist Sharing Options" ,setlist]];
	
			[self.toass addButtonWithTitle:NSLocalizedString (@"Email", @"") completionBlock:^(void) {
				[bself emailSetlist:setlist];
			}];
			
			[self.toass addButtonWithTitle:NSLocalizedString (@"Print", @"") completionBlock:^(void) {
				[bself printSetlist:setlist];
			}];
			[self.toass showInView:self.view];			
			break;
		}	
	}
}

-(void) exec_command:(NSUInteger) tagx
{			 
	if (self.clumpIsShowing) [self clump_dispatcher:tagx];
		
	
	else
	
	switch (tagx) 
	{
		case MAINMENU_COMMAND_TAG:
		{
			[self makeMenu:@"MAINMENU"];
			break;
		}
			
		case ALTMENU_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU"];			
			break;
		}
		case ALTMENUA_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-A"];		
			break;
		}
		case ALTMENUB_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-B"];				
			break;
		}
		case ALTMENUC_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-C"];				
			break;
		}
		case ALTMENUD_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-D"];			
			break;
		}
		case ALTMENUE_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-E"];				
			break;
		}
		case ALTMENUF_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-F"];			
			break;
		}
		case ALTMENUG_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-G"];			
			break;
		}
		case ALTMENUH_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-H"];			
			break;
		}
		case ALTMENUI_COMMAND_TAG:
		{
			[self makeMenu:@"ALTMENU-I"];			
			break;
		}
			
		case INTROOVERLAY_COMMAND_TAG:
		{
			[self showIntroOverlay];
			break; // call this to get the initial intro screen back up again
		}
		case INFOOVERLAY_COMMAND_TAG:
		{
			
			NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"html" inDirectory:@"instructionsHTMLPage"]];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
			KORWebBrowserController *wvc = [[KORWebBrowserController alloc] initWithRequest: requestObj   ];
		
			wvc.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: wvc] ;
			[self presentViewController:nav animated:YES completion: NULL];
			break;
			break;
		}
			
		case LEFTDETAILS_COMMAND_TAG:
			
		case LEFTPLAIN_COMMAND_TAG:
			
		case LEFT_COMMAND_TAG: {
				//email
			[self rewindTune];
			
			if (self.clumpIsShowing) [self showInfoOverlay]; // change page if its up
			break;
		}
			
		case  RIGHTDETAILS_COMMAND_TAG: 
			
		case  RIGHTPLAIN_COMMAND_TAG: 
			
		case  RIGHT_COMMAND_TAG: 
		{
			[self fastforwardTune];
			
			if (self.clumpIsShowing) [self showInfoOverlay]; // change page if its up
			break;
		}
			
		case  CONTACTUS_COMMAND_TAG:
		{
				//email
			[self emailTune: @"ContactUsEmail"];
			break;
		}
		case  TELLAFRIEND_COMMAND_TAG:
		{
				//email
			[self emailTune: @"TellAFriendEmail"];
			break;
		}
		case  PRINTER_COMMAND_TAG:
		{
				//email
			[self printTune:nil];
			break;
		}
		case ABOUT_COMMAND_TAG:
		{
				// hidden about page
			
			NSString *dir = [[KORDataManager globalData].activeArchives objectAtIndex:0];
			
			[self pushToWebPage: [ [KORPathMappings pathForSharedDocuments]
								  stringByAppendingFormat:@"/%@/hidden/about.html",dir]];
			break;
		}
		case ABOUTFULL_COMMAND_TAG:
		{
				// hidden about page
			
			NSString *dir = [[KORDataManager globalData].activeArchives objectAtIndex:0];
			
			[self pushToWebPageFull: [ [KORPathMappings pathForSharedDocuments]
								  stringByAppendingFormat:@"/%@/hidden/about.html",dir]];
			break;
		}
		case INSTRUCTIONS_COMMAND_TAG:
		{
				// hidden instructions page
			
			
			NSString *dir = [[KORDataManager globalData].activeArchives objectAtIndex:0];
			
			[self pushToWebPage: [ [KORPathMappings pathForSharedDocuments]
								  stringByAppendingFormat:@"/%@/hidden/instructions.html",dir]];
			break;
		}
		case RUNDIAGNOSTICS_COMMAND_TAG:
		{
			KORDiagnosticRigController *amvc = [[KORDiagnosticRigController alloc] init];	// was autorelease
			amvc.delegate = self;
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:amvc];
			nav.modalPresentationStyle = UIModalPresentationFormSheet;	
			[self presentViewController:nav animated:YES 
							 completion: ^(void){
								 NSLog (@"DiagnosticRigController presentViewController completion"); 
								 
							 }];
			break;
		}
			

		case SEARCH_COMMAND_TAG:
		{
				//
			KORAllTunesController *atvc = [[KORAllTunesController alloc] init];
			
			atvc.tuneselectordelegate = self;
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:atvc];
					nav.modalPresentationStyle = UIModalPresentationFormSheet;
			
			[self presentViewController:nav animated:YES 
							 completion: ^(void){
							 }];
			
			break;
		}
		case SEARCHARCHIVESMENU_COMMAND_TAG:
		{
				//
			KORArchivesMenuController *atvc = [[KORArchivesMenuController alloc] initWithViewController:self  
					traversingName:self.listName traversingKind:self.listKind ]  ;
			
		
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
				frame.size.height +=30.f;
				
				self.popoverController.popoverContentSize = frame.size;
				self.popoverController.delegate = self;
				[self.popoverController presentPopoverFromRect:(CGRectMake(0,0,1,1)) inView:self.view 				 
									  permittedArrowDirections: UIPopoverArrowDirectionUp
													  animated: YES];
			}
			else
			{
					[self presentViewController:nav animated:YES completion:NULL];

			}
			
			break;
			
		}
		case FULLSCREEN_COMMAND_TAG:
		{
			
			[self toggleFullScreen: nil];
			break;
		}
			
		case  TESTHOOK_COMMAND_TAG :
		case SHOWMP3PLAYER_COMMAND_TAG:
		{
			
			KORAudioStreamingController *ssc = [[KORAudioStreamingController alloc] initWithMiniFests:[KORDataManager globalData].streamingSources];
			
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ssc];
			nav.modalPresentationStyle = UIModalPresentationFormSheet;
			[self presentViewController:nav animated:YES completion:NULL];	
			
			break;
		}

			
		case METRONOMEPREFERENCES_COMMAND_TAG:
		case PERTUNEPREFS_COMMAND_TAG:
		{
			
			KORPerTunePrefsController *mvc = [[KORPerTunePrefsController alloc] 
												 initWithAutoscrollControl:self.autoscrollControl 
											     metronomeControl:self.metronomeControl
											  viewer:self 
												 title:self.currentTuneTitle];
			
			
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mvc];
			
			if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
			{
				if (self.popoverController) 
				{ 
					[self.popoverController dismissPopoverAnimated:YES]; 
					self.popoverController = nil; // prevent troubles
				}
				self.popoverController = [[UIPopoverController alloc] initWithContentViewController: nav] ;
				CGRect frame = self.presentingViewController.view.frame;
				
				self.popoverController.popoverContentSize = mvc.view.frame.size;
				self.popoverController.delegate = self;
				[self.popoverController presentPopoverFromRect:(CGRectMake(frame.size.width/2,frame.size.height-84,1,1)) inView:self.view 				 
									  permittedArrowDirections: UIPopoverArrowDirectionDown
													  animated: YES];
			}
			else
			{			
				[self presentViewController:nav animated:YES completion:NULL];
				
			}	
			
		}	
		case AUTOSCROLLER_COMMAND_TAG:	
		{	
			BOOL state = self.autoscrollControl.scrollingOn;
			self.autoscrollControl.scrollingOn = !state; //acts as toggle
			[self.autoscrollControl refreshAutoScrollButtonLabel];
			
			if (self.autoscrollControl.scrollingOn) 
			{
				
				self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoscrollControl.duration  
																		target:self 
																	  selector:@selector(scrollTimerFired:)  
																	  userInfo:nil 
																	   repeats:NO];  
				
			}
			else {
				[self.autoscrollTimer invalidate];
				self.autoscrollTimer=nil;
			}
			break;
		}
		case SHOWTHIS_COMMAND_TAG:
		{
			[ self showPropsSheet:[NSString stringWithFormat:@"This Document"] tuneTitle:self.currentTuneTitle ];
			
			break;
		}
		case SHOWPREV_COMMAND_TAG:
		{
			[self showPropsSheet:[NSString stringWithFormat:@"Last Up"]  tuneTitle:[self previousOnList]];
			break;
		}
		case SHOWNEXT_COMMAND_TAG:
		{
			[self showPropsSheet:[NSString stringWithFormat:@"Next Up"]  tuneTitle:[self nextOnList]];
			break;
		}
		case TRAVERSING_COMMAND_TAG:
		{


			break;
		}
		case METRONOME_COMMAND_TAG:
		{
			
			if (self.metronomeControl.isTicking == YES)
			{
					// turn off
				[self.metronomeControl stopSound];
			}
			else
			{
					// turn on
				[self.metronomeControl  startSound];  
			}
			self.metronomeControl.isTicking = !self.metronomeControl.isTicking;
			[self.metronomeControl  refreshMetronomeButtonLabel];
			break;
		}
		case VARIANTS_COMMAND_TAG:
		{
			
				// next variant position
			NSUInteger c = [self.variantItems count];
			self.currentVariantPosition++;
			if (self.currentVariantPosition>=c) 
				self.currentVariantPosition= 0;
			InstanceInfo *ii = [self.variantItems objectAtIndex:self.currentVariantPosition];
			[self displayTuneByInstance:ii] ;
			
				//[self displayxTune/*TitlePathArchive*/:ii.title filePath:ii.filePath archive:ii.archive];
			break;
		}
			
		case RIGHTACTIONSHEET_COMMAND_TAG:
		{
				// more
			self.rightActionSheet = [KORActionSheet alloc];
			[self setupActionSheet:self.rightActionSheet named: @"ActionSheetRight" ];
			
			[self.rightActionSheet showInView:self.view];
			
				//[self.rightActionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
			break;	
		}
		case LEFTACTIONSHEET_COMMAND_TAG:
		{
				// more
			
			self.leftActionSheet = [KORActionSheet alloc];
			[self setupActionSheet: self.leftActionSheet    named:@"ActionSheetLeft" ];
			[self.leftActionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
			break;	
		}
		case WALLPAPER_COMMAND_TAG:
		{
			[self saveAsWallpaper];
			break;
		}
		case SHOWSET1_COMMAND_TAG:
		{
			
			[self presentListController:@"@set1"];
			break;
		}
		case SHOWSET2_COMMAND_TAG:
		{
			
			[self presentListController:@"@set2"];
			break;
		}
		case SHOWSET3_COMMAND_TAG:
		{
			[self presentListController:@"@set3"];
			break;
		}
			
		case SHOWFAVORITES_COMMAND_TAG:
		{
			[self presentListController:@"favorites"];			
			break;		
		}
		case SHOWRECENTS_COMMAND_TAG:
		{
			[self presentListController:@"recents"];
			break;
		}
			
		case	SHOWADDTOFAVORITES_COMMAND_TAG:
		{
			[KORListsManager insertListItemUnique: self.currentTuneTitle onList:@"favorites" top:NO];
			break;
		}
		case	SHOWADDTOLIST_COMMAND_TAG:
		{
			self.setListChooserControl = [[KORListChooserControl alloc] initWithTune:self.currentTuneTitle];
			self.setListChooserControl.delegate = self;
			[self.setListChooserControl showInView:self.view];
			break;
		}
		case MANAGELISTS_COMMAND_TAG:
		{
				// 
			
				KORSetlistsMenuController *atvc = [[KORSetlistsMenuController alloc] initWithViewController:self 
												   
												   traversingName:self.listName traversingKind:self.listKind
												   ];
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
					frame.size.height +=30.f;
					
					self.popoverController.popoverContentSize = frame.size;
					self.popoverController.delegate = self;
					[self.popoverController presentPopoverFromRect:(CGRectMake(0,0,1,1)) inView:self.view 				 
										  permittedArrowDirections: UIPopoverArrowDirectionUp
														  animated: YES];
				}
				else
				{
					[self presentViewController:nav animated:YES completion:NULL];
					
				}
				
				break;
		
		}
			
		case ADDLIST_COMMAND_TAG:
		{
			[KORAlertView alertWithInputTitle:@"Add Setlist"
									  message:nil
								  cancelTitle:@"Cancel"
								  cancelBlock:NULL
								   otherTitle:@"OK" 
								   otherBlock:^(UITextField *x) {
										   // NSLog (@"adding setlist %@",x);
									   
									   NSArray *items = [KORListsManager makeSetlistsScan]; //locallistItems;
									   BOOL unique=YES;
									   for (NSString *s in items)
									   {
										   if ([s isEqualToString: x.text])
										   {
											   unique = NO;	
											   break;
										   }
									   }
									   if (unique == YES)
									   { 
										   [KORListsManager insertList:x.text]; // new list
										   [KORAlertView alertWithTitle:@"We created a new List: "
																message:x.text buttonTitle:@"OK" ];
									   }
									   else {  
										   [KORAlertView alertWithTitle:@"Sorry, there is already a list with that name"
																message:@"Make sure your name is unique and try again"
															buttonTitle:@"OK"];
									   }
								   }
			 ];		
			break;
		}

		case ADDARCHIVE_COMMAND_TAG:
		{
			[KORAlertView alertWithInputTitle:@"Add Archive" 
									  message:nil
								  cancelTitle:@"Cancel"
								  cancelBlock:NULL
								   otherTitle:@"OK" 
								   otherBlock:^(UITextField *x) {
										   // NSLog (@"adding archive %@",x);
									   NSArray *items = [KORRepositoryManager allEnabledArchives]; //locallistItems;
									   BOOL unique=YES;
									   for (NSString *s in items)
									   {
										   if ([s isEqualToString: x.text])
										   {
											   unique = NO;	
											   break;
										   }
									   }
									   if (unique == YES)
									   {
										   [KORRepositoryManager insertArchiveUnique:x.text];
										   [KORAlertView alertWithTitle:@"A new archive was created:"
																message:x.text buttonTitle:@"OK" ];
										   
									   }
									   else {
										   [KORAlertView alertWithTitle:@"Sorry, there is already an archive with that name"
																message:@"Make sure your name is unique and try again"
															buttonTitle:@"OK"];
									   }
								   }
			 ];
			break;
		}
		case TITLELEFT_COMMAND_TAG:
		{
				// there's no hidden action under here for now - but it is displayed on the fly
			break;
		}
		case TITLE_COMMAND_TAG:	
		case SHOW_PERSONALFILEMANAGER_TAG:
		{
				__block typeof(self) bself = self;
				self.toass = [[KORActionSheet alloc] initWithTitle: [NSString stringWithFormat:@"%@ - Options",self.currentTuneTitle]];
			
			[self.toass addButtonWithTitle:NSLocalizedString (@"Rename", @"") completionBlock:^(void){
			
				[KORAlertView alertWithInputTitle:[NSString stringWithFormat:@"rename %@ to:",bself.currentTuneTitle] 
										  message:nil
									  cancelTitle:@"Cancel"
									  cancelBlock:NULL
									   otherTitle:@"OK" 
									   otherBlock:^(UITextField *x) {
										   
											   // check for duplicates
										   NSString *newName = x.text;
										   
										   ClumpInfo *ti = [KORRepositoryManager findTune:newName];
										   
										   if (ti==nil)
											   
										   {
											   [KORRepositoryManager renameTune:bself.currentTuneTitle toTune:newName];   
											   [KORListsManager renameTuneOnAllLists:bself.currentTuneTitle newName:newName];
											   
											   NSMutableArray *templist = [NSMutableArray array]; NSUInteger ind = 0;
											   for (NSString *s in bself.listItems)
											   {
												   if (ind == bself.currentListPosition)
													   [templist addObject:newName];
												   else
													   [templist addObject:s];
												   
												   ind++;
											   }
											   
											   bself.listItems = nil; // hope this frees it all
											   bself.listItems = [NSArray arrayWithArray:templist];
											
											   [KORAlertView alertWithTitle:@"The tune is now named" message:newName buttonTitle:@"OK"];
												   // now rebuilt and reinvoke
											   
											   [bself displayTuneByTitle:newName];  //******* refresh after rename
												   
										   }
										   else 
										   
										   {
												   // duplicates exist just bail
											   [KORAlertView alertWithTitle:@"Sorry, there is already a tune with that name" message:@"" buttonTitle:@"OK"];
										   }
									   
									   }];
			
			}];
		
						[self.toass addButtonWithTitle:NSLocalizedString (@"Move To Another Archive",@"") completionBlock:^(void){

							    NSString *title = [bself.currentTuneTitle copy];
								NSArray *archives = [KORRepositoryManager allArchives];
								NSString *titl = [NSString stringWithFormat:@"move tune %@ to archive:", title ,nil];
								
									// [self.toass release];
								bself.toass = [[KORActionSheet alloc] initWithTitle: titl ] ;
								
								
								
								for (NSString *archivename in archives) 
									
								{     // build menu of destinations
									[bself.toass addButtonWithTitle:[KORRepositoryManager shortName:archivename] completionBlock:^(void) {
											//when one is chosen look at each varaition for this title
										NSArray *variants = [KORRepositoryManager allVariantsFromTitle:title ];
										for (InstanceInfo *ii in variants)
											if (![ii.archive isEqualToString:archivename])
											[KORRepositoryManager moveTune:ii.title fromarchive:ii.archive toarchive:archivename ];
									
									}];        
								}
								
								[bself.toass    showInView: bself.view];
						
						}];

			
			[self.toass addButtonWithTitle:NSLocalizedString (@"Delete From All Archives",@"") 
						   completionBlock:^(void){
							   NSLog (@"deleting %@ from alla rchive",bself.currentTuneTitle);
													
							[KORRepositoryManager deleteTuneFromAllArchives:bself.currentTuneTitle];
						
							   NSMutableArray *templist = [NSMutableArray array];
							   NSUInteger ind = 0;
							   for (NSString *s in bself.listItems)
							   {
								   if (ind !=  bself.currentListPosition)
									   [templist addObject:s];
								   ind++;
							   }
							   
							   bself.listItems = nil; // hope this frees it all
							   bself.listItems = [NSArray arrayWithArray:templist];							   
							   bself.currentListPosition --;
							   if (bself.currentListPosition<0)bself.currentListPosition = [bself.listItems count]-1;
							   [bself displayTuneByTitle:
								[bself.listItems objectAtIndex:bself.currentListPosition]];
							   }];
			
			[self.toass showInView:self.view];
			break;
		}
			
		case IMPORT_ONTHEFLY_COMMAND_TAG :
		{
			
			
			__block typeof(self) bself = self;
			self.toass = [[KORActionSheet alloc] initWithTitle: 
						  [NSString stringWithFormat:@"Add More Content"]];
			[self.toass addButtonWithTitle:NSLocalizedString (@"Browse Web",@"") 
						   completionBlock:^(void){
							   
							   bself.pushedToWebBrowser = YES; // set flag so we know how to behave when coming back to viewdidappear
							   KORWebBrowserController *kac = [[KORWebBrowserController alloc] 
															   initWithURL:[[KORDataManager globalData].URLMappings objectForKey:@"Content-Sites"]
																								  andTitle:@"Select Your Content Then Snap Camera"
															   snapShotControl:YES]
							   ;
							   
							   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
							   [bself presentViewController:nav animated:YES 
												 completion: ^(void){
														 // NSLog (@"WebCaptureController presentViewController completion"); 
													 
												 }];
						   }];
			[self.toass addButtonWithTitle:NSLocalizedString (@"Copy From Photo Library",@"") 
						   completionBlock:^(void){
							   
								   //[KORRepositoryManager dump];

							   UIImagePickerController *zvc = [[UIImagePickerController alloc] init] ;
							   zvc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
							   zvc.delegate = bself; // had to make this a UINavigationController delegate
							   zvc.allowsEditing = YES;
							
								   //zvc.navigationBar.tintColor = [DataManager sharedInstance].headlineColor; //
								   //zvc.navigationController.visibleViewController.view.backgroundColor = [UIColor greenColor];
							   
							   
							   if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
								   
							   {
								   [bself presentViewController:zvc animated:YES 
													completion: ^(void){
															//NSLog (@"presented photoPopOverController view controller %@ t",zvc);
													}];
							   }
							   else {
								   
								   bself.photoPopOverController = [[UIPopoverController alloc] initWithContentViewController: zvc] ;
								   
								   bself.photoPopOverController.popoverContentSize = zvc.view.frame.size; 
								   bself.photoPopOverController.delegate = bself;
									   // NSLog (@"photopopup is %.fwx%.fh",zvc.view.frame.size.width,zvc.view.frame.size.height);
								   [bself.photoPopOverController presentPopoverFromRect: CGRectMake(zvc.view.frame.size.width-1,0,1,1) 
																		   inView: bself.view
														 permittedArrowDirections: UIPopoverArrowDirectionUp
																		 animated: YES];
							   }  						   
						   }];
		   
						   
			
			[self.toass addButtonWithTitle:NSLocalizedString (@"Ingest iTunes and Email",@"") 
						   completionBlock:^(void){
							   
			KORAssimilationController *kac = [[KORAssimilationController alloc] initWithArchive: [KORRepositoryManager nameForOnTheFlyArchive]];
			kac.delegate = bself;
			UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
			nav.modalPresentationStyle = UIModalPresentationFormSheet;	
			[bself presentViewController:nav animated:YES 
							 completion: ^(void){
									 //NSLog (@"KORAssimilationController presentViewController completion"); 
								 
							 }];
						   }];
			
			
			[self.toass showInView:self.view];
			
			break;
		}

		default:
		{
				// if nothing matches, check the special bindings
			
			NSArray *buttonTags = [[KORDataManager globalData].specialButtonBindings objectForKey:@"ButtonTags"];
			NSArray *buttonActions = [[KORDataManager globalData].specialButtonBindings objectForKey:@"ButtonActions"];
			NSUInteger udx = 0;
			for (NSNumber *num in buttonTags)
			{
				NSUInteger tag = [num unsignedIntValue];
				if (tag == tagx)
				{
					NSString *actionName = [buttonActions objectAtIndex:udx];
					NSUInteger action = [[KORDataManager actionToTag:actionName] unsignedIntValue];
					[self exec_command:action];
					[self.infoOverlayXib removeFromSuperview];
					self.infoOverlayXib = nil;
					return;
				}
				udx++;
			}
				// yikes absolutely nothing matched
			NSLog (@"******Tag Command Dispatch is unmatched for tag %d", tagx);
		}
	}
}

@end
