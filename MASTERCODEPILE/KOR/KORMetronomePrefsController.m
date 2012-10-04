//
//  KORMetronomePrefsController.m
//  MasterApp
//
//  Created by william donner on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KORMetronomePrefsController.h"
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORAlertView.h"
#import "KORTunePrefsManager.h"
#import "KORMetronomeViewControl.h"

enum
{
    SECTION_COUNT = 1  // MUST be kept in display order ...
    
};

@interface KORMetronomePrefsController ()

@property (nonatomic,retain) UIView *xib;

@property (nonatomic,retain) KORMetronomeViewControl *asp;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) UISlider *metronomeSlider1;
@property (nonatomic,retain) UISlider *metronomeSlider2;
@property (nonatomic,retain) UISlider *metronomeSlider3;
@end


@implementation  KORMetronomePrefsController
@synthesize metronomeSlider1,metronomeSlider2,metronomeSlider3,asp,title,xib;


-(void) metronomeBeatsPerMinuteSliderValueChanged:(id)sender
{
    
    NSUInteger slidervalue = rint(self.metronomeSlider1.value);
    UILabel *sliderLabel =  (UILabel *)[self.xib viewWithTag:921];
    sliderLabel.text = [NSString stringWithFormat:@"%3d",slidervalue];
    self.asp.bpm = slidervalue;
    [self.asp refreshMetronomeButtonLabel];
    [KORTunePrefsManager addPref:@"BeatsPerMinute" valueWithUnsignedInt: self.asp.bpm forTune:self.title];
}

-(void) metronomeNumeratorSliderValueChanged:(id)sender
{
    NSUInteger slidervalue = rint(self.metronomeSlider2.value);
    UILabel *sliderLabel =  (UILabel *)[self.xib  viewWithTag:922];
    int messit = slidervalue;
    sliderLabel.text = [NSString stringWithFormat:@"%d/%d",messit,self.asp.denominator];
    self.asp.numerator = messit;
    [self.asp refreshMetronomeButtonLabel];
    
    [KORTunePrefsManager addPref:@"SigNumerator" valueWithUnsignedInt:self.asp.numerator forTune:self.title];
}

-(void) metronomeDenominatorSliderValueChanged:(id)sender
{
    NSUInteger slidervalue = rint(self.metronomeSlider3.value);
    UILabel *sliderLabel =  (UILabel *)[self.xib  viewWithTag:922];
    
    int messit = pow(2,rint(slidervalue)-1);
    sliderLabel.text = [NSString stringWithFormat:@"%d/%d",self.asp.numerator,messit];
    self.asp.denominator = messit;
    [self.asp refreshMetronomeButtonLabel];
    
    [KORTunePrefsManager addPref:@"SigDenominator" valueWithUnsignedInt:self.asp.denominator forTune:self.title];
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
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor clearColor];
	
		// get overlays in case we need them    
    self.xib = [[[NSBundle mainBundle] loadNibNamed:[KORDataManager lookupXib:@"MusicStandMetronomeSettings"]
                                                     owner:self options:NULL] lastObject];//0612

	self.navigationItem.title =[NSString stringWithFormat:@"Metronome Preferences for %@",self.title] ;		
	
	[KORDataManager disallowOneTouchBehaviors];	
	
	UIView *theview = (UIView *) [self.xib viewWithTag:900];
	
		self.metronomeSlider1 = (UISlider *)[self.xib viewWithTag:923];
		[self.metronomeSlider1 addTarget:self action:@selector(metronomeBeatsPerMinuteSliderValueChangedx:) 
						forControlEvents:UIControlEventValueChanged];
		self.metronomeSlider1.value = self.asp.bpm;
		
		self.metronomeSlider2  = (UISlider *)[self.xib viewWithTag:924];
		[self.metronomeSlider2  addTarget:self action:@selector(metronomeNumeratorSliderValueChanged:) 
						 forControlEvents:UIControlEventValueChanged];
		self.metronomeSlider2 .value = self.asp.numerator; 
		
		
		self.metronomeSlider3  = (UISlider *)[self.xib viewWithTag:925];
		[self.metronomeSlider3  addTarget:self action:@selector(metronomeDenominatorSliderValueChanged:) 
						 forControlEvents:UIControlEventValueChanged];
		self.metronomeSlider3 .value = self.asp.denominator;
		
		UILabel *sliderLabel1 =  (UILabel *)[self.xib viewWithTag:921];
		sliderLabel1.text = [NSString stringWithFormat:@"%3d",
							 self.asp.bpm];
		
		UILabel *sliderLabel2 =  (UILabel *)[self.xib viewWithTag:922];
		sliderLabel2.text = [NSString stringWithFormat:@"%d/%d",
							 self.asp.numerator,self.asp.denominator];
	
	[theview addSubview:self.metronomeSlider1];
	[theview addSubview:self.metronomeSlider2];
	[theview addSubview:self.metronomeSlider3];
	[theview addSubview:sliderLabel1];
	[theview addSubview:sliderLabel2];

       [self.asp refreshMetronomeButtonLabel];
	
		//	NSLog (@"%@     %@      %@",self.metronomeSlider1,self.metronomeSlider2,self.metronomeSlider3);
	
    self.navigationItem.leftBarButtonItem =     [KORBarButtonItem  buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone                                                  completionBlock: ^(UIBarButtonItem *bbi){
		[KORDataManager allowOneTouchBehaviors];
		[self.presentingViewController dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];                                                 
	}];

    [self.view addSubview:theview];
	
	
	[self makeSearchNavHeaders];
}



#pragma mark Overridden NSObject Methods

-(id) init
{
	NSLog (@"dont call init with KORMetronomePrefsController");
	return nil;
}

- (id) initWithMetronomeControl :(KORMetronomeViewControl *)kasp title:(NSString *) tune;
{
    self = [super init];
    if (self)
    {
		self.asp = kasp;
		self.title = tune;
    }
	return self;
}


@end
