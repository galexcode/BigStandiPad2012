	//
	//  KORAutoScrollPrefs.m
	//  MasterApp
	//
	//  Created by bill donner on 10/28/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "KORPerTunePrefsController.h"
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORAlertView.h"
#import "KORAutoScrollViewControl.h"
#import "KORMetronomeViewControl.h"
#import "KORTunePrefsManager.h"
#import "KORViewerController.h"



enum
{
	AUTOSCROLL_SECTION = 0,
	METRONOME_SECTION = 1,
    SECTION_COUNT = 2  // MUST be kept in display order ...
    
};

@implementation KORTunePrefsCustomCell

@synthesize slival,slider,minLabel,maxLabel,theLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
			// Initialization code
		
		
		slider = [[UISlider alloc]init]; // make a new slider each time its presented			
		slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		minLabel = [[UILabel alloc] init] ;	
		minLabel.textAlignment = UITextAlignmentRight;
		minLabel.font = [UIFont boldSystemFontOfSize:14];
		
		maxLabel = [[UILabel alloc] init];
		maxLabel.textAlignment = UITextAlignmentLeft;
		maxLabel.font = [UIFont boldSystemFontOfSize:14];
		
		theLabel = [[UILabel alloc] init];
		theLabel.font = [UIFont boldSystemFontOfSize:15];
		
		
		slival = [[UILabel alloc] init];
		slival.font = [UIFont boldSystemFontOfSize:18];
		slival.textAlignment = UITextAlignmentRight;

		[self.contentView addSubview:slider];
		[self.contentView addSubview:maxLabel];
		[self.contentView addSubview:minLabel];
		[self.contentView addSubview:theLabel];		
		[self.contentView addSubview:slival];		
	}
	return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	frame= CGRectMake(boundsX+5,7, 180, 20);
	theLabel.frame = frame;
	
	frame= CGRectMake(boundsX+195,7, 55, 20);
	slival.frame = frame;
	
	frame= CGRectMake(boundsX+45 ,30, 150, 20);
	slider.frame = frame;
	
	frame= CGRectMake(boundsX+10 ,30, 30, 20);
	minLabel.frame = frame;

	frame= CGRectMake(boundsX+215 ,30, 30, 20);
	maxLabel.frame = frame;
}

@end

@interface KORPerTunePrefsController ()< UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) KORAutoScrollViewControl *asp;
@property (nonatomic,retain) KORMetronomeViewControl *met;
@property (nonatomic,retain) NSString *title;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) KORViewerController *vc;

@end

@implementation  KORPerTunePrefsController
@synthesize  cellprops;
@synthesize vc,tableView,title,met,asp;

- (void)sliderValueChanged:(UISlider *)slider 
{
	switch (slider.tag) {
		case 1001:
		{
			
			self.asp.pps  = floor(slider.value);
			[self.asp refreshAutoScrollButtonLabel];
				//NSLog (@"writing pps %.f slider %.1f",(floor(slider.value)),slider.value);
			[KORTunePrefsManager addPref:@"PixelsPerSecond" valueWithUnsignedInt: floor(slider.value) forTune:self.title];
			break;
		}
		case 1002:
		{
			
			self.met.bpm  = floor(slider.value);
			[self.met refreshMetronomeButtonLabel];		
			[KORTunePrefsManager addPref:@"BeatsPerMinute" valueWithUnsignedInt:floor(slider.value)forTune:self.title];
			break;
		}
		case 1003:
		{
			self.met.numerator  = floor(slider.value);
			[self.met refreshMetronomeButtonLabel];		
			[KORTunePrefsManager addPref:@"SigNumerator" valueWithUnsignedInt:floor(slider.value)forTune:self.title];
			
			break;
		}
		case 1004:
		{
			self.met.denominator  = floor(slider.value);
			[self.met refreshMetronomeButtonLabel];	
			[KORTunePrefsManager addPref:@"SigDenominator" valueWithUnsignedInt:floor(slider.value) forTune:self.title];
			break;
		}
		default :
		{
			return;
		}
	}
	
	UILabel *valueLabel = (UILabel *)[self.view viewWithTag:100+slider.tag]; // get the value label

	valueLabel.text = [NSString stringWithFormat:@"%.f", slider.value];
		//NSLog (@"setting valuelabel %@",valueLabel.text);
}

#pragma mark Overridden UIViewController Methods


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)||
    (UIDeviceOrientationIsPortrait ([UIDevice currentDevice].orientation));
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Private Instance Methods

#pragma mark Overridden UIViewController Methods


	// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView 
{
	CGRect innerFrame = CGRectMake(0,0,280, 400); // 
	self.view = [[UIView alloc] initWithFrame:innerFrame];//[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor clearColor];
		//	
	
	self.navigationItem.title = [KORDataManager makeUnadornedTitleView:[NSString stringWithFormat:@"Prefs: %@",self.title]] ;		
	
	[KORDataManager disallowOneTouchBehaviors];	
	
	
	CGRect frame = innerFrame;//[[UIScreen mainScreen] bounds];
	
		//frame.size = [self computeMenuSizeX];
    
	tableView =  [[UITableView alloc] initWithFrame: frame style: UITableViewStyleGrouped];
	tableView.backgroundColor =  [UIColor lightGrayColor];//[DataManager sharedInstance].headlineColor;
    tableView.opaque = YES;
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor lightGrayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.view = self.tableView	;	
}



#pragma mark Overridden NSObject Methods

-(id) init
{
	NSLog (@"dont call init with KORAutoScrollPrefsController");
	return nil;
}

- (id) initWithAutoscrollControl :(KORAutoScrollViewControl *)kasp 
				 metronomeControl: (KORMetronomeViewControl *)kmet 
						   viewer: (KORViewerController *)viewer
							title:(NSString *) tune;
{
    self = [super init];
    if (self)
    {
		self.asp = kasp;
		self.met = kmet;
		self.title = tune;
		self.vc = viewer;
		
		NSUInteger pps = [KORTunePrefsManager prefUnsignedIntValueForKey:@"PixelsPerSecond" forTune:self.vc.currentTuneTitle];
		if (pps==0) pps=kDefaultPPS;
		NSUInteger bpm = [KORTunePrefsManager prefUnsignedIntValueForKey:@"BeatsPerMinute" forTune:self.vc.currentTuneTitle];
		if (bpm==0) bpm=kDefaultBPM;
		NSUInteger numerator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigNumerator" forTune:self.vc.currentTuneTitle];
		if (numerator==0) numerator=4;
		NSUInteger denominator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigDenominator" forTune:self.vc.currentTuneTitle];
		if (denominator==0) denominator=4;		

			//BOOL scrollingOn = [KORTunePrefsManager prefBoolValueForKey:@"AutoScrollOn" forTune:self.vc.currentTuneTitle];

		NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Scroll Speed",@"label",
							[NSNumber numberWithInt:1001],@"tag",
							[NSNumber numberWithInt:kMinPPS],@"min",							
							[NSNumber numberWithInt:kMaxPPS],@"max",
							[NSNumber numberWithInt:pps],@"default",
							nil];
		NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Beats Per Minute",@"label",
							[NSNumber numberWithInt:1002],@"tag",
							[NSNumber numberWithInt:kMinBPM],@"min",
							[NSNumber numberWithInt:kMaxBPM],@"max",							
							[NSNumber numberWithInt:bpm],@"default",
							nil];
		NSDictionary *d3 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Time Signature - Num",@"label",
							[NSNumber numberWithInt:1003],@"tag",
							[NSNumber numberWithInt:2],@"min",							
							[NSNumber numberWithInt:32],@"max",							
							[NSNumber numberWithInt:numerator],@"default",
							nil];
		NSDictionary *d4 = [NSDictionary dictionaryWithObjectsAndKeys:
							@"Time Signature - Denom",@"label",
							[NSNumber numberWithInt:1004],@"tag",
							[NSNumber numberWithInt:2],@"min",							
							[NSNumber numberWithInt:32],@"max",							
							[NSNumber numberWithInt:denominator],@"default",
							nil];
		
		self.cellprops = [NSDictionary dictionaryWithObjectsAndKeys:
				d1,@"AutoScrollPPS",
				d2,@"MetronomeBPM",
				d3,@"MentronomeNUM",
				d4,@"MetronomeDEN",
						  nil];
							
							
		
		
	}
	return self;
}

	////




/*
 Section-related methods: Retrieve the section titles and section index titles
 */



- (NSInteger) numberOfSectionsInTableView: (UITableView *) tabView
{
	return SECTION_COUNT;
}

- (NSInteger) tableView: (UITableView *) tabView
  numberOfRowsInSection: (NSInteger) section
{
	switch (section) {
		case AUTOSCROLL_SECTION:
			{
			return 1;
			}
		case METRONOME_SECTION:
		{
			return 3;
		}
		default:
			return 0;
	}
	
	
}
- (CGFloat) tableView: (UITableView *) tabView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
	return 60;
	
}


#pragma mark UITableViewDelegate Methods



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case AUTOSCROLL_SECTION:
		{
			return @"Auto Scroll Parameters";
		
		}
			
		case METRONOME_SECTION:
			
		{
			return @"Metronome Parameters";
		}
	}
	
	return @"<bad section>";
	
}

- (UITableViewCell *) tableView: (UITableView *) tabView
          cellForRowAtIndexPath: (NSIndexPath *) idxPath
{
	NSUInteger section = idxPath.section;
	NSUInteger row = idxPath.row;
	NSDictionary *dict ;

	KORTunePrefsCustomCell *cell = [tabView dequeueReusableCellWithIdentifier: @"SettingsSLider"];
	
	if (!cell)
	{			
		cell = [[KORTunePrefsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"SettingsSLider"];
		cell.frame = CGRectZero;
	}
	
	switch (section) {
		case AUTOSCROLL_SECTION:
		{
			dict = [self.cellprops objectForKey:	@"AutoScrollPPS"];
			cell.slider.value = (CGFloat)self.asp.pps;
			cell.slival.text = [NSString stringWithFormat:@"%d",self.asp.pps];
			break;
		}
			
		case METRONOME_SECTION:
			
		{
			if (row==0)
			{
			dict = [self.cellprops objectForKey:	@"MetronomeBPM"];
				
				cell.slider.value = (CGFloat)self.met.bpm;
				
				cell.slival.text = [NSString stringWithFormat:@"%d",self.met.bpm];
			}
			else 	if (row==1)
			{
			dict = [self.cellprops objectForKey:	@"MentronomeNUM"];
				
				cell.slider.value = (CGFloat)self.met.numerator;
				
				cell.slival.text = [NSString stringWithFormat:@"%d",self.met.numerator];
			}
			else	if (row==2)
			{
			dict = [self.cellprops objectForKey:	@"MetronomeDEN"];
				
				cell.slider.value = (CGFloat)self.met.denominator;
				
				cell.slival.text = [NSString stringWithFormat:@"%d",self.met.denominator];
			}
			break;
			
		}
	}
	
	cell.minLabel.text =[NSString stringWithFormat:@"%.f",[	[dict objectForKey:@"min"] floatValue]]; 
	cell.maxLabel.text = [NSString stringWithFormat:@"%.f",[	[dict objectForKey:@"max"]floatValue]];	
	cell.theLabel.text = [dict objectForKey:@"label"];
	
	cell.slider.minimumValue = [	[dict objectForKey:@"min"] floatValue];
	cell.slider.maximumValue = [	[dict objectForKey:@"max"] floatValue];
	cell.slider.tag = [[dict objectForKey:@"tag"] intValue]; // give same tag to both slider and text value
	
	cell.slival.tag = [[dict objectForKey:@"tag"] intValue]+100; // give related tag to both slider and text value
	[cell.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	return cell;

}



- (void) tableView: (UITableView *) tabView
didSelectRowAtIndexPath: (NSIndexPath *) idxPath
{
    
}

@end

